import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '../../main.dart';


class MemberCategory extends StatelessWidget {
  const MemberCategory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: MemberCategoryPage(),
    );
  }
}
class MemberCategoryPage extends StatefulWidget {
  const MemberCategoryPage({Key? key}) : super(key: key);

  @override
  State<MemberCategoryPage> createState() => _MemberCategoryPageState();
}
final _formKey = GlobalKey<FormState>();

class _MemberCategoryPageState extends State<MemberCategoryPage> {

  String? selectedDistrict;
  String? selectedChapter;
  String? selectedmember;
  TextEditingController membercategorycontroller = TextEditingController();
  ScrollController _scrollController=ScrollController();
  TextEditingController editteam = TextEditingController();
  String name = "";
  TextEditingController districtController = TextEditingController();
  TextEditingController chapterController = TextEditingController();
  TextEditingController memberTypeController = TextEditingController();

  ///district code
  List<Map<String, dynamic>> suggesstiondata = [];

  List district = [];

  Future<void> getDistrict() async {
    try {
      final url = Uri.parse('http://mybudgetbook.in/GIBAPI/district.php');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final List<dynamic> itemGroups = responseData;
        setState(() {
          suggesstiondata = itemGroups.cast<Map<String, dynamic>>();
          print("district:$suggesstiondata}");
        });
      } else {
        //print('Error: ${response.statusCode}');
      }
    } catch (error) {
      //  print('Error: $error');
    }
  }
  /// chapter code
  List<String> chapters = [];

  List<Map<String, dynamic>> suggesstiondataitemName = [];

  Future<void> getChapter(String district) async {
    try {
      final url = Uri.parse('http://mybudgetbook.in/GIBAPI/chapter.php?district=$district'); // Fix URL
      print(url);
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final List<dynamic> units = responseData;
        setState(() {
          suggesstiondataitemName = units.cast<Map<String, dynamic>>();
          print("chapter:$suggesstiondataitemName");
        });
        print('Sorted chapter Names: $suggesstiondataitemName');
        setState(() {
          print('chapter: $chapters');
          setState(() {
          });
          chapterController.clear();
        });
      } else {
        print('chapter Error: ${response.statusCode}');
      }
    } catch (error) {
      print(' chapter Error: $error');
    }
  }

  List<Map<String, dynamic>> membersuggesstiondata = [];

  List member = [];

  Future<void> getMemberType() async {
    try {
      final url = Uri.parse('http://mybudgetbook.in/GIBADMINAPI/member_type.php');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final List<dynamic> itemGroups = responseData;
        setState(() {
          membersuggesstiondata = itemGroups.cast<Map<String, dynamic>>();
          print("district:$membersuggesstiondata}");
        });
      } else {
        //print('Error: ${response.statusCode}');
      }
    } catch (error) {
      //  print('Error: $error');
    }
  }

  Future<void> addMemberCategory() async {
    try {
      final url = Uri.parse('http://mybudgetbook.in/GIBADMINAPI/add_member_category.php');
      print(url);
      print("Member Category: ${membercategorycontroller.text}");
      final response = await http.post(
        url,
        body: jsonEncode({
          "district": districtController.text,
          "chapter": chapterController.text,
          "member_type": memberTypeController.text,
          "member_category": membercategorycontroller.text,
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
      final url = Uri.parse('http://mybudgetbook.in/GIBADMINAPI/add_member_category.php?table=withoutFilter');
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
      final url = Uri.parse('http://mybudgetbook.in/GIBADMINAPI/add_member_category.php?id=$id');
      final response = await http.delete(url);
      print("Delete Url: $url");
      if (response.statusCode == 200) {
        Navigator.push(context, MaterialPageRoute(builder: (context)=>MemberCategory()));
        // Success handling, e.g., show a success message
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
    super.initState();
    getData();
    getDistrict();
    getMemberType();
  }
  @override
  Widget build(BuildContext context) {

    return MyScaffold(
      route: '/add_member_category',
      body: Center(
        child: Form(
          key:_formKey ,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  children: [
                    const SizedBox(height: 30,),
                    Text("Add Member Category",
                        style: Theme.of(context).textTheme.headlineMedium),
                    const SizedBox(height: 12,),
                    Wrap(
                      runSpacing: 20,
                      spacing: 10,
                      children: [
                        SizedBox(
                          width: 300,
                          height: 50,
                          child: TypeAheadFormField<String>(
                            textFieldConfiguration: TextFieldConfiguration(
                              controller: districtController,
                              decoration: const InputDecoration(
                                  fillColor: Colors.white,
                                  filled: true,
                                  labelText: "District"
                              ),
                            ),
                            suggestionsCallback: (pattern) async {
                              return suggesstiondata
                                  .where((item) =>
                                  (item['district']?.toString().toLowerCase() ?? '')
                                      .startsWith(pattern.toLowerCase()))
                                  .map((item) => item['district'].toString())
                                  .toList();
                            },
                            itemBuilder: (context, suggestion) {
                              return ListTile(
                                title: Text(suggestion),
                              );
                            },
                            onSuggestionSelected: (suggestion) async {
                              setState(() {
                                districtController.text = suggestion;
                                setState(() {
                                  getChapter(districtController.text.trim());

                                });
                              });
                              //   print('Selected Item Group: $suggestion');
                            },
                          ),
                        ),

                        const SizedBox(height: 10,width: 40,),
                        SizedBox(

                          width: 300,
                          height: 50,
                          child: TypeAheadFormField<String>(
                            textFieldConfiguration: TextFieldConfiguration(
                              controller: chapterController,
                              decoration: const InputDecoration(
                                  fillColor: Colors.white,
                                  filled: true,
                                  labelText: "Chapter"
                              ),
                            ),
                            suggestionsCallback: (pattern) async {
                              return suggesstiondataitemName
                                  .where((item) =>
                                  (item['chapter']?.toString().toLowerCase() ?? '')
                                      .startsWith(pattern.toLowerCase()))
                                  .map((item) => item['chapter'].toString())
                                  .toList();
                            },
                            itemBuilder: (context, suggestion) {
                              return ListTile(
                                title: Text(suggestion),
                              );
                            },
                            onSuggestionSelected: (suggestion) async {
                              setState(() {
                                chapterController.text = suggestion;
                              });
                            },
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),
                    Wrap(
                      runSpacing: 20,
                      spacing: 10,
                      children: [
                        SizedBox(
                          width: 300,
                          height: 50,
                          child: TypeAheadFormField<String>(
                            textFieldConfiguration: TextFieldConfiguration(
                              controller: memberTypeController,
                              decoration: const InputDecoration(
                                  fillColor: Colors.white,
                                  filled: true,
                                  labelText: "Member Type"
                              ),
                            ),
                            suggestionsCallback: (pattern) async {
                              return membersuggesstiondata
                                  .where((item) =>
                                  (item['member_type']?.toString().toLowerCase() ?? '')
                                      .startsWith(pattern.toLowerCase()))
                                  .map((item) => item['member_type'].toString())
                                  .toList();
                            },
                            itemBuilder: (context, suggestion) {
                              return ListTile(
                                title: Text(suggestion),
                              );
                            },
                            onSuggestionSelected: (suggestion) async {
                              setState(() {
                                memberTypeController.text = suggestion;
                              });
                              //   print('Selected Item Group: $suggestion');
                            },
                          ),
                        ),
                        //TextFormField  Enter name starts
                        const SizedBox(height: 10,width: 40,),
                        SizedBox(
                          width: 300,
                          height: 50,
                          child: TextFormField(
                            controller: membercategorycontroller,
                            validator: (value){
                              if(value!.isEmpty){
                                return "Required field ";
                              }else {
                                return null;
                              }
                            },
                            decoration: const InputDecoration(
                                label: Text('Member Category')
                            ),
                          ),
                        ),
                        //TextFormField  Enter name end
                      ],
                    ),

                    const SizedBox(width: 10,height: 20,),
                    //ElevatedButton Submit starts
                    ElevatedButton(
                        onPressed: () async{
                          if(_formKey.currentState!.validate()){
                            addMemberCategory();
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                content: Text('Member Category is Successfully Added')));
                          }
                        },
                        child: const Text("ADD")),
                    const SizedBox(height: 20,),
                    Scrollbar(
                      thumbVisibility: true,
                      controller: _scrollController,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        controller: _scrollController,
                        child: SizedBox(
                          width: 1000,
                          child: PaginatedDataTable(
                            columnSpacing: 50,
                            rowsPerPage: 15,
                            columns: const [
                              DataColumn(label: Center(child: Text("S.No", style: TextStyle(fontWeight: FontWeight.bold)))),
                              DataColumn(label: Center(child: Text("District", style: TextStyle(fontWeight: FontWeight.bold)))),
                              DataColumn(label: Center(child: Text("Chapter", style: TextStyle(fontWeight: FontWeight.bold)))),
                              DataColumn(label: Center(child: Text("Member Type", style: TextStyle(fontWeight: FontWeight.bold)))),
                              DataColumn(label: Center(child: Text("Member Category", style: TextStyle(fontWeight: FontWeight.bold)))),
                              DataColumn(label: Center(child: Text("Edit", style: TextStyle(fontWeight: FontWeight.bold)))),
                              DataColumn(label: Center(child: Text("Delete", style: TextStyle(fontWeight: FontWeight.bold)))),
                            ],
                            source: MyDataTableSource4(
                              data: data,
                              delete: delete, // Pass the unblocked function here
                              context: context,
                            ),
                          ),
                        ),
                      ),
                    ),

                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
//Dialogue  button
class MyDataTableSource4 extends DataTableSource {
  List<Map<String, dynamic>> data;
  BuildContext context;
  final Future<void> Function(String id) delete;

  String capitalizeFirstLetter(String text) {
    if (text.isEmpty) return text;
    return text.substring(0, 1).toUpperCase() + text.substring(1);
  }

  MyDataTableSource4({required this.data,
    required this.delete,
    required this.context});

  @override
  int get rowCount => data.length;

  @override
  bool get isRowCountApproximate => false;
  Future<void> editCategory(int id) async {
    try {
      final url = Uri.parse('http://mybudgetbook.in/GIBADMINAPI/add_member_category.php');
      print(url);
      print("Member Type: ${editteam.text}");
      final response = await http.put(
        url,
        body: jsonEncode({
          "member_category": editteam.text,
          "id": id,
        }),
      );
      if (response.statusCode == 200) {
        print("Response Status: ${response.statusCode}");
        print("Response Body: ${response.body}");
        Navigator.push(context, MaterialPageRoute(builder: (context)=>MemberCategory()));
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

  @override
  int get selectedRowCount => 0;
  TextEditingController editteam=TextEditingController();
  @override
  DataRow getRow(int index) {
    return DataRow(
      cells: [
        DataCell(Text('${index + 1}')),
        DataCell(Text('${data[index]["district"]}')),
        DataCell(Text('${data[index]["chapter"]}')),
        DataCell(Text('${data[index]["member_type"]}')),
        DataCell(Text('${data[index]["member_category"]}')),
        DataCell(
            IconButton(
                onPressed: (){
                  showDialog<void>(
                    context: context,
                    builder: (BuildContext dialogContext) {
                      return AlertDialog(
                        backgroundColor: Colors.white,
                        title: const Text('Edit',),
                        content:  SizedBox(width: 300,
                          child: TextFormField(
                            controller: editteam = TextEditingController(
                                text: data[index]["member_category"]
                            ),
                            validator: (value){
                              if(value!.isEmpty){
                                return " * Enter the category";
                              }
                              else{
                                return null;
                              }
                            },
                            decoration: InputDecoration(
                                suffixIcon: IconButton(onPressed: (){
                                  editteam.clear();
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
                                onPressed: () {
                                  editCategory(int.parse(data[index]["id"]));
                                  Navigator.pop(context); // Dismiss alert dialog
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
                icon: Icon(Icons.edit_note,color: Colors.blue,))
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




