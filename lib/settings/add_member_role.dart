import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../main.dart';
import 'package:http/http.dart' as http;

class AddMemeberRole extends StatelessWidget {
  const AddMemeberRole({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: AddMemeberRolePage(),
    );
  }
}
class AddMemeberRolePage extends StatefulWidget {
  const AddMemeberRolePage({Key? key}) : super(key: key);

  @override
  State<AddMemeberRolePage> createState() => _AddMemeberRolePageState();
}


class _AddMemeberRolePageState extends State<AddMemeberRolePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController rolecontroller = TextEditingController();
  TextEditingController changerolecontroller = TextEditingController();
  String MemName = "";
  ///First Letter capital code
  String capitalizeFirstLetter(String text) {
    if (text.isEmpty) return text;
    return text.substring(0, 1).toUpperCase() + text.substring(1);
  }

  List<Map<String, dynamic>> data=[];
  Future<void> getData() async {
    print('Attempting to make HTTP request...');
    try {
      final url = Uri.parse('http://mybudgetbook.in/GIBADMINAPI/add_member_role.php');
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
  Future<void> editRole(int id) async {
    try {
      final url = Uri.parse('http://mybudgetbook.in/GIBADMINAPI/add_member_role.php');
      print(url);
      print("Member Role: ${changerolecontroller.text}");
      final response = await http.put(
        url,
        body: jsonEncode({
          "member_role": changerolecontroller.text,
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
      final url = Uri.parse('http://mybudgetbook.in/GIBADMINAPI/add_member_role.php?id=$id');
      final response = await http.delete(url);
      print("Delete Url: $url");
      if (response.statusCode == 200) {
        // Success handling, e.g., show a success message
       // Navigator.pop(context);
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
  void initState() {
    getData();
    super.initState();
  }

  Future<void> addMemberRole() async {
    try {
      final url = Uri.parse('http://mybudgetbook.in/GIBADMINAPI/add_member_role.php');
      print(url);
      print("Member Role: ${rolecontroller.text}");
      final response = await http.post(
        url,
        body: jsonEncode({
          "member_role": rolecontroller.text,
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

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
        route: '/add_member_role',
        body: Form(
          key: _formKey,
          child: Center(
            child: Column(
              children: [
                const SizedBox(height: 30,),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Container(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            const SizedBox(height: 20,),
                            Text("Add Member Role",style: Theme.of(context).textTheme.headlineMedium,),
                            const SizedBox(height: 60,),
                            SizedBox(width: 350,
                              child: TextFormField(
                                controller: rolecontroller,
                                validator: (value){
                                  if(value!.isEmpty){
                                    return "* Required the Role type ";
                                  }else{
                                    return null;
                                  }
                                },
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(25),
                                  AlphabetInputFormatter(),
                                ],
                                onChanged: (value) {
                                  String capitalizedValue = capitalizeFirstLetter(value);
                                  rolecontroller.value = rolecontroller.value.copyWith(
                                    text: capitalizedValue,
                                    selection: TextSelection.collapsed(offset: capitalizedValue.length),
                                  );
                                },
                                decoration: const InputDecoration(
                                  labelText: 'Role Type',
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(onPressed: (){
                              if(_formKey.currentState!.validate()){
                                addMemberRole();
                              }
                            }, child: const Text('Submit'),),

                            const SizedBox(height: 25,),

                            Align(
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
                                                  2:FixedColumnWidth(120),
                                                  3:FixedColumnWidth(120),
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
                                                                Text(data[i]["role"]),
                                                                const SizedBox(height: 4,),],
                                                            ),
                                                          )
                                                          ),

                                                          //edit_note Tabel cell
                                                          TableCell(
                                                              child: Center(
                                                                child: Column(
                                                                  children:  [
                                                                    const SizedBox(height: 4,),
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
                                                                                onChanged: (value) {
                                                                                  String capitalizedValue = capitalizeFirstLetter(value);
                                                                                  changerolecontroller.value = changerolecontroller.value.copyWith(
                                                                                    text: capitalizedValue,
                                                                                    //selection: TextSelection.collapsed(offset: capitalizedValue.length),
                                                                                  );
                                                                                },

                                                                                inputFormatters: [
                                                                                  LengthLimitingTextInputFormatter(25),
                                                                                AlphabetInputFormatter(),],
                                                                                controller: changerolecontroller = TextEditingController(
                                                                                    text: data[i]["role"]
                                                                                ),
                                                                                validator: (value){
                                                                                  if(value!.isEmpty){
                                                                                    return "enter the field";
                                                                                  }else{
                                                                                    return null;
                                                                                  }
                                                                                },
                                                                                decoration: InputDecoration(
                                                                                    suffixIcon: IconButton(onPressed: (){
                                                                                      changerolecontroller.clear();
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
                                                                                      editRole(int.parse(data[i]["id"]));
                                                                                      Navigator.pop(context);
                                                                                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                                                                          content: Text("You have Successfully Updated a Role")));
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
                                                                    const SizedBox(height: 4,),
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
                                                                            title: const Text('Delete',
                                                                                style: TextStyle(color: Colors.white)),
                                                                            content: const Text("Do you want to Delete the role?",
                                                                                style: TextStyle(color: Colors.white)),
                                                                            actions: [
                                                                              TextButton(
                                                                                  onPressed: () async{
                                                                                    delete(data[i]['id']);
                                                                                    Navigator.pop(context);
                                                                                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                                                                        content: Text("You have Successfully Deleted a Role")));
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

                          ],
                        ),
                      )),
                )

              ],
            ),
          ),
        ));
  }
}

class AlphabetInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    String filteredText = newValue.text.replaceAll(RegExp(r'[^a-zA-Z]'), '');

    return newValue.copyWith(text: filteredText);
  }
}

