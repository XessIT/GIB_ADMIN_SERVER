import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../main.dart';

class HonorReport extends StatefulWidget {
  const HonorReport({Key? key}) : super(key: key);

  @override
  State<HonorReport> createState() => _HonorReportState();
}

class _HonorReportState extends State<HonorReport> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: HonorReportPage(),
    );
  }
}
class HonorReportPage extends StatefulWidget {
  const HonorReportPage({Key? key}) : super(key: key);

  @override
  State<HonorReportPage> createState() => _HonorReportPageState();
}

class _HonorReportPageState extends State<HonorReportPage> {
  DateTime date = DateTime(2022, 25, 08);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: MyScaffold(
        route:'/honoring_report',
        body: Center(
          child: Column(
              children: [
                // Text("data")
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    color: Colors.white,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            const TabBar(
                              //  controller: _tabController,
                                isScrollable: true,
                                labelColor: Colors.green,
                                unselectedLabelColor: Colors.black,
                                tabs: [
                                 // Tab(text: ("Show All"),),
                                  Tab(text: ('Honoring Report'),),
                                ]),
                            const SizedBox(height: 30,),
                            Container(
                                height: 1100,
                                color: Colors.red,
                                child: const TabBarView(children: [
                                //  ShowAllPage(),
                                  MemberWisePage(),
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


class MemberWisePage extends StatefulWidget {
  const MemberWisePage({Key? key}) : super(key: key);

  @override
  State<MemberWisePage> createState() => _MemberWisePageState();
}

class _MemberWisePageState extends State<MemberWisePage> {


  @override
  Widget build(BuildContext context) {
    return  DefaultTabController(
      length: 1,
      child: Scaffold(
        body: Column(
          children: [
          /*  Container(
              height: 35,
              width: 250,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(0),
              ),
              child: const TabBar(
                indicator: BoxDecoration(
                  color: Colors.green,
                ),
                isScrollable: true,
                unselectedLabelColor: Colors.black,
                tabs:[
                Tab(text:(""),),
                 // Tab(text: ('InCompleted'),),
                ],
              ),
            ),*/
            const Expanded(
              child: TabBarView(children: <Widget>[
                MemberWiseCompleted(),
               // MemberwiseIncompleted(),
              ]),
            ),
          ],
        ),),
    );

  }
}
class MemberWiseCompleted extends StatefulWidget {
  const MemberWiseCompleted({Key? key}) : super(key: key);

  @override
  State<MemberWiseCompleted> createState() => _MemberWiseCompletedState();
}

class _MemberWiseCompletedState extends State<MemberWiseCompleted> {

  String membersgroup ='Select Member Type';
  var membersgrouplist = ['Select Member Type','Gold Member','Silver Member',
    'Executive Member','Non Executive Member',"Women's Wing-Executive Member",
    "Women's Wing-Non Executive Member","Doctor's wing","Student's Wing",];
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String chaptergroup ='Select Member Type';
  var chaptergrouplist = ['Select Member Type','Gold Member','Silver Member',
    'Executive Member','Non Executive Member',"Women's Wing-Executive Member",
    "Women's Wing-Non Executive Member","Doctor's wing","Student's Wing",];

  DateTime date =DateTime(2022,22,08);
  final TextEditingController _date = TextEditingController();
  final TextEditingController _date1 = TextEditingController();

  String? selectedmetlocation;
  // String? selectedcategory;

  String? selecteddate;
  String? selecteddate1;

  String? status= "Successful";
  String name = "";

  int totalcount = 0;
  // String nametotal= name;

  countDocuments(String name) async {
    QuerySnapshot memtotal =
    await FirebaseFirestore.instance.collection('Honoring Slip')
        .where("First Name", isNotEqualTo: name)
        .get();
    List<DocumentSnapshot> memcount = memtotal.docs;
    setState(() {
      totalcount = memcount.length;
    });
    //Count of Documents in Collection
  }



  @override
  void initState() {
    countDocuments(name);
    super.initState();
  }

  String length = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 20,),
              Container(
                color: Colors.white,
                child: Column(
                  children: [
                    Container(
                      width: 1800,
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.grey
                          )
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Wrap(
                              runSpacing: 10,
                              spacing: 10,
                              children: [
                                //DropdownButton District
                                Container(
                                  height: 50,
                                  width:300,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.grey,
                                      ),
                                      borderRadius: BorderRadius.circular(5)
                                  ),
                                  child: StreamBuilder<QuerySnapshot>(
                                      stream: FirebaseFirestore.instance.collection("Honoring Slip")
                                          .snapshots(),
                                      builder: (context, snapshot) {
                                        if (!snapshot.hasData) {
                                          const Text('Loading...');
                                        } else {
                                          List<DropdownMenuItem> teamItems = [];
                                          for (int i = 0; i < snapshot.data!.docs.length; i++) {
                                            DocumentSnapshot snap = snapshot.data!.docs[i];
                                            QuerySnapshot<Object?>? querySnapshot = snapshot.data;
                                            List<QueryDocumentSnapshot> documents = querySnapshot!.docs;
                                            List<Map> items = documents.map((e) =>
                                            {
                                              "id": e.id,
                                              "Location": e['Location'],
                                            }).toList();
                                            var data = snapshot.data!.docs[i];
                                            teamItems.add(
                                              DropdownMenuItem(
                                                  value: "${snap["Location"]}",
                                                  child: Text("${snap["Location"]}")
                                              ),
                                            );
                                          }
                                          return SizedBox(
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: DropdownButtonHideUnderline(
                                                child: DropdownButton<
                                                    dynamic>(
                                                  items: teamItems,
                                                  onChanged: (teamValue) {
                                                    // selectedcategory=null;
                                                    setState(() {
                                                      selectedmetlocation = teamValue;
                                                    });
                                                  },
                                                  value: selectedmetlocation,
                                                  isExpanded: true,
                                                  hint: const Text(
                                                    "Choose Met Location",
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
                                SizedBox(width: 30,),


                                //DropdownButton Chapter
                                const SizedBox(width: 30,),
                                SizedBox(width: 300,
                                  child: TextFormField(
                                    onChanged: (val){         //search bar
                                      setState(() {
                                        name = val ;
                                      });
                                    },
                                    decoration:  const InputDecoration(
                                      prefixIcon: Icon(Icons.search,color: Colors.green,),
                                      hintText: 'Search Member Name ',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.grey
                          )
                      ),
                      child: Column(
                        children: [
                          SizedBox(height: 20,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Align(
                                alignment: Alignment.topLeft,
                                child: SizedBox(
                                    height: 100,
                                    child: Image.asset("assets/logo.png",)),
                              ),

                              Row(
                                // mainAxisAlignment:MainAxisAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          const Text("Indivudual Member Name :"),
                                          Text(name),
                                        ],
                                      ),
                                      const SizedBox(height: 20,),
                                      Row(
                                        children:
                                        [
                                          Text("Business Name :"),
                                          Text("Xessinfotech"),
                                        ],
                                      ),
                                      const SizedBox(height: 20,),
                                      Row(
                                        children: [
                                          const Text("Total Count :"),
                                          //  countDocuments(name),
                                          Text(totalcount.toString())
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 30,),


                        ],
                      ),
                    ),
                    //dataTable Container
                    StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance.collection("Honoring Slip")
                            .where("Location", isEqualTo: selectedmetlocation).snapshots(),
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
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.grey
                                  )
                              ),
                              child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Column(children: [Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Table(
                                        border: TableBorder.all(),
                                        defaultColumnWidth: const FixedColumnWidth(250.0),
                                        columnWidths: const <int, TableColumnWidth>{
                                          0:FixedColumnWidth(80),5:FixedColumnWidth(240),
                                        },
                                        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                                        children:[
                                          // Table row start
                                          TableRow(children: [
                                            // S.no
                                            TableCell(child: Center(
                                              child: Text('S.No',style: Theme.of(context).textTheme.headlineMedium,),)),
                                            //Referer name
                                            TableCell(child: Center(
                                              child: Text('First Name',style: Theme.of(context).textTheme.headlineMedium,),)),
                                            //Referer mob no
                                            //Referer company name
                                            TableCell(child: Center(child: Column(children: [const SizedBox(height: 8,),
                                              Text('To',style: Theme.of(context).textTheme.headlineMedium,),
                                              const SizedBox(height: 8,),
                                            ],),)),
                                            //TableCell(child: Center(
                                            //  child: Text('',style: Theme.of(context).textTheme.headlineMedium,),)),
                                            TableCell(child: Center(
                                              child: Text('Date',style: Theme.of(context).textTheme.headlineMedium,),)),
                                            TableCell(child: Center(
                                              child: Text('Location',style: Theme.of(context).textTheme.headlineMedium,),)),
                                            TableCell(child: Center(
                                              child: Text('Amount',style: Theme.of(context).textTheme.headlineMedium,),)),
                                          ]),
                                          for(var i = 0 ;i < storedocs.length; i++) ...[
                                            //Table row start
                                            if (storedocs[i]["First Name"].toString().toLowerCase().startsWith(name.toLowerCase())||storedocs[i]["Location"].toString().toLowerCase().startsWith(name.toLowerCase()))
                                              TableRow(
                                              decoration: BoxDecoration(color: Colors.grey[200]),
                                              children: [
                                                // s.no
                                                TableCell(child: Center(child: Text("${i+1}"),)
                                                ),

                                                // Referer Name
                                                TableCell(child: Center(child: Text("${storedocs[i]["First Name"]}"),)),
                                                // Referer mob no
                                                // Referer company name
                                                TableCell(child: Center(child: Column(
                                                  children:  [const SizedBox(height: 8,),Text("${storedocs[i]["To"]}",), SizedBox(height: 8,),
                                                  ],),),),
                                                TableCell(child: Center(child: Text("${storedocs[i]["Date"]}"),)),
                                                TableCell(child: Center(child: Text("${storedocs[i]["Location"]}"),)),
                                                TableCell(child: Center(child: Text("${storedocs[i]["Amount"]}"),)),
                                                // TableCell(child: Center(child: Text("${storedocs[i]["Purpose"]}"),)),
                                              ],
                                            ),

                                          ]

                                        ]
                                    ),

                                  ),
                                  ]
                                  )
                              )
                          );
                        }


                    ),


                  ],
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}

