import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '../../main.dart';
import 'member_update_registration.dart';


class WomensExecutiveMembers extends StatelessWidget {
  const WomensExecutiveMembers({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: WomensExecutiveMembersPage(),
    );
  }
}
class WomensExecutiveMembersPage extends StatefulWidget {
  const WomensExecutiveMembersPage({Key? key}) : super(key: key);

  @override
  State<WomensExecutiveMembersPage> createState() => _WomensExecutiveMembersPageState();
}

class _WomensExecutiveMembersPageState extends State<WomensExecutiveMembersPage> {
  final _formKey = GlobalKey<FormState>();
  String numbersgroup ="10";
  var numbersgrouplist = ["10",'25','50',
    '100',];
  TextEditingController search =TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<Map<String, dynamic>> filteredData = [];
  //final DataTableSource _data = MyData();
  int activePage = 0;
  int pageSize = 10;
  String name = "";
  String membertype = "Executive Women's Wing";
  String sno = "";
  int currentPage = 1;

  @override
  void initState() {
    getData();
    // TODO: implement initState
    super.initState();
  }
  List<Map<String, dynamic>> data=[];
  Future<void> getData() async {
    print('Attempting to make HTTP request...');
    try {
      final url = Uri.parse('http://mybudgetbook.in/GIBADMINAPI/womens_executive.php?member_type=$membertype');
      final response = await http.get(url);
      print("ResponseStatus: ${response.statusCode}");
      print("Response: ${response.body}");
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print("ResponseData: $responseData");
        final List<dynamic> itemGroups = responseData;
        setState(() {
          data = itemGroups.cast<Map<String, dynamic>>();
          filteredData = data; // Initially set filtered data to all data
        });
        print('Data: $data');
        print("Id: ${data[0]["id"]}");
      } else {
        print('Error: ${response.statusCode}');
      }
      print('HTTP request completed. Status code: ${response.statusCode}');
    } catch (e) {
      print('Error making HTTP request: $e');
      throw e;
    }
  }
  @override
  Widget build(BuildContext context) {
    return MyScaffold(route: "/womens_executive_members",
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [

              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Container(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                        children:  [

                          const SizedBox(height: 20,),
                          //View Women's Executive Members text and icon starts
                          Wrap(
                            //  mainAxisAlignment: MainAxisAlignment.center,
                            children:[
                              //  const Icon(Icons.calendar_today_outlined,color: Colors.green,),
                              Text("View Women's Executive Members", style:Theme.of(context).textTheme.headlineMedium,),
                            ],
                          ),
                          const SizedBox(height: 30,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              SizedBox(
                                width: 300,
                                height: 50,
                                child: TextFormField(
                                  onChanged: (val){         //search bar
                                    setState(() {
                                      filteredData = filterData(val);
                                    });
                                  },
                                  decoration:  const InputDecoration(
                                    prefixIcon: Icon(Icons.search,color: Colors.green,),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(12))
                                    ),
                                    hintText: 'Search ',
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          Scrollbar(
                            thumbVisibility: true,
                            controller: _scrollController,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              controller: _scrollController,
                              child: SizedBox(
                                width:1000,
                                child: PaginatedDataTable(
                                    columnSpacing:50,
                                    //  header: const Text("Report Details", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                    rowsPerPage:15,
                                    columns:   const [
                                      DataColumn(label: Center(child: Text("S.No",style: TextStyle(fontWeight: FontWeight.bold),))),
                                      DataColumn(label: Center(child: Text("Name ",style: TextStyle(fontWeight: FontWeight.bold),))),
                                      DataColumn(label: Center(child: Text("Member ID ",style: TextStyle(fontWeight: FontWeight.bold),))),
                                      DataColumn(label: Center(child: Text("Mobile No",style: TextStyle(fontWeight: FontWeight.bold),))),
                                      DataColumn(label: Center(child: Text("Company Name",style: TextStyle(fontWeight: FontWeight.bold),))),
                                      DataColumn(label: Center(child: Text("Status",style: TextStyle(fontWeight: FontWeight.bold),))),
                                    ],
                                    source: MyDataTableSource(
                                      data: filteredData,
                                      context: context,
                                    )
                                ),
                              ),
                            ),
                          ),
                        ]
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  List<Map<String, dynamic>> filterData(String searchTerm) {
    if (searchTerm.isEmpty) {
      return data;
    } else {
      return data.where((item) => item["first_name"].toLowerCase().contains(searchTerm.toLowerCase())).toList();
    }
  }
}
class MyDataTableSource extends DataTableSource {
  List<Map<String, dynamic>> data;
  BuildContext context;

  MyDataTableSource({required this.data, required this.context,});

  @override
  int get rowCount => data.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => 0;

  @override
  DataRow getRow(int index) {
    return DataRow(
      cells: [
        DataCell(Text('${index + 1}')),
        DataCell(Text('${data[index]["first_name"]} ${data[index]["last_name"]}')),
        DataCell(Text('${data[index]["member_id"]}')),
        DataCell(Text('${data[index]["mobile"]}')),
        DataCell(Text('${data[index]["company_name"]}')),
        DataCell(
          IconButton(onPressed: (){
            Navigator.push(context,
                MaterialPageRoute(builder: (context) =>  UpdateRegisterationPage(currentID: data[index]["id"])));
          },
              icon:const Icon(Icons.edit_note,color: Colors.blue,)),
        ),
      ],
    );
  }

  @override
  void rowsRefresh() {
    // handle data refresh
  }
}

