import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
//import 'package:table_paginator/table_paginator.dart';
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
                          //View Women's Executive Members text and icon end


                          Wrap(
                            runSpacing: 20,spacing: 20,
                            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              //search
                              SizedBox(width: 300,
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
                              const SizedBox(width: 20,height: 5,),
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(),
                                  onPressed: (){
                                    if(_formKey.currentState!.validate()){}
                                    Navigator.pop(context);},
                                  child:const Text("Go Back",
                                    style: TextStyle(fontSize: 10),)),
                              const SizedBox(width: 20,height: 5,),

                            ],
                          ),

                          const SizedBox(height: 40,),
                                 Container(
                                  // height: 300,
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Column(
                                      children: [
                                        Table(
                                          border: TableBorder.all(),
                                          defaultColumnWidth:const FixedColumnWidth(190.0),
                                          columnWidths: const<int,TableColumnWidth>{
                                            0:FixedColumnWidth(70),2:FixedColumnWidth(100), 5:FixedColumnWidth(70)},
                                          //  5:FixedColumnWidth(140),},
                                          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                                          children: [
                                            TableRow(
                                                children: [
                                                  //s.no
                                                  TableCell(child:  Center(child: Column(children: [const SizedBox(height: 8,), Text('S.No', style: Theme.of(context).textTheme.headlineMedium), const SizedBox(height: 8,),],),)),
                                                  //name
                                                  TableCell(child:  Center(child: Text('Name', style: Theme.of(context).textTheme.headlineMedium),),),
                                                  // user id
                                                  TableCell(child:  Center(child: Text('User Id', style: Theme.of(context).textTheme.headlineMedium),),),
                                                  // email
                                                  TableCell(child: Center(child: Text('Email', style: Theme.of(context).textTheme.headlineMedium),),),
                                                  // mobile
                                                  TableCell(child:  Center(child: Text('Mobile', style: Theme.of(context).textTheme.headlineMedium),),),
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
                                        // const SizedBox(height: 30,),
                                        Align(
                                          alignment: Alignment.topRight,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [

                                             /* TablePaginator(
                                                pageSizeOptions: const [2,5,10,25],
                                                itemsPerPageLabel: "hello",
                                                pageSize: pageSize,
                                                pageIndex: activePage,
                                                length: data.length,
                                                onPageSizeChanged: (newValue) {
                                                  setState(() {
                                                    activePage = 0;
                                                    pageSize = newValue;
                                                  });
                                                },
                                                onSkipPreviousPressed: () {
                                                  setState(() {
                                                    activePage = 0;
                                                  });
                                                },
                                                onPreviousPressed: () {
                                                  setState(() {
                                                    activePage = activePage - 1;
                                                  });
                                                },
                                                onNextPressed: () {
                                                  setState(() {
                                                    activePage = activePage + 1;
                                                  });
                                                },
                                                onSkipNextPressed: (lastPage) {
                                                  setState(() {
                                                    activePage = lastPage;
                                                  });
                                                },
                                              ),*/
                                            ],
                                          ),
                                        ),



                                      ],
                                    ),

                                  ),
                                )
                                /*return PaginatedDataTable( source: _data,columns: [
        DataColumn(label: Text('S.No', style: Theme.of(context).textTheme.headlineMedium),),
        DataColumn(label: Text('Name', style: Theme.of(context).textTheme.headlineMedium),),
        DataColumn(label: Text('User Id', style: Theme.of(context).textTheme.headlineMedium),)],);*/



                                //return CircularProgressIndicator();   //Table ends



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
}
/*class MyData extends DataTableSource {
  String name="";
  // Generate some made-up data

  List<DocumentSnapshot> register = <DocumentSnapshot>[];
  List<Map<String, dynamic>> _data = [];

  final user = FirebaseAuth.instance.currentUser;

  final CollectionReference _users =
  FirebaseFirestore.instance.collection('Register');
  @override
  bool get isRowCountApproximate => false;
  @override
  int get rowCount => _data.length;
  @override
  int get selectedRowCount => 0;
  @override
  DataRow getRow(int index) {
    return


    DataRow(
        cells: [
   // for (var i = 0; i < _data.length; i++) ...[
   // if( _data[i]["First Name"].toString().toLowerCase().startsWith(name.toLowerCase()))
      DataCell(Text('${_data[index]["Email"]}',),),
    DataCell(Text('${_data[index]["First Name"]}',),),
      DataCell(Text("${_data[index]["Mobile"]}"),
    )];
  }
}*/

