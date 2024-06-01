import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gibadmin/main.dart';
import 'package:intl/intl.dart';

class CurrentMeetingUserRegistration extends StatelessWidget {
  const CurrentMeetingUserRegistration({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body:CurrentMeetingUserRegistrationPage() ,
    );
  }
}
class CurrentMeetingUserRegistrationPage extends StatefulWidget {
  const CurrentMeetingUserRegistrationPage({Key? key}) : super(key: key);

  @override
  State<CurrentMeetingUserRegistrationPage> createState() => _CurrentMeetingUserRegistrationPageState();
}

/*String meetinggroup ='Select';
var meetinggroplist = ['Select','Network Meeting','Team Meeting',
  'Training Program','Industrial Visit',];*/
String teammeetingpagegroup ='Select';
var teammeetingpagegrouplist = ['Select','Vaagai 4.0','Kurinji 4.0',
  'Neithal 4.0','Mullai 4.0',"Ambal 4.0","marutham 4.0"];


class _CurrentMeetingUserRegistrationPageState extends State<CurrentMeetingUserRegistrationPage> {
  DateTime date =DateTime.now();
  String? selectedmeetingtype;
  String? newmeetingtype;
  String? selectedmeetingname;
  String? meetingdate1;

  String? typeoutput;
  String? dateoutput;

  // final today = DateFormat("yyyy-MM-dd").format(DateTime.now());
  //DateFormat meetingdate1=DateFormat("yyyy-MM-dd").parse();

