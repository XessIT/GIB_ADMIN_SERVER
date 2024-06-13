import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../main.dart';

class NewMemberApproval extends StatelessWidget {
  const NewMemberApproval({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: MemberApprovaltabbarview(),
    );
  }
}
class MemberApprovaltabbarview extends StatefulWidget {
  const MemberApprovaltabbarview({Key? key}) : super(key: key);

  @override
  State<MemberApprovaltabbarview> createState() => _MemberApprovaltabbarviewState();
}

class _MemberApprovaltabbarviewState extends State<MemberApprovaltabbarview> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: MyScaffold(
        route: "/new_member_approval",
        body: Container(
          color: Colors.white,
          child: Center(
            child: Column(
              children:  [
                const Align(
                  alignment: Alignment.center,
                  child: TabBar(
                    //  controller: _tabController,
                      isScrollable: true,
                      labelColor: Colors.green,
                      unselectedLabelColor: Colors.black,
                      tabs:[
                        Tab(text:("Pending"),),
                        Tab(text: ('Approval'),),
                        Tab(text: ('Reject'),),
                      ]),
                ),
                const SizedBox(height: 30,),
                Container(
                    height:1100,
                    child:const TabBarView(children: [
                      NewMemberApprovalPage(),
                      ApprovedMemebers(),
                      RejectMembers(),
                    ])
                )
              ],
            ),
          ),
        ),

      ),
    );
  }
}

class NewMemberApprovalPage extends StatefulWidget {
  const NewMemberApprovalPage({Key? key}) : super(key: key);

  @override
  State<NewMemberApprovalPage> createState() => _NewMemberApprovalPageState();
}

class _NewMemberApprovalPageState extends State<NewMemberApprovalPage> {

  String numbersgroup ="10";
  var numbersgrouplist = ["10",'25','50',
    '100',];
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String type = "Guest";
  String status = "Pending";
  String NotStatus="Pending";
  String approve = "Approved";
  String decline = "Rejected";
  String name = "";
  String firstname = "";
  String? currentRow;
  String? today;
  List<Map<String, dynamic>> data=[];
  String pending="Pending";

  int currentPoNumber = 1;
  String? getNameFromJsonDatasalINv(Map<String, dynamic> jsonItem) {
    return jsonItem['member_id'];
  }
  final ScrollController _scrollController = ScrollController();
  String poNumber = "";
  String? poNo;
  List<Map<String, dynamic>> ponumdata = [];
  String? mID;
  List<Map<String, dynamic>> codedatas = [];


  Future<void> getData() async {
    print('Attempting to make HTTP request...');
    try {
      final url = Uri.parse('http://mybudgetbook.in/GIBADMINAPI/new_member_approval.php?admin_rights=$pending');
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

  Future<void> rejected(int ID) async {
    try {
      final url = Uri.parse('http://mybudgetbook.in/GIBADMINAPI/new_member_approval.php');
      final response = await http.put(
        url,
        body: jsonEncode({
          "admin_rights": "Rejected",
          "id": ID
        }),
      );
      if (response.statusCode == 200) {
        Navigator.push(context, MaterialPageRoute(builder: (context) => const NewMemberApproval()));
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Successfully Rejected")));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Failed to Reject")));
      }
    } catch (e) {
      print("Error during signup: $e");
      // Handle error as needed
    }
  }
  Future<void> approved(int ID) async {
    try {
      final url = Uri.parse('http://mybudgetbook.in/GIBADMINAPI/new_member_approval.php');
      final response = await http.put(
        url,
        body: jsonEncode({
          "admin_rights": "Accepted",
          "id": ID,
          "member_id":salRetNum,
        }),

      );
      print(" member if new${salRetNum}");
      if (response.statusCode == 200) {
        Navigator.push(context, MaterialPageRoute(builder: (context) => const NewMemberApproval()));
       // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Successfully Rejected")));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Failed to Reject")));
      }
    } catch (e) {
      print("Error during signup: $e");
      // Handle error as needed
    }
  }


