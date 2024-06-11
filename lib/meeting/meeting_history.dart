import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:http/http.dart' as http;

import '../main.dart';

class MeetingHistory extends StatelessWidget {
  const MeetingHistory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: MeetingHistoryPage(),
    );
  }
}

class MeetingHistoryPage extends StatefulWidget {
  const MeetingHistoryPage({Key? key}) : super(key: key);

  @override
  State<MeetingHistoryPage> createState() => _MeetingHistoryPageState();
}

class _MeetingHistoryPageState extends State<MeetingHistoryPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController districtController = TextEditingController();
  TextEditingController chapterController = TextEditingController();
  String? selectedMemberType;
  String? selectedMeetingType;
  List<Map<String, dynamic>> meetingHistory = []; // Sample data
  int _rowsPerPage = 7;
  int _currentPage = 1;

  List<Map<String, dynamic>> suggesstiondata = [];
  List district = [];

  List<String> allMeetingTypes = [
    "Network Meeting",
    "Training Program",
    "Team Meeting",
    "Industrial Visit"
  ];
  List<String> meetingTypes = [];

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

  List<String> chapters = [];
  List<Map<String, dynamic>> suggesstiondataitemName = [];

  Future<void> getChapter(String district) async {
    try {
      final url = Uri.parse(
          'http://localhost/GIB/lib/GIBAPI/chapter.php?district=$district');
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

  Future<void> fetchMeetingHistory() async {
    try {
      final district = districtController.text.trim();
      final chapter = chapterController.text.trim();
      final memberType = selectedMemberType ?? '';
      final meetingType = selectedMeetingType ?? '';

      final url = Uri.parse(
          'http://mybudgetbook.in/GIBADMINAPI/meeting_history.php?district=$district&chapter=$chapter&meeting_type=$meetingType&member_type=$memberType');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        setState(() {
          meetingHistory = List<Map<String, dynamic>>.from(
              responseData); // Ensure meetingHistory is a List<Map<String, dynamic>>
        });
        print(
            'Meeting history fetched: $meetingHistory'); // Check if meetingHistory is updated correctly
      } else {
        // Handle error
        print('Failed to fetch meeting history: ${response.statusCode}');
      }
    } catch (error) {
      // Handle error
      print('Error fetching meeting history: $error');
    }
  }

  @override
  void initState() {
    super.initState();
    getDistrict();
    fetchMeetingHistory();
    meetingTypes = allMeetingTypes;
  }

  void updateMeetingTypes(String? memberType) {
    setState(() {
      if (memberType == "Non-Executive") {
        meetingTypes = ["Training program"];
        if (selectedMeetingType != "Training program") {
          selectedMeetingType = null;
        }
      } else {
        meetingTypes = allMeetingTypes;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      route: "/meeting_history_page",
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 3,
                      blurRadius: 7,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text(
                        'Completed Meeting History',
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: 250,
                                height: 50,
                                child: TypeAheadFormField<String>(
                                  textFieldConfiguration:
                                      TextFieldConfiguration(
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
                                        .map((item) =>
                                            item['district'].toString())
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
                              SizedBox(
                                width: 250,
                                height: 50,
                                child: TypeAheadFormField<String>(
                                  textFieldConfiguration:
                                      TextFieldConfiguration(
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
                                        .map((item) =>
                                            item['chapter'].toString())
                                        .toList();
                                  },
                                  itemBuilder: (context, suggestion) {
                                    return ListTile(
                                      title: Text(suggestion),
                                    );
                                  },
                                  onSuggestionSelected: (suggestion) async {
                                    chapterController.text = suggestion;
                                  },
                                ),
                              ),
                              SizedBox(
                                width: 250,
                                height: 50,
                                child: DropdownButtonFormField<String>(
                                  decoration: const InputDecoration(
                                    fillColor: Colors.white,
                                    filled: true,
                                    labelText: "Member Type",
                                  ),
                                  value: selectedMemberType,
                                  onChanged: (newValue) {
                                    setState(() {
                                      selectedMemberType = newValue;
                                      updateMeetingTypes(newValue);
                                    });
                                  },
                                  items: [
                                    "Executive Men's Wgiing",
                                    "Executive Women's Wing",
                                    "Doctor's Wing",
                                    "Non-Executive"
                                  ].map((memberType) {
                                    return DropdownMenuItem(
                                      value: memberType,
                                      child: Text(memberType),
                                    );
                                  }).toList(),
                                ),
                              ),
                              SizedBox(
                                width: 250,
                                height: 50,
                                child: DropdownButtonFormField<String>(
                                  decoration: const InputDecoration(
                                    fillColor: Colors.white,
                                    filled: true,
                                    labelText: "Meeting Type",
                                  ),
                                  value: selectedMeetingType,
                                  onChanged: (newValue) {
                                    setState(() {
                                      selectedMeetingType = newValue;
                                    });
                                  },
                                  items: meetingTypes.map((meetingType) {
                                    return DropdownMenuItem(
                                      value: meetingType,
                                      child: Text(meetingType),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: fetchMeetingHistory,
                        child: Text('Fetch Meeting History'),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 500,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: PaginatedDataTable(
                    rowsPerPage: _rowsPerPage,
                    columnSpacing: 80,
                    onPageChanged: (int page) {
                      setState(() {
                        _currentPage = page + 1;
                      });
                    },
                    source: MeetingDataSource(meetingHistory, context),
                    columns: [
                      DataColumn(
                          label: Text(
                        'Serial Number',
                        style: Theme.of(context).textTheme.headlineSmall,
                      )),
                      DataColumn(
                          label: Text(
                        'District',
                        style: Theme.of(context).textTheme.headlineSmall,
                      )),
                      DataColumn(
                          label: Text(
                        'Chapter',
                        style: Theme.of(context).textTheme.headlineSmall,
                      )),
                      DataColumn(
                          label: Text(
                        'Meeting Name',
                        style: Theme.of(context).textTheme.headlineSmall,
                      )),
                      DataColumn(
                          label: Text(
                        'Place ',
                        style: Theme.of(context).textTheme.headlineSmall,
                      )),
                      DataColumn(
                          label: Text(
                        'Team Name ',
                        style: Theme.of(context).textTheme.headlineSmall,
                      )),
                      DataColumn(
                          label: Text(
                        'Date ',
                        style: Theme.of(context).textTheme.headlineSmall,
                      )),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MeetingDataSource extends DataTableSource {
  final List<Map<String, dynamic>> meetingHistory;

  MeetingDataSource(this.meetingHistory, this.context);
  final BuildContext context;

  @override
  DataRow getRow(int index) {
    final meeting = meetingHistory[index];
    return DataRow(cells: [
      DataCell(
        Text(
          '${index + 1}',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ),
      DataCell(Text(meeting['district'] ?? 'N/A',
          style: Theme.of(context).textTheme.bodySmall)),
      DataCell(Text(meeting['chapter'] ?? 'N/A',
          style: Theme.of(context).textTheme.bodySmall)), // Serial number
      DataCell(Text(meeting['meeting_name'] ?? 'N/A',
          style: Theme.of(context).textTheme.bodySmall)),
      DataCell(Text(meeting['place'] ?? 'N/A',
          style: Theme.of(context).textTheme.bodySmall)),
      DataCell(Text(meeting['team_name'] ?? 'N/A',
          style: Theme.of(context).textTheme.bodySmall)),
      DataCell(Text(meeting['meeting_date'] ?? 'N/A',
          style: Theme.of(context).textTheme.bodySmall)),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => meetingHistory.length;

  @override
  int get selectedRowCount => 0;
}
