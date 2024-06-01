import 'package:flutter/material.dart';

import '../main.dart';

class WomensNonExecutive extends StatelessWidget {
  const WomensNonExecutive({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: WomensNonExecutiveMembers(),
    );
  }
}
class WomensNonExecutiveMembers extends StatefulWidget {
  const WomensNonExecutiveMembers({Key? key}) : super(key: key);

  @override
  State<WomensNonExecutiveMembers> createState() => _WomensNonExecutiveMembersState();
}

class _WomensNonExecutiveMembersState extends State<WomensNonExecutiveMembers> {

  final _formKey = GlobalKey<FormState>();

  String numbersgroup = '10';
  var numbersgrouplist = ['10','25','50','100',];
  @override
  Widget build(BuildContext context) {
    return MyScaffold(route: "/womensnon_executive_members",
        body:Form(
            key: _formKey,
            child: Center(
                child: Column(
                    children: [
                      Padding(
                          padding:  EdgeInsets.all(15.0),
                          child: Container(
                              color: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Column(
                                    children:  [
                                      const SizedBox(height: 30,),
                                      //view non members start
                                      Wrap(
                                    //    mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text("View Non Executive Members",style: Theme.of(context).textTheme.headlineMedium,),
                                        ],
                                      ),
                                      //Go back button
                                      const SizedBox(height: 20,),
                                      Align(alignment: Alignment.topRight,
                                        child: ElevatedButton(onPressed: (){
                                          if(_formKey.currentState!.validate()){}
                                          Navigator.pop(context);
                                        },
                                            child: const Text("Go back")),
                                      ),
                                      //show
                                      const SizedBox(height: 25,),
                                      Row(
                                        //  mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            const Text("Show",),
                                            const SizedBox(height: 20,),
                                            //dropdown button
                                            Padding(
                                                padding: const EdgeInsets.all(15.0),
                                                child: Container(
                                                    height: 30,
                                                    width: 90,
                                                    padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 4),
                                                    decoration: BoxDecoration(
                                                      border: Border.all(color: Colors.grey),
                                                      borderRadius: BorderRadius.circular(5.0),
                                                    ),
                                                    child: DropdownButtonHideUnderline(
                                                        child: DropdownButton(
                                                          value: numbersgroup,
                                                          //elevation: 20,
                                                          icon:  Icon(Icons.arrow_drop_down),
                                                          isExpanded: true,
                                                          items:numbersgrouplist.map((String numbers) {
                                                            return  DropdownMenuItem(
                                                                value: numbers,
                                                                child:  Text(numbers)
                                                            );
                                                          }
                                                          ).toList(),
                                                          onChanged: (newValue){
                                                            setState(() {
                                                              numbersgroup = newValue.toString();
                                                            });
                                                          },
                                                        )
                                                    )
                                                )
                                            ),
                                            // entries
                                            const Text('entries'),
                                            const SizedBox(width: 20,),
                                            // search
                                            const SizedBox(height: 7,),

                                          ]
                                      ),
                                      Align(alignment: Alignment.topRight,
                                        child: SizedBox(width: 380,
                                          child: TextFormField(
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
                                      // Table starting
                                      const SizedBox(height: 27,),
                                      Container(
                                          child: SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: Table(
                                                  border: TableBorder.all(),
                                                  defaultColumnWidth:const FixedColumnWidth(200.0),
                                                  columnWidths: const <int, TableColumnWidth>{
                                                   0:FixedColumnWidth(70),},
                                                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                                                  // s.no
                                                  children: [TableRow(children:[TableCell(child:  Center(child: Text('S.No', style: Theme.of(context).textTheme.headlineMedium),),),
                                                    //Name
                                                    TableCell(child:Center(child: Text('Name',style: Theme.of(context).textTheme.headlineMedium,),)),
                                                    // company name
                                                    TableCell(child:Center(child: Text('Company Name',style: Theme.of(context).textTheme.headlineMedium,),)),
                                                    //Email
                                                    TableCell(child:Center(child: Column(children: [SizedBox(height: 8,), Text('Email', style: Theme.of(context).textTheme.headlineMedium,), SizedBox(height: 8,),],),)),
                                                    // Chapter
                                                    TableCell(child: Center(child: Text('Chapter', style: Theme.of(context).textTheme.headlineMedium,),))]),

                                                    for (var i = 0; i < 5; i++) ...[
                                                      TableRow(
                                                          decoration: BoxDecoration(color: Colors.grey[200]),
                                                          children:[
                                                        // 1 Table row contents
                                                        TableCell(child:Center(child: Column(children: [SizedBox(height: 8,), Text('',), SizedBox(height: 8,),],),)),
                                                        //2 name
                                                        const TableCell(child: Center(child: Text('',),)),
                                                        // 3 company name
                                                        const TableCell(child:Center(child: Text('',),)),
                                                        // 4 email
                                                        const TableCell(child: Center(child: Text('',),)),
                                                        // 5 chapter
                                                        const TableCell(child:Center(child: Text('',),))
                                                      ]
                                                      ),
                                                    ]]   )
                                          )
                                      )
                                    ]
                                ),
                              )
                          )
                      )
                    ]
                )
            )
        )
    );
  }
}