/*  String generateId() {
    DateTime now = DateTime.now();
    String year = (now.year % 100).toString();
    String month = now.month.toString().padLeft(2, '0');

    if (gID != null && gID!.length >= 11) {
      try {
        String ID = gID!.substring(7);
        print("generateId: $ID");

        int idInt = int.parse(ID) + 1;
        String id = 'GIB$year$month${idInt.toString().padLeft(3, '0')}';
        print("--------------------------------------------------------------: $id");
        print("generateId: $id");
        return id;
      } catch (e) {
        print("Error parsing ID: $e");
        return "";
      }
    } else {
      print("Invalid gID format: $gID");
      return "";
    }
  }*/

  String generateId() {
    DateTime now= DateTime.now();
    String year=(now.year%100).toString();
    String month=now.month.toString().padLeft(2,'0');
    if (gID != null) {
      String iD = gID!.substring(7);
      int idInt = int.parse(iD) + 1;
      String id = 'GIB$year$month${idInt.toString().padLeft(4, '0')}';
      print(id);
      return id;
    }
    return "";
  }
  ///
  List<Map<String, dynamic>> filteredData = [];

  Future<void> ponumfetch() async {
    try {
      final url = Uri.parse('http://mybudgetbook.in/GIBADMINAPI/new_member_approval.php');
      print("ponumurl: $url");
      final response = await http.get(url);
      if (response.statusCode == 200) {
        print("status code: ${response.statusCode}");
        print("status body: ${response.body}");
        final List<dynamic> jsonData = jsonDecode(response.body);
        for (var item in jsonData) {
          gID = getNameFromJsonData(item);
          print('member_id 23: $gID');
        }
        setState(() {
          srnumdata = jsonData.cast<Map<String, dynamic>>();
          print("salRetNumber: $srnumdata");

          salRetNum = generateId();
          print("salRetNo: $salRetNum");
        });
      } else {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('Failed to fetch data'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    } catch (error) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('An error occurred: $error'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  int currentSRNumber = 1;
  String? getNameFromJsonData(Map<String, dynamic> jsonItem) {
    return jsonItem['member_id'];
  }
  String salRetNum = "";
  String? SRNo;
  List<Map<String, dynamic>> srnumdata = [];
  String? gID;
  List<Map<String, dynamic>> srcodedata = [];
  int currentPage = 0;
  final int rowsPerPage = 15;
  int index = 0;
  List<Map<String, dynamic>> getCurrentPageData() {
    final start = currentPage * rowsPerPage;
    final end = start + rowsPerPage;
    return data.sublist(start, end > data.length ? data.length : end);
  }


  ///
  @override
  void initState() {
    getData();
    ponumfetch();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
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
                      child: Column(
                        children:  [
                          const SizedBox(height: 20,),
                          Text("View New Members for Approval", style:Theme.of(context).textTheme.headlineMedium,),
                          const SizedBox(height: 20,),
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

                          const SizedBox(height: 20,),

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
                                    DataColumn(label: Center(child: Text("Action",style: TextStyle(fontWeight: FontWeight.bold),))),
                                  ],
                                  source: MyDataTableSource(
                                    data: filteredData,
                                    context: context,
                                    approved: approved,
                                    rejected: rejected,
                                  )
                                ),
                              ),
                            ),
                          ),

                       /*   Container(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Table(
                                  border: TableBorder.all(),
                                  defaultColumnWidth: const FixedColumnWidth(140.0),
                                  columnWidths: const <int, TableColumnWidth>{
                                    0:FixedColumnWidth(100),
                                    1:FixedColumnWidth(200),
                                    2:FixedColumnWidth(200),
                                    4:FixedColumnWidth(200),
                                  },
                                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                                  children: [
                                    TableRow(
                                        children: [
                                          //s.no
                                          TableCell(child:  Center(
                                            child: Column(
                                              children: [
                                                const SizedBox(height: 8,),
                                                Text('S.No', style: Theme.of(context).textTheme.headlineMedium),
                                                const SizedBox(height: 8,),
                                              ],
                                            ),)),
                                          //Name
                                          TableCell(child: Center(child: Text('Name', style: Theme.of(context).textTheme.headlineMedium,),)),
                                          // Email
                                          TableCell(child:Center(child: Text('Email', style: Theme.of(context).textTheme.headlineMedium,))),
                                          // Mobile
                                          TableCell(child: Center(child: Text('Mobile', style: Theme.of(context).textTheme.headlineMedium,))),
                                          //Role
                                          TableCell(child:Center(child: Text('Company Name', style: Theme.of(context).textTheme.headlineMedium,))),
                                          //status
                                          // TableCell(child: Center(child: Text('Status', style: Theme.of(context).textTheme.headlineMedium,))),
                                          TableCell(child: Center(child: Text('Status', style: Theme.of(context).textTheme.headlineMedium,)))

                                        ]),
                                    //1

                                    for(var i = 0 ;i < data.length; i++) ...[
                                      if(data[i]['first_name']
                                          .toString()
                                          .toLowerCase().startsWith(firstname.toLowerCase()))
                                      // if(name.isEmpty)
                                        TableRow(
                                            children: [
                                              TableCell(child: Center(child: Text("${i+1}", style: Theme.of(context).textTheme.bodySmall,))),
                                              //2
                                              TableCell(child: Padding(
                                                padding: const EdgeInsets.only(left: 10),
                                                child: Text("${data[i]["first_name"]}",style: Theme.of(context).textTheme.bodySmall,),
                                              )),
                                              //3
                                              TableCell(child: Padding(
                                                padding: const EdgeInsets.only(left: 10),
                                                child: Text("${data[i]["email"]}",style: Theme.of(context).textTheme.bodySmall,),
                                              )),
                                              //4
                                              TableCell(child:Padding(
                                                padding: const EdgeInsets.only(left: 10),
                                                child: Text("${data[i]["mobile"]}",style: Theme.of(context).textTheme.bodySmall,),
                                              )),
                                              //5
                                              TableCell(child:Padding(
                                                padding: const EdgeInsets.only(left: 10),
                                                child: Text("${data[i]["company_name"]}",style: Theme.of(context).textTheme.bodySmall,),
                                              )),

                                              TableCell(child:
                                              IconButton(

                                                  onPressed: (){
                                                showDialog<void>(
                                                  context: context,
                                                  builder: (BuildContext dialogContext) {
                                                    return AlertDialog(
                                                      backgroundColor: Colors.white,
                                                      actions: <Widget>[
                                                        Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            const SizedBox(height: 20,),
                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment.end,

                                                              children: [
                                                                IconButton(onPressed: (){
                                                                  Navigator.pop(context);
                                                                }, icon: Icon(Icons.cancel_presentation,color: Colors.red,))
                                                              ],
                                                            ),
                                                            SizedBox(height: 10,),

                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children: [
                                                                const Column(
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: [
                                                                    Text("Status"),
                                                                    Text("Referrer Id"),
                                                                    Text("Referrer Number"),

                                                                  ],
                                                                ),
                                                                Column(
                                                                  crossAxisAlignment: CrossAxisAlignment.end,
                                                                  children: [
                                                                    Text("InActive"),
                                                                    // Text(data[i]["Referrer Id"]),
                                                                    Text(data[i]["referrer_mobile"]),

                                                                  ],
                                                                )
                                                              ],
                                                            ),
                                                            SizedBox(height: 10,),
                                                            Wrap(
                                                              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                              children: [
                                                                //  const SizedBox(width: 20,),
                                                                ElevatedButton(onPressed: () async {
                                                                  showDialog<void>(
                                                                    context: context,
                                                                    builder: (BuildContext dialogContext) {
                                                                      return AlertDialog(
                                                                        title: Text("Alert"),
                                                                        content: Text("Do you want to Approve the Member?"),
                                                                        backgroundColor: Colors.white,
                                                                        actions: <Widget>[
                                                                          Column(
                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                            children: [
                                                                              Wrap(
                                                                                // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                                children: [
                                                                                  //  const SizedBox(width: 20,),
                                                                                  TextButton(onPressed: () async {
                                                                                    approved(int.parse(data[i]["id"]));
                                                                                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                                                                        content: Text("You have Successfully Approved")));
                                                                                  },
                                                                                      child:  Text("Approve",style: TextStyle(fontSize: 9),)),
                                                                                  const SizedBox(width: 10,),
                                                                                  TextButton(onPressed: () async {
                                                                                    Navigator.pop(context);
                                                                                  }, child: const Text("Cancel",style: TextStyle
                                                                                    (fontSize: 9),)),
                                                                                ],
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ],
                                                                      );
                                                                    },
                                                                  );
                                                                },
                                                                    child:  Text("Approve",style: TextStyle(fontSize: 9),)),
                                                                const SizedBox(width: 10,),
                                                                OutlinedButton(onPressed: () async {
                                                                  showDialog<void>(
                                                                    context: context,
                                                                    builder: (BuildContext dialogContext) {
                                                                      return AlertDialog(
                                                                        title: Text("Alert"),
                                                                        content: Text("Do you want to reject the member?"),
                                                                        backgroundColor: Colors.white,
                                                                        actions: <Widget>[
                                                                          Column(
                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                            children: [
                                                                              Wrap(
                                                                                // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                                children: [
                                                                                  TextButton(onPressed: () async
                                                                                  {
                                                                                    rejected(int.parse(data[i]["id"]));
                                                                                  },
                                                                                      child:  Text("Reject",style: TextStyle(fontSize: 9),)),
                                                                                  const SizedBox(width: 10,),
                                                                                  TextButton(onPressed: () async {
                                                                                    Navigator.pop(context);
                                                                                  }, child: const Text("cancel",style: TextStyle(fontSize: 9),)),
                                                                                ],
                                                                              ),

                                                                            ],
                                                                          ),
                                                                        ],
                                                                      );
                                                                    },
                                                                  );

                                                                },
                                                                    child:  Text("Reject",style: TextStyle(fontSize: 9),)),

                                                              ],
                                                            ),

                                                          ],
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                              }, icon: Icon(Icons.edit,color: Colors.blue,),)
                                              )
                                             // child: const Text("Pending",style: TextStyle(color: Colors.orangeAccent),))),
                                            ]),
                                    ]
                                  ]
                              ),
                            ),
                          ),
                          const SizedBox(height: 40,),*/
                        ],
                      ),
                    ),
                  ),
                ),

              ],
            ),
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
  final Function(int) approved;
  final Function(int) rejected;

  MyDataTableSource({required this.data, required this.context, required this.approved, required this.rejected});

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
        DataCell(Text('${data[index]["first_name"]}')),
        DataCell(Text('${data[index]["mobile"]}')),
        DataCell(Text('${data[index]["company_name"]}')),
        DataCell(
        IconButton(
          onPressed: (){
            showDialog<void>(
              context: context,
              builder: (BuildContext dialogContext) {
                return AlertDialog(
                  backgroundColor: Colors.white,
                  actions: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,

                          children: [
                            IconButton(onPressed: (){
                              Navigator.pop(context);
                            }, icon: Icon(Icons.cancel_presentation,color: Colors.red,))
                          ],
                        ),
                        SizedBox(height: 10,),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Status"),
                                Text("Referrer Id"),
                                Text("Referrer Number"),

                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text("InActive"),
                                // Text(data[i]["Referrer Id"]),
                                Text(data[index]["referrer_mobile"]),

                              ],
                            )
                          ],
                        ),
                        SizedBox(height: 10,),
                        Wrap(
                          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            //  const SizedBox(width: 20,),
                            ElevatedButton(onPressed: () async {
                              showDialog<void>(
                                context: context,
                                builder: (BuildContext dialogContext) {
                                  return AlertDialog(
                                    title: Text("Alert"),
                                    content: Text("Do you want to Approve the Member?"),
                                    backgroundColor: Colors.white,
                                    actions: <Widget>[
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Wrap(
                                            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                              //  const SizedBox(width: 20,),
                                              TextButton(onPressed: () async {
                                                approved(int.parse(data[index]["id"]));
                                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                                    content: Text("You have Successfully Approved")));
                                              },
                                                  child:  Text("Approve",style: TextStyle(fontSize: 9),)),
                                              const SizedBox(width: 10,),
                                              TextButton(onPressed: () async {
                                                Navigator.pop(context);
                                              }, child: const Text("Cancel",style: TextStyle
                                                (fontSize: 9),)),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                                child:  Text("Approve",style: TextStyle(fontSize: 9),)),
                            const SizedBox(width: 10,),
                            OutlinedButton(onPressed: () async {
                              showDialog<void>(
                                context: context,
                                builder: (BuildContext dialogContext) {
                                  return AlertDialog(
                                    title: Text("Alert"),
                                    content: Text("Do you want to reject the member?"),
                                    backgroundColor: Colors.white,
                                    actions: <Widget>[
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Wrap(
                                            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                              TextButton(onPressed: () async
                                              {
                                                rejected(int.parse(data[index]["id"]));
                                              },
                                                  child:  Text("Reject",style: TextStyle(fontSize: 9),)),
                                              const SizedBox(width: 10,),
                                              TextButton(onPressed: () async {
                                                Navigator.pop(context);
                                              }, child: const Text("cancel",style: TextStyle(fontSize: 9),)),
                                            ],
                                          ),

                                        ],
                                      ),
                                    ],
                                  );
                                },
                              );

                            },
                                child:  Text("Reject",style: TextStyle(fontSize: 9),)),

                          ],
                        ),

                      ],
                    ),
                  ],
                );
              },
            );
          }, icon: Icon(Icons.edit,color: Colors.blue,),)
        )
      ],
    );
  }

  @override
  void rowsRefresh() {
    // handle data refresh
  }
}



