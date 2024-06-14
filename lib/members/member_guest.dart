import 'dart:convert';
import 'package:flutter/material.dart';
import '../main.dart';
import 'package:http/http.dart'as http;

class Guest extends StatelessWidget {
  const Guest({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: GuestPage(),
    );
  }
}
class GuestPage extends StatefulWidget {
  const GuestPage({Key? key}) : super(key: key);

  @override
  State<GuestPage> createState() => _GuestPageState();
}

class _GuestPageState extends State<GuestPage> {

final ScrollController _scrollController = ScrollController();
  String numbersgroup ="10";
  var numbersgrouplist = ["10",'25','50',
    '100',];

  String name = "";
  String type = "Guest";
  List<Map<String,dynamic>> data =[];
List<Map<String, dynamic>> filteredData = [];
Future<void> getData() async {
  print('Attempting to make HTTP request...');
  try {
    final url = Uri.parse('http://mybudgetbook.in/GIBADMINAPI/registration_admin.php?table=registration&member_type=$type');
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
  void initState() {
    // TODO: implement initState
    getData();
    super.initState();
  }

  String sno = "";
  @override
  Widget build(BuildContext context) {
    return MyScaffold(route: "/guest_page",
        body: Container(
            color: Colors.white,
            child: Column(
                children:  [

                  Text("View Guest", style:Theme.of(context).textTheme.headlineMedium,),

                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Align(alignment: Alignment.topRight,
                      child: SizedBox(
                        width: 300,
                        height: 50,
                        child: TextFormField(
                          onChanged: (val){         //search bar
                            setState(() {
                              filteredData = filterData(val) ;
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
                    ),
                  ),
                  //Search TextFormField end

                  const SizedBox(height: 27,),
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
                              DataColumn(label: Center(child: Text("Mobile No",style: TextStyle(fontWeight: FontWeight.bold),))),
                              DataColumn(label: Center(child: Text("Company Name",style: TextStyle(fontWeight: FontWeight.bold),))),
                            ],
                            source: MyDataTableSource(
                              data: filteredData,
                              context: context,
                            )
                        ),
                      ),
                    ),
                  ),
                  //Table Starts
                  const SizedBox(height: 40,),
                ]
            )
        )
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
        DataCell(Text('${data[index]["mobile"]}')),
        DataCell(Text('${data[index]["company_name"]}')),
      ],
    );
  }

  @override
  void rowsRefresh() {
    // handle data refresh
  }
}


