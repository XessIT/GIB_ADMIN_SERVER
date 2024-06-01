import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'main.dart';

class CurrentMeetingAttendance extends StatelessWidget {
  const CurrentMeetingAttendance({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: CurrentMeetingAttendancePage(),
    );
  }
}
class CurrentMeetingAttendancePage extends StatefulWidget {
  const CurrentMeetingAttendancePage({Key? key}) : super(key: key);

  @override
  State<CurrentMeetingAttendancePage> createState() => _CurrentMeetingAttendancePageState();
}

class _CurrentMeetingAttendancePageState extends State<CurrentMeetingAttendancePage> {

//dropdown members
  String meetingtype = 'Select';
  var meetingtypegroup = ['Select',
    'Network Meeting','Team meeting','Training Program','Industrial Visit',];

  //date time  Textformfield
  DateTime date =DateTime(2022,22,08);
  final TextEditingController _date = TextEditingController();

  // _formkey
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
        route: "/current_meeting_page",
        body: Form(
            key: _formKey,
            child: Center(
                child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(30.0),
                        child: Container(
                          color: Colors.white,
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            children: [
                              // text meeting report
                              const SizedBox(height: 20,),
                              Text('Meeting Report',style: Theme.of(context).textTheme.headlineMedium,),
                              const SizedBox(height: 20,),
                              // wrap
                              Wrap(
                                runSpacing: 10,
                                spacing: 10,
                                children: [
                                  Column(
                                    children: [
                                      // meeting date text starts
                                      Text('Meeting Date',
                                        style: Theme.of(context).textTheme.headlineMedium,),
                                      // // meeting date text end

                                      const SizedBox(height: 20,),

                                      //TextFormField  Meeting Date starts
                                      SizedBox(width:300,
                                          child: TextFormField(
                                              controller: _date,
                                              validator: (value) {
                                                if(value!.isEmpty){
                                                  return "*Enter Your Meeting Date";
                                                }else{
                                                  return null;
                                                }
                                              },
                                              decoration:  InputDecoration(
                                                  labelText: "Meeting Date",
                                                  suffixIcon: IconButton(onPressed: ()async{
                                                    DateTime? pickDate = await showDatePicker(
                                                        context: context,
                                                        initialDate: DateTime.now(),
                                                        firstDate: DateTime(1900),
                                                        lastDate: DateTime(2100));
                                                    if(pickDate==null) return;{
                                                      setState(() {
                                                        _date.text =DateFormat('dd/MM/yyyy').format(pickDate);
                                                      });
                                                    }
                                                  },
                                                    icon: const Icon(
                                                        Icons.calendar_today_outlined),color: Colors.green,
                                                  )
                                              )
                                          )
                                      ),
                                      //TextFormField  Meeting Date end
                                    ],
                                  ),
                                  const SizedBox(width: 50,),
                                  Column(
                                    children: [
                                      // meeting type dropdown button starts
                                      Text('Meeting Type',
                                        style: Theme.of(context).textTheme.headlineMedium,),
                                      // meeting type dropdown button end

                                      const SizedBox(height: 20,),
                                      //DropdownButton

                                      Container(
                                          height: 52,
                                          padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 4),
                                          decoration: BoxDecoration(
                                            border: Border.all(color: Colors.grey),
                                            borderRadius: BorderRadius.circular(5.0),
                                          ),
                                          child: DropdownButtonHideUnderline(
                                              child: SizedBox(width: 275,
                                                child: DropdownButton(
                                                  value: meetingtype,
                                                  //elevation: 20,
                                                  icon: const Icon(Icons.arrow_drop_down),
                                                  isExpanded: true,
                                                  items:meetingtypegroup.map((String meeting) {
                                                    return DropdownMenuItem(
                                                        value: meeting,
                                                        child: Text(meeting)
                                                    );
                                                  }
                                                  ).toList(),
                                                  onChanged: (newValue){
                                                    setState(() {
                                                      meetingtype = newValue.toString();
                                                    });
                                                  },
                                                ),
                                              )
                                          )
                                      )
                                    ],
                                  ),
                                  // outline button print table
                                ],),
                              const SizedBox(height: 30,),
                              //Table starts
                              Container(
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Table(
                                      border: TableBorder.all(),
                                      defaultColumnWidth: const FixedColumnWidth(250),
                                      columnWidths: const <int, TableColumnWidth>{
                                        0:FixedColumnWidth(80),5:FixedColumnWidth(240),
                                      },
                                      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                                      children:[
                                        // Table row start
                                        TableRow(children: [
                                          //S.no
                                          TableCell(child: Center(child: Column(
                                            children: [const SizedBox(height: 8,),
                                              Text('S.No',style: Theme.of(context).textTheme.headlineMedium,),
                                              const SizedBox(height: 8,),],),)),
                                          // Member id
                                          TableCell(child: Center(
                                            child: Text('Member Id',style: Theme.of(context).textTheme.headlineMedium,),)),
                                          //Member name
                                          TableCell(child: Center(
                                            child: Text('Member Name',style: Theme.of(context).textTheme.headlineMedium,),)),
                                          // contact no
                                          TableCell(child: Center(
                                            child: Text('Contact No',style: Theme.of(context).textTheme.headlineMedium,),)),
                                          //Koottam
                                          TableCell(child: Center(
                                            child: Text('Koottam',style: Theme.of(context).textTheme.headlineMedium,),)),
                                          // Business
                                          TableCell(child: Center(
                                            child: Text('Business',style: Theme.of(context).textTheme.headlineMedium,),)),
                                          // Meeting date
                                          TableCell(child: Center(
                                            child: Text('Member Date',style: Theme.of(context).textTheme.headlineMedium,),)),
                                          //Attendance
                                          TableCell(child: Center(
                                            child: Text('Attendance',style: Theme.of(context).textTheme.headlineMedium,),)),
                                          // visitors
                                          TableCell(child: Center(
                                            child: Text('Visitors',style: Theme.of(context).textTheme.headlineMedium,),)),]),
                                        for(var i = 0; i < 5; i++) ...[
                                          //Table row start
                                          TableRow(
                                              decoration: BoxDecoration(color: Colors.grey[200]),
                                              children: [
                                                //S.no
                                                const TableCell(child: Center(child: Text('1'),)),
                                                // Member id
                                                TableCell(child: Center(child: Column(
                                                  children: const [SizedBox(height: 8,), Text('1234'),
                                                    SizedBox(height: 8,),],),)),
                                                //Member name
                                                const TableCell(child: Center(child: Text('Tamilselvan'),)),
                                                // Contact no
                                                const TableCell(child: Center(child: Text('8907654323'),)),
                                                // Koottam
                                                const TableCell(child: Center(child: Text('Aandhai'),)),
                                                //Business
                                                const TableCell(child: Center(child: Text('Textile'),)),
                                                // meeting date
                                                const TableCell(child: Center(child: Text('June 11 , 2022,Saturday'),)),
                                                // Attendance
                                                const TableCell(child: Center(child: Text('1'),)),
                                                //Visitors
                                                const TableCell(child: Center(child: Text(''),)),
                                                // Table row end
                                              ]
                                          )
                                        ],
                                      ] ),
                                ),
                              ),
                              //Table end

                            ],
                          ),
                        ),
                      ),
                    ]
                )
            )
        )
    );
  }
}