class ApprovedMemebers extends StatefulWidget {
  const ApprovedMemebers({Key? key}) : super(key: key);

  @override
  State<ApprovedMemebers> createState() => _ApprovedMemebersState();
}

class _ApprovedMemebersState extends State<ApprovedMemebers> {
  String numbersgroup ="10";
  var numbersgrouplist = ["10",'25','50',
    '100',];
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String type = "Guest";
  String status = "Pending";
  String NotStatus="Pending";
  String approve = "Approved";
  String decline = "Rejected";
  String name = "";
  String firstname = "";
  String? currentRow;
  String? today;
  final ScrollController _scrollController = ScrollController();

  List<Map<String, dynamic>> data=[];
  List<Map<String, dynamic>> filteredData = [];
  String approved = "Accepted";
  Future<void> getData() async {
    print('Attempting to make HTTP request...');
    try {
      final url = Uri.parse('http://mybudgetbook.in/GIBADMINAPI/new_member_approval.php?admin_rights=$approved');
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
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
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
                  child: Column(
                    children:  [
                      const SizedBox(height: 20,),
                      Wrap(
                        // mainAxisAlignment: MainAxisAlignment.center,
                        children:[
                          // view approved members
                          //  const Icon(Icons.calendar_today_outlined,color: Colors.green,),
                          Text("View New Approved Members",
                            style:Theme.of(context).textTheme.headlineMedium,),
                        ],
                      ),
                      const SizedBox(height: 20,),
//Search TextFormField starts
                      Align(alignment: Alignment.center,
                        child: SizedBox(
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
                      ),
                      const SizedBox(height: 20,),
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
                                  DataColumn(label: Center(child: Text("Status",style: TextStyle(fontWeight: FontWeight.bold),))),
                                ],
                                source: MyDataTableSourceA(
                                  data: filteredData,
                                  context: context,
                                )
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          ],
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
class MyDataTableSourceA extends DataTableSource {
  List<Map<String, dynamic>> data;
  BuildContext context;

  MyDataTableSourceA({required this.data, required this.context,});

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
        DataCell(Text('${data[index]["first_name"]}')),
        DataCell(Text('${data[index]["mobile"]}')),
        DataCell(Text('${data[index]["company_name"]}')),
        DataCell(Text("${data[index]["admin_rights"]}",style: TextStyle(color: Colors.green),),
        ),
      ],
    );
  }

  @override
  void rowsRefresh() {
    // handle data refresh
  }
}


class RejectMembers extends StatefulWidget {
  const RejectMembers({Key? key}) : super(key: key);

