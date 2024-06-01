import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../main.dart';

class TodayAttendance extends StatelessWidget {
  const TodayAttendance({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: TodayAttendancePage(),
    );
  }
}
class TodayAttendancePage extends StatefulWidget {
  const TodayAttendancePage({Key? key}) : super(key: key);

  @override
  State<TodayAttendancePage> createState() => _TodayAttendancePageState();
}

class _TodayAttendancePageState extends State<TodayAttendancePage> {


  int exemem= 0;
  String Exemem="Non-Executive";
  int visi= 0;
  int allcount=0; int vaagaitotal=0;int mullaitotal=0;int maruthamtotal=0;int neithaltotal=0;int aambaltotal=0;
  //String Visicount="Non-Executive";
  int totalcount=0;
  late Stream<QuerySnapshot> _streamhonoring;
  Stream<int>? _sumStream;
  int totalCount = 0;


  countDocuments() async {
    QuerySnapshot totalexemem =
    await FirebaseFirestore.instance.collection('Register Meeting')
        .where("Member Type", isNotEqualTo: Exemem)
        .get();
    List<DocumentSnapshot> execount = totalexemem.docs;
    setState(() {
      exemem = execount.length;
    });
    ///Vaagai
    QuerySnapshot vaagai =
    await FirebaseFirestore.instance.collection('Register Meeting').
    where("Team Name",isEqualTo:"Vaagai")
        .get();
    List<DocumentSnapshot> vaagaicount = vaagai.docs;
    setState(() {
      vaagaitotal = vaagaicount.length;
    });
    ///Mullai
    QuerySnapshot mullai =
    await FirebaseFirestore.instance.collection('Register Meeting').
    where("Team Name",isEqualTo:"Mullai")
        .get();
    List<DocumentSnapshot> mullaicount = mullai.docs;
    setState(() {
      mullaitotal = mullaicount.length;
    });
    ///Marutham
    QuerySnapshot marutham =
    await FirebaseFirestore.instance.collection('Register Meeting').
    where("Team Name",isEqualTo:"Marutham")
        .get();
    List<DocumentSnapshot> maruthamcount = marutham.docs;
    setState(() {
      maruthamtotal = maruthamcount.length;
    }); ///Neithal
    QuerySnapshot neithal =
    await FirebaseFirestore.instance.collection('Register Meeting').
    where("Team Name",isEqualTo:"Neithal")
        .get();
    List<DocumentSnapshot> neithalcount = neithal.docs;
    setState(() {
      neithaltotal = neithalcount.length;
    });///Aambal
    QuerySnapshot aambal =
    await FirebaseFirestore.instance.collection('Register Meeting').
    where("Team Name",isEqualTo:"Aambal")
        .get();
    List<DocumentSnapshot> aamballcount = aambal.docs;
    setState(() {
      aambaltotal = aamballcount.length;
    });

    /*  QuerySnapshot querySnapshot =
    await FirebaseFirestore.instance.collection('Register Meeting').get();

    querySnapshot.docs.forEach((doc) {
      // access the field values of the document using the doc object
      var fieldValue = doc.data()['fieldName'];
      print(fieldValue);
    });*/

  }

 // In this code, we use col


