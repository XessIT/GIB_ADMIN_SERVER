import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class TotalMembers extends StatelessWidget {
  const TotalMembers({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: TotalMembersPage(),
    );
  }
}

class TotalMembersPage extends StatefulWidget {
  const TotalMembersPage({Key? key}) : super(key: key);

  @override
  State<TotalMembersPage> createState() => _TotalMembersPageState();
}

class _TotalMembersPageState extends State<TotalMembersPage> {
  DateTime date = DateTime(2022, 25, 08);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: MyScaffold(
        route:'/total_members',
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
                                  Tab(text: ("Total Gib Members"),),
                                 // Tab(text: ('Member Wise'),),
                                ]),
                            const SizedBox(height: 30,),
                            Container(
                                height: 1100,
                                color: Colors.red,
                                child: const TabBarView(children: [
                                  ShowAllPage(),
                                 // MemberWisePage(),
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

class ShowAllPage extends StatefulWidget {
  const ShowAllPage({Key? key}) : super(key: key);

  @override
  State<ShowAllPage> createState() => _ShowAllPageState();
}

class _ShowAllPageState extends State<ShowAllPage> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String membersgroup ='Select Member Type';
  var membersgrouplist = ['Select Member Type','Gold Member','Silver Member',
    'Executive Member','Non Executive Member',"Women's Wing-Executive Member",
    "Women's Wing-Non Executive Member","Doctor's wing","Student's Wing",];
  String chaptergroup ='Select Member Type';
  var chaptergrouplist = ['Select Member Type','Gold Member','Silver Member',
    'Executive Member','Non Executive Member',"Women's Wing-Executive Member",
    "Women's Wing-Non Executive Member","Doctor's wing","Student's Wing",];



  String? selectedmembertype;
  String? selectedcategory;

  DateTime date =DateTime(2022,22,08);
  final TextEditingController _date = TextEditingController();
  final TextEditingController _date1 = TextEditingController();
  String? selecteddate;
  String? selecteddate1;


  String? timestamp = "Date";

  String totalmem="Member";

  String? selectedDistrict;
  String? selectedChapter;
  String? selectedmemtype;
  String? name="";





  int placeCount = 0;

  countDocuments() async {
    QuerySnapshot myDoc2 =
    await FirebaseFirestore.instance.collection('Register').where("Type", isEqualTo:totalmem).get();
    List<DocumentSnapshot> myDocCount2 = myDoc2.docs;
    setState(() {
      placeCount = myDocCount2.length;
    });
    //Count of Documents in Collection
  }




  @override
  void initState() {
    countDocuments();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return   Scaffold(
      body: Form(
        key:_formKey,
        child: Column(
          children: [
            Container(
              // height: 100,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 15,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: SizedBox(
                            height: 100,width: 100,
                            child: Image.asset("assets/logo.png",)),
                      ),
                      //Count
                      Row(
                        children: [
                          const Align(
                            alignment: Alignment.topRight,
                          ),
                          Text("Total Business Count :"),

                          Text(placeCount.toString()),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 30,),
                  Wrap(
                    runSpacing: 20,
                    spacing: 10,
                    children: [
                      Container(
                        height: 50,
                        width:300,
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.grey
                            ),
                            borderRadius: BorderRadius.circular(5)
                        ),
                        child: StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance.collection("District").snapshots(),
                          builder:(context, snapshot) {
                            if (!snapshot.hasData) {
                              const Text('Loading');
                            } else
                            {
                              List<DropdownMenuItem> districtItems=[];
                              for(int i=0;i<snapshot.data!.docs.length;i++){
                                DocumentSnapshot snap = snapshot.data!.docs[i];
                                districtItems.add(
                                  DropdownMenuItem(
                                      value:snap.id,
                                      child: Text(
                                        snap.id,
                                      )
                                  ),
                                );
                              }
                              return SizedBox(
                                width:300,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<dynamic>(
                                      items: districtItems,
                                      onChanged: (districtValue) {
                                        selectedChapter = null;
                                        setState(() {
                                          selectedDistrict = districtValue;
                                        });
                                      },
                                      value: selectedDistrict,
                                      isExpanded: true,
                                      hint:  const Text(
                                        "Choose District",
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } ,
                        ),
                      ),
                      SizedBox(width: 30,),
                      //DropdownButton Chapter
                      Container(
                        height: 50,
                        width:300,
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.grey
                            ),
                            borderRadius: BorderRadius.circular(5)
                        ),
                        child: StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance.collection("District").doc(selectedDistrict).collection("Chapter").snapshots(),
                          builder:(context, snapshot) {
                            if (!snapshot.hasData) {
                              const Text('Loading');
                            } else
                            {
                              List<DropdownMenuItem> chapterItems=[];
                              for(int i=0;i<snapshot.data!.docs.length;i++){
                                DocumentSnapshot snap = snapshot.data!.docs[i];
                                chapterItems.add(
                                  DropdownMenuItem(
                                      value:snap.id,
                                      child: Text(
                                        snap.id,
                                      )
                                  ),
                                );
                              }
                              return SizedBox(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<dynamic>(
                                      items: chapterItems,
                                      onChanged:(chapterValue)
                                      {
                                        setState(() {
                                          selectedChapter = chapterValue;
                                        });
                                      },
                                      value: selectedChapter,
                                      isExpanded: true,
                                      hint:  const Text(
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
                          } ,
                        ),
                      ),
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
                            stream: FirebaseFirestore.instance.collection("Register")
                             //   .where("Type",isNotEqualTo: "Guest")
                          //  .where("NonExecutive")
                                .where("District", isEqualTo: selectedDistrict)
                                .where("Chapter", isEqualTo: selectedChapter)

                                .snapshots(),

                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                const Text('Loading');
                              } else {
                                List<DropdownMenuItem> teamItems = [];
                                for (int i = 0; i < snapshot.data!.docs.length; i++) {
                                  DocumentSnapshot snap = snapshot.data!.docs[i];
                                  QuerySnapshot<Object?>? querySnapshot = snapshot.data;
                                  List<QueryDocumentSnapshot> documents = querySnapshot!.docs;
                                  List<Map> items = documents.map((e) =>
                                  {
                                    "id": e.id,
                                    "Member Type": e['Member Type'],
                                  }).toList();
                                  var data = snapshot.data!.docs[i];
                                  teamItems.add(
                                    DropdownMenuItem(
                                        value: "${snap["Member Type"]}",
                                        child: Text("${snap["Member Type"]}")
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
                                          setState(() {
                                            selectedmemtype = teamValue;
                                          });
                                        },
                                        value: selectedmemtype,
                                        isExpanded: true,
                                        hint: const Text(
                                          "Choose Member Type",
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
                  const SizedBox(height: 30,),

                ],
              ),
            ),

            //dataTable Container
            Column(
              children: [
                StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance.collection("Register")
                        .where("District", isEqualTo: selectedDistrict)
                        .where("Chapter", isEqualTo: selectedChapter)
                        .where("Member Type", isEqualTo:selectedmemtype )



                        .snapshots(),
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
                                          Text('Email',style: Theme.of(context).textTheme.headlineMedium,),
                                          const SizedBox(height: 8,),
                                        ],),)),
                                        TableCell(child: Center(
                                          child: Text('Mobile',style: Theme.of(context).textTheme.headlineMedium,),)),
                                        TableCell(child: Center(
                                          child: Text('Member Type',style: Theme.of(context).textTheme.headlineMedium,),)),
                                        TableCell(child: Center(
                                          child: Text('Member Category',style: Theme.of(context).textTheme.headlineMedium,),)),
                                        TableCell(child: Center(
                                          child: Text('Company Name',style: Theme.of(context).textTheme.headlineMedium,),)),

                                      ]),
                                      for(var i = 0 ;i < storedocs.length; i++) ...[
                                        if (storedocs[i]["First Name"].toString().toLowerCase().startsWith(name!.toLowerCase())||storedocs[i]["First Name"].toString().toLowerCase().startsWith(name!.toLowerCase()))                                            //Table row start

                                        //Table row start
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
                                              children:  [const SizedBox(height: 8,),Text("${storedocs[i]["Email"]}",), SizedBox(height: 8,),
                                              ],),),),
                                            TableCell(child: Center(child: Text("${storedocs[i]["Mobile"]}"),)),
                                            TableCell(child: Center(child: Text("${storedocs[i]["Member Type"]}"),)),
                                            TableCell(child: Center(child: Text("${storedocs[i]["Member Category"]}"),)),
                                            TableCell(child: Center(child: Text("${storedocs[i]["Company Name"]}"),)),
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
            )

          ],
        ),
      ),);
  }
}
/*class MemberWisePage extends StatefulWidget {
  const MemberWisePage({Key? key}) : super(key: key);

  @override
  State<MemberWisePage> createState() => _MemberWisePageState();
}

class _MemberWisePageState extends State<MemberWisePage> {


  @override
  Widget build(BuildContext context) {
    return  DefaultTabController(
      length: 2,
      child: Scaffold(
        body: Column(
          children: [
            Container(
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
                  Tab(text:("Completed"),),
                  Tab(text: ('InCompleted'),),
                ],
              ),
            ),
            const Expanded(
              child: TabBarView(children: <Widget>[
                MemberWiseCompleted(),
                MemberwiseIncompleted(),
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

  String? selectedmembertype;
  String? selectedcategory;

  String? selecteddate;
  String? selecteddate1;

  String? status= "Successful";
  String name = "";
  String totalmem="Member";





  int placeCount = 0;

  countDocuments(String name) async {
    QuerySnapshot memtotal =
    await FirebaseFirestore.instance.collection('Register')
        .where("Type", isEqualTo: totalmem)
    //.where("First Name", isNotEqualTo: name)
        .get();
    List<DocumentSnapshot> memcount = memtotal.docs;
    setState(() {
      placeCount = memcount.length;
    });
    //Count of Documents in Collection
  }
  int honor=0;
  companyname()async{
    var amount = await FirebaseFirestore.instance.collection("Register")
        .orderBy("Amount")
        .get();

    //List<FieldValue> honoramount= amount.size.

    /*.then((snapshot) async{
    if(snapshot.exists)
    {
      setState(() {
        company = snapshot.data()!["Company Name"];
        //docId = snapshot.data()!['Uid'];
      });
    }
  }
  );*/
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
                                      stream: FirebaseFirestore.instance.collection("Member Type").snapshots(),
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
                                              "Member Type": e['Member Type'],
                                            }).toList();
                                            var data = snapshot.data!.docs[i];
                                            teamItems.add(
                                              DropdownMenuItem(
                                                  value: "${snap["Member Type"]}",
                                                  child: Text("${snap["Member Type"]}")
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
                                                    selectedcategory = null;
                                                    setState(() {
                                                      selectedmembertype = teamValue;
                                                    });
                                                  },
                                                  value: selectedmembertype,
                                                  isExpanded: true,
                                                  hint: const Text(
                                                    "Choose Member Type",
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
                                /*
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
                                      stream: FirebaseFirestore.instance.collection("Member Category").snapshots(),
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
                                              "Member Category": e['Member Category'],
                                            }).toList();
                                            var data = snapshot.data!.docs[i];
                                            teamItems.add(
                                              DropdownMenuItem(
                                                  value: "${snap["Member Category"]}",
                                                  child: Text("${snap["Member Category"]}")
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
                                                    setState(() {
                                                      selectedcategory = teamValue;
                                                    });
                                                  },
                                                  value: selectedcategory,
                                                  isExpanded: true,
                                                  hint: const Text(
                                                    "Choose Member Category",
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
                                ),*/
                                SizedBox(width: 30,),
                                SizedBox(width:300,
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
                                        const [

                                          Text("Business Name :"),
                                          Text("")
                                        ],
                                      ),
                                      const SizedBox(height: 20,),
                                      Row(
                                        children: [
                                          const Text("Total Count :"),
                                          //  countDocuments(name),
                                          Text(placeCount.toString())
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 30,),
                          /* Wrap(
                            runSpacing: 20,
                            spacing: 20,
                            children: [
                              //From Date
                              SizedBox(
                                width:300,
                                child: TextFormField(
                                    controller: _date,
                                    validator: (value) {
                                      if(value!.isEmpty){
                                        return "*Enter the Field";
                                      }else{
                                        return null;
                                      }
                                    },
                                    //pickDate From Date
                                    decoration:  InputDecoration(
                                      labelText: "  From Date  ",
                                      suffixIcon: IconButton(onPressed: ()async{
                                        DateTime? pickDate = await showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime(1900),
                                            lastDate: DateTime(2100));
                                        if(pickDate==null) return;{
                                          setState(() {
                                            _date.text =DateFormat('dd/MM/yyyy').format(pickDate);
                                            selecteddate = _date.text;
                                            selectedmembertype = null;
                                            selectedcategory = null;
                                          });
                                        }
                                      }, icon: const Icon(
                                          Icons.calendar_today_outlined),
                                        color: Colors.green,),
                                    )
                                ),
                              ),
                              const SizedBox(width: 20,),

                              //To Date TextFormField
                              SizedBox(
                                  width: 300,
                                  child: TextFormField(
                                      controller: _date1,
                                      validator: (value) {
                                        if(value!.isEmpty){
                                          return "*Enter the Field";
                                        }
                                        else{
                                          return null;
                                        }
                                      },
                                      //pickDate From Date
                                      decoration:  InputDecoration(
                                        labelText: " To Date",
                                        suffixIcon: IconButton(onPressed: ()async{
                                          DateTime? pickDate = await showDatePicker(
                                              context: context,
                                              initialDate: DateTime.now(),
                                              firstDate: DateTime(1900),
                                              lastDate: DateTime(2100));
                                          if(pickDate==null) return;{
                                            setState(() {
                                              _date1.text =DateFormat('dd/MM/yyyy').format(pickDate);
                                              selecteddate1 = _date1.text;
                                            });
                                          }
                                        }, icon: const Icon(
                                            Icons.calendar_today_outlined),
                                          color: Colors.green,),
                                      )
                                  )

                              ),
                              const SizedBox(width: 100,height: 10,),
                              const Text("District"),
                              const SizedBox(width: 20,height: 10,),
                              const Text("Chapter"),



                            ],
                          ),*/
                          const SizedBox(height: 30,),
                        ],
                      ),
                    ),
                    //dataTable Container
                    StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance.collection("Register")
                            .where("Type", isEqualTo: totalmem)
                        //.where("Date", isGreaterThanOrEqualTo: selecteddate)
                        //.where("Date", isLessThanOrEqualTo: selecteddate1)
                        // .where("Member Type", isEqualTo: selectedmembertype)
                        // .where("Member Category", isEqualTo: selectedcategory )
                            .snapshots(),
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
                                              Text('Email',style: Theme.of(context).textTheme.headlineMedium,),
                                              const SizedBox(height: 8,),
                                            ],),)),
                                            TableCell(child: Center(
                                              child: Text('Mobile',style: Theme.of(context).textTheme.headlineMedium,),)),
                                            TableCell(child: Center(
                                              child: Text('Member Type',style: Theme.of(context).textTheme.headlineMedium,),)),
                                            TableCell(child: Center(
                                              child: Text('Member Category',style: Theme.of(context).textTheme.headlineMedium,),)),
                                            TableCell(child: Center(
                                              child: Text('Company Name',style: Theme.of(context).textTheme.headlineMedium,),)),

                                          ]),
                                          for(var i = 0 ;i < storedocs.length; i++) ...[
                                            if (storedocs[i]["First Name"].toString().toLowerCase().startsWith(name.toLowerCase()))

                                            //Table row start
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
                                                    children:  [const SizedBox(height: 8,),Text("${storedocs[i]["Email"]}",), SizedBox(height: 8,),
                                                    ],),),),
                                                  TableCell(child: Center(child: Text("${storedocs[i]["Mobile"]}"),)),
                                                  TableCell(child: Center(child: Text("${storedocs[i]["Member Type"]}"),)),
                                                  TableCell(child: Center(child: Text("${storedocs[i]["Member Category"]}"),)),
                                                  TableCell(child: Center(child: Text("${storedocs[i]["Company Name"]}"),)),
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
class MemberwiseIncompleted extends StatefulWidget {
  const MemberwiseIncompleted({Key? key}) : super(key: key);

