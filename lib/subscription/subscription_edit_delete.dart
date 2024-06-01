
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gibadmin/main.dart';
import 'package:gibadmin/subscription/subscription_edit_editpage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class SubcriptionEditDelete extends StatelessWidget {
  const  SubcriptionEditDelete({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  const Scaffold(
      body: SubscriptionPage(),
    );
  }
}
class SubscriptionPage extends StatefulWidget {
  const SubscriptionPage({Key? key}) : super(key: key);

  @override
  State<SubscriptionPage> createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionPage> {
  final _formkey = GlobalKey<FormState>();
  ///Subscription get code
  ///member type
  List<Map<String, dynamic>> stordocs = [];
  Future<void> getSubscription() async {
    try {
      final url = Uri.parse('http://mybudgetbook.in/GIBADMINAPI/subscription.php?table=subscription');
      print('subscription_url :$url');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final List<dynamic> member = responseData;
        print("subscription-status code :${response.statusCode}");
        print("subscription-response body :${response.body} ");

        setState(() {
          stordocs = member.cast<Map<String, dynamic>>();
          print("subscription fetch table code: $stordocs");

        });
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }
  Future<void> subscriptionDelete(String getID) async {
    try {
      final url = Uri.parse('http://mybudgetbook.in/GIBADMINAPI/subscription.php?id=$getID');
      print('member_category_url :$url');
      final response = await http.delete(url);
      if (response.statusCode == 200) {
        print("Cat-status code :${response.statusCode}");
        print("Cat-response body :${response.body}");
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }



  @override
  void initState() {
    // TODO: implement initState
    getSubscription();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return MyScaffold(route: '/subscription_edit_delete',
        body:SingleChildScrollView(
          child: SafeArea(
            child: Center(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Container(
                      color: Colors.white,
                      child: Form(
                        key:_formkey,
                        child:Center(
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Column(
                              children: [
                                const SizedBox(height: 20,),
                                //View Subscription List Text Starts
                                Text('View Subscription List',
                                    style: Theme.of(context).textTheme.displayLarge),
                                //View Subscription List Text End
                                const SizedBox(height: 30,),
                                Container(
                                  height: 300,
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Table(
                                        border: TableBorder.all(),
                                        defaultColumnWidth: const FixedColumnWidth(160.0),
                                        columnWidths: const<int,TableColumnWidth>{
                                          0:FixedColumnWidth(50),
                                          5:FixedColumnWidth(140),
                                        },
                                        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                                        children: [
                                          TableRow(
                                              children: [
                                                //S.No
                                                TableCell(
                                                  child:  Center(
                                                    child: Column(
                                                      children: [
                                                        const  SizedBox(height: 8,),
                                                        Text('S.No',
                                                          style: Theme.of(context).textTheme.headlineMedium,
                                                        ),
                                                        const SizedBox(height: 8,),
                                                      ],
                                                    ),
                                                  ),
                                                ),//Member Id
                                                TableCell(
                                                  child: Center(
                                                    child: Text('Members',
                                                      style: Theme.of(context).textTheme.headlineMedium,
                                                    ),
                                                  ),
                                                ),
                                                //Subscription From
                                                TableCell(
                                                  child: Center(
                                                    child: Text('Subscription From',
                                                      style: Theme.of(context).textTheme.headlineMedium,
                                                    ),
                                                  ),
                                                ),
                                                //Subscription To
                                                TableCell(
                                                  child:  Center(
                                                    child: Text('Subscription To',
                                                      style: Theme.of(context).textTheme.headlineMedium,
                                                    ),
                                                  ),
                                                ),
                                                //Amount
                                                TableCell(
                                                  child:  Center(
                                                    child: Text('Amount',
                                                      style: Theme.of(context).textTheme.headlineMedium,
                                                    ),
                                                  ),
                                                ),
                                                //Schedule Date
                                                TableCell(
                                                  child: Center(
                                                    child: Text('Schedule Date',
                                                      style: Theme.of(context).textTheme.headlineMedium,
                                                    ),
                                                  ),
                                                ),
                                                //Action
                                                TableCell(
                                                  child: Center(
                                                    child: Text('Action',
                                                      style: Theme.of(context).textTheme.headlineMedium,
                                                    ),
                                                  ),
                                                ),
                                              ]
                                          ),
                                          for (var i = 0; i < stordocs.length; i++) ...[
                                            TableRow(
                                                decoration: BoxDecoration(color: Colors.grey[200]),
                                                children: [
                                                  //1
                                                  TableCell(
                                                    child: Center(
                                                      child: Text("${i+1}",
                                                        //style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold),
                                                      ),
                                                    ),
                                                  ),
                                                  TableCell(
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: Text('${stordocs[i]["member_type"]}\n${stordocs[i]["member_category"]}',
                                                        // style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold),
                                                      ),
                                                    ),
                                                  ),
                                                  TableCell(
                                                    child: Center(
                                                      child: Text(
                                                        // Assuming stordocs[i]["to_year"] is a String in ISO 8601 format
                                                        DateFormat('dd/MM/yyyy').format(DateTime.parse(stordocs[i]["from_year"])),
                                                      ),
                                                    ),
                                                  ),

                                                  //27-09-2023
                                                  TableCell(
                                                    child: Center(
                                                      child: Text(
                                                        // Assuming stordocs[i]["to_year"] is a String in ISO 8601 format
                                                        DateFormat('dd/MM/yyyy').format(DateTime.parse(stordocs[i]["to_year"])),
                                                      ),
                                                    ),
                                                  ),
                                                  //6000
                                                  TableCell(
                                                    child: Center(
                                                      child: Text('${stordocs[i]["subscription_amount"]}',
                                                        //style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold),
                                                      ),
                                                    ),
                                                  ),
                                                  //27-09-2022
                                                  TableCell(
                                                    child: Center(
                                                      child: Text(
                                                        // Assuming stordocs[i]["to_year"] is a String in ISO 8601 format
                                                        DateFormat('dd/MM/yyyy').format(DateTime.parse(stordocs[i]["schedule_date"])),
                                                      ),
                                                    ),
                                                  ),
                                                  //Cancel
                                                  TableCell(
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        //edit_note_sharp IconButton
                                                        IconButton(onPressed: (){
                                                          String formattedDate = DateFormat('dd/MM/yyyy').format(DateTime.parse(stordocs[i]["from_year"]));
                                                          String formattedtoDate = DateFormat('dd/MM/yyyy').format(DateTime.parse(stordocs[i]["to_year"]));
                                                          String formattedscheduleDate = DateFormat('dd/MM/yyyy').format(DateTime.parse(stordocs[i]["schedule_date"]));

                                                          Navigator.push(context, MaterialPageRoute(builder: (context) => SubscriptionEditPage(
                                                              id: stordocs[i]["id"],
                                                              currentfromyear: formattedDate,
                                                              currenttoyear: formattedtoDate,
                                                              currentmembertype: stordocs[i]["member_type"],
                                                              currentmembercategory: stordocs[i]["member_category"],
                                                              currentsubscriptionamount: stordocs[i]["subscription_amount"],
                                                              currentscheduledate:formattedscheduleDate,
                                                              currentdistrict: stordocs[i]["district"],
                                                              currentchapter: stordocs[i]["chapter"]
                                                          )));
                                                          //  Navigator.pushNamed(context, "/subscription_edit_page");
                                                        },
                                                            icon: const Icon(Icons.edit_note_sharp,color: Colors.blue,)),
                                                        const SizedBox(width: 20,),

                                                        //delete  IconButtonstarts
                                                        IconButton(
                                                            icon: const Icon(Icons.delete,color: Colors.red,),
                                                            onPressed: () {
                                                              showDialog(
                                                                  context: context,
                                                                  builder: (ctx) =>
                                                                  // Dialog box for register meeting and add guest
                                                                  AlertDialog(
                                                                    backgroundColor: Colors.grey[800],
                                                                    title: const Text('Delete',
                                                                        style: TextStyle(color: Colors.white)),
                                                                    content: const Text("Do you want to Delete the Subscription Details?",
                                                                        style: TextStyle(color: Colors.white)),
                                                                    actions: [
                                                                      TextButton(
                                                                          onPressed: () async{
                                                                            subscriptionDelete(stordocs[i]["id"]);
                                                                             Navigator.push(context, MaterialPageRoute(builder: (context)=>SubcriptionEditDelete()));
                                                                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                                                                content: Text("You have Successfully Deleted a Subscription Details")));
                                                                          },
                                                                          child: const Text('Yes')),
                                                                      TextButton(
                                                                          onPressed: () {
                                                                            Navigator.pop(context);
                                                                          },
                                                                          child: const Text('No'))
                                                                    ],
                                                                  )
                                                              );
                                                            }
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ]
                                            )

                                          ],]
                                    ),
                                  ),
                                ),
                                //Table Starts
/*
                                StreamBuilder<QuerySnapshot>(
                                    stream: subscription,
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
                                    return;
                                  }
                                ),
*/
                                //Table End
                                const SizedBox(height: 30,),


                              ],
                            ),
                          ),
                        ) ,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ) );
  }
}
void _showDialog(BuildContext context) {
  showDialog<void>(
    context: context,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        backgroundColor: Colors.black,
        title: Text('Delete',style: Theme.of(context).textTheme.headlineSmall,),
        content: Text('Are you sure do you want delete this?',style: Theme.of(context).textTheme.bodyLarge),
        actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                child: Text('cancel',style: Theme.of(context).textTheme.headlineSmall,),
                onPressed: () {
                  Navigator.of(dialogContext).pop(); // Dismiss alert dialog
                },
              ),
              TextButton(
                child:  Text('delete',style: Theme.of(context).textTheme.headlineSmall,),
                onPressed: () {
                  // Navigator.of(dialogContext).pop(); // Dismiss alert dialog
                },
              ),
            ],
          ),
        ],
      );
    },
  );
}

