import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import '../main.dart';

class AllocationDetails extends StatelessWidget {
  const AllocationDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: AllocationDetailsPage(),
    );
  }
}

class AllocationDetailsPage extends StatefulWidget {
  const AllocationDetailsPage({Key? key}) : super(key: key);

  @override
  State<AllocationDetailsPage> createState() => _AllocationDetailsPageState();
}

String membersgroup = 'Select Any One';
var membersgrouplist = [
  'Select Any One',
  'Neithal 4.0',
  'Vaagai 4.0',
  'Marutham 4.0',
  'Kurinji 4.0'
];
String teamnamegroup = 'Select Options';
var teamnamegrouplist = ['Select Options'];
List<String> selected = [];

class _AllocationDetailsPageState extends State<AllocationDetailsPage> {
  String? selectedDistrict;
  String? selectedChapter;
  String? selectedTeamName;
  String? selectedFirstName;

  final _formKey = GlobalKey<FormState>();
  String type = "Kurinji";
  String aambal = "Aambal";
  String neithal = "Neithal";
  String marutham = "Marutham";
  String mullai = "Mullai";
  String vaagai = "Vaagai";
  String name = "";

  bool isChecked = false;
  TextEditingController districtController = TextEditingController();
  TextEditingController chapterController = TextEditingController();
  TextEditingController teamnamecontroller = TextEditingController();
  List<bool> isCheckedList = [false, false, false];

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
      final url = Uri.parse('http://localhost/GIB/lib/GIBAPI/district.php');
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
          'http://localhost/GIB/lib/GIBAPI/chapter.php?district=$district'); // Fix URL
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

  ///team name

  List<String> teams = [];
  List<Map<String, dynamic>> suggesstiondatateam = [];
  Future<void> getTeam(String district, String chapter) async {
    try {
      final url = Uri.parse(
          'http://mybudgetbook.in/GIBADMINAPI/team_name.php?district=$district&chapter=$chapter'); // Fix URL
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final List<dynamic> units = responseData;
        setState(() {
          suggesstiondatateam = units.cast<Map<String, dynamic>>();
        });
        print('Sorted team Names: $suggesstiondatateam');
        setState(() {
          print('teams: $teams');
          setState(() {});
          teamnamecontroller.clear();
        });
      } else {
        print('chapter Error: ${response.statusCode}');
      }
    } catch (error) {
      print(' chapter Error: $error');
    }
  }

  ///fetch members

  List<Map<String, dynamic>> members = [];

  Future<void> getMembers(String district, String chapter) async {
    try {
      final url = Uri.parse(
          'http://mybudgetbook.in/GIBADMINAPI/fetch_members.php?district=$district&chapter=$chapter');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        print(
            'Response body: ${response.body}'); // Print the entire response body for debugging

        List<dynamic>? responseData = json.decode(response.body);
        print(
            'Decoded data: $responseData'); // Print the decoded data for debugging

        if (responseData is List && responseData.isNotEmpty) {
          setState(() {
            print("Members $responseData");
            members = responseData.map((e) {
              Map<String, dynamic> convertedMap = {};
              e.forEach((key, value) {
                convertedMap[key.toString()] = value;
              });

              bool isChecked = convertedMap.containsKey('isChecked')
                  ? convertedMap['isChecked'] == 0
                      ? false
                      : true
                  : false;

              return {...convertedMap, 'isChecked': isChecked};
            }).toList();

            print("Members $members");
          });
        } else {
          print('Empty or invalid response data.');
        }
      } else {
        print('Error fetching members: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  ///team name update

  List<int> selectedMemberIds = []; // List of selected member IDs

  void updateTeamName() async {
    String apiUrl =
        'http://mybudgetbook.in/GIBADMINAPI/fetch_members.php'; // Replace with your actual API URL

    Map<String, dynamic> requestData = {
      'members': members
          .where((element) => element['isChecked'])
          .map((e) => e['id'])
          .toList(), // Convert the MappedIterable to a List
      'team_name': teamnamecontroller.text,
    };

    try {
      var response = await http.put(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestData),
      );

      if (response.statusCode == 200) {
        // Handle successful response
        print('Team name updated successfully.');
        getMembers(districtController.text, chapterController.text);
      } else {
        // Handle error response
        print('Error updating team name: ${response.statusCode}');
      }
    } catch (e) {
      // Handle network or API errors
      print('Error: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    getDistrict();
  }

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      route: '/allocation_details',
      body: SingleChildScrollView(
          child: Center(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Container(
                    padding: const EdgeInsets.all(15),
                    // height: 700,
                    color: Colors.white,
                    child: Column(children: [
                      const SizedBox(
                        height: 30,
                      ),
                      Text("Allocation Details",
                          style: Theme.of(context).textTheme.headlineMedium),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
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
                                    labelText: "District",
                                  ),
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
                                onSuggestionSelected: (suggestion) async {
                                  districtController.text = suggestion;
                                  await getChapter(
                                      districtController.text.trim());
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
                                    labelText: "Chapter",
                                  ),
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
                                  chapterController.text = suggestion;
                                  await getMembers(
                                      districtController.text.trim(),
                                      chapterController.text.trim());
                                  getTeam(districtController.text.trim(),
                                      chapterController.text.trim());
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
                              child: TypeAheadFormField<String>(
                                textFieldConfiguration: TextFieldConfiguration(
                                  controller: teamnamecontroller,
                                  decoration: const InputDecoration(
                                    fillColor: Colors.white,
                                    filled: true,
                                    labelText: "Team",
                                  ),
                                ),
                                suggestionsCallback: (pattern) async {
                                  return suggesstiondatateam
                                      .where((item) => (item['team_name']
                                                  ?.toString()
                                                  .toLowerCase() ??
                                              '')
                                          .startsWith(pattern.toLowerCase()))
                                      .map((item) =>
                                          item['team_name'].toString())
                                      .toList();
                                },
                                itemBuilder: (context, suggestion) {
                                  return ListTile(
                                    title: Text(suggestion),
                                  );
                                },
                                onSuggestionSelected: (suggestion) async {
                                  teamnamecontroller.text = suggestion;
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: SizedBox(
                          width: 300,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              onChanged: (val) {
                                //search bar
                                setState(() {
                                  name = val;
                                });
                              },
                              decoration: const InputDecoration(
                                prefixIcon: Icon(
                                  Icons.search,
                                  color: Colors.green,
                                ),
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(12))),
                                hintText: 'Search ',
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Table(
                              border: TableBorder.all(),
                              defaultColumnWidth: const FixedColumnWidth(180.0),
                              columnWidths: const <int, TableColumnWidth>{
                                1: FixedColumnWidth(180),
                                0: FixedColumnWidth(60),
                              },
                              defaultVerticalAlignment:
                                  TableCellVerticalAlignment.middle,
                              children: [
                                // table row contents
                                TableRow(
                                    decoration:
                                        BoxDecoration(color: Colors.grey[200]),
                                    children: [
                                      TableCell(
                                        child: Center(
                                          child: Column(
                                            children: [
                                              const SizedBox(height: 2),
                                              Text(
                                                'S.No',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall,
                                              ),
                                              const SizedBox(height: 2),
                                            ],
                                          ),
                                        ),
                                      ),
                                      TableCell(
                                        child: Center(
                                          child: Text(
                                            'Name',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall,
                                          ),
                                        ),
                                      ),
                                      TableCell(
                                        child: Center(
                                          child: Text(
                                            'Mobile No',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall,
                                          ),
                                        ),
                                      ),
                                      TableCell(
                                        child: Center(
                                          child: Column(
                                            children: [
                                              const SizedBox(height: 2),
                                              Text(
                                                'Member Type',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      TableCell(
                                        child: Center(
                                          child: Column(
                                            children: [
                                              const SizedBox(height: 2),
                                              Text(
                                                'Status',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ]),
                                for (var i = 0; i < members.length; i++)
                                  TableRow(
                                    decoration:
                                        BoxDecoration(color: Colors.grey[200]),
                                    children: [
                                      TableCell(
                                        child: Center(
                                          child: Column(
                                            children: [
                                              const SizedBox(height: 2),
                                              Row(
                                                children: [
                                                  Checkbox(
                                                    value: members[i]
                                                        ['isChecked'],
                                                    onChanged: (value) {
                                                      setState(() {
                                                        members[i]
                                                                ['isChecked'] =
                                                            value!;
                                                      });
                                                    },
                                                    activeColor:
                                                        Colors.lightBlue,
                                                    checkColor: Colors.white,
                                                  ),
                                                  Text("${i + 1}"),
                                                ],
                                              ),
                                              const SizedBox(height: 2),
                                            ],
                                          ),
                                        ),
                                      ),
                                      TableCell(
                                        child: Center(
                                          child: Column(
                                            children: [
                                              const SizedBox(height: 2),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Align(
                                                  alignment: Alignment.topLeft,
                                                  child: Text(
                                                      members[i]['first_name']),
                                                ),
                                              ),
                                              const SizedBox(height: 8),
                                            ],
                                          ),
                                        ),
                                      ),
                                      TableCell(
                                        child: Center(
                                          child: Align(
                                            alignment: Alignment.topLeft,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(members[i]['mobile']),
                                            ),
                                          ),
                                        ),
                                      ),
                                      TableCell(
                                        child: Center(
                                          child: Align(
                                            alignment: Alignment.topLeft,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                  members[i]['member_type']),
                                            ),
                                          ),
                                        ),
                                      ),
                                      TableCell(
                                        child: Center(
                                          child: IconButton(
                                            onPressed: () {},
                                            icon: const Icon(
                                              Icons.check_circle,
                                              color: Colors.green,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ])),
              ),
              ElevatedButton(
                  onPressed: () {
                    updateTeamName();
                  },
                  child: Text("Update"))
            ],
          ),
        ),
      )),
    );
  }
}
