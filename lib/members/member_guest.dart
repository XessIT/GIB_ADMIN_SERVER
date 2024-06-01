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


  String numbersgroup ="10";
  var numbersgrouplist = ["10",'25','50',
    '100',];

  String name = "";
  String type = "Guest";
  List<Map<String,dynamic>> data =[];
  Future<void> getData() async {
    print('Attempting to make HTTP request...');
    try {
      final url = Uri.parse('http://mybudgetbook.in/GIBADMINAPI/registration_admin.php?table=registration&member_type=$type');
      print("Guest url: $url");
      final response = await http.get(url);
      print("Guest ResponseStatus: ${response.statusCode}");
      print("Guest Response: ${response.body}");
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print("Guest ResponseData: $responseData");
        final List<dynamic> itemGroups = responseData;
        setState(() {});
        data = itemGroups.cast<Map<String, dynamic>>();
        print('Guest Data: $data');
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
                  // view guest end text icon
                  const SizedBox(height: 10,),
                  // Go back ElevatedButton starts

                  // Go back ElevatedButton end

                  const SizedBox(height: 7,),

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

                  const SizedBox(height: 27,),

                  //Table Starts
            SingleChildScrollView(
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
                          ]),
                    //1

                    for(var i = 0 ;i < data.length; i++) ...[
                      if(data[i]['first_name']
                          .toString()
                          .toLowerCase().startsWith(name.toLowerCase()))
                        TableRow(
                            children: [
                              TableCell(child: Center(child: Column(
                                children: [
                                  const SizedBox(height: 8,),
                                  Text("${i+1}", style: Theme.of(context).textTheme.bodySmall,),
                                  const SizedBox(height: 8,)
                                ],
                              ))),
                              //2
                              TableCell(child: Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Text('${data[i]["first_name"]}', style: Theme.of(context).textTheme.bodySmall,),
                              )),
                              //3
                              TableCell(child: Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Text('${data[i]["email"]}', style: Theme.of(context).textTheme.bodySmall,),
                              )),
                              //4
                              TableCell(child:Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Text('${data[i]["mobile"]}', style: Theme.of(context).textTheme.bodySmall,),
                              )),
                              //5
                              TableCell(child:Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Text("${data[i]["company_name"]}", style: Theme.of(context).textTheme.bodySmall,),
                              )),
                              //6
                              ])
                    ]
                  ]),
            ),
                            /*
                  StreamBuilder<QuerySnapshot>(
                      stream: guestStream,
                      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          print("Something went Wrong");
                        }
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        final List storedocs = [];
                        snapshot.data!.docs.map((DocumentSnapshot document) {
                          Map a = document.data() as Map<String, dynamic>;
                          storedocs.add(a);
                          a['id'] = document.id;
                        }).toList();
                        ListView.builder(
                            itemCount: storedocs.length,
                            itemBuilder: (context, index){
                              return Container();
                            });

                        return Container(
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
                                              Text('S.No', style: Theme.of(context).textTheme.headline4),
                                              const SizedBox(height: 8,),
                                            ],
                                          ),)),
                                        //Name
                                        TableCell(child: Center(child: Text('Name', style: Theme.of(context).textTheme.headline4,),)),
                                        // Email
                                        TableCell(child:Center(child: Text('Email', style: Theme.of(context).textTheme.headline4,))),
                                        // Mobile
                                        TableCell(child: Center(child: Text('Mobile', style: Theme.of(context).textTheme.headline4,))),
                                        //Role
                                        TableCell(child:Center(child: Text('Company Name', style: Theme.of(context).textTheme.headline4,))),
                                        //status
                                        TableCell(child: Center(child: Text('Status', style: Theme.of(context).textTheme.headline4,)))]),
                                  //1

                                  for(var i = 0 ;i < storedocs.length; i++) ...[
                                    if(storedocs[i]['First Name']
                                        .toString()
                                        .toLowerCase().startsWith(name.toLowerCase()))
                                    TableRow(
                                        children: [
                                           TableCell(child: Center(child: Column(
                                            children: [
                                              const SizedBox(height: 8,),
                                              Text("${i+1}"),
                                              const SizedBox(height: 8,)
                                            ],
                                          ))),
                                      //2
                                      TableCell(child: Padding(
                                        padding: const EdgeInsets.only(left: 10),
                                        child: Text('${storedocs[i]["First Name"]}'),
                                      )),
                                      //3
                                      TableCell(child: Padding(
                                        padding: const EdgeInsets.only(left: 10),
                                        child: Text('${storedocs[i]["Email"]}'),
                                      )),
                                      //4
                                      TableCell(child:Padding(
                                        padding: const EdgeInsets.only(left: 10),
                                        child: Text('${storedocs[i]["Mobile"]}'),
                                      )),
                                      //5
                                      TableCell(child:Padding(
                                        padding: const EdgeInsets.only(left: 10),
                                        child: Text("${storedocs[i]["Company Name"]}"),
                                      )),
                                      //6
                                      TableCell(child: Padding(
                                        padding: const EdgeInsets.only(left: 10),
                                        child: Text("${storedocs[i]["Member Status"]}"),
                                      ))])
                                  ]
                                ]),
                          ),
                        );
                      }
                  ),
                            */
                  //Table End

                  const SizedBox(height: 40,),
                ]
            )
        )
    );
  }
}

