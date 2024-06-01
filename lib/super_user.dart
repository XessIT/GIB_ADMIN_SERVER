import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import 'main.dart';

class SuperUser extends StatelessWidget {
  const SuperUser({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Super(),
    );
  }
}

class Super extends StatefulWidget {
  const Super({Key? key}) : super(key: key);

  @override
  State<Super> createState() => _SuperState();
}

class _SuperState extends State<Super> {
  var name;
  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      route: '/super_user',
      body: Center(
        child: Column(
          children: [
            Container(
              width: 1500,
              color:Colors.white,
              child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection("Register").snapshots(),
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

                    return  Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.all(70),
                        child: Container(
                          child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Table(
                                  border: TableBorder.all(),
                                  defaultColumnWidth: const FixedColumnWidth(200.0),
                                  columnWidths: const <int, TableColumnWidth>{
                                    0:FixedColumnWidth(90),
                                    1:FixedColumnWidth(160),
                                    2:FixedColumnWidth(350),
                                    3:FixedColumnWidth(120),
                                    4:FixedColumnWidth(120),
                                    5:FixedColumnWidth(120),
                                  },
                                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                                  children:[
                                    //Table row starting
                                    TableRow(
                                        children: [
                                          TableCell(
                                              child:Center(
                                                child: Text('S.No',
                                                  style: Theme.of(context).textTheme.headlineMedium,),)),
                                          //Meeting Name
                                          TableCell(
                                              child:Center(
                                                child: Text('Role',
                                                  style: Theme.of(context).textTheme.headlineMedium,),)),
                                          TableCell(
                                              child:Center(
                                                child: Text('Role in Charge',
                                                  style: Theme.of(context).textTheme.headlineMedium,),)),
                                          // Edit
                                          TableCell(
                                            child: Center(
                                              child: Text('Status',
                                                style: Theme.of(context).textTheme.headlineMedium,
                                              ),),),
                                          TableCell(
                                            child: Center(
                                              child: Text('Authorize',
                                                style: Theme.of(context).textTheme.headlineMedium,
                                              ),),),
                                          //Delete
                                          TableCell(
                                              child: Center(
                                                child: Column(
                                                  children: [
                                                    const SizedBox(height: 8,),
                                                    Text('Rejected',
                                                        style: Theme.of(context).textTheme.headlineMedium),
                                                    const SizedBox(height: 8,),],),)),
                                        ]),
                                    // Table row end
                                    for(var i = 0 ;i < storedocs.length; i++) ...[
                                      if(storedocs[i]["Role in Gib"] != null )
                                      //Table row start
                                      TableRow(
                                          decoration: BoxDecoration(color: Colors.grey[200]),
                                          children: [
                                            // 1 s.no
                                            TableCell(child: Center(child: Column(
                                              children: [
                                                const SizedBox(height: 4,),
                                                Text("${i+1}"),
                                                const SizedBox(height: 4,)
                                              ],
                                            ))),
                                            TableCell(child:Center(
                                              child: Column(
                                                children:  [
                                                  const SizedBox(height: 4,),
                                                  Text("${storedocs[i]["Role in Gib"]}"),
                                                  const SizedBox(height: 4,),],
                                              ),
                                            )
                                            ),

                                            TableCell(child:Center(
                                              child: Column(
                                                children: [
                                                  const SizedBox(height: 4,),
                                                 Text("${storedocs[i]["First Name"]} ${storedocs[i]["Last Name"]}"),
                                                  const SizedBox(height: 4,),],
                                              ),
                                            )
                                            ),
                                            TableCell(child:Center(
                                              child: Column(
                                                children:  [
                                                  const SizedBox(height: 4,),
                                                  Text("${storedocs[i]["Admin Rights"]}"),
                                                  const SizedBox(height: 4,),],
                                              ),
                                            )
                                            ),

                                            //edit_note Tabel cell
                                            TableCell(
                                                child: Center(
                                                  child: Column(
                                                    children: [
                                                      SizedBox(height: 4,),
                                                      IconButton(onPressed: (){
                                                        // _editnote(context);
                                                        showDialog<void>(
                                                          context: context,
                                                          builder: (BuildContext dialogContext) {
                                                            return AlertDialog(
                                                              backgroundColor: Colors.grey[800],
                                                              title: const Text('Edit',style: TextStyle(color: Colors.white),),
                                                              content:  const Text("Do you want to give rights?", style: TextStyle(color: Colors.white),),
                                                              actions: <Widget>[
                                                                Row(
                                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                                  children: [
                                                                    TextButton(
                                                                      child: const Text('Yes',),
                                                                      onPressed:  ()async{
                                                                        await FirebaseFirestore.instance.collection("Register").doc(storedocs[i]["Uid"]).update({
                                                                          "Admin Rights": "Approved"
                                                                        });
                                                                        await FirebaseFirestore.instance.collection("Super Admin").doc(storedocs[i]["Uid"]).set({
                                                                          "Uid": storedocs[i]["Uid"],
                                                                          "First Name": storedocs[i]["First Name"],
                                                                          "Last Name": storedocs[i]["Last Name"],
                                                                          "Mobile": storedocs[i]["Mobile"],
                                                                          "Email": storedocs[i]["Email"],
                                                                          "Status": "Approved",
                                                                          "Block Status":"Unblock"
                                                                        });
                                                                        Navigator.pop(context);
                                                                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                                                            content: Text("You have Successfully Given the Rights")));
                                                                      },
                                                                    ),
                                                                    TextButton(
                                                                      child:  const Text('Cancel',),
                                                                      onPressed: () {
                                                                        Navigator.pop(context);
                                                                        // Navigator.of(dialogContext).pop(); // Dismiss alert dialog
                                                                      },
                                                                    ),
                                                                  ],
                                                                ),

                                                              ],
                                                            );
                                                          },
                                                        );
                                                      },
                                                          icon:const Icon(Icons.check_circle,color: Colors.green,)),
                                                      SizedBox(height: 4,),
                                                    ],),)),
                                            //delete Tabel cell
                                             TableCell(
                                                child: Center(
                                                  child:  IconButton(
                                                      onPressed: (){
                                                        showDialog(
                                                            context: context,
                                                            builder: (ctx) =>
                                                            // Dialog box for register meeting and add guest
                                                            AlertDialog(
                                                              backgroundColor: Colors.grey[800],
                                                              title: const Text('Remove',
                                                                  style: TextStyle(color: Colors.white)),
                                                              content: const Text("Do you want to Cancel the Rights?",
                                                                  style: TextStyle(color: Colors.white)),
                                                              actions: [
                                                                TextButton(
                                                                    onPressed: () async{
                                                                      await FirebaseFirestore.instance.collection("Register").doc(storedocs[i]["Uid"]).update({

                                                                        "Admin Rights": "Rejected"
                                                                      });
                                                                      await FirebaseFirestore.instance.collection("Super Admin").doc(storedocs[i]["Uid"]).delete();
                                                                      Navigator.pop(context);
                                                                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                                                          content: Text("You have Successfully Cancel the Rights")));
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
                                                      },
                                                      icon: const Icon(Icons.cancel,color: Colors.red,)),
                                                )),]),
                                      // Table row end
                                    ]]   )
                          ),
                        ),
                      ),
                    );

                  }
              ),
            )
          ],
        ),
      ),

    );
  }
}

