import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '../main.dart';

class TeamCreations extends StatelessWidget {
  const TeamCreations({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: TeamCreationspage(),
    );
  }
}

class TeamCreationspage extends StatefulWidget {
  const TeamCreationspage({Key? key}) : super(key: key);

  @override
  State<TeamCreationspage> createState() => _TeamCreationspageState();
}

final _formKey = GlobalKey<FormState>();

class _TeamCreationspageState extends State<TeamCreationspage> {
  TextEditingController teamnamecontroller = TextEditingController();
  TextEditingController editteam = TextEditingController();
  String name = "";
  TextEditingController districtController = TextEditingController();
  TextEditingController chapterController = TextEditingController();

  ///capital letter starts code
  String capitalizeFirstLetter(String text) {
    if (text.isEmpty) return text;
    return text.substring(0, 1).toUpperCase() + text.substring(1);
  }

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
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final List<dynamic> units = responseData;
        setState(() {
          suggesstiondataitemName = units.cast<Map<String, dynamic>>();
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

  @override
  void initState() {
    getDistrict();
    getData();
    super.initState();
  }

  List<Map<String, dynamic>> data = [];
  // List<Map<String, dynamic>> membersuggesstiondata = [];
  Future<void> getData() async {
    print('Attempting to make HTTP request...');
    try {
      final url = Uri.parse(
          'http://mybudgetbook.in/GIBADMINAPI/team_creations.php');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final List<dynamic> itemGroups = responseData;
        setState(() {
          data = itemGroups.cast<Map<String, dynamic>>();
          print("district:$data}");
        });
      } else {
        //print('Error: ${response.statusCode}');
      }
    } catch (error) {
      //  print('Error: $error');
    }
  }

  Future<void> addTeamName() async {
    try {
      final url = Uri.parse(
          'http://mybudgetbook.in/GIBADMINAPI/team_creations.php');
      print(url);

      final response = await http.post(
        url,
        body: jsonEncode({
          "district": districtController.text,
          "chapter": chapterController.text,
          "team_name": teamnamecontroller.text,
        }),
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        if (responseBody["Success"] == true) {
          print("Response Status: ${response.statusCode}");
          print("Response Body: ${response.body}");
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const TeamCreations()));
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Team Name is Successfully Added")));
        } else if (responseBody["Message"] == "Duplicate entry") {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Team Name is already exists")));
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Failed to Add")));
        }
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Failed to Add")));
      }
    } catch (e) {
      print("Error during signup: $e");
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  Future<void> editTeam(int id) async {
    try {
      final url = Uri.parse(
          'http://mybudgetbook.in/GIBADMINAPI/team_creations.php');
      print(url);
      print("Team Name: ${editteam.text}");

      final response = await http.put(
        url,
        body: jsonEncode({
          "team_name": editteam.text,
          "id": id,
        }),
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        if (responseBody["Success"] == true) {
          print("Response Status: ${response.statusCode}");
          print("Response Body: ${response.body}");
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Successfully Edited")));
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const TeamCreations()));
        } else if (responseBody["Message"] == "Duplicate entry") {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Team Name is already exists")));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(responseBody["Message"] ?? "Failed to Edit")));
        }
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Failed to Edit")));
      }
    } catch (e) {
      print("Error during edit: $e");
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  Future<void> delete(String id) async {
    try {
      final url = Uri.parse(
          'http://mybudgetbook.in/GIBADMINAPI/team_creations.php?id=$id');
      final response = await http.delete(url);
      print("Delete Url: $url");
      if (response.statusCode == 200) {
        // Success handling, e.g., show a success message
      } else {
        // Error handling, e.g., show an error message
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      // Handle network or server errors
      print('Error making HTTP request: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      route: '/team_creation',
      body: Center(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 3,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    Text("Add Team Name",
                        style: Theme.of(context).textTheme.headlineMedium),
                    const SizedBox(
                      height: 12,
                    ),
                    Row(
                      //Wrap Changed to Row
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: SizedBox(
                            width: 250,
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
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "* Required District";
                                } else {
                                  return null;
                                }
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
                        ),
                        const SizedBox(
                          height: 10,
                          width: 40,
                        ),
                        Expanded(
                          child: SizedBox(
                            width: 250,
                            height: 50,
                            child: TypeAheadFormField<String>(
                              textFieldConfiguration: TextFieldConfiguration(
                                controller: chapterController,
                                decoration: const InputDecoration(
                                    fillColor: Colors.white,
                                    filled: true,
                                    labelText: "Chapter"),
                              ),
                              suggestionsCallback: (pattern) async {
                                return suggesstiondataitemName
                                    .where((item) => (item['chapter']
                                                ?.toString()
                                                .toLowerCase() ??
                                            '')
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
                        ),
                        const SizedBox(
                          height: 10,
                          width: 40,
                        ),
                        Expanded(
                          child: SizedBox(
                            width: 250,
                            child: TextFormField(
                              controller: teamnamecontroller,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Required field ";
                                } else {
                                  return null;
                                }
                              },
                              onChanged: (value) {
                                String capitalizedValue =
                                    capitalizeFirstLetter(value);
                                teamnamecontroller.value =
                                    teamnamecontroller.value.copyWith(
                                  text: capitalizedValue,
                                  // selection: TextSelection.collapsed(offset: capitalizedValue.length),
                                );
                              },
                              decoration: const InputDecoration(
                                  hintText: "Kurinji",
                                  label: Text('Enter Team Name')),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                      width: 20,
                    ),
                    //ElevatedButton Submit starts
                    ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            addTeamName();
                          }
                        },
                        child: const Text("Submit")),
                    const SizedBox(
                      height: 20,
                    ),
                    SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Table(
                            border: TableBorder.all(),
                            defaultColumnWidth: const FixedColumnWidth(200.0),
                            columnWidths: const <int, TableColumnWidth>{
                              3: FixedColumnWidth(100),
                              4: FixedColumnWidth(100),
                            },
                            defaultVerticalAlignment:
                                TableCellVerticalAlignment.middle,
                            // s.no
                            children: [
                              TableRow(children: [
                                TableCell(
                                  child: Center(
                                    child: Text('District',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineSmall),
                                  ),
                                ),
                                //Name
                                TableCell(
                                    child: Center(
                                  child: Text(
                                    'Chapter',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall,
                                  ),
                                )),
                                // company name
                                TableCell(
                                    child: Center(
                                  child: Text(
                                    'Team Name',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall,
                                  ),
                                )),
                                //Email
                                TableCell(
                                    child: Center(
                                  child: Text(
                                    'Edit',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall,
                                  ),
                                )),

                                TableCell(
                                    child: Center(
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 8,
                                      ),
                                      Text(
                                        'Detele',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineSmall,
                                      ),
                                      SizedBox(
                                        height: 8,
                                      ),
                                    ],
                                  ),
                                )),
                                // Chapter
                              ]),
                              for (var i = 0; i < data.length; i++) ...[
                                TableRow(
                                    decoration:
                                        BoxDecoration(color: Colors.grey[200]),
                                    children: [
                                      // 1 Table row contents
                                      TableCell(
                                          child: Center(
                                        child: Column(
                                          children: [
                                            const SizedBox(
                                              height: 8,
                                            ),
                                            Text(
                                              '${data[i]["district"]}',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall,
                                            ),
                                            const SizedBox(
                                              height: 8,
                                            ),
                                          ],
                                        ),
                                      )),
                                      //2 name
                                      TableCell(
                                          child: Center(
                                        child: Text(
                                          '${data[i]["chapter"]}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall,
                                        ),
                                      )),
                                      // 3 company name
                                      TableCell(
                                          child: Center(
                                        child: Text(
                                          '${data[i]["team_name"]}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall,
                                        ),
                                      )),
                                      // 4 email
                                      TableCell(
                                          child: Center(
                                              child: IconButton(
                                                  onPressed: () {
                                                    showDialog<void>(
                                                      context: context,
                                                      builder: (BuildContext
                                                          dialogContext) {
                                                        return AlertDialog(
                                                          backgroundColor:
                                                              Colors.grey[800],
                                                          title: const Text(
                                                              'Edit',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white)),
                                                          content: SizedBox(
                                                            width: 300,
                                                            child:
                                                                TextFormField(
                                                              controller: editteam =
                                                                  TextEditingController(
                                                                      text: data[
                                                                              i]
                                                                          [
                                                                          "team_name"]),
                                                              onChanged:
                                                                  (value) {
                                                                String
                                                                    capitalizedValue =
                                                                    capitalizeFirstLetter(
                                                                        value);
                                                                editteam.value =
                                                                    editteam
                                                                        .value
                                                                        .copyWith(
                                                                  text:
                                                                      capitalizedValue,
                                                                  // selection: TextSelection.collapsed(offset: capitalizedValue.length),
                                                                );
                                                              },
                                                              validator:
                                                                  (value) {
                                                                if (value!
                                                                    .isEmpty) {
                                                                  return "Enter the field";
                                                                } else {
                                                                  return null;
                                                                }
                                                              },
                                                              decoration:
                                                                  InputDecoration(
                                                                      filled:
                                                                          true, // Fill the background
                                                                      fillColor:
                                                                          Colors
                                                                              .white,
                                                                      suffixIcon: IconButton(
                                                                          onPressed: () {
                                                                            editteam.clear();
                                                                          },
                                                                          icon: Icon(
                                                                            Icons.cancel_presentation,
                                                                            color:
                                                                                Colors.red,
                                                                          ))),
                                                            ),
                                                          ),
                                                          contentTextStyle:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .bodySmall,
                                                          actions: <Widget>[
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .end,
                                                              children: [
                                                                TextButton(
                                                                  child: const Text(
                                                                      'Ok',
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.white)),
                                                                  onPressed:
                                                                      () {
                                                                    editTeam(int
                                                                        .parse(data[i]
                                                                            [
                                                                            "id"]));
                                                                    Navigator.pop(
                                                                        context); // Dismiss alert dialog
                                                                  },
                                                                ),
                                                                TextButton(
                                                                  child: const Text(
                                                                      'Cancel',
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.white)),
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.pop(
                                                                        context);
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
                                                  icon: Icon(
                                                    Icons.edit_note,
                                                    color: Colors.blue,
                                                  )))),

                                      TableCell(
                                          child: Center(
                                              child: IconButton(
                                                  onPressed: () {
                                                    showDialog(
                                                        context: context,
                                                        builder: (ctx) =>
                                                            // Dialog box for register meeting and add guest
                                                            AlertDialog(
                                                              backgroundColor:
                                                                  Colors.grey[
                                                                      800],
                                                              title: const Text(
                                                                  'Delete',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white)),
                                                              content: const Text(
                                                                  "Do you want to Delete the Team Name?",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white)),
                                                              actions: [
                                                                TextButton(
                                                                  onPressed:
                                                                      () async {
                                                                    delete(data[
                                                                            i]
                                                                        ['id']);
                                                                    Navigator.pop(
                                                                        context);
                                                                    ScaffoldMessenger.of(
                                                                            context)
                                                                        .showSnackBar(const SnackBar(
                                                                            content:
                                                                                Text("You have Successfully Deleted a Team Name")));
                                                                  },
                                                                  child: const Text(
                                                                      'Yes',
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.white)),
                                                                ),
                                                                TextButton(
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.pop(
                                                                          context);
                                                                    },
                                                                    child: const Text(
                                                                        'No',
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.white)))
                                                              ],
                                                            ));
                                                  },
                                                  icon: const Icon(
                                                    Icons.delete,
                                                    color: Colors.red,
                                                  )))),
                                      // 5 chapter
                                    ]),
                              ]
                            ]))
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

void _showDialog(BuildContext context) {
  showDialog<void>(
    context: context,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        backgroundColor: Colors.black,
        title: Text(
          'Delete',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        content: Text('Are you sure do you want delete this?',
            style: Theme.of(context).textTheme.bodySmall),
        actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                child: Text(
                  'cancel',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                onPressed: () {
                  Navigator.of(dialogContext).pop(); // Dismiss alert dialog
                },
              ),
              TextButton(
                child: Text(
                  'delete',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                onPressed: () {
                  // Navigator.of(dialogContext).pop(); // Dismiss alert dialog
                },
              ),
            ],
          ),
        ],
      );
    },
  );
}

void _editnote(BuildContext context, String teamname) {
  showDialog<void>(
    context: context,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        backgroundColor: Colors.white,
        title: const Text(
          'Edit',
        ),
        content: SizedBox(
          width: 300,
          child: TextFormField(
            validator: (value) {
              if (value!.isEmpty) {
                return "enter the field";
              } else {
                return null;
              }
            },
            decoration: InputDecoration(
                suffixIcon: IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.cancel_presentation,
                      color: Colors.red,
                    ))),
          ),
        ),
        actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                child: const Text(
                  'Ok',
                ),
                onPressed: () {
                  Navigator.of(dialogContext).pop(); // Dismiss alert dialog
                },
              ),
              TextButton(
                child: const Text(
                  'Cancel',
                ),
                onPressed: () {
                  // Navigator.of(dialogContext).pop(); // Dismiss alert dialog
                },
              ),
            ],
          ),
        ],
      );
    },
  );
}
