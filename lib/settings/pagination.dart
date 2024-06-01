

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class Pagination extends StatefulWidget {
  const Pagination({Key? key}) : super(key: key);

  @override
  State<Pagination> createState() => _PaginationState();
}

class _PaginationState extends State<Pagination> {

 // final DataTableSource _data = MyDataTable();
  List storedocs = [];
  bool sort = true;
  String name = "";

  onsortColum(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      if (ascending) {
        storedocs!.sort((a, b) => a.storedocs[0]["First Name"]!.compareTo(b.storedocs[0]["First Name"]!));
      } else {
        storedocs!.sort((a, b) => b.storedocs[0]["First Name"]!.compareTo(a.storedocs[0]["First Name"]!));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      route: '/add_pagination',
      body: Column(
        children: [
          const SizedBox(height: 7,),
          //Search TextFormField starts
          Align(alignment: Alignment.topRight,
            child: Container(
              width: 380,
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
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection("Register").snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if(snapshot.hasError) {
                print("Something went Wrong");
              }
              if(snapshot.connectionState == ConnectionState.waiting) {
                return  Center(
                  child: Container(),
                );
              }
              List storedocs = [];
              snapshot.data!.docs.map((DocumentSnapshot document) {
                Map a = document.data() as Map<String, dynamic>;
                storedocs.add(a);
                a["id"] = document.id;
              }).toList();
              ListView.builder(
                itemCount: storedocs.length,
                  itemBuilder: (context, index){
                  return Container();
                  });
              return Column(
                children: [
                //  for(var i=0; i < storedocs.length; i++) ...[
                  PaginatedDataTable(
                    sortColumnIndex: 0,
                    sortAscending: sort,
                      columns: [
                        DataColumn(label: Text("Id")),
                        DataColumn(label: Text("First Name"),
                            onSort: (columnIndex, ascending) {
                              setState(() {
                                sort = !sort;
                              });

                              onsortColum(columnIndex, ascending);
                            }),
                        DataColumn(label: Text("Last Name")),
                        DataColumn(label: Text("Mobile")),
                       // DataColumn(label: Text("Email")),
                        //DataColumn(label: Text("Company Name")),
                      ],
              source: MyDataTable(snapshot.data!.docs, name),
                    columnSpacing: 200,
                    horizontalMargin: 60,
                  )
                 // ]
                ],
              );
            }
          ),
        ],
      ),
    );
  }
}

class MyDataTable extends DataTableSource{
  MyDataTable(this._data, this.nam);
 final String nam;
  final List<dynamic> _data;
 // List<DocumentSnapshot> datas = <DocumentSnapshot>[];
 // List<Map<String, dynamic>> _data = [];

 /* final user = FirebaseAuth.instance.currentUser;

  final CollectionReference _users =
  FirebaseFirestore.instance.collection('users');
  final List<Map<String, dynamic>> _data = List.generate(
      200, (index) => {
     "id": index,
     "title": "Item $index",
     "price": Random().nextInt(10000)
  });*/

  @override
  DataRow? getRow(int index) {
    if(_data[index]["First Name"].toString().toLowerCase().startsWith(nam.toLowerCase())) {
      return DataRow(
        cells: [
          DataCell(Text("${index+1}")),
      DataCell(Text(_data[index]["First Name"])),
      DataCell(Text(_data[index]["Last Name"])),
      DataCell(Text(_data[index]["Mobile"])),
    ]);
    }
  }
 /* DataRow? getRow(int index) {
    if (index < rowCount) {
      return recentFileDataRow(_data![index], nam);
    } else
      return null;
  }*/

  @override
  // TODO: implement isRowCountApproximate
  bool get isRowCountApproximate => false;

  @override
  // TODO: implement rowCount
  int get rowCount => _data.length;

  @override
  // TODO: implement selectedRowCount
  int get selectedRowCount => 0;
  }
DataRow recentFileDataRow(var _data, String nam) {
  return DataRow(
    cells: [
      if(_data["First Name"].toString().toLowerCase().startsWith(nam.toLowerCase()))
      DataCell(Text(_data["Uid"])),
      DataCell(Text(_data["First Name"] ?? "First Name")),
      DataCell(Text(_data["Last Name"])),
      DataCell(Text(_data["Mobile"])),
    ],
  );
}
