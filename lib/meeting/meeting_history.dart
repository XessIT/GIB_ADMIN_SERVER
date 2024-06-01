import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class MeetingHistory extends StatelessWidget {
  const MeetingHistory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: MeetingHistoryPage(),
    );
  }
}
class MeetingHistoryPage extends StatefulWidget {
  const MeetingHistoryPage({Key? key}) : super(key: key);

  @override
  State<MeetingHistoryPage> createState() => _MeetingHistoryPageState();
}

class _MeetingHistoryPageState extends State<MeetingHistoryPage> {
  final _formKey = GlobalKey<FormState>();
  String? selectedDistrict;
  String? selectedChapter;

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
        route: "/meeting_history_page",
        body:Form(
          key: _formKey,
          child: Center(
              child: Column(
                  children:[
                    Padding(
                        padding:const EdgeInsets.all(8.0),
                        child: Container(
                            color: Colors.white,
                            child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    const SizedBox(height: 30,),
                                    Wrap(
                                      children:  [
                                        Column(
                                          children: [
                                            const SizedBox(height: 30,),
                                            Text(
                                              'Completed Meeting History',style: Theme.of(context).textTheme.headlineMedium,),
                                          ],
                                        )
                                      ],),
                                    // Go back button start
                                    const SizedBox(height: 20,),
                                    Align(alignment: Alignment.topRight,
                                      child: ElevatedButton(onPressed: (){
                                        if(_formKey.currentState!.validate()){}
                                        Navigator.pop(context);}, child: const Text("Go back")),),
                                    const SizedBox(height: 20,),
                                    Align(alignment: Alignment.center,
                                      child: Wrap(
                                          children:  [
                                            const Align(alignment: Alignment.topLeft,),
                                            Padding(
                                              padding: const EdgeInsets.all(25.0),
                                              child: StreamBuilder<QuerySnapshot>(
                                                  stream: FirebaseFirestore
                                                      .instance.collection(
                                                      "District").snapshots(),
                                                  builder: (context, snapshot) {
                                                    if (!snapshot.hasData) {
                                                      const Text('Loading');
                                                    } else {
                                                      List<
                                                          DropdownMenuItem> districtItems = [
                                                      ];
                                                      for (int i = 0; i <
                                                          snapshot.data!.docs
                                                              .length; i++) {
                                                        DocumentSnapshot snap = snapshot
                                                            .data!.docs[i];
                                                        districtItems.add(
                                                          DropdownMenuItem(
                                                              value: "${snap.id}",
                                                              child: Text(
                                                                snap.id,
                                                              )
                                                          ),
                                                        );
                                                      }
                                                      return SizedBox(width:300,
                                                        child: Container(
                                                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                                          decoration: BoxDecoration(
                                                            border: Border.all(color: Colors.grey),
                                                            borderRadius: BorderRadius.circular(5.0),),
                                                          child: DropdownButtonHideUnderline(
                                                            child: DropdownButton<
                                                                dynamic>(
                                                              items: districtItems,
                                                              onChanged: (districtValue) {
                                                                selectedChapter = null;
                                                                setState(() {
                                                                selectedDistrict = districtValue;
                                                                });
                                                              },
                                                              value: selectedDistrict,
                                                              isExpanded: true,
                                                              hint: const Text(
                                                                "Choose District",
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    }
                                                    return const Center(
                                                      child: CircularProgressIndicator(),);
                                                  }
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(22.0),
                                              child: StreamBuilder<QuerySnapshot>(
                                                  stream:FirebaseFirestore.instance.collection("District").
                                                  doc(selectedDistrict).collection("Chapter").snapshots(),
                                                  builder: (context,snapshot) {
                                                    if (!snapshot.hasData) {
                                                      const Text('Loading');
                                                    } else{
                                                      List<DropdownMenuItem> chapterItems=[];
                                                      for(int i=0;i<snapshot.data!.docs.length;i++){
                                                        DocumentSnapshot snap = snapshot.data!.docs[i];
                                                        chapterItems.add(
                                                          DropdownMenuItem(value:snap.id, child: Text(snap.id,
                                                          )
                                                          ),
                                                        );
                                                      }
                                                      return SizedBox(width: 300,
                                                        child: Container(
                                                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                                          decoration: BoxDecoration(
                                                            border: Border.all(
                                                                color: Colors.grey),
                                                            borderRadius: BorderRadius
                                                                .circular(5.0),
                                                          ),
                                                          child: DropdownButtonHideUnderline(
                                                            child: DropdownButton<
                                                                dynamic>(
                                                              items: chapterItems,
                                                              onChanged: (
                                                                  chapterValue) {
                                                                setState(() {
                                                                  selectedChapter =
                                                                      chapterValue;
                                                                });
                                                              },
                                                              value: selectedChapter,
                                                              isExpanded: true,
                                                              hint: const Text(
                                                                "Choose Chapter",
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    }
                                                    return const Center(
                                                      child: CircularProgressIndicator(),
                                                    );
                                                  }
                                              ),
                                            ), // Table Row starting
                                          ]
                                      ),
                                    ),
                                    const SizedBox(height: 20,),
                                    Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: Wrap(
                                        children: [
                                          StreamBuilder<QuerySnapshot>(
                                              stream: FirebaseFirestore.instance.collection("Meeting")
                                                  .where("District", isEqualTo: selectedDistrict)
                                                  .where("Chapter", isEqualTo: selectedChapter)
                                              //.where("Meeting Date",isLessThanOrEqualTo: DateFormat('dd/MM/yyyy').format(now))
                                                  .snapshots(),
                                              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                                if (snapshot.hasError) {
                                                  print("Something went Wrong");
                                                }
                                                if (snapshot.connectionState ==
                                                    ConnectionState.waiting) {
                                                  return const Center(
                                                    child: CircularProgressIndicator(),
                                                  );
                                                }

                                                final List storedocs = [];
                                                snapshot.data!.docs.where((document) => DateTime.parse(document["Meeting Date"]).isBefore(DateTime.now()))
                                                    .map((
                                                    DocumentSnapshot document) {
                                                  Map a = document.data() as Map<String,
                                                      dynamic>;
                                                  storedocs.add(a);
                                                  a['id'] = document.id;
                                                }).toList();
                                                ListView.builder(
                                                    itemCount: storedocs.length,
                                                    itemBuilder: (context, index) {
                                                      return Container();
                                                    });
                                                return Align(alignment: Alignment.topLeft,
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(25.0),
                                                    child: Container(
                                                        child: SingleChildScrollView(
                                                          scrollDirection: Axis.horizontal,
                                                          child: Table(
                                                            border: TableBorder.all(),
                                                            defaultColumnWidth: const FixedColumnWidth(
                                                                180.0),
                                                            columnWidths: const <
                                                                int,
                                                                TableColumnWidth>{
                                                              1: FixedColumnWidth(160),
                                                              0: FixedColumnWidth(100),
                                                            },
                                                            defaultVerticalAlignment: TableCellVerticalAlignment
                                                                .middle,
                                                            children: [
                                                              TableRow(children: [
                                                                //s.no 1
                                                                TableCell(
                                                                  child: Center(child: Column(
                                                                    children: [
                                                                      const SizedBox(height: 8,),
                                                                      Text('S.No',
                                                                        style: Theme
                                                                            .of(context)
                                                                            .textTheme
                                                                            .headlineMedium,),
                                                                      const SizedBox(height: 8,),
                                                                    ],
                                                                  )),),
                                                                // chapter 2
                                                                TableCell(child: Center(child: Text(
                                                                  'Meeting Date', style: Theme
                                                                    .of(context)
                                                                    .textTheme
                                                                    .headlineMedium,))),
                                                                //Date
                                                                TableCell(child: Center(
                                                                    child: Text('Meeting Name', style: Theme
                                                                        .of(context)
                                                                        .textTheme
                                                                        .headlineMedium,))),
                                                                // time from
                                                                TableCell(child: Center(child: Text(
                                                                  'Place', style: Theme
                                                                    .of(context)
                                                                    .textTheme
                                                                    .headlineMedium,),)),
                                                              ]),

                                                              // table row contents
                                                              for (var i = 0; i < storedocs.length; i++) ...[
                                                                //Table Row
                                                                TableRow(
                                                                    decoration: BoxDecoration(
                                                                        color: Colors.grey[200]),
                                                                    children: [
                                                                      TableCell(child: Center(
                                                                        child: Column(
                                                                          children:  [
                                                                            const SizedBox(height: 2,),
                                                                            Text("${i+1}"),
                                                                            const SizedBox(height: 2,),
                                                                          ],),)),
                                                                      //2
                                                                      TableCell(child: Center(
                                                                        child: Column(
                                                                          children:  [
                                                                            const SizedBox(height: 2,),
                                                                            Padding(
                                                                              padding: const EdgeInsets.all(15.0),
                                                                              child: Align(alignment:Alignment.topLeft,
                                                                                  child: Text('${storedocs[i]["Meeting Date"]}')),
                                                                            ),
                                                                            const SizedBox(height: 2,),
                                                                          ],
                                                                        ),)),
                                                                      //3
                                                                      TableCell(child: Center(
                                                                        child: Padding(
                                                                          padding: const EdgeInsets.all(15.0),
                                                                          child: Align(alignment:Alignment.topLeft,
                                                                              child: Text('${storedocs[i]["Meeting Name"]}')),
                                                                        ),)),
                                                                      //4
                                                                      TableCell(child: Center(
                                                                        child: Padding(
                                                                          padding: const EdgeInsets.all(30.0),
                                                                          child: Align(alignment:Alignment.topLeft,
                                                                              child: Text('${storedocs[i]["Place"]}')),
                                                                        ),)),
                                                                    ]
                                                                )
                                                              ]
                                                            ],
                                                          ),
                                                        )
                                                    ),
                                                  ),
                                                );
                                              }),
                                        ],
                                      ),
                                    )
                                  ],
                                )
                            )
                        )
                    )
                  ]
              )
          ),
        )
    );
  }
}

// delete validation start
void _showDialog(BuildContext context) {
  showDialog<void>(
    context: context,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        backgroundColor: Colors.black,
        title: Text('Delete',style: Theme.of(context).textTheme.headlineMedium,),
        content: Text('Are you sure do you want to delete this?',style: Theme.of(context).textTheme.headlineMedium),
        actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                child: Text('Cancel',style: Theme.of(context).textTheme.headlineMedium,),
                onPressed: () {
                  Navigator.of(dialogContext).pop(); // Dismiss alert dialog
                },
              ),
              TextButton(
                child:  Text('Delete',style: Theme.of(context).textTheme.headlineMedium,),
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
