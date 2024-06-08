import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:gibadmin/main.dart';
import 'package:http/http.dart' as http;

class BlockAndUnBlock extends StatelessWidget {
  const BlockAndUnBlock({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: BlockAndUnblockPage(),
    );
  }
}

class BlockAndUnblockPage extends StatefulWidget {
  const BlockAndUnblockPage({Key? key}) : super(key: key);
  @override
  State<BlockAndUnblockPage> createState() => _BlockAndUnblockPageState();
}
class _BlockAndUnblockPageState extends State<BlockAndUnblockPage> with TickerProviderStateMixin{

  String membersgroup ='District';
  var membersgrouplist = ['District',];

  String chaptergroup ='Chapter';
  var chaptergrouplist = ['Chapter',];

  DateTime date = DateTime(2022,25,08);

  @override
  Widget build(BuildContext context) {
    return  DefaultTabController(
      length: 2,
      child: MyScaffold(
        route: "/member_block_unblock",
        body: Center(
          child: Column(
              children:  [
                // Text("data")
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    color: Colors.white,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children:  [
                            const TabBar(
                              //  controller: _tabController,
                                isScrollable: true,
                                labelColor: Colors.green,
                                unselectedLabelColor: Colors.black,
                                tabAlignment: TabAlignment.center,
                                tabs:[
                                  Tab(text:("Block Members"),),
                                  Tab(text: ('UnBlock Members'),),
                                  // Tab(text: ('ViewBlock&UnBlock Members'),),
                                ]),
                            const SizedBox(height: 30,),
                            Container(
                                height:1100,
                                color: Colors.red,
                                child:const TabBarView(children: [
                                  BlockList(),
                                  UnBlockList(),
                                  // ViewBlockUnBlockListpage()

                                ])
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ]
          ),
        ),
      ),
    );
  }
}




class BlockList extends StatelessWidget {
  const BlockList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: BlockListpage(),
    );
  }
}
class BlockListpage extends StatefulWidget {
  const BlockListpage({Key? key}) : super(key: key);

  @override
  State<BlockListpage> createState() => _BlockListpageState();
}

class _BlockListpageState extends State<BlockListpage> {
  final GlobalKey<FormState> _formKey =GlobalKey<FormState>();

  TextEditingController search =TextEditingController();

  String block="Block";
  String name = "";

  String membertype = "";
   final ScrollController _scrollController=ScrollController();
  // bool block = true;
  String blockstatus= "Block";
  List<Map<String, dynamic>> data =[];