  @override
  void initState() {
    countDocuments();
    super.initState();
    _streamhonoring = Stream.periodic(const Duration(milliseconds:1), (_) {
      return FirebaseFirestore.instance
          .collection("Register Meeting")//.where("HonorMobile",isEqualTo:mobile)
          //.where("Register TimeParse", isGreaterThanOrEqualTo: Timestamp.fromDate(DateTime.n)
          .snapshots();
    }).asyncMap((event) async => await event.first);




  }

int? totalmember =0;

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      route: '/today_attendance',
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 30,),
                      Wrap(
                        runSpacing: 10,
                        spacing: 10,
                        children:   [
                     //     const SizedBox(width: 5,height: 20,),
                          //Executive Member Count :

                          //Executive  + Visitors Count : Text
                          StreamBuilder<QuerySnapshot>(
                              stream: _streamhonoring,

                              builder: (context,AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                                if (streamSnapshot.hasData) {
                                  final querySnapshot = streamSnapshot.data!;
                                  final yearCounts = querySnapshot.docs.fold<Map<int, int>>(
                                    {},
                                        (counts, doc) => counts..update(doc["Register TimeParse"].toDate().year, (count) => count + 1, ifAbsent: () => 1),
                                  );
                                  final totalYears = yearCounts.length;
                                  final now = DateTime.now();
                                  final twoWeeksAgo = now.subtract(const Duration(days: 1));
                                  final docsAfterTwoWeeks = querySnapshot.docs.where((doc) => doc["Register TimeParse"].toDate().isAfter(twoWeeksAgo)).toList();
                                  final totalAmount1 = docsAfterTwoWeeks.fold<int>(0, (sum, doc) => sum + int.parse(doc["Visitors Count"]),);

                                  totalmember = totalAmount1+exemem;
                                  if (totalAmount1 == 0) {
                                    Timer.periodic(const Duration(days: 15), (timer) {
                                      // Refresh the stream every two minutes
                                      setState(() {});
                                    });
                                  }
                                  return
                                     Row(
                                      children:  [
                                        const Text("     Executive Member Count : ",style: TextStyle(fontSize: 18),),
                                        Text(exemem.toString(),style: TextStyle(fontSize: 18),),


                                        Text("        Vistors Count Count ",style: TextStyle(fontSize: 18),),

                                        Text(" : ""$totalAmount1",style: TextStyle(fontSize: 18),),
                                        Text("          Total Count" " : " ,style: TextStyle(fontSize: 18),),
                                        Text("$totalmember",style: TextStyle(fontSize: 18),),
                                      ],
                                    );

                                }return Container();
                              }
                          ),


                       //   Text(visi.toString()),

                        ],
                      ),


                      //Total Count :

                      /*SizedBox(
                        width: 300,height: 130,
                        child: StreamBuilder<QuerySnapshot>(
                            stream: _streamhonoring,

                            builder: (context,AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                              if (streamSnapshot.hasData) {
                                final querySnapshot = streamSnapshot.data!;
                                final yearCounts = querySnapshot.docs.fold<Map<int, int>>(
                                  {},
                                      (counts, doc) => counts..update(doc["Register TimeParse"].toDate().year, (count) => count + 1, ifAbsent: () => 1),
                                );
                                final totalYears = yearCounts.length;
                                final now = DateTime.now();
                                final twoWeeksAgo = now.subtract(const Duration(days: 15));
                                final docsAfterTwoWeeks = querySnapshot.docs.where((doc) => doc["Register TimeParse"].toDate().isAfter(twoWeeksAgo)).toList();
                                final totalAmount1 = docsAfterTwoWeeks.fold<int>(0, (sum, doc) => sum + int.parse(doc["Visitors Count"]),);


                                return Container(
                                  child: Column(
                                    children:  [
                                      SizedBox(height: 10,),
                                      Text("Total Count",
                                        style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.white),),
                                      SizedBox(height: 10,),
                                      Text("$totalAmount1",
                                        style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.white),),
                                    ],
                                  ),
                                );
                              }return Container();
                            }
                        ),
                      ),*/




                      Wrap(
                        runSpacing: 10,
                        spacing: 10,
                        children:[
                          // Vaagai
                          SizedBox(height: 100,width:200,
                            child: Card(
                              color: Colors.blue.shade600,
                              child:  Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Align(
                                      alignment: Alignment.center,
                                      child: Text("Vaagai:0")),  Align(
                                      alignment: Alignment.center,
                                      child: Text(vaagaitotal.toString())),
                                ],
                              ),
                            ),
                          ),
                          //Mullai
                          SizedBox(height: 100,width:200,
                            child: Card(
                              color: Colors.redAccent.shade200,
                              child:  Column(
                                mainAxisAlignment: MainAxisAlignment.center,

                                children: [
                                  const Align(
                                      alignment: Alignment.center,
                                      child: Text("Mullai:0")),
                                  Align(
                                      alignment: Alignment.center,
                                      child: Text(mullaitotal.toString())),
                                ],
                              ),
                            ),
                          ),

                          //Marutham
                          SizedBox(height: 100,width:200,
                            child: Card(
                              color: Colors.cyan.shade600,
                              child:  Column(
                                mainAxisAlignment: MainAxisAlignment.center,

                                children: [
                                  const Align(
                                      alignment: Alignment.center,
                                      child: Text("Marutham:0")),
                                  Align(
                                      alignment: Alignment.center,
                                      child: Text(maruthamtotal.toString())),
                                ],
                              ),
                            ),
                          ),

                          //Neithal
                          SizedBox(height: 100,width:200,
                            child: Card(
                              color: Colors.indigo.shade400,
                              child:  Column(
                                mainAxisAlignment: MainAxisAlignment.center,

                                children: [
                                  const Align(
                                      alignment: Alignment.center,
                                      child: Text("Neithal:0")),
                                  Align(
                                      alignment: Alignment.center,
                                      child: Text(neithaltotal.toString())),
                                ],
                              ),
                            ),
                          ),

                          //Aambal
                          SizedBox(height: 100,width:200,
                            child: Card(
                              color: Colors.deepOrange.shade300,
                              child:  Column(
                                mainAxisAlignment: MainAxisAlignment.center,

                                children: [
                                  const Align(
                                      alignment: Alignment.center,
                                      child: Text("Aambal:0")),
                                  Align(
                                      alignment: Alignment.center,
                                      child: Text(aambaltotal.toString())),
                                ],
                              ),
                            ),
                          ),

                          //Vaagai

                        ],
                      ),
                      const SizedBox(height: 30,),


                      //End Attendance ElevatedButton
                      const SizedBox(height: 30,),

                   /*   Align(
                        alignment: Alignment.topRight,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              elevation: 10,
                              shadowColor: Colors.pinkAccent,
                            ),
                            onPressed: (){}, child: const Text("End Attendance")),
                      ),*/
                      const SizedBox(height: 30,),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          child: StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance.collection("Register Meeting")
                                  .where("Meeting Date", isEqualTo: DateFormat("yyyy-MM-dd").format(DateTime.now()))

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
                                return SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Table(
                                        border: TableBorder.all(),
                                        defaultColumnWidth: const FixedColumnWidth(190.0),
                                        columnWidths: const <int, TableColumnWidth>{
                                          0:FixedColumnWidth(70),
                                          1:FixedColumnWidth(160), 3:FixedColumnWidth(160),
                                          6:FixedColumnWidth(130), 7:FixedColumnWidth(130),
                                        },
                                        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                                        children:[
                                          //Table row starting
                                          TableRow(
                                              children: [
                                                //S.no
                                                TableCell(
                                                    child:Center(
                                                      child: Text('S.No',
                                                        style: Theme.of(context).textTheme.headlineMedium,),)),
                                                // Member name
                                                TableCell(
                                                  child: Center(
                                                    child: Text('Member Id',
                                                      style: Theme.of(context).textTheme.headlineMedium,
                                                    ),),),
                                                // Member mobile no
                                                TableCell(
                                                    child: Center(
                                                      child: Column(
                                                        children: [
                                                          const SizedBox(height: 8,),
                                                          Text('Member Name',
                                                              style: Theme.of(context).textTheme.headlineMedium),
                                                          const SizedBox(height: 8,),],),)),
                                                // Referrer name
                                                TableCell(
                                                    child: Center(
                                                      child: Text('Contact No',
                                                          style: Theme.of(context).textTheme.headlineMedium),)),
                                                //Referrer mob no
                                                //Referred To

                                                TableCell(
                                                    child: Center(
                                                      child: Text('Meeting Type',
                                                          style: Theme.of(context).textTheme.headlineMedium),)),
                                                //Referred To Mobile No
                                                TableCell(
                                                    child: Center(
                                                      child: Text('Visitors count',
                                                          style: Theme.of(context).textTheme.headlineMedium),)),
                                                // Location
                                                TableCell(
                                                    child: Center(
                                                      child: Text('Attendance',
                                                          style: Theme.of(context).textTheme.headlineMedium),))]),
                                          // Table row end
                                          for (var i = 0; i < storedocs.length; i++) ...[
                                            //Table row start
                                            TableRow(
                                                decoration: BoxDecoration(color: Colors.grey[200]),
                                                children: [
                                                  // 1 s.no
                                                  TableCell(child:Center(
                                                    child: Column(
                                                      children: [
                                                        const SizedBox(height: 8,),
                                                        Text("${i+1}"),
                                                        const SizedBox(height: 8,),],),)),
                                                  const TableCell(child: Center(child: Text('',),)),
                                                  // Member name
                                                  TableCell(child: Center(child: Text('${storedocs[i]["Name"]} '),)),
                                                  //Member mob no
                                                  //Referrer name
                                                  TableCell(child: Center(child: Text("${storedocs[i]["Mobile"]}"),)),
                                                  //Referrer company name
                                                  //    TableCell(child: Center(child: Text("${storedocs[i]["Company Name"]}"),)),
                                                  //Referred to
                                                  TableCell(child: Center(child: Text("${storedocs[i]["Meeting Type"]}"),)),
                                                  // Referred to mob no
                                                  TableCell(child: Center(child: Text("${storedocs[i]["Visitors Count"]}"),)),
                                                  // Location
                                                  TableCell(child: Center(child: Text("${storedocs[i]["Attendance"]}"),)),]),
                                            // Table row end
                                          ]]   )
                                );
                              }
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
  Stream<int> sumVisitorsCount() {
    // Reference the "Register Meeting" collection in Firebase
    final collectionReference =
    FirebaseFirestore.instance.collection('Register Meeting');

    // Use collectionReference.snapshots() to listen to changes in the collection
    return collectionReference.snapshots().map((querySnapshot) {
      // Sum up the "Visitors Count" field values across all documents
      return querySnapshot.docs.fold(0, (total, doc) {
        final visitorsCountFieldValue = doc.get('Attendance Visitors Count');
        return total +
            (visitorsCountFieldValue is int ? visitorsCountFieldValue : 0);
      });
    });
  }

}
