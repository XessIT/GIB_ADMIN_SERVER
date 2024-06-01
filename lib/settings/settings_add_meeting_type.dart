import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gibadmin/main.dart';
class AddMeeting extends StatelessWidget {
  const AddMeeting({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body:AddMeetingPage(),
    );

  }

}
class AddMeetingPage extends StatefulWidget {
  const AddMeetingPage({Key? key,}) : super(key: key);

  @override
  State<AddMeetingPage> createState() => _AddMeetingPageState();

}

class _AddMeetingPageState extends State<AddMeetingPage> {

  TextEditingController meetingtypecontroller = TextEditingController();
  TextEditingController changetypecontroller = TextEditingController();

  @override
  void initState() {
    getData();
    super.initState();
  }
  //Formkey
  final _formkey = GlobalKey<FormState>();
  Future<void> addMeeting() async {
    try {
      final url = Uri.parse('http://mybudgetbook.in/GIBADMINAPI/add_meeting.php');
      print(url);
      print("Meeting Type: ${meetingtypecontroller.text}");
      final response = await http.post(
        url,
        body: jsonEncode({
          "meeting_type": meetingtypecontroller.text,
        }),
      );
      if (response.statusCode == 200) {
        print("Response Status: ${response.statusCode}");
        print("Response Body: ${response.body}");
       // Navigator.push(context, MaterialPageRoute(builder: (context) => const NewMemberApproval()));
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Successfully Added")));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Failed to Add")));
      }
    } catch (e) {
      print("Error during signup: $e");
      // Handle error as needed
    }
  }
  List<Map<String, dynamic>> data=[];
  Future<void> getData() async {
    print('Attempting to make HTTP request...');
    try {
      final url = Uri.parse('http://mybudgetbook.in/GIBADMINAPI/add_meeting.php');
      print(url);
      final response = await http.get(url);
      print("ResponseStatus: ${response.statusCode}");
      print("Response: ${response.body}");
      // http.Response response = await http.get(url);
      //  var data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print("ResponseData: $responseData");
        final List<dynamic> itemGroups = responseData;
        setState(() {});
        data = itemGroups.cast<Map<String, dynamic>>();
        print('Data: $data');
        print("Id: ${data[0]["ID"]}");
      } else {
        print('Error: ${response.statusCode}');
      }
      print('HTTP request completed. Status code: ${response.statusCode}');
    } catch (e) {
      print('Error making HTTP request: $e');
      throw e; // rethrow the error if needed
    }
  }
  Future<void> editMeeting(int id) async {
    try {
      final url = Uri.parse('http://mybudgetbook.in/GIBADMINAPI/add_meeting.php');
      print(url);
      print("Meeting Type: ${changetypecontroller.text}");
      final response = await http.put(
        url,
        body: jsonEncode({
          "meeting_type": changetypecontroller.text,
          "id": id,
        }),
      );
      if (response.statusCode == 200) {
        print("Response Status: ${response.statusCode}");
        print("Response Body: ${response.body}");
        // Navigator.push(context, MaterialPageRoute(builder: (context) => const NewMemberApproval()));
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Successfully Edited")));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Failed to Edit")));
      }
    } catch (e) {
      print("Error during signup: $e");
      // Handle error as needed
    }
  }
  Future<void> delete(String id) async {
    try {
      final url = Uri.parse('http://mybudgetbook.in/GIBADMINAPI/add_meeting.php?id=$id');
      final response = await http.delete(url);
      print("Delete Url: $url");
      if (response.statusCode == 200) {
        // Success handling, e.g., show a success message
        Navigator.pop(context);
      }
      else {
        // Error handling, e.g., show an error message
        print('Error: ${response.statusCode}');
      }
    }
    catch (e) {
      // Handle network or server errors
      print('Error making HTTP request: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return  MyScaffold(
        route:'/add_meeting_type',
        body:SingleChildScrollView(
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Container(
                  margin: EdgeInsets.all(10.0),
                  width: 700,
                  color: Colors.white70,
                  child: Form(
                    key:_formkey,
                    child: Center(
                      child: Column(
                          children: [
                            const SizedBox(height: 40,),
                            Text('Add Meeting Type',
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                            const SizedBox(height: 25,),
                            Wrap(
                              runSpacing: 10,
                              spacing: 10,
                              children: [
                                //  const Padding(padding: EdgeInsets.only(right: 20,left: 20,)),
                                SizedBox(width: 350,
                                  child: TextFormField(
                                    controller: meetingtypecontroller,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: "Meeting Type",
                                      hintText: "Enter Meeting Type",
                                    ),
                                    inputFormatters:<TextInputFormatter> [
                                      FilteringTextInputFormatter.singleLineFormatter,
                                    ],
                                    validator: (value){
                                      if(value==null || value.isEmpty){
                                        return 'Required';
                                      }
                                      return null;
                                    },
                                  ),),
                                Column(
                                  children: [
                                    const SizedBox(width: 40,height: 10,),
                                    SizedBox(
                                      child: OutlinedButton(                         //submit button
                                        style: OutlinedButton.styleFrom(backgroundColor: Colors.green),
                                        onPressed: (){
                                          addMeeting();
                                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> const AddMeeting()));
                                        },
                                        child: const Text('Submit',
                                            style: TextStyle(fontSize: 18,color: Colors.white)),),
                                    ),
                                  ],
                                ),
                                SizedBox(width: 20,),
                              ],
                            ),
                            const SizedBox(height: 20,),
                                Align(
                                    alignment: Alignment.topLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.all(70),
                                      child: Container(
                                        child: SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: Table(
                                                border: TableBorder.all(),
                                                defaultColumnWidth: const FixedColumnWidth(200.0),
                                                columnWidths: const <int, TableColumnWidth>{
                                                  1:FixedColumnWidth(180),
                                                  2:FixedColumnWidth(160),
                                                },
                                                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                                                children:[
                                                  //Table row starting
                                                  TableRow(
                                                      children: [
                                                        //Meeting Name
                                                        TableCell(
                                                            child:Center(
                                                              child: Text('Meeting Name',
                                                                style: Theme.of(context).textTheme.headlineMedium,),)),
                                                        // Edit
                                                        TableCell(
                                                          child: Center(
                                                            child: Text('Edit',
                                                              style: Theme.of(context).textTheme.headlineMedium,
                                                            ),),),
                                                        //Delete
                                                        TableCell(
                                                            child: Center(
                                                              child: Column(
                                                                children: [
                                                                  const SizedBox(height: 8,),
                                                                  Text('Delete',
                                                                      style: Theme.of(context).textTheme.headlineMedium),
                                                                  const SizedBox(height: 8,),],),)),
                                                      ]),
                                                  // Table row end
                                                  for(var i = 0 ;i < data.length; i++) ...[
                                                    //Table row start
                                                    TableRow(
                                                        decoration: BoxDecoration(color: Colors.grey[200]),
                                                        children: [
                                                          // 1 s.no
                                                          TableCell(child:Center(
                                                            child: Column(
                                                              children:  [
                                                                const SizedBox(height: 8,),
                                                                Text(data[i]["meeting_type"]),
                                                                const SizedBox(height: 8,),],
                                                            ),
                                                          )
                                                          ),
                                                          //edit_note Tabel cell
                                                          TableCell(
                                                              child: Center(
                                                                child: Column(
                                                                  children:  [
                                                                    const SizedBox(height: 8,),
                                                                    IconButton(onPressed: (){
                                                                      // _editnote(context);
                                                                      showDialog<void>(
                                                                        context: context,
                                                                        builder: (BuildContext dialogContext) {
                                                                          return AlertDialog(
                                                                            backgroundColor: Colors.white,
                                                                            title: const Text('Edit',),
                                                                            content:  SizedBox(width: 300,
                                                                              child: TextFormField(
                                                                                controller: changetypecontroller = TextEditingController(
                                                                                    text: data[i]["meeting_type"]
                                                                                ),
                                                                                validator: (value){
                                                                                  if(value!.isEmpty){
                                                                                    return "enter the field";
                                                                                  }else{
                                                                                    return null;
                                                                                  }
                                                                                },
                                                                                decoration: InputDecoration(
                                                                                  //labelText:"${storedocs[i]["Meeting Type"]}",
                                                                                    suffixIcon: IconButton(onPressed: (){
                                                                                      changetypecontroller.clear();
                                                                                    }, icon: const Icon(Icons.cancel_presentation,color: Colors.red,))
                                                                                ) ,
                                                                              ),
                                                                            ),
                                                                            actions: <Widget>[
                                                                              Row(
                                                                                mainAxisAlignment: MainAxisAlignment.end,
                                                                                children: [
                                                                                  TextButton(
                                                                                    child: const Text('Ok',),
                                                                                    onPressed:  ()  {
                                                                                      editMeeting(int.parse(data[i]["id"]));
                                                                                      Navigator.pop(context);
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
                                                                        icon:const Icon(Icons.edit_note,color: Colors.blue,)),
                                                                    const SizedBox(height: 8,),
                                                                  ],),)),
                                                          //delete Tabel cell
                                                          TableCell(child: Center(child:  IconButton(onPressed: (){
                                                            showDialog(
                                                                context: context,
                                                                builder: (ctx) =>
                                                                // Dialog box for register meeting and add guest
                                                                AlertDialog(
                                                                  backgroundColor: Colors.grey[800],
                                                                  title: const Text('Delete',
                                                                      style: TextStyle(color: Colors.white)),
                                                                  content: const Text("Do you want to Delete the Image?",
                                                                      style: TextStyle(color: Colors.white)),
                                                                  actions: [
                                                                    TextButton(
                                                                        onPressed: () async{
                                                                         delete(data[i]['id']);
                                                                          Navigator.pop(context);
                                                                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                                                              content: Text("You have Successfully Deleted a Meeting Type")));
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
                                                              icon: const Icon(Icons.delete,color: Colors.red,)),
                                                          )),]),
                                                    // Table row end
                                                  ]]   )
                                        ),
                                      ),
                                    ),
                                  )

                          ]

                      ),
                    ),
                  ),
                ),
              ),
            )
        )
    );
  }
}
// delete dialougebox starts

// delete dialougebox ends

// _editnote dialougebox starts
void _editnote(BuildContext context) {

}
// _editnote dialougebox ends