  @override
  State<MemberwiseIncompleted> createState() => _MemberwiseIncompletedState();
}

class _MemberwiseIncompletedState extends State<MemberwiseIncompleted> {

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


  String? selectedmembertype;
  String? selectedcategory;

  String? selecteddate;
  String? selecteddate1;
  String totalmem="Member";

  String? status= "Successful";
  String name ="";

  int totalcount = 0;
  // String nametotal= name;

  countDocuments() async {
    QuerySnapshot memtotal =
    await FirebaseFirestore.instance.collection('Register')
        .where("Type", isEqualTo: totalmem)
    //.where("First Name", isNotEqualTo: name)
        .get();
    List<DocumentSnapshot> memcount = memtotal.docs;
    setState(() {
      totalcount = memcount.length;
    });
    //Count of Documents in Collection
  }
  @override
  void initState() {
    countDocuments();
    super.initState();
  }


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
                                      stream: FirebaseFirestore.instance.collection("Member Type").snapshots(),
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
                                              "Member Type": e['Member Type'],
                                            }).toList();
                                            var data = snapshot.data!.docs[i];
                                            teamItems.add(
                                              DropdownMenuItem(
                                                  value: "${snap["Member Type"]}",
                                                  child: Text("${snap["Member Type"]}")
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
                                                    selectedcategory = null;
                                                    setState(() {
                                                      selectedmembertype = teamValue;
                                                    });
                                                  },
                                                  value: selectedmembertype,
                                                  isExpanded: true,
                                                  hint: const Text(
                                                    "Choose Member Type",
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
                                /*
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
                                      stream: FirebaseFirestore.instance.collection("Member Category").snapshots(),
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
                                              "Member Category": e['Member Category'],
                                            }).toList();
                                            var data = snapshot.data!.docs[i];
                                            teamItems.add(
                                              DropdownMenuItem(
                                                  value: "${snap["Member Category"]}",
                                                  child: Text("${snap["Member Category"]}")
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
                                                    setState(() {
                                                      selectedcategory = teamValue;
                                                    });
                                                  },
                                                  value: selectedcategory,
                                                  isExpanded: true,
                                                  hint: const Text(
                                                    "Choose Member Category",
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
                                ),*/
                                SizedBox(width: 30,),
                                SizedBox(width:300,
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
                                        const [

                                          Text("Business Name :"),
                                          Text("")
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
                          /* Wrap(
                            runSpacing: 20,
                            spacing: 20,
                            children: [
                              //From Date
                              SizedBox(
                                width:300,
                                child: TextFormField(
                                    controller: _date,
                                    validator: (value) {
                                      if(value!.isEmpty){
                                        return "*Enter the Field";
                                      }else{
                                        return null;
                                      }
                                    },
                                    //pickDate From Date
                                    decoration:  InputDecoration(
                                      labelText: "  From Date  ",
                                      suffixIcon: IconButton(onPressed: ()async{
                                        DateTime? pickDate = await showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime(1900),
                                            lastDate: DateTime(2100));
                                        if(pickDate==null) return;{
                                          setState(() {
                                            _date.text =DateFormat('dd/MM/yyyy').format(pickDate);
                                            selecteddate = _date.text;
                                            selectedmembertype = null;
                                            selectedcategory = null;
                                          });
                                        }
                                      }, icon: const Icon(
                                          Icons.calendar_today_outlined),
                                        color: Colors.green,),
                                    )
                                ),
                              ),
                              const SizedBox(width: 20,),

                              //To Date TextFormField
                              SizedBox(
                                  width: 300,
                                  child: TextFormField(
                                      controller: _date1,
                                      validator: (value) {
                                        if(value!.isEmpty){
                                          return "*Enter the Field";
                                        }
                                        else{
                                          return null;
                                        }
                                      },
                                      //pickDate From Date
                                      decoration:  InputDecoration(
                                        labelText: " To Date",
                                        suffixIcon: IconButton(onPressed: ()async{
                                          DateTime? pickDate = await showDatePicker(
                                              context: context,
                                              initialDate: DateTime.now(),
                                              firstDate: DateTime(1900),
                                              lastDate: DateTime(2100));
                                          if(pickDate==null) return;{
                                            setState(() {
                                              _date1.text =DateFormat('dd/MM/yyyy').format(pickDate);
                                              selecteddate1 = _date1.text;
                                            });
                                          }
                                        }, icon: const Icon(
                                            Icons.calendar_today_outlined),
                                          color: Colors.green,),
                                      )
                                  )

                              ),
                              const SizedBox(width: 100,height: 10,),
                              const Text("District"),
                              const SizedBox(width: 20,height: 10,),
                              const Text("Chapter"),



                            ],
                          ),*/
                          const SizedBox(height: 30,),
                        ],
                      ),
                    ),
                    //dataTable Container
                    StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance.collection("Register")
                            .where("Type", isEqualTo: totalmem)
                        //.where("Date", isGreaterThanOrEqualTo: selecteddate)
                        //.where("Date", isLessThanOrEqualTo: selecteddate1)
                        // .where("Member Type", isEqualTo: selectedmembertype)
                        // .where("Member Category", isEqualTo: selectedcategory )
                            .snapshots(),
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
                                              Text('Email',style: Theme.of(context).textTheme.headlineMedium,),
                                              const SizedBox(height: 8,),
                                            ],),)),
                                            TableCell(child: Center(
                                              child: Text('Mobile',style: Theme.of(context).textTheme.headlineMedium,),)),
                                            TableCell(child: Center(
                                              child: Text('Member Type',style: Theme.of(context).textTheme.headlineMedium,),)),
                                            TableCell(child: Center(
                                              child: Text('Member Category',style: Theme.of(context).textTheme.headlineMedium,),)),
                                            TableCell(child: Center(
                                              child: Text('Company Name',style: Theme.of(context).textTheme.headlineMedium,),)),

                                          ]),
                                          for(var i = 0 ;i < storedocs.length; i++) ...[
                                            if (storedocs[i]["First Name"].toString().toLowerCase().startsWith(name.toLowerCase()))
                                            //Table row start
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
                                                    children:  [const SizedBox(height: 8,),Text("${storedocs[i]["Email"]}",), SizedBox(height: 8,),
                                                    ],),),),
                                                  TableCell(child: Center(child: Text("${storedocs[i]["Mobile"]}"),)),
                                                  TableCell(child: Center(child: Text("${storedocs[i]["Member Type"]}"),)),
                                                  TableCell(child: Center(child: Text("${storedocs[i]["Member Category"]}"),)),
                                                  TableCell(child: Center(child: Text("${storedocs[i]["Company Name"]}"),)),
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
}*/