  String status = "Block";
  List<Map<String, dynamic>> filteredData = [];
  Future<void> getData() async {
    print('Attempting to make HTTP request...');
    try {
      final url = Uri.parse('http://mybudgetbook.in/GIBADMINAPI/registration_admin.php?table=registration&block_status=$status');
      final response = await http.get(url);
      print("ResponseStatus: ${response.statusCode}");
      print("Response: ${response.body}");
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print("gib members ResponseData: $responseData");
        if (responseData is List) {
          // Filter out members with member_type "Guest" and "Non-Executive"
          final List<dynamic> itemGroups = responseData.where((item) {
            return item['member_type'] == 'Guest';
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
          return item['member_type'] != 'Guest';
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
 /* Future<void> getData() async {
    print('Attempting to make HTTP request...');
    try {
      final url = Uri.parse('http://mybudgetbook.in/GIBADMINAPI/registration_admin.php?table=registration&block_status=$status');
      print("block url: $url");
      final response = await http.get(url);
      print("block ResponseStatus: ${response.statusCode}");
      print("block Response: ${response.body}");
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print("ResponseData: $responseData");
        final List<dynamic> itemGroups = responseData;
        setState(() {});
        data = itemGroups.cast<Map<String, dynamic>>();
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
  }*/
  @override
  void initState() {
    // TODO: implement initState
    getData();
    super.initState();
  }
  Future<void> unblocked(int id) async {
    try {
      final url = Uri.parse('http://mybudgetbook.in/GIBADMINAPI/registration_admin.php');
      final response = await http.put(
        url,
        body: jsonEncode({
          "id": id,
          "block_status": "UnBlock"
        }),
      );
      if (response.statusCode == 200) {
        Navigator.push(context,MaterialPageRoute(builder: (context)=>BlockAndUnBlock()));

        // Navigator.push(context, MaterialPageRoute(builder: (context) => const NewMemberApproval()));
         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Successfully Updated")));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Failed to Block")));
      }
    } catch (e) {
      print("Error during signup: $e");
      // Handle error as needed
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Form(
          key: _formKey,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Container(
                  padding: EdgeInsets.all(15),
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
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(" Block Members",style: Theme.of(context).textTheme.displayLarge,),],
                      ),
                      const SizedBox(height: 20,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(width: 300,
                              child: TextFormField(
                                onChanged: (val){
                                  setState(() {
                                    filteredData = filterData(val);
                                  });
                                },
                                controller: search,
                                decoration: const InputDecoration(
                                  prefixIcon: Icon(Icons.search),
                                  border: OutlineInputBorder(),
                                  hintText: 'Search ',
                                ),

                              ),
                            ),
                          ),
                        ],
                      ),
                      Scrollbar(
                        thumbVisibility: true,
                        controller: _scrollController,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          controller: _scrollController,
                          child: SizedBox(
                            width: 1000,
                            child: PaginatedDataTable(
                              columnSpacing: 50,
                              rowsPerPage: 15,
                              columns: const [
                                DataColumn(label: Center(child: Text("S.No", style: TextStyle(fontWeight: FontWeight.bold)))),
                                DataColumn(label: Center(child: Text("Member ID", style: TextStyle(fontWeight: FontWeight.bold)))),
                                DataColumn(label: Center(child: Text("Name", style: TextStyle(fontWeight: FontWeight.bold)))),
                                DataColumn(label: Center(child: Text("Mobile No", style: TextStyle(fontWeight: FontWeight.bold)))),
                                DataColumn(label: Center(child: Text("Member Type", style: TextStyle(fontWeight: FontWeight.bold)))),
                                DataColumn(label: Center(child: Text("Company Name", style: TextStyle(fontWeight: FontWeight.bold)))),
                                DataColumn(label: Center(child: Text("Status", style: TextStyle(fontWeight: FontWeight.bold)))),
                                DataColumn(label: Center(child: Text("Action", style: TextStyle(fontWeight: FontWeight.bold)))),
                              ],
                              source: MyDataTableSource(
                                data: filteredData,
                                unblocked: unblocked, // Pass the unblocked function here
                                context: context,
                              ),
                            ),
                          ),
                        ),
                      ),

                    ],
                  ),
                ),
              )
            ],
          ),
        ));
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
  final Future<void> Function(int id) unblocked;

  MyDataTableSource({required this.data, required this.unblocked, required this.context});

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
        DataCell(Text('${data[index]["member_id"]}')),
        DataCell(Text('${data[index]["first_name"]} ${data[index]["last_name"]}')),
        DataCell(Text('${data[index]["mobile"]}')),
        DataCell(Text('${data[index]["member_type"]}')),
        DataCell(Text('${data[index]["company_name"]}')),
        DataCell(Text('${data[index]["company_name"]}')),
        DataCell(
            IconButton(onPressed: () async {
              AwesomeDialog(
                context: context,
                animType: AnimType.leftSlide,
                headerAnimationLoop: true,
                dialogType: DialogType.warning,
                showCloseIcon: true,
                title: 'UnBlock',
                titleTextStyle: TextStyle(
                  color: Theme.of(context).brightness == Brightness.light
                      ? Colors.black // Light theme color
                      : Colors.white, // Dark theme color
                ),
                desc: 'Do you want to UnBlock this Member?',
                btnOkText: 'Yes',
                btnCancelText: 'No',
                btnCancelOnPress: () {},
                btnOkOnPress: () {
                  unblocked(int.parse("${data[index]["id"]}"));
                },
                // btnOkIcon: Icons.check_circle,
                onDismissCallback: (type) {
                  debugPrint('Dialog Dismiss from callback $type');
                },
              ).show();
            }, icon: const Icon(Icons.lock, color: Colors.red),
            )
        ),
      ],
    );
  }

  @override
  void rowsRefresh() {
    // handle data refresh
  }
}



class UnBlockList extends StatelessWidget {
  const UnBlockList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: UnBlockListpage(),
    );
  }
}
class UnBlockListpage extends StatefulWidget {
  const UnBlockListpage({Key? key}) : super(key: key);

  @override
  State<UnBlockListpage> createState() => _UnBlockListpageState();
}

class _UnBlockListpageState extends State<UnBlockListpage> {
  final GlobalKey<FormState> _formKey =GlobalKey<FormState>();

  TextEditingController search =TextEditingController();
  final ScrollController _scrollController=ScrollController();

