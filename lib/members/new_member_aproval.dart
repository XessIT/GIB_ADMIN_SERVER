import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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

                      //  NewMemberApprovalPage(),
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
  String poNumber = "";
  String? poNo;
  List<Map<String, dynamic>> ponumdata = [];
  String? mID;
  List<Map<String, dynamic>> codedatas = [];
  String generateID() {
    DateTime now=DateTime.now();
    String year=(now.year%100).toString();
    String month=now.month.toString().padLeft(2,'0');
    if (mID != null) {
      String ID = mID!.substring(7);
      int idInt = int.parse(ID) + 1;
      String id = 'GI$year$month/${idInt.toString().padLeft(3, '0')}';
      print(id);
      return id;
    }
    return "";
  }
  Future<void> memberIDGenerate() async {
    try {
      final response = await http.get(Uri.parse('http://localhost:3309/generate_id'));
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body);
        for(var item in jsonData){
          mID = getNameFromJsonDatasalINv(item);
          print('member_id: $mID');
        }
        setState(() {
          ponumdata = jsonData.cast<Map<String, dynamic>>();
          poNumber = generateID(); // Call generateId here
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




  Future<void> getData() async {
    print('Attempting to make HTTP request...');
    try {
      final url = Uri.parse('http://mybudgetbook.in/GIBADMINAPI/new_member_approval.php?admin_rights=$pending');
      // final url = Uri.parse('http://207.174.212.202/getData.php');
      // final url = Uri.parse('http://localhost/API/getData.php');

      print(url);
      final response = await http.get(url);
      print("ResponseStatus: ${response.statusCode}");
      print("Response: ${response.body}");
      // http.Response response = await http.get(url);
      //  var data = jsonDecode(response.body);
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
      // var dataReceived = json.decode(response.body);
      // print(dataReceived);
      // return dataReceived;
    } catch (e) {
      print('Error making HTTP request: $e');
      throw e; // rethrow the error if needed
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
  ///


  Future<void> ponumfetch() async {
    try {
      final url = Uri.parse('http://mybudgetbook.in/GIBADMINAPI/new_member_approval.php');
      // final url = Uri.parse('http://207.174.212.202/getData.php');
      // final url = Uri.parse('http://localhost/API/getData.php');
      print("ponumurl:$url");
      final response = await http.get(url);
  //    final response = await http.get(Uri.parse('http://mybudgetbook.in/GIBADMINAPI/new_member_approval.php'));
      if (response.statusCode == 200) {
        print("status code:${response.statusCode}");
        print("status body:${response.body}");
        final List<dynamic> jsonData = jsonDecode(response.body);
        for(var item in jsonData){
          gID = getNameFromJsonData(item);
          print('member_id: $gID');
        }
        setState(() {
          srnumdata = jsonData.cast<Map<String, dynamic>>();
          print("salRetNumber:$srnumdata");

          salRetNum = generateId();
          print("salRetNo:$salRetNum");
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

  String generateId() {
    DateTime now=DateTime.now();
    String year=(now.year%100).toString();
    String month=now.month.toString().padLeft(2,'0');

    if (gID != null) {
      String ID = gID!.substring(7);
      print("generateId:$ID");

      int idInt = int.parse(ID) + 1;
      String id = 'GIB$year$month${idInt.toString().padLeft(4, '0')}';
      print("--------------------------------------------------------------:$id");
      print("generateId:$id");
      return id;
    }
    return "";
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
                           Row(
                             mainAxisAlignment: MainAxisAlignment.end,
                             children: [
                               SizedBox(
                                width: 300,
                                height: 50,
                                child: TextFormField(
                                  onChanged: (val){         //search bar
                                    setState(() {
                                      firstname = val ;
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
                              ),]
                           ),

                          const SizedBox(height: 20,),
                          Container(
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

                                              TableCell(child: IconButton(

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
                                              }, icon: Icon(Icons.edit,color: Colors.blue,),))
                                             // child: const Text("Pending",style: TextStyle(color: Colors.orangeAccent),))),
                                            ]),
                                    ]
                                  ]
                              ),
                            ),
                          ),
                          const SizedBox(height: 40,),
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

  List<Map<String, dynamic>> data=[];
  String approved = "Accepted";
  Future<void> getData() async {
    print('Attempting to make HTTP request...');
    try {
      final url = Uri.parse('http://mybudgetbook.in/GIBADMINAPI/new_member_approval.php?admin_rights=$approved');
      // final url = Uri.parse('http://207.174.212.202/getData.php');
      // final url = Uri.parse('http://localhost/API/getData.php');
      print(url);
      final response = await http.get(url);
      print("ResponseStatus: ${response.statusCode}");
      print("Response: ${response.body}");
      // http.Response response = await http.get(url);
      //  var data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print("ResponseData: $responseData");
        final List<dynamic> itemGroups = responseData;
        setState(() {});
        data = itemGroups.cast<Map<String, dynamic>>();
        print('Data: $data');
        print("Id: ${data[0]["ID"]}");
      } else {
        print('Error: ${response.statusCode}');
      }
      print('HTTP request completed. Status code: ${response.statusCode}');
    } catch (e) {
      print('Error making HTTP request: $e');
      throw e; // rethrow the error if needed
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
                    /*  // go back
                      Align(alignment: Alignment.topRight,
                        child: ElevatedButton(onPressed: (){
                          if(_formKey.currentState!.validate()){}
                          Navigator.pop(context);
                        },
                            child: const Text("Go back",style: TextStyle(fontSize: 9),)),
                      ),

                      //show
                      const SizedBox(height: 15,),*/


//Search TextFormField starts
                      Align(alignment: Alignment.topRight,
                        child: SizedBox(width: 380,
                          child: TextFormField(
                            onChanged: (val){         //search bar
                              setState(() {
                                name = val ;
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
//Search TextFormField end
                      const SizedBox(height: 20,),
                      //Table
                      Align(
                        alignment: Alignment.center,
                        child: Container(
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
                                  children:[
                                    //Table row starting
                                    TableRow(
                                        children: [
                                          TableCell(
                                              child:Center(
                                                child: Column(
                                                  children: [
                                                    const SizedBox(height: 8,),
                                                    Text('S.No',
                                                      style: Theme.of(context).textTheme.headlineMedium,),
                                                    const SizedBox(height: 8,)
                                                  ],
                                                ),)),
                                          //Meeting Name
                                          TableCell(
                                              child:Center(
                                                child: Text('Name',
                                                  style: Theme.of(context).textTheme.headlineMedium,),)),
                                          TableCell(
                                              child:Center(
                                                child: Text('Email',
                                                  style: Theme.of(context).textTheme.headlineMedium,),)),
                                          TableCell(
                                              child:Center(
                                                child: Text('Mobile',
                                                  style: Theme.of(context).textTheme.headlineMedium,),)),
                                          TableCell(
                                              child:Center(
                                                child: Text('Company Name',
                                                  style: Theme.of(context).textTheme.headlineMedium,),)),
                                          TableCell(
                                              child:Center(
                                                child: Text('Status',
                                                  style: Theme.of(context).textTheme.headlineMedium,),)),
                                          // Edit
                                        ]),
                                    // Table row end
                                    for(var i = 0 ;i < data.length; i++)...[
                                      if(data[i]['first_name']
                                          .toString()
                                          .toLowerCase().startsWith(name.toLowerCase()))
                                      //Table row start
                                        TableRow(
                                          // decoration: BoxDecoration(color: Colors.grey[200]),
                                            children: [
                                              // 1 s.no
                                              TableCell(child: Center(child: Column(
                                                children: [
                                                  const SizedBox(height: 10,),
                                                  Text("${i+1}",style: Theme.of(context).textTheme.bodySmall,),
                                                  const SizedBox(height: 10,)
                                                ],
                                              ))),
                                              TableCell(child:Padding(
                                                padding: const EdgeInsets.only(left: 10),
                                                child: Text("${data[i]["first_name"]}",style: Theme.of(context).textTheme.bodySmall,),
                                              )
                                              ),
                                              TableCell(child:Padding(
                                                padding: const EdgeInsets.only(left: 10),
                                                child: Text("${data[i]["email"]}",style: Theme.of(context).textTheme.bodySmall,),
                                              )
                                              ),
                                              TableCell(child:Padding(
                                                padding: const EdgeInsets.only(left: 10),
                                                child: Text("${data[i]["mobile"]}",style: Theme.of(context).textTheme.bodySmall,),
                                              )
                                              ),
                                              TableCell(child:Padding(
                                                padding: const EdgeInsets.only(left: 10),
                                                child: Text("${data[i]["company_name"]}",style: Theme.of(context).textTheme.bodySmall,),
                                              )
                                              ),
                                              TableCell(child:Padding(
                                                padding: const EdgeInsets.only(left: 10),
                                                child: Text("${data[i]["admin_rights"]}",style: TextStyle(color: Colors.green),),
                                              )
                                              ),
                                            ]
                                        )
                                    ]
                                  ]
                              )
                          ),
                        ),
                      )
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
  List<Map<String, dynamic>> data=[];
  String rejected = "Rejected";
  Future<void> getData() async {
    print('Attempting to make HTTP request...');
    try {
      final url = Uri.parse('http://mybudgetbook.in/GIBADMINAPI/new_member_approval.php?admin_rights=$rejected');
      print(url);
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print("ResponseData: $responseData");
        final List<dynamic> itemGroups = responseData;
        setState(() {});
        data = itemGroups.cast<Map<String, dynamic>>();
      } else {
        print('Error: ${response.statusCode}');
      }
      print('HTTP request completed. Status code: ${response.statusCode}');
    } catch (e) {
      print('Error making HTTP request: $e');
      throw e; // rethrow the error if needed
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
                      /*// go back
                      Align(alignment: Alignment.topRight,
                        child: ElevatedButton(onPressed: (){
                          if(_formKey.currentState!.validate()){}
                          Navigator.pop(context);
                        },
                            child: const Text("Go back",style: TextStyle(fontSize: 9),)),
                      ),
                      //show
                      const SizedBox(height: 15,),*/
//Search TextFormField starts
                      Align(alignment: Alignment.topRight,
                        child: SizedBox(width: 380,
                          child: TextFormField(
                            onChanged: (val){         //search bar
                              setState(() {
                                name = val ;
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
//Search TextFormField end
                      const SizedBox(height: 20,),
                      //Table
                      Align(
                        alignment: Alignment.center,
                        child: Container(
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
                                  children:[
                                    //Table row starting
                                    TableRow(
                                        children: [
                                          TableCell(
                                              child:Center(
                                                child: Column(
                                                  children: [
                                                    const SizedBox(height: 8,),
                                                    Text('S.No',
                                                      style: Theme.of(context).textTheme.headlineMedium,),
                                                    const SizedBox(height: 8,)
                                                  ],
                                                ),)),
                                          //Meeting Name
                                          TableCell(
                                              child:Center(
                                                child: Text('Name',
                                                  style: Theme.of(context).textTheme.headlineMedium,),)),
                                          TableCell(
                                              child:Center(
                                                child: Text('Email',
                                                  style: Theme.of(context).textTheme.headlineMedium,),)),
                                          TableCell(
                                              child:Center(
                                                child: Text('Mobile',
                                                  style: Theme.of(context).textTheme.headlineMedium,),)),
                                          TableCell(
                                              child:Center(
                                                child: Text('Company Name',
                                                  style: Theme.of(context).textTheme.headlineMedium,),)),
                                          TableCell(
                                              child:Center(
                                                child: Text('Status',
                                                  style: Theme.of(context).textTheme.headlineMedium,),)),
                                          // Edit
                                        ]),
                                    // Table row end
                                    for(var i = 0 ;i < data.length; i++)...[
                                      if(data[i]['first_name']
                                          .toString()
                                          .toLowerCase().startsWith(name.toLowerCase()))
                                      //Table row start
                                        TableRow(
                                          // decoration: BoxDecoration(color: Colors.grey[200]),
                                            children: [
                                              // 1 s.no
                                              TableCell(child: Center(child: Column(
                                                children: [
                                                  const SizedBox(height: 10,),
                                                  Text("${i+1}", style: Theme.of(context).textTheme.bodySmall,),
                                                  const SizedBox(height: 10,)
                                                ],
                                              ))),
                                              TableCell(child:Padding(
                                                padding: const EdgeInsets.only(left: 10),
                                                child: Text("${data[i]["first_name"]}", style: Theme.of(context).textTheme.bodySmall,),
                                              )
                                              ),
                                              TableCell(child:Padding(
                                                padding: const EdgeInsets.only(left: 10),
                                                child: Text("${data[i]["email"]}", style: Theme.of(context).textTheme.bodySmall,),
                                              )
                                              ),
                                              TableCell(child:Padding(
                                                padding: const EdgeInsets.only(left: 10),
                                                child: Text("${data[i]["mobile"]}", style: Theme.of(context).textTheme.bodySmall,),
                                              )
                                              ),
                                              TableCell(child:Padding(
                                                padding: const EdgeInsets.only(left: 10),
                                                child: Text("${data[i]["company_name"]}", style: Theme.of(context).textTheme.bodySmall,),
                                              )
                                              ),
                                              TableCell(child:Padding(
                                                padding: const EdgeInsets.only(left: 10),
                                                child: Text("${data[i]["admin_rights"]}",style: TextStyle(color: Colors.red),),
                                              )
                                              ),
                                            ]
                                        )
                                    ]
                                  ]
                              )
                          ),
                        ),
                      )
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
}





