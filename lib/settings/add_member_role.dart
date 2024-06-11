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
  final ScrollController _scrollController=ScrollController();
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
  Future<void> delete(String id) async {
    try {
      final url = Uri.parse('http://mybudgetbook.in/GIBADMINAPI/add_member_role.php?id=$id');
      final response = await http.delete(url);
      print("Delete Url: $url");
      if (response.statusCode == 200) {
        //Success handling, e.g., show a success message
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
         Navigator.push(context, MaterialPageRoute(builder: (context) => const AddMemeberRole()));
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
                            }, child: const Text('ADD'),),

                            const SizedBox(height: 25,),
                            Scrollbar(
                              thumbVisibility: true,
                              controller: _scrollController,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                controller: _scrollController,
                                child: SizedBox(
                                  width: 800,
                                  child: PaginatedDataTable(
                                    columnSpacing: 50,
                                    rowsPerPage: 15,
                                    columns: const [
                                      DataColumn(label: Center(child: Text("S.No", style: TextStyle(fontWeight: FontWeight.bold)))),
                                      DataColumn(label: Center(child: Text("Role", style: TextStyle(fontWeight: FontWeight.bold)))),
                                      DataColumn(label: Center(child: Text("Edit", style: TextStyle(fontWeight: FontWeight.bold)))),
                                      DataColumn(label: Center(child: Text("Delete", style: TextStyle(fontWeight: FontWeight.bold)))),
                                    ],
                                    source: MyDataTableSource4(
                                      data: data,
                                      delete: delete,
                                      member_role: rolecontroller.text,// Pass the unblocked function here
                                      context: context,
                                    ),
                                  ),
                                ),
                              ),
                            ),
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
class MyDataTableSource4 extends DataTableSource {
  List<Map<String, dynamic>> data;
  String member_role;
  BuildContext context;
  final Future<void> Function(String id) delete;
  TextEditingController changerolecontroller2;

  MyDataTableSource4({
    required this.data,
    required this.member_role,
    required this.delete,
    required this.context,
  }) : changerolecontroller2 = TextEditingController(text: member_role);

  String capitalizeFirstLetter(String text) {
    if (text.isEmpty) return text;
    return text.substring(0, 1).toUpperCase() + text.substring(1);
  }

  @override
  int get rowCount => data.length;

  @override
  bool get isRowCountApproximate => false;

  Future<void> editRole(int id) async {
    try {
      final url = Uri.parse('http://mybudgetbook.in/GIBADMINAPI/add_member_role.php');
      print(url);
      print("Member Role: ${changerolecontroller2.text}");
      final response = await http.put(
        url,
        body: jsonEncode({
          "member_role": changerolecontroller2.text,
          "id": id,
        }),
      );
      if (response.statusCode == 200) {
        print("Response Status: ${response.statusCode}");
        print("Response Body: ${response.body}");
        Navigator.push(context, MaterialPageRoute(builder: (context) => const AddMemeberRole()));
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Successfully Edited")));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Failed to Edit")));
      }
    } catch (e) {
      print("Error during signup: $e");
      // Handle error as needed
    }
  }

  @override
  int get selectedRowCount => 0;
  @override
  DataRow getRow(int index) {
    return DataRow(
      cells: [
        DataCell(Text('${index + 1}')),
        DataCell(Text('${data[index]["role"]}')),
        DataCell(
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
                        changerolecontroller2.value = changerolecontroller2.value.copyWith(
                          text: capitalizedValue,
                          //selection: TextSelection.collapsed(offset: capitalizedValue.length),
                        );
                      },

                      inputFormatters: [
                        LengthLimitingTextInputFormatter(25),
                        AlphabetInputFormatter(),],
                      controller: changerolecontroller2 = TextEditingController(
                          text: data[index]["role"]
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
                            changerolecontroller2.clear();
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
                            editRole(int.parse(data[index]["id"]));
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
        ),
        DataCell(
          IconButton(
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
                              delete(data[index]['id']);
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

        ),

      ],
    );
  }

  @override
  void rowsRefresh() {
    // handle data refresh
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

