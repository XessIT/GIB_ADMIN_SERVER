import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import '../main.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_typeahead/flutter_typeahead.dart';

class CreateMeeting extends StatelessWidget {
  const CreateMeeting({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: CreateMeetingPage(),
    );
  }
}

class Member {
  final int id;
  final String name;

  Member({
    required this.id,
    required this.name,
  });
}

class CreateMeetingPage extends StatefulWidget {
  const CreateMeetingPage({Key? key}) : super(key: key);
  @override
  State<CreateMeetingPage> createState() => _CreateMeetingPageState();
}

enum SelectedItem { offline, online }

class _CreateMeetingPageState extends State<CreateMeetingPage> {
  static final List<Member> _members = [
    Member(id: 1, name: "Golden Member"),
    Member(id: 2, name: "Silver Member "),
    Member(id: 3, name: "Executive "),
    Member(id: 4, name: "NonExecutive"),
    Member(id: 5, name: "Women's Wing"),
    Member(id: 6, name: "All of the above"),
  ];

  final _items = _members
      .map((members) => MultiSelectItem<Member>(members, members.name))
      .toList();

  FilePickerResult? result;
  PlatformFile? file;
  // String? membervalue="";

  PlatformFile? pickedfile;
  String urlDownload = "";

  // bool for enable/ disable
  bool value = false;
  Map<String, bool> values = {
    'Golden Member': false,
    'Silver Member': false,
    'Executive': false,
    "Non Executive": false,
    "Women's Wing": false,
    // "All of the Above":false,
  };

  var tmpArray = [];
  getCheckboxItems() {
    values.forEach((key, value) {
      if (value == true) {
        tmpArray.add(key);
      }
    });
    // Printing all selected items on Terminal screen.
    print(tmpArray);
    // Here you will get all your selected Checkbox items.
    // Clear array after use.
    tmpArray.clear();
  }

  DateTime date = DateTime.now();
  String? selectedDistrict;
  String? selectedChapter;
  String? selectedTeamName;
  String? selectedMeetingType;
  String? selectedMembertype;
  final TextEditingController _meetingdate = TextEditingController();
  TextEditingController placecontroller = TextEditingController();
  TextEditingController meetingnamecontroller = TextEditingController();
  TextEditingController _registrationclosingdate = TextEditingController();
  TextEditingController _registrationopeningdate = TextEditingController();
  TextEditingController registrationclosingtime = TextEditingController();
  TextEditingController fromtime = TextEditingController();
  TextEditingController totime = TextEditingController();
  TextEditingController registrationopeningtime = TextEditingController();
  TextEditingController districtController = TextEditingController();
  TextEditingController chapterController = TextEditingController();
  TextEditingController meetingController = TextEditingController();
  TextEditingController memberController = TextEditingController();
  Set<String> _selectedMemberTypes = Set<String>();
  DateTime? fromTimeParsed;


  String? _selectedMemberType = ""; // Change the type to String?

  @override
  void initState() {
    getDistrict();
    getMeeting();
    getMemberType();
    getMember();
    registrationclosingtime.text = "";
    fromtime.text = "";
    totime.text = "";
    registrationopeningtime.text = "";
    // init();
    super.initState();
  }

