import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '../main.dart';
import 'member_update_registration.dart';

class ExecutiveMembers extends StatelessWidget {
  const ExecutiveMembers({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: ExecutiveMembersPage(),
    );
  }
}

class ExecutiveMembersPage extends StatefulWidget {
  const ExecutiveMembersPage({Key? key}) : super(key: key);

  @override
  State<ExecutiveMembersPage> createState() => _ExecutiveMembersPageState();
}

final _formKey = GlobalKey<FormState>();
String dropdownvalue = '10';
var items = [
  '10',
  '25',
  '50',
  '100',
];

class _ExecutiveMembersPageState extends State<ExecutiveMembersPage> {
  TextEditingController search = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<Map<String, dynamic>> filteredData = [];
  String name = "";
  // String companyname ="";
  String membertype = "Executive Men's Wing";
  String sno = "";
  @override
  void initState() {
    getData();
    // TODO: implement initState
    super.initState();
  }

  List<Map<String, dynamic>> data = [];

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
    return MyScaffold(
      route: '/view_executive_members',
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 3,
                      blurRadius: 7,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(children: [
                    const SizedBox(
                      height: 20,
                    ),
                    //  View Executive Members text and icon starts
                    Text(
                      " View Executive Members",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(
                      height: 40,
                    ),
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

                  ]),
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
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            UpdateRegisterationPage(
                                currentID: data[
                                index]
                                ["id"])));
              },
              icon: const Icon(
                Icons.edit_note,
                color: Colors.blue,
              )),
        ),
      ],
    );
  }

  @override
  void rowsRefresh() {
    // handle data refresh
  }
}