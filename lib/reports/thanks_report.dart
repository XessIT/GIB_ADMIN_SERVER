import 'package:flutter/material.dart';
import '../main.dart';

class ThanksNoteReport extends StatelessWidget {
  const ThanksNoteReport({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: ThanksNoteReportPage(),
    );
  }
}
class ThanksNoteReportPage extends StatefulWidget {
  const ThanksNoteReportPage({Key? key}) : super(key: key);

  @override
  State<ThanksNoteReportPage> createState() => _ThanksNoteReportPageState();
}

class _ThanksNoteReportPageState extends State<ThanksNoteReportPage> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return MyScaffold(
        route: "/thanksnote_report_page",
        body: Form(
          key: _formKey,
          child: Center(
            child: Column(
              children: [
                Padding(
                  padding:const EdgeInsets.all(30.0),
                  child: Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        const SizedBox(height: 20,),
                        Text('ThanksNote Report',style: Theme.of(context).textTheme.headlineMedium,),
                        const SizedBox(height: 20,),
                        // Outline button text
                        Align(alignment: Alignment.topRight,
                          child: OutlinedButton(
                            onPressed: (){
                              if(_formKey.currentState!.validate()){}},
                            child: const Text('Print Table',style: TextStyle(fontSize: 15,),),
                          ),
                        ),
                        const SizedBox(height: 20,),
                        // GOUNDERS in business text
                        const Align(alignment:Alignment.topLeft,
                          child: Text('GOUNDERS IN BUSINESS',style: TextStyle(color: Colors.green,fontSize: 20)),),
                        const SizedBox(height: 10,),
                        Align(alignment: Alignment.topLeft,
                            child: Text("ThanksNote Report",style: Theme.of(context).textTheme.headlineMedium,)),
                        const SizedBox(height: 20,),
                        Container(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Column(
                                  children: [
                                    Table(
                                        border: TableBorder.all(),
                                        defaultColumnWidth: const FixedColumnWidth(200.0),
                                        columnWidths: const <int, TableColumnWidth>{
                                          0:FixedColumnWidth(70),5:FixedColumnWidth(240),
                                        },
                                        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                                        children:[
                                          // Table row start
                                          TableRow(children: [
                                            // s.no
                                            TableCell(child: Center(
                                              child: Text('S.No',style: Theme.of(context).textTheme.headlineMedium,),)),
                                            //Member name
                                            TableCell(child: Center(
                                              child: Text('Member Name',style: Theme.of(context).textTheme.headlineMedium,),)),
                                            // Member mob no
                                            TableCell(child: Center(
                                              child: Text('Member Mobile No',style: Theme.of(context).textTheme.headlineMedium,),)),
                                            // Referrer name
                                            TableCell(child: Center(
                                              child: Text('Referrer Name',style: Theme.of(context).textTheme.headlineMedium,),)),
                                            // Referrer mobile no
                                            TableCell(child: Center(
                                              child: Text('Referrer Mobile No',style: Theme.of(context).textTheme.headlineMedium,),)),
                                            // Referrer company name
                                            TableCell(child: Center(
                                              child: Text('Referrer Company Name',style: Theme.of(context).textTheme.headlineMedium,),)),
                                            //Referred to name
                                            TableCell(child: Center(
                                              child: Text('Referred To Name',style: Theme.of(context).textTheme.headlineMedium,),)),
                                            //Referred to mob no
                                            TableCell(child: Center(
                                              child: Text('Referred Mobile No',style: Theme.of(context).textTheme.headlineMedium,),)),
                                            // Location
                                            TableCell(child: Center(
                                              child: Text('Location',style: Theme.of(context).textTheme.headlineMedium,),)),
                                            // Amount
                                            TableCell(child: Center(child: Column(children: [const SizedBox(height: 8,),
                                              Text('Amount',style: Theme.of(context).textTheme.headlineMedium,),
                                              const SizedBox(height: 8,),],),)),]),
                                          for(var i = 0; i < 5; i++) ...[
                                            //Table row start
                                            TableRow(
                                                decoration: BoxDecoration(color: Colors.grey[200]),
                                                children: [
                                                  // s.no
                                                  const TableCell(child: Center(child: Text('1'),)),
                                                  // Member name
                                                  const TableCell(child: Center(child: Text('Tamilselvan'),)),
                                                  // Member mob no
                                                  const TableCell(child: Center(child: Text('8765456789'),)),
                                                  // Referrer name
                                                  const TableCell(child: Center(child: Text('Suresh kumar'),)),
                                                  // Referrer mob no
                                                  const TableCell(child: Center(child: Text('7654678909'),)),
                                                  // Referrer company name
                                                  const TableCell(child: Center(child: Text('ABC & Co'),)),
                                                  // Referred to name
                                                  const TableCell(child: Center(child: Text('Kumar'),)),
                                                  // Referred to mob no
                                                  const TableCell(child: Center(child: Text('8765456789'),)),
                                                  // Location
                                                  const TableCell(child: Center(child: Text('Erode'),)),
                                                  // Amount
                                                  TableCell(
                                                      child: Center(child: Column(children: const [SizedBox(height: 8,),
                                                        Text('100000'), SizedBox(height: 8,),],),)),
                                                  //Table row end
                                                ]
                                            ),
                                          ],
                                        ] ),
                                  ]
                              ),
                            )
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),

          ),
        )
    );
  }
}