  String name = "";
  List<Map<String, dynamic>> data =[];
  String status = "UnBlock";
  List<Map<String, dynamic>> filteredData = [];
  Future<void> getData() async {
    print('Attempting to make HTTP request...');
    try {
      final url = Uri.parse('http://mybudgetbook.in/GIBADMINAPI/registration_admin.php?table=registration&block_status=$status');
      final response = await http.get(url);
      print("ResponseStatus: ${response.statusCode}");
      print("Response: ${response.body}");
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print("ResponseData: $responseData");
        //  final List<dynamic> itemGroups = responseData;
        final List<dynamic> itemGroups = responseData.where((item) {
          return item['member_type'] != 'Guest';
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


  @override
  void initState() {
    // TODO: implement initState
    getData();
    super.initState();
  }
  Future<void> blocked(int id) async {
    try {
      final url = Uri.parse('http://mybudgetbook.in/GIBADMINAPI/registration_admin.php');
      final response = await http.put(
        url,
        body: jsonEncode({
          "id": id,
          "block_status": "Block"
        }),
      );
      if (response.statusCode == 200) {
        Navigator.push(context,MaterialPageRoute(builder: (context)=>BlockAndUnBlock()));

        // Navigator.push(context, MaterialPageRoute(builder: (context) => const NewMemberApproval()));
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Successfully Updated")));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Failed to Block")));
      }
    } catch (e) {
      print("Error during signup: $e");
      // Handle error as needed
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Form(
          key: _formKey,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 3,
                        blurRadius: 7,
                        offset: const Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(" Unblock Members",style: Theme.of(context).textTheme.displayLarge,),],
                      ),
                      const SizedBox(height: 20,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(width: 300,
                              child: TextFormField(
                                onChanged: (val){
                                  setState(() {
                                    name = val;
                                  });
                                },
                                controller: search,
                                decoration: const InputDecoration(
                                  prefixIcon: Icon(Icons.search),
                                  border: OutlineInputBorder(),
                                  hintText: 'Search ',
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Scrollbar(
                        thumbVisibility: true,
                        controller: _scrollController,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          controller: _scrollController,
                          child: SizedBox(
                            width: 1000,
                            child: PaginatedDataTable(
                              columnSpacing: 50,
                              rowsPerPage: 15,
                              columns: const [
                                DataColumn(label: Center(child: Text("S.No", style: TextStyle(fontWeight: FontWeight.bold)))),
                                DataColumn(label: Center(child: Text("Member ID", style: TextStyle(fontWeight: FontWeight.bold)))),
                                DataColumn(label: Center(child: Text("Name", style: TextStyle(fontWeight: FontWeight.bold)))),
                                DataColumn(label: Center(child: Text("Mobile No", style: TextStyle(fontWeight: FontWeight.bold)))),
                                DataColumn(label: Center(child: Text("Member Type", style: TextStyle(fontWeight: FontWeight.bold)))),
                                DataColumn(label: Center(child: Text("Company Name", style: TextStyle(fontWeight: FontWeight.bold)))),
                                DataColumn(label: Center(child: Text("Status", style: TextStyle(fontWeight: FontWeight.bold)))),
                                DataColumn(label: Center(child: Text("Action", style: TextStyle(fontWeight: FontWeight.bold)))),
                              ],
                              source: MyDataTableSource4(
                                data: filteredData,
                                blocked: blocked, // Pass the unblocked function here
                                context: context,
                              ),
                            ),
                          ),
                        ),
                      ),
                     /* const SizedBox(height: 30,),
                      SizedBox(
                        height: 500,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Table(
                            border: TableBorder.all(),
                            defaultColumnWidth: const FixedColumnWidth(150.0),
                            columnWidths: const <int, TableColumnWidth>{
                              0: FixedColumnWidth(50),
                              1: FixedColumnWidth(200),
                              2: FixedColumnWidth(100),
                              3: FixedColumnWidth(200),
                              5: FixedColumnWidth(200),
                              6: FixedColumnWidth(120),
                              7: FixedColumnWidth(120)},
                            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                            children: [
                              TableRow(
                                  children: [
                                    //S.no
                                    TableCell(child: Center(child: Column(
                                      children: [
                                        const SizedBox(height: 8,),
                                        Text("S.no",style: Theme.of(context).textTheme.headlineMedium,),
                                        const SizedBox(height: 8,),
                                      ],))),
                                    //Name
                                    TableCell(child: Center(child: Text("Name",style: Theme.of(context).textTheme.headlineMedium,)),),
                                    //User Id
                                    TableCell(child: Center(child: Text("User Id" ,style: Theme.of(context).textTheme.headlineMedium)),),
                                    //Email
                                    TableCell(child: Center(child: Text("Company name" ,style: Theme.of(context).textTheme.headlineMedium,)),),
                                    //Mobile
                                    TableCell(child: Center(child: Text("Mobile" ,style: Theme.of(context).textTheme.headlineMedium)),),
                                    //Company name
                                    TableCell(child: Center(child: Text("Member Type" ,style: Theme.of(context).textTheme.headlineMedium,)),),
                                    //Role
                                    TableCell(child: Center(child: Text("Status" ,style: Theme.of(context).textTheme.headlineMedium,))),
                                    //status
                                    TableCell(child: Center(child: Text("Action" ,style: Theme.of(context).textTheme.headlineMedium)),),
                                  ]
                              ),
                              for (var i = 0; i < data.length; i++) ...[
                                if(data[i]["first_name"].toString().toLowerCase().startsWith(name.toLowerCase()))
                                  TableRow(
                                      children: [
                                        //sno
                                        TableCell(child: Center(child:  Text('${i+1}',),),),
                                        //Name
                                        TableCell(
                                          child: Padding(
                                            padding: const EdgeInsets.only(left: 10),
                                            child: Text('${data[i]["first_name"]}',),
                                          ),
                                        ),
                                        //User Id
                                         TableCell(
                                          child: Center(
                                              child: Text('${data[i]["member_id"]}',)),
                                        ),
                                        //Email
                                        TableCell(
                                          child: Padding(
                                            padding: const EdgeInsets.only(left: 10),
                                            child: Text('${data[i]["company_name"]}',),
                                          ),
                                        ),
                                        //Mobile
                                        TableCell(
                                          child: Padding(
                                            padding: const EdgeInsets.only(left: 10),
                                            child: Text('${data[i]["mobile"]}',),
                                          ),
                                        ),
                                        //Role
                                        TableCell(
                                          child: Padding(
                                            padding: const EdgeInsets.only(left: 10),
                                            child: Text("${data[i]["member_type"]}",
                                            ),
                                          ),),
                                        //Status
                                        TableCell(child: Padding(
                                          padding: const EdgeInsets.only(left: 10),
                                          child: Text('${data[i]["block_status"]}',),
                                        ),),
                                        //Action
                                        TableCell(child: Center(child: IconButton(onPressed: () {
                                          AwesomeDialog(
                                            context: context,
                                            animType: AnimType.leftSlide,
                                            headerAnimationLoop: true,
                                            dialogType: DialogType.warning,
                                            showCloseIcon: true,
                                            title: 'Block',
                                            titleTextStyle: TextStyle(
                                              color: Theme.of(context).brightness == Brightness.light
                                                  ? Colors.black // Light theme color
                                                  : Colors.white, // Dark theme color
                                            ),
                                            desc: 'Do you want to Block this Member?',
                                            btnOkText: 'Yes',
                                            btnCancelText: 'No',
                                            btnCancelOnPress: () {},
                                            btnOkOnPress: () {
                                              blocked(int.parse(data[i]["id"]));
                                            },
                                            // btnOkIcon: Icons.check_circle,
                                            onDismissCallback: (type) {
                                              debugPrint('Dialog Dismiss from callback $type');
                                            },
                                          ).show();
                                        }, icon: const Icon(Icons.lock_open, color:Colors.green),))
                                        )
                                      ])
                              ]
                            ],
                          ),
                        ),
                      )*/
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
  }
  List<Map<String, dynamic>> filterData(String searchTerm) {
    if (searchTerm.isEmpty) {
      return data;
    } else {
      return data.where((item) => item["first_name"].toLowerCase().contains(searchTerm.toLowerCase())).toList();
    }
  }
}
class MyDataTableSource4 extends DataTableSource {
  List<Map<String, dynamic>> data;
  BuildContext context;
  final Future<void> Function(int id) blocked;

  MyDataTableSource4({required this.data, required this.blocked, required this.context});

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
        DataCell(Text('${data[index]["member_id"]}')),
        DataCell(Text('${data[index]["first_name"]} ${data[index]["last_name"]}')),
        DataCell(Text('${data[index]["mobile"]}')),
        DataCell(Text('${data[index]["member_type"]}')),
        DataCell(Text('${data[index]["company_name"]}')),
        DataCell(Text('${data[index]["block_status"]}',),),
        DataCell(
            IconButton(onPressed: () async {
              AwesomeDialog(
                context: context,
                animType: AnimType.leftSlide,
                headerAnimationLoop: true,
                dialogType: DialogType.warning,
                showCloseIcon: true,
                title: 'UnBlock',
                titleTextStyle: TextStyle(
                  color: Theme.of(context).brightness == Brightness.light
                      ? Colors.black // Light theme color
                      : Colors.white, // Dark theme color
                ),
                desc: 'Do you want to UnBlock this Member?',
                btnOkText: 'Yes',
                btnCancelText: 'No',
                btnCancelOnPress: () {},
                btnOkOnPress: () {
                  blocked(int.parse("${data[index]["id"]}"));
                },
                // btnOkIcon: Icons.check_circle,
                onDismissCallback: (type) {
                  debugPrint('Dialog Dismiss from callback $type');
                },
              ).show();
            }, icon: const Icon(Icons.lock, color: Colors.red),
            )
        ),
      ],
    );
  }

  @override
  void rowsRefresh() {
    // handle data refresh
  }
}