  final TextEditingController meetingdate = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return MyScaffold(route: "/current_meeting_user_regitration",
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Container(
              color:Colors.white ,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text("Meeting Report",style: Theme.of(context).textTheme.headlineMedium,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(

                            child: ElevatedButton(onPressed: (){
                              Navigator.pop(context);
                            }, child: const Text("Back"))),
                        /*const SizedBox(width: 25,),
                        OutlinedButton(onPressed: (){}, child: const Text("Print Table"))*/
                      ],
                    ),
                    const SizedBox(height: 20,),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Wrap(
                            runSpacing: 20,
                            spacing: 10,
                            children: [
                              Column(
                                children: [
                                  const Text("Meeting Date"),
                                  const SizedBox(height: 10,),
                                  SizedBox(width:280,
                                    child: TextFormField(
                                        controller: meetingdate,
                                        validator: (value) {
                                          if(value!.isEmpty){
                                            return "*Enter the Field";
                                          }else{
                                            return null;
                                          }
                                        },
                                        //pickDate meeting date
                                        decoration:  InputDecoration(
                                          hintText: "yyyy-MM-dd",
                                          suffixIcon: IconButton(onPressed: ()async{
                                            DateTime? pickDate = await showDatePicker(
                                                context: context,
                                                initialDate: DateTime.now(),
                                                firstDate: DateTime(1900),
                                                lastDate: DateTime(2100));
                                            if(pickDate==null) return;{
                                              setState(() {
                                                meetingdate.text =DateFormat('yyyy-MM-dd').format(pickDate);
                                                meetingdate1 = meetingdate.text;
                                                dateoutput = meetingdate1;
                                              });
                                            }
                                          }, icon: const Icon(
                                              Icons.calendar_today_outlined),
                                            color: Colors.green,),
                                        )
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  const SizedBox(height: 25,),
                                  Container(
                                    height: 52,
                                    padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 4),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                    // padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 4),
                                    child: SizedBox(
                                      width: 260,
                                      child: StreamBuilder<QuerySnapshot>(
                                        stream: FirebaseFirestore.instance.collection("Add Meeting").snapshots(),
                                        builder: (context, snapshot) {
                                          if (!snapshot.hasData) {
                                            const Text('Loading');
                                          } else {
                                            List<DropdownMenuItem> roleItems = [];
                                            for (int i = 0; i < snapshot.data!.docs.length; i++) {
                                              DocumentSnapshot snap = snapshot.data!.docs[i];
                                              // Id = snap["Id"];
                                              QuerySnapshot<Object?>? querySnapshot = snapshot.data;
                                              List<QueryDocumentSnapshot> documents = querySnapshot!.docs;
                                              List<Map> items = documents.map((e) => {
                                                "id": e.id,
                                                "Meeting Type": e["Meeting Type"]
                                              }).toList();
                                              roleItems.add(
                                                DropdownMenuItem(
                                                    value: "${snap["Meeting Type"]}",
                                                    child: Text("${snap["Meeting Type"]}")
                                                ),
                                              );
                                            }
                                            return Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: <Widget>[
                                                SizedBox(
                                                  width: 240,
                                                  child: DropdownButtonHideUnderline(
                                                    child: DropdownButton<dynamic>(
                                                      items: roleItems,
                                                      onChanged: (roleValue) {
                                                        setState(() {
                                                          newmeetingtype = roleValue;
                                                          //  id = "${snap["id"]}";
                                                        });
                                                      },
                                                      value: newmeetingtype,
                                                      isExpanded: true,
                                                      hint: const Text(
                                                        "Choose Meeting Type",
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            );
                                          }
                                          return const Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              /*Column(
                                children: [
                                  const Text("Meeting Type"),
                                 const SizedBox(height: 10,),
                                  SizedBox(width: 300,
                                    child: Container(
                                      //  width: 300,
                                      height: 52,
                                      padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 4),
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey),
                                        borderRadius: BorderRadius.circular(5.0),
                                      ),
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton(
                                          value: meetinggroup,
                                          //elevation: 20,
                                          icon: const Icon(Icons.arrow_drop_down),
                                          isExpanded: true,
                                          items:meetinggroplist.map((String members) {
                                            return DropdownMenuItem(
                                                value: members,
                                                child: Text(members)
                                            );
                                          }
                                          ).toList(),
                                          onChanged: (newValue){
                                            setState(() {
                                              meetinggroup = newValue.toString();
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),*/

                              Column(
                                children: [
                                  const SizedBox(height: 25,),
                                  Column(
                                    children: [
                                      Container(
                                        height: 52,
                                        padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 4),
                                        decoration: BoxDecoration(
                                          border: Border.all(color: Colors.grey),
                                          borderRadius: BorderRadius.circular(5.0),
                                        ),
                                        child: StreamBuilder<QuerySnapshot>(
                                          stream: FirebaseFirestore.instance.collection("Team Name").snapshots(),
                                          builder:(context, snapshot) {
                                            if (!snapshot.hasData) {
                                              const Text('Loading');
                                            } else
                                            {
                                              List<DropdownMenuItem> districtItems=[];
                                              for(int i=0;i<snapshot.data!.docs.length;i++){
                                                DocumentSnapshot snap = snapshot.data!.docs[i];
                                                QuerySnapshot<Object?>? querySnapshot = snapshot.data;
                                                List<QueryDocumentSnapshot> documents = querySnapshot!.docs;
                                                List<Map> items = documents.map((e) => {
                                                  "id": e.id,
                                                  "Team Name": e["Team Name"],
                                                }).toList();
                                                districtItems.add(
                                                  DropdownMenuItem(
                                                      value:"${snap["Team Name"]}",
                                                      child: Row(
                                                        children: [
                                                          Text("${snap["Team Name"]}"),
                                                        ],
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
                                                        setState(() {
                                                          selectedmeetingname = districtValue;
                                                        });
                                                      },
                                                      value: selectedmeetingname,
                                                      isExpanded: true,
                                                      hint:  const Text(
                                                        "Choose Team Name",
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
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 25,),


                    const SizedBox(height: 12,),
                    Row(
                      children:  [
                        Text("Meeting date :"),
                        Text(meetingdate1 != null ? meetingdate1! : " "),
                      ],
                    ),
                    const SizedBox(height: 12,),
                    Row(
                      children: [
                        Text("Meeting Type :"),
                        Text(newmeetingtype != null ? newmeetingtype! : " "),

                      ],
                    ),

                    const SizedBox(height: 20,),
                    Align(
                        alignment: Alignment.center,
                        child:  Text("Reports",style: Theme.of(context).textTheme.displayMedium,)),
                    const SizedBox(height: 20,),
                    StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance.collection("Register Meeting")
                            .where("Meeting Date", isEqualTo: meetingdate1)
                            .where("Meeting Type",isEqualTo: newmeetingtype)
                            .where("Team Name",isEqualTo: selectedmeetingname)
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

                          return Align(
                            alignment: Alignment.center,
                            child: Padding(
                              padding: const EdgeInsets.all(70.0),
                              child: Container(

                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Table(
                                      border: TableBorder.all(),
                                      defaultColumnWidth: const FixedColumnWidth(200.0),
                                      columnWidths: const <int, TableColumnWidth>{
                                        0:FixedColumnWidth(60),
                                        1:FixedColumnWidth(200),
                                        2:FixedColumnWidth(300),
                                      },
                                      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                                      children: [
                                        TableRow(
                                            children: [
                                              //s.no
                                              TableCell(child:  Center(
                                                child: Column(
                                                  children: [
                                                    const SizedBox(height: 8,),
                                                    Text('S.No', style: Theme.of(context).textTheme.headlineMedium),
                                                    const SizedBox(height: 8,),
                                                  ],
                                                ),)),
                                              TableCell(child:Center(child: Text('Meeting Date', style: Theme.of(context).textTheme.headlineMedium,))),

                                              //Name
                                              TableCell(child: Center(child: Text('Member ID', style: Theme.of(context).textTheme.headlineMedium,),)),
                                              // Email
                                              TableCell(child:Center(child: Text('Member Name', style: Theme.of(context).textTheme.headlineMedium,))),
                                              // Mobile
                                              TableCell(child: Center(child: Text('Member Name', style: Theme.of(context).textTheme.headlineMedium,))),
                                              //Role
                                              TableCell(child:Center(child: Text('Contact No', style: Theme.of(context).textTheme.headlineMedium,))),
                                              //status
                                              TableCell(child: Center(child: Text('Koottam', style: Theme.of(context).textTheme.headlineMedium,))),

                                              TableCell(child:Center(child: Text('Business Type', style: Theme.of(context).textTheme.headlineMedium,))),
                                              TableCell(child:Center(child: Text('Meeting Type', style: Theme.of(context).textTheme.headlineMedium,))),

                                              TableCell(child:Center(child: Text('Team Name', style: Theme.of(context).textTheme.headlineMedium,))),

                                              TableCell(child:Center(child: Text('Visitors Count', style: Theme.of(context).textTheme.headlineMedium,))),


                                            ]),
                                        //1

                                        for(var i = 0 ;i < storedocs.length; i++) ...[
                                          TableRow(
                                              children: [
                                                TableCell(child: Center(child: Column(
                                                  children: [
                                                    const SizedBox(height: 8,),
                                                    Text("${i+1}"),
                                                    const SizedBox(height: 8,)
                                                  ],
                                                ))),
                                                TableCell(child: Center(child:
                                                Align(
                                                    alignment:Alignment.topLeft,
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: Text("${storedocs[i]["Meeting Date"]}"),
                                                    )),)),
                                                //2
                                                TableCell(child: Center(child:
                                                Align(
                                                    alignment:Alignment.topLeft,
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: Text("${storedocs[i]["First Name"]}"),
                                                    )),)),
                                                //3
                                                TableCell(child: Center(child:
                                                Align(
                                                    alignment:Alignment.topLeft,
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: Text("${storedocs[i]["Name"]}"),
                                                    )),)),
                                                //4
                                                TableCell(child:Center(child:
                                                Align(
                                                    alignment:Alignment.topLeft,
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: Text("${storedocs[i]["Member Type"]}"),
                                                    )),)),
                                                //5
                                                TableCell(child:Center(child:
                                                Align(
                                                    alignment:Alignment.topLeft,
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: Text("${storedocs[i]["Mobile"]}"),
                                                    )),)),
                                                //6
                                                TableCell(child:Center(child:
                                                Align(
                                                    alignment:Alignment.topLeft,
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: Text("${storedocs[i]["Koottam"]}"),
                                                    )),)),
                                                TableCell(child:Center(child:
                                                Align(
                                                    alignment:Alignment.topLeft,
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: Text("${storedocs[i]["Business Type"]}"),
                                                    )),)), TableCell(child:Center(child:
                                                Align(
                                                    alignment:Alignment.topLeft,
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: Text("${storedocs[i]["Meeting Type"]}"),
                                                    )),)),
                                                TableCell(child:Center(child:
                                                Align(
                                                    alignment:Alignment.topLeft,
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: Text("${storedocs[i]["Team Name"]}"),
                                                    )),)),
                                                TableCell(child:Center(child:
                                                Align(
                                                    alignment:Alignment.topLeft,
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: Text("${storedocs[i]["Visitors Count"]}"),
                                                    )),)),
                                              ]
                                          )]]),
                                ),
                              ),
                            ),
                          );
                        }
                    ),
                    const SizedBox(height: 20,),
                  ],
                ),
              ),
            ),
          ),
        )
    );
  }
}