  @override
  State<RejectMembers> createState() => _RejectMembersState();
}

class _RejectMembersState extends State<RejectMembers> {
  String numbersgroup ="10";
  var numbersgrouplist = ["10",'25','50',
    '100',];
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String type = "Guest";
  String status = "Pending";
  String NotStatus="Pending";
  String approve = "Approved";
  String decline = "Rejected";
  String name = "";
  String firstname = "";
  String? currentRow;
  String? today;
  final ScrollController _scrollController = ScrollController();
  List<Map<String, dynamic>> data=[];
  List<Map<String, dynamic>> filteredData = [];
  String rejected = "Rejected";

  Future<void> getData() async {
    print('Attempting to make HTTP request...');
    try {
      final url = Uri.parse('http://mybudgetbook.in/GIBADMINAPI/new_member_approval.php?admin_rights=$rejected');
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
    super.initState();
    getData();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
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
                  child: Column(
                    children:  [
                      const SizedBox(height: 20,),
                      Wrap(
                        // mainAxisAlignment: MainAxisAlignment.center,
                        children:[
                          // view approved members
                          //  const Icon(Icons.calendar_today_outlined,color: Colors.green,),
                          Text("View Rejected Members",
                            style:Theme.of(context).textTheme.headlineMedium,),
                        ],
                      ),
                      const SizedBox(height: 20,),

//Search TextFormField starts
                      Align(alignment: Alignment.topRight,
                        child: SizedBox(
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
                      ),
                      const SizedBox(height: 20,),
                      //Table
                      const SizedBox(height: 20,),
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
                                  DataColumn(label: Center(child: Text("Status",style: TextStyle(fontWeight: FontWeight.bold),))),
                                ],
                                source: MyDataTableSourceReject(
                                  data: filteredData,
                                  context: context,
                                )
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          ],
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
class MyDataTableSourceReject extends DataTableSource {
  List<Map<String, dynamic>> data;
  BuildContext context;

  MyDataTableSourceReject({required this.data, required this.context,});

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
        DataCell(Text('${data[index]["first_name"]}')),
        DataCell(Text('${data[index]["mobile"]}')),
        DataCell(Text('${data[index]["company_name"]}')),
        DataCell(Text("${data[index]["admin_rights"]}",style: TextStyle(color: Colors.red),),
        ),
      ],
    );
  }

  @override
  void rowsRefresh() {
    // handle data refresh
  }
}


