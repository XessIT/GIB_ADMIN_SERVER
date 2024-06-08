import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '../main.dart';
import 'member_update_registration.dart';


class ViewNonExecutive extends StatelessWidget {
  const ViewNonExecutive({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: ViewNonExecutivePage(),
    );
  }
}

class ViewNonExecutivePage extends StatefulWidget {
  const ViewNonExecutivePage({Key? key}) : super(key: key);


  @override
  State<ViewNonExecutivePage> createState() => _ViewNonExecutivePageState();
}

class _ViewNonExecutivePageState extends State<ViewNonExecutivePage> {
  final _formKey = GlobalKey<FormState>();
  String numbersgroup = '10';
  var numbersgrouplist = ['10', '25', '50', '100',];




  String name = "";// search bar



  final TextEditingController search = TextEditingController();
   final ScrollController _scrollController = ScrollController();

  void clearText() {
    search.clear();
  }
  String membertype = "Non-Executive";

  String sno = "";

  @override
  void initState() {
    getData();
    // TODO: implement initState
    super.initState();
  }
  List<Map<String, dynamic>> data=[];
  List<Map<String, dynamic>> filteredData = [];
  Future<void> getData() async {
    print('Attempting to make HTTP request...');
    try {
      final url = Uri.parse('http://mybudgetbook.in/GIBADMINAPI/womens_executive.php?member_type=$membertype');
      final response = await http.get(url);
      print("ResponseStatus: ${response.statusCode}");
      print("Response: ${response.body}");
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print("gib members ResponseData: $responseData");
        if (responseData is List) {
          // Filter out members with member_type "Guest" and "Non-Executive"
          final List<dynamic> itemGroups = responseData.where((item) {
            return item['admin_rights'] != 'Waiting' && item['admin_rights'] != 'Rejected';
          }).toList();

          setState(() {
            data = itemGroups.cast<Map<String, dynamic>>();
          });
          print('gib members Data: $data');
        } else if (responseData is Map && responseData.containsKey('message')) {
          print('Message: ${responseData['message']}');
        } else {
          print('Error: Unexpected response type ${responseData.runtimeType}');
        }
      } else {
        print('Error: ${response.statusCode}');
      }
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print("ResponseData: $responseData");
      //  final List<dynamic> itemGroups = responseData;
        final List<dynamic> itemGroups = responseData.where((item) {
          return item['admin_rights'] != 'Waiting' && item['admin_rights'] != 'Rejected';
        }).toList();
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

/*  Future<void> getData() async {
    print('Attempting to make HTTP request...');
    try {
      final url = Uri.parse('http://mybudgetbook.in/GIBADMINAPI/womens_executive.php?member_type=$membertype');
      print("gib members url =$url");
      final response = await http.get(url);
      print("gib members ResponseStatus: ${response.statusCode}");
      print("gib members Response: ${response.body}");
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print("gib members ResponseData: $responseData");
        if (responseData is List) {
          // Filter out members with member_type "Guest" and "Non-Executive"
          final List<dynamic> itemGroups = responseData.where((item) {
            return item['admin_rights'] != 'Waiting' && item['admin_rights'] != 'Rejected';
          }).toList();

          setState(() {
            data = itemGroups.cast<Map<String, dynamic>>();
          });
          print('gib members Data: $data');
        } else if (responseData is Map && responseData.containsKey('message')) {
          print('Message: ${responseData['message']}');
        } else {
          print('Error: Unexpected response type ${responseData.runtimeType}');
        }
      } else {
        print('Error: ${response.statusCode}');
      }
      print('HTTP request completed. Status code: ${response.statusCode}');
    } catch (e) {
      print('Error making HTTP request: $e');
      throw e; // rethrow the error if needed
    }
  }*/



  @override
  Widget build(BuildContext context) {
    return MyScaffold(route: "/members_non_executivepage",
        body: Form(
          key: _formKey,
          child: Center(
              child: Column(
                  children: [
                    Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Container(
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Column(
                                  children: [
                                    const SizedBox(height: 30,),
                                    Wrap(
                                      children: [
                                        //view non members start
                                        Text("View Non Executive Members", style: Theme.of(context).textTheme.headlineMedium,)],),
                                    const SizedBox(height: 25,),
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

                                    /*Container(
                                              child: SingleChildScrollView(
                                                  scrollDirection: Axis.horizontal,
                                                child: Table(
                                                  border: TableBorder.all(),
                                                  defaultColumnWidth: const FixedColumnWidth(190.0),
                                                  columnWidths: const<int, TableColumnWidth>{
                                                    0:FixedColumnWidth(70),2:FixedColumnWidth(100), 5:FixedColumnWidth(70)},
                                                  //  5:FixedColumnWidth(140),},
                                                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                                                  children: [
                                                    TableRow(
                                                        children: [
                                                          //s.no
                                                          TableCell(child: Center(child: Column(children: [
                                                            const SizedBox(height: 8,),
                                                            Text('S.No', style: Theme
                                                                .of(context)
                                                                .textTheme
                                                                .headlineMedium),
                                                            const SizedBox(height: 8,),
                                                          ],),)),
                                                          //name
                                                          TableCell(child: Center(child: Text('Name', style: Theme
                                                              .of(context)
                                                              .textTheme
                                                              .headlineMedium),),),
                                                          // user id
                                                          TableCell(child: Center(child: Text('User Id', style: Theme
                                                              .of(context)
                                                              .textTheme
                                                              .headlineMedium),),),
                                                          // email
                                                          TableCell(child: Center(child: Text('Email', style: Theme
                                                              .of(context)
                                                              .textTheme
                                                              .headlineMedium),),),
                                                          // mobile
                                                          TableCell(child: Center(child: Text('Mobile', style: Theme
                                                              .of(context)
                                                              .textTheme
                                                              .headlineMedium),),),
                                                          // Edit
                                                          TableCell(child:  Center(child: Text('Edit', style: Theme.of(context).textTheme.headlineMedium),),),
                                                        ]
                                                    ),
                                                    for (var i = 0; i < data.length; i++) ...[
                                                      if( data[i]["first_name"].toString().toLowerCase().startsWith(name.toLowerCase()))

                                                      //   if( storedocs[i]["Company Name"].toString().toLowerCase().startsWith(name.toLowerCase()))

                                                        TableRow(
                                                            decoration: BoxDecoration(color: Colors.grey[200]),
                                                            children:[
                                                              //s.no
                                                              TableCell(child:Row(
                                                                children: [
                                                                  //       const SizedBox(width: 4,),
                                                                  //   IconButton( onPressed: () {}, icon:const Icon(Icons.add_circle,color: Colors.blue,)),
                                                                  // const SizedBox(width: 8,),
                                                                  Text("     "'${i+1}',),
                                                                  const SizedBox(width: 4,),
                                                                ],
                                                              ),),
                                                              // name
                                                              TableCell(child:Center(child: Column(children:  [ const SizedBox(height: 8,), Text('${data[i]["first_name"]}',), const SizedBox(height: 8,),])),),
                                                              //User id
                                                              const TableCell(child:Center(child: Text('2345678',)),),
                                                              // email
                                                              TableCell(child:Center(child: Text('${data[i]["email"]}',),),),
                                                              //mobile
                                                              TableCell(child:Center(child: Text('${data[i]["mobile"]}',),),),
                                                              TableCell(child: Center(
                                                                child: Column(
                                                                  children:  [
                                                                    const SizedBox(height: 8,),
                                                                    IconButton(onPressed: (){
                                                                      Navigator.push(context,
                                                                          MaterialPageRoute(builder: (context) =>  UpdateRegisterationPage(currentID: data[i]["id"])));
                                                                    },
                                                                        icon:const Icon(Icons.edit_note,color: Colors.blue,)),
                                                                    const SizedBox(height: 8,),
                                                                  ],),)),

                                                            ]
                                                        ),


                                                    ]
                                                  ],
                                                ),
                                                // Table end
                                              ))*/

                                  ]
                              ),)))
                  ]
              )
          ),
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