  ///First Letter capital code
  String capitalizeFirstLetter(String text) {
    if (text.isEmpty) return text;
    return text.substring(0, 1).toUpperCase() + text.substring(1);
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
      final url = Uri.parse(
          'http://mybudgetbook.in/GIBAPI/chapter.php?district=$district'); // Fix URL
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
          setState(() {});
          chapterController.clear();
        });
      } else {
        print('chapter Error: ${response.statusCode}');
      }
    } catch (error) {
      print(' chapter Error: $error');
    }
  }

  ///meeting type code
  List<Map<String, dynamic>> meetingsuggesstion = [];
  List meeting = [];
  Future<void> getMeeting() async {
    try {
      final url =
      Uri.parse('http://mybudgetbook.in/GIBADMINAPI/add_meeting.php');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final List<dynamic> itemGroups = responseData;
        setState(() {
          meetingsuggesstion = itemGroups.cast<Map<String, dynamic>>();
        });
      } else {
        //print('Error: ${response.statusCode}');
      }
    } catch (error) {
      //  print('Error: $error');
    }
  }

  ///member type code
  List<Map<String, dynamic>> membersuggesstion = [];
  Future<void> getMember() async {
    try {
      final url =
      Uri.parse('http://mybudgetbook.in/GIBADMINAPI/add_member_type.php');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final List<dynamic> itemGroups = responseData;
        setState(() {
          membersuggesstion = itemGroups.cast<Map<String, dynamic>>();
        });
      } else {
        //print('Error: ${response.statusCode}');
      }
    } catch (error) {
      //  print('Error: $error');
    }
  }

  Map<String, bool> selectedValues = {};
  String? selectedItem;
  List<String> itemGroupValues = [];

  /// team name code
  List<String> teamName = [];
  List<Map<String, dynamic>> suggesstiondataTeamName = [];
  List<bool> _isCheckedList = [];
  String selectaTeamName = "";
  List<String> selectedCheckBoxValue = [];
  List<String> teamNames = [];

  Future<void> getTeamNames(String district, String chapter) async {
    try {
      final url = Uri.parse(
          'http://mybudgetbook.in/GIBADMINAPI/team_creations.php?district=$district&chapter=$chapter');
      final response = await http.get(url);
      print('url$url');

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        if (responseData is List<dynamic>) {
          // Assuming the JSON structure is a list of team names
          setState(() {
            teamNames = (responseData as List<dynamic>).map((item) => item['team_name'] as String).toList();
          });

        } else {
          print('Unexpected JSON structure: $responseData');
        }
      } else {
        print('Error fetching team names: ${response.statusCode}');
      }
    }
    catch (error) {
      print('Error occurred during HTTP request: $error');
    }
  }

  Future<void> addMeeting() async {
    try {
      final DateTime parsedMeetingDate =
      DateFormat('dd/MM/yyyy').parse(_meetingdate.text);
      final formattedMeetingDate =
      DateFormat('yyyy/MM/dd').format(parsedMeetingDate);
      final DateTime parsedOpenDate =
      DateFormat('dd/MM/yyyy').parse(_registrationopeningdate.text);
      final formattedOpenDate = DateFormat('yyyy/MM/dd').format(parsedOpenDate);
      final DateTime parsedCloseDate =
      DateFormat('dd/MM/yyyy').parse(_registrationclosingdate.text);
      final formattedCloseDate =
      DateFormat('yyyy/MM/dd').format(parsedCloseDate);
      final String teamNamesString = selectedItems.join(',');

      final url =
      Uri.parse('http://mybudgetbook.in/GIBADMINAPI/create_meeting.php');
      print(url);
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "meeting_date": formattedMeetingDate,
          "from_time": fromtime.text,
          "to_time": totime.text,
          "district": districtController.text,
          "chapter": chapterController.text,
          "meeting_type": meetingController.text,
          "member_type": _selectedMemberTypes.toList(),
          "team_name": teamNamesString, // Corrected line
          "place": placecontroller.text,
          "meeting_name": meetingnamecontroller.text,
          "registration_closing_date": formattedCloseDate,
          "registration_closing_time": registrationclosingtime.text,
          "registration_opening_date": formattedOpenDate,
          "registration_opening_time": registrationopeningtime.text,
        }),
      );
      if (response.statusCode == 200) {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const CreateMeeting()));
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Successfully Added")));
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Failed to Add")));
      }
    } catch (e) {
      print("Error during signup: $e");
    }
  }

  List<String> selectedItems = [];

  List<Map<String, dynamic>> memberSuggestion = [];
  Future<void> getMemberType() async {
    try {
      final url =
      Uri.parse('http://mybudgetbook.in/GIBADMINAPI/member_type.php');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final List<dynamic> itemGroups = responseData;
        setState(() {
          memberSuggestion = itemGroups.cast<Map<String, dynamic>>();
        });
      } else {
        //print('Error: ${response.statusCode}');
      }
    } catch (error) {
      //  print('Error: $error');
    }
  }

  /// gowtham done 16/05/2024
  void _updateTextField() {
    // Concatenate selected member types into a single string
    String concatenatedTypes = _selectedMemberTypes.join(', ');
    // Update text field with concatenated string
    memberController.text = concatenatedTypes;
  }

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      route: '/create_meeting',
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Center(
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
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Card(
                        elevation: 0,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Add Meeting Details",
                              style:
                              Theme.of(context).textTheme.headlineMedium),
                        )),
                    Wrap(children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                width: 300,
                                child: TextFormField(
                                  controller: _meetingdate,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "* Required Meeting Date";
                                    } else {
                                      return null;
                                    }
                                  },
                                  onTap: () async {
                                    DateTime? pickDate = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now().add(Duration(days: 1)),
                                      firstDate: DateTime.now().add(Duration(days: 1)), // Set firstDate to one day after current date
                                      lastDate: DateTime(2100),
                                    );
                                    if (pickDate == null) return;
                                    setState(() {
                                      _meetingdate.text = DateFormat('dd/MM/yyyy').format(pickDate);
                                    });
                                  },
                                  //pickDate From Date
                                  decoration: InputDecoration(
                                    labelText: " Meeting Date  ",
                                    suffixIcon: IconButton(
                                      onPressed: () async {},
                                      icon: const Icon(Icons.calendar_today_outlined),
                                      color: Colors.green,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )        ,
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                width: 300,
                                child: TextFormField(
                                  controller: fromtime,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "* Required Time From";
                                    } else {
                                      return null;
                                    }
                                  },
                                  onTap: () async {
                                    TimeOfDay? fromnewTime =
                                    await showTimePicker(context: context, initialTime: TimeOfDay.now());
                                    if (fromnewTime == null) return;
                                    fromTimeParsed = DateTime(
                                      DateTime.now().year,
                                      DateTime.now().month,
                                      DateTime.now().day,
                                      fromnewTime.hour,
                                      fromnewTime.minute,
                                    );
                                    String fromformattedTime = DateFormat('hh:mm a').format(fromTimeParsed!);
                                    setState(() {
                                      fromtime.text = fromformattedTime;
                                    });
                                  },
                                  readOnly: true,
                                  decoration: InputDecoration(
                                    labelText: "From Time",
                                    suffixIcon: IconButton(
                                      onPressed: () async {},
                                      icon: const Icon(Icons.watch_later_outlined),
                                      color: Colors.green,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                width: 300,
                                child: TextFormField(
                                  controller: totime,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "* Required To Time";
                                    } else {
                                      return null;
                                    }
                                  },
                                  onTap: () async {
                                    TimeOfDay? tonewTime =
                                    await showTimePicker(context: context, initialTime: TimeOfDay.now());
                                    if (tonewTime == null) return;
                                    DateTime toparsedTime = DateTime(
                                      DateTime.now().year,
                                      DateTime.now().month,
                                      DateTime.now().day,
                                      tonewTime.hour,
                                      tonewTime.minute,
                                    );
                                    if (fromTimeParsed != null && toparsedTime.isBefore(fromTimeParsed!)) {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text("Invalid To Time"),
                                            content: Text("The 'To Time' cannot be earlier than the 'From Time'."),
                                            actions: [
                                              TextButton(
                                                child: Text("OK"),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                      return;
                                    }
                                    String toformattedTime = DateFormat('hh:mm a').format(toparsedTime);
                                    setState(() {
                                      totime.text = toformattedTime;
                                    });
                                  },
                                  readOnly: true,
                                  decoration: InputDecoration(
                                    labelText: "To Time",
                                    suffixIcon: IconButton(
                                      onPressed: () async {},
                                      icon: const Icon(Icons.watch_later_outlined),
                                      color: Colors.green,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ]),

                    /// from time & totime  & meeitng date
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: SizedBox(
                                width: 300,
                                child: TypeAheadFormField<String>(
                                  textFieldConfiguration: TextFieldConfiguration(
                                    controller: memberController,
                                    decoration: InputDecoration(
                                      labelText: 'Member Type',
                                      filled: true,
                                      fillColor: Colors.white,
                                    ),
                                  ),
                                  suggestionsCallback: (pattern) {
                                    return memberSuggestion
                                        .map((item) =>
                                        item['member_type'].toString())
                                        .toList();
                                  },
                                  itemBuilder: (context, String suggestion) {
                                    return CheckboxListTile(
                                      title: Text(suggestion),
                                      value:
                                      _selectedMemberTypes.contains(suggestion),
                                      onChanged: (bool? value) {
                                        setState(() {
                                          if (value != null && value) {
                                            _selectedMemberTypes.add(suggestion);
                                            memberController.text =
                                                suggestion; // Update text field
                                          } else {
                                            _selectedMemberTypes.remove(suggestion);
                                          }
                                          _updateTextField(); // Update text field
                                        });
                                      },
                                    );
                                  },
                                  onSuggestionSelected: (String? suggestion) {
                                    setState(() {
                                      if (suggestion != null) {
                                        if (_selectedMemberTypes
                                            .contains(suggestion)) {
                                          _selectedMemberTypes.remove(suggestion);
                                        } else {
                                          _selectedMemberTypes.add(suggestion);
                                          memberController.text =
                                              suggestion; // Update text field
                                        }
                                        _updateTextField(); // Update text field
                                      }
                                    });
                                  },
                                  validator: (value) {
                                    if (_selectedMemberTypes.isEmpty) {
                                      return 'Select at least one member type';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            )),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              width: 300,
                              child: TypeAheadFormField<String>(
                                textFieldConfiguration: TextFieldConfiguration(
                                  controller: meetingController,
                                  decoration: const InputDecoration(
                                      fillColor: Colors.white,
                                      filled: true,
                                      labelText: "Meeting Type"
                                  ),
                                ),
                                suggestionsCallback: (pattern) async {
                                  if (_selectedMemberTypes.isEmpty) {
                                    return [];
                                  }
                                  // Filter meetings based on selected member type
                                  List<String> filteredMeetings = [];
                                  if (_selectedMemberTypes.contains('Non-Executive')) {
                                    // If Non-Executive is selected, show only Training Program
                                    filteredMeetings.add('Training Program');
                                  } else {
                                    // Otherwise, show all meetings
                                    filteredMeetings = meetingsuggesstion
                                        .where((item) => (item['meeting_type']?.toString().toLowerCase() ?? '')
                                        .startsWith(pattern.toLowerCase()))
                                        .map((item) => item['meeting_type'].toString())
                                        .toList();
                                  }
                                  return filteredMeetings;
                                },
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "* Required Meeting Type";
                                  } else {
                                    return null;
                                  }
                                },
                                itemBuilder: (context, suggestion) {
                                  return ListTile(
                                    title: Text(suggestion),
                                  );
                                },
                                onSuggestionSelected: (suggestion) async {
                                  setState(() {
                                    meetingController.text = suggestion;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),

                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              width: 300,
                              child: TextFormField(
                                  controller: meetingnamecontroller,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "* Required Meeting Name";
                                    } else {
                                      return null;
                                    }
                                  },
                                  onChanged: (value) {
                                    String capitalizedValue =
                                    capitalizeFirstLetter(value);
                                    meetingnamecontroller.value =
                                        meetingnamecontroller.value.copyWith(
                                          text: capitalizedValue,
                                          selection: TextSelection.collapsed(
                                              offset: capitalizedValue.length),
                                        );
                                  },
                                  decoration: const InputDecoration(
                                    label: Text('Meeting Name'),
                                  )),
                            ),
                          ),
                        ),

                        /// Metting name skip file path

                        /// Metting Type

                        /// member type
                      ],
                    ),

                    /// meeting name & meeting type & member type
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              width: 300,
                              child: TypeAheadFormField<String>(
                                textFieldConfiguration: TextFieldConfiguration(
                                  controller: districtController,
                                  decoration: const InputDecoration(
                                      fillColor: Colors.white,
                                      filled: true,
                                      labelText: "District"),
                                ),
                                suggestionsCallback: (pattern) async {
                                  return suggesstiondata
                                      .where((item) => (item['district']
                                      ?.toString()
                                      .toLowerCase() ??
                                      '')
                                      .startsWith(pattern.toLowerCase()))
                                      .map(
                                          (item) => item['district'].toString())
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
                                      getChapter(
                                          districtController.text.trim());
                                    });
                                  });
                                  //   print('Selected Item Group: $suggestion');
                                },
                              ),
                            ),
                          ),
                        ),

                        /// District
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              width: 300,
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
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "* Required Chapter";
                                  } else {
                                    return null;
                                  }
                                },
                                onSuggestionSelected: (suggestion) async {
                                  setState(() {
                                    chapterController.text = suggestion;
                                    getTeamNames(districtController.text.trim(), chapterController.text.trim());
                                  });
                                },
                              ),
                            ),
                          ),
                        ),

                        /// chapter
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              width: 300,
                              child: TextFormField(
                                  controller: placecontroller,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "* Required Place";
                                    } else {
                                      return null;
                                    }
                                  },
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(25),
                                  ],
                                  onChanged: (value) {
                                    String capitalizedValue =
                                    capitalizeFirstLetter(value);
                                    placecontroller.value =
                                        placecontroller.value.copyWith(
                                          text: capitalizedValue,
                                          selection: TextSelection.collapsed(
                                              offset: capitalizedValue.length),
                                        );
                                  },
                                  //pickDate From Date
                                  decoration: const InputDecoration(
                                    labelText: "Place",
                                    hintText: "Place",
                                  )),
                            ),
                          ),
                        ),

                        ///place
                      ],
                    ),
                    ValueListenableBuilder<TextEditingValue>(
                      valueListenable: meetingController,
                      builder: (context, value, child) {
                        if (value.text == "Team Meeting") {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SizedBox(
                                    width: 300,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            // Use StatefulBuilder to manage local state within the dialog
                                            return StatefulBuilder(
                                              builder: (context, setState) {
                                                return AlertDialog(

                                                  title: Text("Select a Team Name"),
                                                  content: SingleChildScrollView(
                                                    child: Column(
                                                      children: teamNames.map((String value) {
                                                        return GestureDetector(
                                                          onTap: () {
                                                            setState(() {
                                                              selectedValues[value] =
                                                              !(selectedValues[value] ?? false);

                                                            });
                                                          },
                                                          child: Container(
                                                            color: selectedValues[value] ?? false
                                                                ? Colors.blueGrey
                                                                : Colors.white,
                                                            child: Padding(
                                                              padding: EdgeInsets.symmetric(
                                                                  horizontal: 16.0, vertical: 8.0),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                MainAxisAlignment.spaceBetween,
                                                                children: [
                                                                  Text(
                                                                    value,
                                                                    style: Theme.of(context)
                                                                        .textTheme
                                                                        .headlineMedium!
                                                                        .copyWith(),
                                                                  ),
                                                                  if (selectedValues[value] ?? false)
                                                                    Icon(Icons.check,
                                                                        color: Colors.white),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        );
                                                      }).toList(),
                                                    ),
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () {
                                                        // Update parent state when dialog is closed
                                                        setState(() {
                                                          selectedItems = selectedValues.entries
                                                              .where((entry) => entry.value)
                                                              .map((entry) => entry.key)
                                                              .toList();
                                                        });
                                                        Navigator.of(context).pop();
                                                        // Trigger a rebuild of the parent widget
                                                        this.setState(() {});
                                                      },
                                                      child: Text("Done"),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                        );
                                      },
                                      style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty.all(Colors.blue),
                                      ),
                                      child: Container(
                                        child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Text("Select Team Name",
                                              style: Theme.of(context).textTheme.displayMedium),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Text(
                                        "Selected Team Names",
                                        style: Theme.of(context).textTheme.bodySmall,
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: selectedItems.map((String value) {
                                          return Column(
                                            children: [
                                              Text(
                                                value,
                                                style: TextStyle(color: Colors.green),
                                              ),
                                            ],
                                          );
                                        }).toList(),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SizedBox(
                                    height: 50,
                                  ),
                                ),
                              ),
                            ],
                          );
                        } else {
                          return SizedBox.shrink();
                        }
                      },
                    ),
                    Card(
                        elevation: 0,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Registration Details",
                              style:
                              Theme.of(context).textTheme.headlineMedium),
                        )),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                    child: Padding(
                    padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: 300,
                  child: TextFormField(
                    readOnly: true,
                    controller: _registrationopeningdate,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "* Required Registration Opening Date";
                      } else {
                        return null;
                      }
                    },
                    onTap: () async {
                      DateTime? meetingDate;
                      if (_meetingdate.text.isNotEmpty) {
                        meetingDate = DateFormat('dd/MM/yyyy')
                            .parse(_meetingdate.text);
                      }
                      DateTime? pickDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: meetingDate ?? DateTime(2100),
                      );
                      if (pickDate == null) return;
                      setState(() {
                        _registrationopeningdate.text =
                            DateFormat('dd/MM/yyyy')
                                .format(pickDate);
                      });
                    },
                    decoration: InputDecoration(
                      label:
                      const Text("Registration Opening Date"),
                      suffixIcon: IconButton(
                        onPressed: () async {},
                        icon: const Icon(
                            Icons.calendar_today_outlined),
                        color: Colors.green,
                      ),
                    ),
                  ),
                ),
              ),
            ),

                       /* Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              width: 300,
                              child: TextFormField(
                                readOnly: true,
                                controller: registrationopeningtime,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "* Required Registration Opening Time";
                                  } else {
                                    return null;
                                  }
                                },
                                //pickDate From Date
                                decoration: InputDecoration(
                                  label:
                                  const Text("Registration Opening Time"),
                                  //  icon:Icon( Icons.timer),
                                  suffixIcon: IconButton(
                                    onPressed: () async {
                                      TimeOfDay? schedulenewTime =
                                      await showTimePicker(
                                          context: context,
                                          initialTime: TimeOfDay.now());
                                      //if 'cancel =null'
                                      if (schedulenewTime == null) return;
                                      DateTime scheduleparsedTime = DateTime(
                                        DateTime.now().year,
                                        DateTime.now().month,
                                        DateTime.now().day,
                                        schedulenewTime.hour,
                                        schedulenewTime.minute,
                                      );
                                      String scheduleformattedTime =
                                      DateFormat('hh:mm a')
                                          .format(scheduleparsedTime);
                                      //if 'ok = Timeofday
                                      setState(() {
                                        registrationopeningtime.text =
                                            scheduleformattedTime;
                                      });
                                    },
                                    icon:
                                    const Icon(Icons.watch_later_outlined),
                                    color: Colors.green,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),*/
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              width: 300,
                              child: TextFormField(
                                controller: _registrationclosingdate,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "* Required Registration Closing Date";
                                  } else {
                                    return null;
                                  }
                                },
                                onTap: () async {
                                  DateTime? registrationOpeningDate;
                                  DateTime? meetingDate;
                                  if (_registrationopeningdate.text.isNotEmpty) {
                                    registrationOpeningDate = DateFormat('dd/MM/yyyy')
                                        .parse(_registrationopeningdate.text);
                                  }
                                  if (_meetingdate.text.isNotEmpty) {
                                    meetingDate = DateFormat('dd/MM/yyyy').parse(_meetingdate.text);
                                  }
                                  DateTime? pickDate = await showDatePicker(
                                    context: context,
                                    initialDate: registrationOpeningDate ?? DateTime.now(),
                                    firstDate: registrationOpeningDate ?? DateTime.now(),
                                    lastDate: meetingDate ?? DateTime(2100),
                                  );
                                  if (pickDate == null) return;
                                  setState(() {
                                    _registrationclosingdate.text =
                                        DateFormat('dd/MM/yyyy').format(pickDate);
                                  });
                                },
                                decoration: InputDecoration(
                                  labelText: "Registration Closing Date",
                                  suffixIcon: IconButton(
                                    onPressed: () async {},
                                    icon: const Icon(Icons.calendar_today_outlined),
                                    color: Colors.green,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        /// regesitration closing date
                      ],
                    ),
                  /*  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              width: 300,
                              child: TextFormField(
                                readOnly: true,
                                controller: registrationclosingtime,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "* Required Closing Time";
                                  } else {
                                    return null;
                                  }
                                },
                                //pickDate Closing Time
                                decoration: InputDecoration(
                                  label: const Text("Closing Time"),
                                  //  icon:Icon( Icons.timer),
                                  suffixIcon: IconButton(
                                    onPressed: () async {
                                      TimeOfDay? closingnewTime =
                                      await showTimePicker(
                                          context: context,
                                          initialTime: TimeOfDay.now());
                                      //if 'cancel =null'
                                      if (closingnewTime == null) return;
                                      DateTime closingparsedTime = DateTime(
                                        DateTime.now().year,
                                        DateTime.now().month,
                                        DateTime.now().day,
                                        closingnewTime.hour,
                                        closingnewTime.minute,
                                      );
                                      String closingformattedTime =
                                      DateFormat('hh:mm a')
                                          .format(closingparsedTime);
                                      //if 'ok = Timeofday
                                      setState(() {
                                        registrationclosingtime.text =
                                            closingformattedTime;
                                      });
                                    },
                                    icon:
                                    const Icon(Icons.watch_later_outlined),
                                    color: Colors.green,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                        /// regestiration closing time
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              height: 50,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              height: 50,
                            ),
                          ),
                        ),
                      ],
                    ),*/
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              height: 50,
                            ),
                          ),
                        ),
                        Expanded(
                          child: SizedBox(
                            height: 50,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  elevation: 10,
                                  shadowColor: Colors.grey,
                                ),
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    addMeeting();
                                  }
                                },
                                child: Text(
                                  "Submit",
                                  style:
                                  Theme.of(context).textTheme.displayMedium,
                                )),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              height: 50,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;

    setState(() {
      pickedfile = result.files.first;
    });
    final file = File('');
    int sizeInBytes = file.lengthSync();
    double sizeInmb = sizeInBytes / (1024 * 1024);
    if (sizeInmb < 1) {
      // This file is Longer the
    }
  }
}

class AlphabetInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    // Filter out non-alphabetic characters
    String filteredText = newValue.text.replaceAll(RegExp(r'[^a-zA-Z]'), '');

    return newValue.copyWith(text: filteredText);
  }
}
