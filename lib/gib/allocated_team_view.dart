import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import '../main.dart';
import 'package:http/http.dart' as http;

class AllocatedTeamView extends StatelessWidget {
  const AllocatedTeamView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: AllocatedTeamViewPage(),
    );
  }
}

class AllocatedTeamViewPage extends StatefulWidget {
  const AllocatedTeamViewPage({Key? key}) : super(key: key);

  @override
  State<AllocatedTeamViewPage> createState() => _AllocatedTeamViewPageState();
}

//group dropdown
String groupsgroup = 'Select any one';
var groupsgrouplist = [
  'Select any one',
  'Kurinji 4.0',
  'Mullai 4.0',
  'Neithal 4.0',
  'vaagai 4.0'
];

class _AllocatedTeamViewPageState extends State<AllocatedTeamViewPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController districtController = TextEditingController();
  TextEditingController chapterController = TextEditingController();
  TextEditingController teamnamecontroller = TextEditingController();

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

  /// allocated team view

  List<Map<String, dynamic>> tableData = [];
  Future<void> fetchDataAndUpdateUI(
      String district, String chapter, String teamName) async {
    try {
      final url = Uri.parse(
          'http://mybudgetbook.in/GIBADMINAPI/team_view.php?chapter=$chapter&district=$district&team_name=$teamName');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);
        // Assuming responseData is a list of maps with keys like 'Name', 'Email', 'Mobile', 'MemberType'
        List<Map<String, dynamic>> data =
            responseData.cast<Map<String, dynamic>>();

        // Update your UI with the fetched data
        setState(() {
          tableData = data;
        });
      } else {
        print('Error fetching data: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching data: $error');
    }
  }

  @override
  void initState() {
    super.initState();
    getDistrict();
    fetchDataAndUpdateUI(
      districtController.text.trim(),
      chapterController.text.trim(),
      teamnamecontroller.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      route: '/allocated_team_view',
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(
                height: 30,
              ),
              Container(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 30,
                      ),
                      Text("Allocated Team View",
                          style: Theme.of(context).textTheme.headlineMedium),
                      const SizedBox(
                        height: 30,
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
                                  fetchDataAndUpdateUI(
                                    districtController.text.trim(),
                                    chapterController.text.trim(),
                                    teamnamecontroller.text.trim(),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                              columns: [
                                DataColumn(
                                    label: Text('S.No',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineMedium)),
                                DataColumn(
                                    label: Text('Member ID',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineMedium)),
                                DataColumn(
                                    label: Text('Name',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineMedium)),
                                //DataColumn(label: Text('Email', style: Theme.of(context).textTheme.headlineMedium)),
                                DataColumn(
                                    label: Text('Mobile',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineMedium)),
                                DataColumn(
                                    label: Text('Member',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineMedium)),
                                DataColumn(
                                    label: Text('Team Name',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineMedium)),
                              ],
                              rows: List<DataRow>.generate(tableData.length,
                                  (index) {
                                return DataRow(
                                  cells: [
                                    DataCell(
                                        Text((index + 1).toString())), // S.No
                                    DataCell(Text(
                                        tableData[index]['member_id'] ?? '')),
                                    DataCell(Text(tableData[index]
                                            ['first_name'] ??
                                        '')), // Name
                                    //DataCell(Text(tableData[index]['Email'] ?? '')), // Email
                                    DataCell(Text(tableData[index]['mobile'] ??
                                        '')), // Mobile
                                    DataCell(Text(tableData[index]
                                            ['member_type'] ??
                                        '')), // Member
                                    DataCell(Text(
                                        tableData[index]['team_name'] ?? '')),
                                  ],
                                );
                              }),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
