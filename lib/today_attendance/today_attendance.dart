import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';
import '../attendance_report.dart';
import '../main.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TodayAttendance extends StatefulWidget {
  const TodayAttendance({Key? key}) : super(key: key);

  @override
  State<TodayAttendance> createState() => _TodayAttendanceState();
}

class _TodayAttendanceState extends State<TodayAttendance> {
  TextEditingController searchController = TextEditingController();
  TextEditingController idController = TextEditingController();
  TextEditingController memberTypeController = TextEditingController();
  List<Map<String, dynamic>> searchResults = [];
  String selectedUserID = "";
  String selectedMemberType = "";

  Future<List<Map<String, dynamic>>> fetchNames(String query) async {
    final response = await http.get(
        Uri.parse('http://mybudgetbook.in/GIBAPI/admin_attendance.php?query=$query'));

    if (response.statusCode == 200) {
      List<dynamic> names = json.decode(response.body);
      return names.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to load names');
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: MyScaffold(
        route: "/today_attendance",
        body: Container(
          color: Colors.white,
          child: Center(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: TabBar(
                    isScrollable: true,
                    labelColor: Colors.green,
                    unselectedLabelColor: Colors.black,
                    tabs: [
                      // Tab(text: "Cumulative"),
                      const Tab(text: 'Individual Report'),
                      TextButton(onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const OverallReportAtt()));
                      }, child: const Text('Over all Report')),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 300,
                        child: TypeAheadFormField<Map<String, dynamic>>(
                          textFieldConfiguration: TextFieldConfiguration(
                            controller: searchController,
                            decoration: InputDecoration(
                              hintText: 'Search...',
                              prefixIcon: Icon(Icons.search),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                          ),
                          suggestionsCallback: (pattern) async {
                            if (pattern.isEmpty) {
                              return [];
                            } else {
                              searchResults = await fetchNames(pattern);
                              return searchResults;
                            }
                          },
                          itemBuilder: (context, suggestion) {
                            return ListTile(
                              title: Text(suggestion['full_name']),
                            );
                          },
                          onSuggestionSelected: (suggestion) {
                            setState(() {
                              searchController.text = suggestion['full_name'];
                              idController.text = suggestion['id'].toString();
                              memberTypeController.text = suggestion['member_type'];
                              selectedUserID = idController.text;
                              selectedMemberType = memberTypeController.text;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 1100,
                  child: TabBarView(
                    children: [
                      // NetworkAttendanceOverall(userType: selectedMemberType, userID: selectedUserID),
                      AttendancePage(userType: selectedMemberType, userID: selectedUserID),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
class AttendancePage extends StatefulWidget {
  final String userType;
  final String?  userID;
  const AttendancePage({super.key,
    required this.userType,
    required this. userID,});


  @override
  State<AttendancePage> createState() => _AttendancePageState();
}
class _AttendancePageState extends State<AttendancePage> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("ID:${widget. userID}");
    print("userType:${widget.userType}");
  }
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body:Column(
            children: [
              //TABBAR STARTS
              TabBar(
                isScrollable: true,
                labelColor: Colors.green.shade100,
                unselectedLabelColor: Colors.black,
                tabs: const [
                  Tab(text: ('Network Meeting'),),
                  Tab(text: ('Team Meeting') ,),
                  Tab(text:('Training Program'),
                  ),
                ],
              )  ,
              //TABBAR VIEW STARTS
              Expanded(
                child: TabBarView(children: [
                  NetworkAttendance(userType: widget.userType, userID: widget.userID,),
                  TeamMeetingPage(userType: widget.userType, userID: widget.userID,),
                  TrainingProgram(userType: widget.userType, userID: widget.userID,),
                ]),
              )
            ]),
      ),
    );
  }
}


class NetworkAttendanceOverall extends StatefulWidget {
  final String userType;
  final String? userID;

  NetworkAttendanceOverall({required this.userType, this.userID});

  @override
  _NetworkAttendanceOverallState createState() => _NetworkAttendanceOverallState();
}
class _NetworkAttendanceOverallState extends State<NetworkAttendanceOverall> {
  int selectedYear = DateTime.now().year;
  int totalMeetCount = 0;
  int presentCount = 0;
  int absentCount = 0;
  int leaveCount = 0;
  bool isPresentCardTapped = false;
  bool isAbsentCardTapped = false;
  bool isLeaveCardTapped = false;
  List<dynamic> presentMeetings = [];
  List<dynamic> absentMeetings = [];
  List<dynamic> leaveMeetings = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        isLoading = false; // Hide the loading indicator after 1 second
      });
    });
    fetchMeetCount(selectedYear, widget.userType);
    fetchPresentAndAbsentCount(selectedYear, widget.userType);
    fetchMeetingDetails(selectedYear, widget.userType);
  }

  Future<void> fetchMeetingDetails(int year, String userType) async {
    try {
      final response = await http.get(Uri.parse(
          'http://mybudgetbook.in/GIBAPI/overall_attendance.php?year=$year&member_type=$userType'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          presentMeetings = data['presentMeetings'];
          absentMeetings = data['absentMeetings'];
          leaveMeetings = data['leaveMeetings'];
        });
      } else {
        throw Exception('Failed to load meeting details');
      }
    } catch (e) {
      print('Error fetching meeting details: $e');
    }
  }

  Future<void> fetchMeetCount(int year, String userType) async {
    try {
      final response = await http.get(Uri.parse(
          'http://mybudgetbook.in/GIBAPI/insert_attendance.php?year=$year&member_type=$userType'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data is Map<String, dynamic> && data.containsKey('count')) {
          setState(() {
            totalMeetCount = int.parse(data['count'].toString());
          });
        } else {
          throw Exception('Unexpected response format');
        }
      } else {
        throw Exception('Failed to load meeting count');
      }
    } catch (e) {
      print('Error fetching meeting count: $e');
      setState(() {
        totalMeetCount = 0;
      });
    }
  }

  Future<void> fetchPresentAndAbsentCount(int year, String userType) async {
    try {
      final response = await http.get(Uri.parse(
          'http://mybudgetbook.in/GIBAPI/overall_attendance.php?year=$year&member_type=$userType'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data is Map<String, dynamic> && data.containsKey('presentCount') && data.containsKey('absentCount') && data.containsKey('leaveCount')) {
          setState(() {
            presentCount = int.parse(data['presentCount'].toString());
            absentCount = int.parse(data['absentCount'].toString());
            leaveCount = int.parse(data['leaveCount'].toString());
          });
        } else {
          throw Exception('Unexpected response format');
        }
      } else {
        throw Exception('Failed to load present, absent, and leave count');
      }
    } catch (e) {
      print('Error fetching present, absent, and leave count: $e');
      setState(() {
        presentCount = 0;
        absentCount = 0;
        leaveCount = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                DropdownButton<int>(
                  value: selectedYear,
                  onChanged: (int? newValue) {
                    if (newValue != null) {
                      setState(() {
                        selectedYear = newValue;
                      });
                      fetchMeetCount(newValue, widget.userType);
                      fetchPresentAndAbsentCount(newValue, widget.userType);
                      fetchMeetingDetails(newValue, widget.userType);
                    }
                  },
                  items: List.generate(11, (index) {
                    int year = DateTime.now().year - index;
                    return DropdownMenuItem<int>(
                      value: year,
                      child: Text(year.toString()),
                    );
                  }),
                ),
              ]
          ),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // FIRST CARD STARTS
                  SizedBox(
                    width: 130,
                    height: 120,
                    child: Padding(
                      padding: EdgeInsets.only(left: 5,right: 5,top: 5,bottom: 10),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            // Reset tap state of other cards
                            isAbsentCardTapped = false;
                            isLeaveCardTapped = false;
                            // Toggle the tap state of this card
                            isPresentCardTapped = !isPresentCardTapped;
                          });
                        },
                        child: Card(
                          // Change the color based on the state variable
                          color: isPresentCardTapped ? Colors.green.shade100 : Colors.white,
                          child: ListTile(
                            title: Padding(
                              padding: const EdgeInsets.fromLTRB(14, 15, 0, 0),
                              child: Text('$presentCount/$totalMeetCount', style: const TextStyle(fontSize: 25)),
                            ),
                            subtitle: const Padding(
                              padding: EdgeInsets.fromLTRB(13, 0, 0, 0),
                              child: Text('Present'),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // SECOND CARD STARTS
                  SizedBox(
                    width: 130,
                    height: 120,
                    child: Padding(
                      padding: EdgeInsets.only(left: 5,right: 5,top: 5,bottom: 10),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            isPresentCardTapped = false;
                            isLeaveCardTapped = false;
                            // Toggle the tap state of this card
                            isAbsentCardTapped = !isAbsentCardTapped;
                          });
                        },
                        child: Card(
                          // Change the color based on the state variable
                          color: isAbsentCardTapped ? Colors.green.shade100 : Colors.white,
                          child: ListTile(
                            title: Padding(
                              padding: const EdgeInsets.fromLTRB(14, 15, 0, 0),
                              child: Text('$absentCount/$totalMeetCount', style: const TextStyle(fontSize: 25)),
                            ),
                            subtitle: const Padding(
                              padding: EdgeInsets.fromLTRB(13, 0, 0, 0),
                              child: Text('Absent'),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // THIRD CARD STARTS
                  SizedBox(
                    width: 130,
                    height: 120,
                    child: Padding(
                      padding: EdgeInsets.only(left: 5,right: 5,top: 5,bottom: 10),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            isPresentCardTapped = false;
                            isAbsentCardTapped = false;
                            isLeaveCardTapped = !isLeaveCardTapped;
                          });
                        },
                        child: Card(
                          // Change the color based on the state variable
                          color: isLeaveCardTapped ? Colors.green.shade100 : Colors.white,
                          child: ListTile(
                            title: Padding(
                              padding: const EdgeInsets.fromLTRB(14, 15, 0, 0),
                              child: Text('$leaveCount/$totalMeetCount', style: const TextStyle(fontSize: 25)),
                            ),
                            subtitle: const Padding(
                              padding: EdgeInsets.fromLTRB(13, 0, 0, 0),
                              child: Text('Leave'),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SingleChildScrollView(
                child: Card(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: isPresentCardTapped
                        ? presentMeetings.length
                        : isAbsentCardTapped
                        ? absentMeetings.length
                        : leaveMeetings.length,
                    itemBuilder: (context, index) {
                      final meeting = isPresentCardTapped
                          ? presentMeetings[index]
                          : isAbsentCardTapped
                          ? absentMeetings[index]
                          : leaveMeetings[index];
                      return ListTile(
                        title: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('${index + 1}'),
                                Row(
                                  children: [
                                    Text(meeting['meeting_name']),
                                    SizedBox(width: 5),
                                    Text(meeting['meeting_date']),
                                  ],
                                ),
                                Text(meeting['from_time']),
                                Text(meeting['to_time']),
                                Text(meeting['district']),
                                Text(meeting['chapter']),
                              ],
                            ),
                            Divider(thickness: 1),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class NetworkAttendance extends StatefulWidget {
  final String userType;
  final String? userID;
  const NetworkAttendance({super.key, required this.userType, required this.userID});

  @override
  _NetworkAttendanceState createState() => _NetworkAttendanceState();
}
class _NetworkAttendanceState extends State<NetworkAttendance> {
  int selectedYear = DateTime.now().year;
  int totalMeetCount = 0;
  int presentCount = 0;
  int absentCount = 0;
  int leaveCount = 0;
  bool isPresentCardTapped = false;
  bool isAbsentCardTapped = false;
  bool isLeaveCardTapped = false;
  List<dynamic> presentMeetings = [];
  List<dynamic> absentMeetings = [];
  List<dynamic> leaveMeetings = [];



  Future<void> _getInternet() async {
    // Replace the URL with your PHP backend URL
    var url = 'http://mybudgetbook.in/GIBAPI/internet.php';

    try {
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        // Handle successful response
        var data = json.decode(response.body);
        print(data);
        // Show online status message
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(
        //     content: Text('Now online.'),
        //   ),
        // );
      } else {
        // Handle other status codes
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      // Handle network errors
      print('Error: $e');
      // Show offline status message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please check your internet connection.'),
        ),
      );
    }
  }
  bool isLoading = true;
  ///refresh
  List<String> items = List.generate(20, (index) => 'Item $index');
  Future<void> _refresh() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      initState();
    });
  }
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        isLoading = false; // Hide the loading indicator after 4 seconds
      });
    });
    fetchMeetCount(selectedYear,widget.userType);
    if (widget.userID != null) {
      fetchPresentAndAbsentCount(selectedYear, widget.userID!,  widget.userType);
    }
    if (widget.userID != null) {
      fetchMeetingDetails(selectedYear, widget.userID!,  widget.userType);
    }
    print("id-------------${widget.userID}");
    print("member-------------${widget.userType}");

  }
  Future<void> fetchMeetingDetails(int year, String userId, String userType) async {
    try {
      final response = await http.get(Uri.parse('http://mybudgetbook.in/GIBAPI/att_present_fetch.php?year=$year&user_id=$userId&member_type=$userType'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          presentMeetings = data['presentMeetings'];
          absentMeetings = data['absentMeetings'];
          leaveMeetings = data['leaveMeetings'];
        });
      } else {
        throw Exception('Failed to load meeting details');
      }
    } catch (e) {
      print('Error fetching meeting details: $e');
    }
  }
  Future<void> fetchMeetCount(int year,String userType) async {
    try {
      final response = await http.get(Uri.parse('http://mybudgetbook.in/GIBAPI/insert_attendance.php?year=$year&member_type=$userType'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data is Map<String, dynamic> && data.containsKey('count')) {
          setState(() {
            totalMeetCount = int.parse(data['count'].toString());
            print(totalMeetCount);
          });
        } else {
          throw Exception('Unexpected response format');
        }
      } else {
        throw Exception('Failed to load meeting count');
      }
    } catch (e) {
      print('Error fetching meeting count: $e');
      setState(() {
        totalMeetCount = 0;
      });
    }
  }
  Future<void> fetchPresentAndAbsentCount(int year, String userId, String userType) async {
    try {
      final response = await http.get(Uri.parse('http://mybudgetbook.in/GIBAPI/att_present_fetch.php?year=$year&user_id=$userId&member_type=$userType'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data is Map<String, dynamic> && data.containsKey('presentCount') && data.containsKey('absentCount') && data.containsKey('leaveCount')) {
          setState(() {
            presentCount = int.parse(data['presentCount'].toString());
            absentCount = int.parse(data['absentCount'].toString());
            leaveCount = int.parse(data['leaveCount'].toString());
            print('Present: $presentCount, Absent: $absentCount, Leave: $leaveCount');

          });
        } else {
          throw Exception('Unexpected response format');
        }
      } else {
        throw Exception('Failed to load present, absent, and leave count');
      }
    } catch (e) {
      print('Error fetching present, absent, and leave count: $e');
      setState(() {
        presentCount = 0;
        absentCount = 0;
        leaveCount = 0;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                DropdownButton<int>(
                  value: selectedYear,
                  onChanged: (int? newValue) {
                    if (newValue != null) {
                      setState(() {
                        selectedYear = newValue;
                      });
                      fetchMeetCount(newValue,widget.userType);
                      if (widget.userID != null) {
                        fetchPresentAndAbsentCount(newValue, widget.userID!, widget.userType);
                      }
                      if (widget.userID != null) {
                        fetchMeetingDetails(newValue, widget.userID!, widget.userType);
                      }
                    }
                  },
                  items: List.generate(11, (index) {
                    int year = DateTime.now().year - index;
                    return DropdownMenuItem<int>(
                      value: year,
                      child: Text(year.toString()),
                    );
                  }),
                ),
              ]
          ),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // FIRST CARD STARTS
                  SizedBox(
                    width: 130,
                    height: 120,
                    child: Padding(
                      padding: EdgeInsets.only(left: 5,right: 5,top: 5,bottom: 10),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
// Reset tap state of other cards
                            isAbsentCardTapped = false;
                            isLeaveCardTapped = false;
                            // Toggle the tap state of this card
                            isPresentCardTapped = !isPresentCardTapped;
                          });
                        },
                        child: Card(
                          // Change the color based on the state variable
                          color: isPresentCardTapped ? Colors.green.shade100 : Colors.white,
                          child: ListTile(
                            title: Padding(
                              padding: const EdgeInsets.fromLTRB(14, 15, 0, 0),
                              child: Text('$presentCount/$totalMeetCount', style: const TextStyle(fontSize: 25)),
                            ),
                            subtitle: const Padding(
                              padding: EdgeInsets.fromLTRB(13, 0, 0, 0),
                              child: Text('Present'),
                            ),
                          ),
                        ),
                      ),
                    ),

                  ),
                  SizedBox(width: 130,height: 120,
                    child:Padding(
                      padding: EdgeInsets.only(left: 5,right: 5,top: 5,bottom: 10),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            isPresentCardTapped = false;
                            isLeaveCardTapped = false;
                            // Toggle the tap state of this card
                            isAbsentCardTapped = !isAbsentCardTapped;
                          });
                        },
                        child: Card(
                          // Change the color based on the state variable
                          color: isAbsentCardTapped ? Colors.green.shade100 : Colors.white,
                          child: ListTile(
                            title: Padding(
                              padding: const EdgeInsets.fromLTRB(14, 15, 0, 0),
                              child: Text('$absentCount/$totalMeetCount', style: const TextStyle(fontSize: 25)),
                            ),
                            subtitle: const Padding(
                              padding: EdgeInsets.fromLTRB(13, 0, 0, 0),
                              child: Text('Absent'),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  //THIRD CARD STARTS
                  SizedBox(width: 130,height: 120,
                    child: Padding(
                      padding: EdgeInsets.only(left: 5,right: 5,top: 5,bottom: 10),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            isPresentCardTapped = false;
                            isAbsentCardTapped = false;
                            isLeaveCardTapped = !isLeaveCardTapped;
                          });
                        },
                        child: Card(
                          // Change the color based on the state variable
                          color: isLeaveCardTapped ? Colors.green.shade100 : Colors.white,
                          child: ListTile(
                            title: Padding(
                              padding: const EdgeInsets.fromLTRB(14, 15, 0, 0),
                              child: Text('$leaveCount/$totalMeetCount', style: const TextStyle(fontSize: 25)),
                            ),
                            subtitle: const Padding(
                              padding: EdgeInsets.fromLTRB(13, 0, 0, 0),
                              child: Text('Leave'),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SingleChildScrollView(
                child: Card(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: isPresentCardTapped
                        ? presentMeetings.length
                        : isAbsentCardTapped
                        ? absentMeetings.length
                        : leaveMeetings.length,
                    itemBuilder: (context, index) {
                      final meeting = isPresentCardTapped
                          ? presentMeetings[index]
                          : isAbsentCardTapped
                          ? absentMeetings[index]
                          : leaveMeetings[index];
                      return ListTile(
                        title: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('${index + 1}'),
                                Row(
                                  children: [
                                    const Icon(Icons.calendar_month_rounded),
                                    Text('${meeting['meeting_type']}'),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('${meeting['meeting_date']}'),
                                Text('${meeting['meeting_name']} Meeting'),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('${meeting['district']}'),
                                Text('${meeting['chapter']}'),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('${meeting['from_time']}'),
                                const Text('-'),
                                Text('${meeting['to_time']}'),
                              ],
                            ),

                          ],
                        ),
                      );
                    },
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

class TeamMeetingPage extends StatefulWidget {
  final String userType;
  final String? userID;
  TeamMeetingPage({super.key, required this.userType, required this.userID});

  @override
  _TeamMeetingPageState createState() => _TeamMeetingPageState();
}

class _TeamMeetingPageState extends State<TeamMeetingPage> {
  int selectedYear = DateTime.now().year;
  int totalMeetCount = 0;
  int presentCount = 0;
  int absentCount = 0;
  int leaveCount = 0;
  bool isPresentCardTapped = false;
  bool isAbsentCardTapped = false;
  bool isLeaveCardTapped = false;
  List<dynamic> presentMeetings = [];
  List<dynamic> absentMeetings = [];
  List<dynamic> leaveMeetings = [];

  @override
  void initState() {
    super.initState();
    fetchMeetCount(selectedYear,widget.userType);
    if (widget.userID != null) {
      fetchPresentAndAbsentCount(selectedYear, widget.userID!,  widget.userType);
    }
    if (widget.userID != null) {
      fetchMeetingDetails(selectedYear, widget.userID!,  widget.userType);
    }
  }
  Future<void> fetchMeetingDetails(int year, String userId, String userType) async {
    try {
      final response = await http.get(Uri.parse('http://mybudgetbook.in/GIBAPI/team_meeting_att.php?year=$year&user_id=$userId&member_type=$userType'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          presentMeetings = data['presentMeetings'];
          absentMeetings = data['absentMeetings'];
          leaveMeetings = data['leaveMeetings'];
        });
      } else {
        throw Exception('Failed to load meeting details');
      }
    } catch (e) {
      print('Error fetching meeting details: $e');
    }
  }
  Future<void> fetchMeetCount(int year,String userType) async {
    try {
      final response = await http.get(Uri.parse('http://mybudgetbook.in/GIBAPI/team_meeting_fetch.php?year=$year&member_type=$userType'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data is Map<String, dynamic> && data.containsKey('count')) {
          setState(() {
            totalMeetCount = int.parse(data['count'].toString());
            print(totalMeetCount);
          });
        } else {
          throw Exception('Unexpected response format');
        }
      } else {
        throw Exception('Failed to load meeting count');
      }
    } catch (e) {
      print('Error fetching meeting count: $e');
      setState(() {
        totalMeetCount = 0;
      });
    }
  }
  Future<void> fetchPresentAndAbsentCount(int year, String userId, String userType) async {
    try {
      final response = await http.get(Uri.parse('http://mybudgetbook.in/GIBAPI/team_meeting_att.php?year=$year&user_id=$userId&member_type=$userType'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data is Map<String, dynamic> && data.containsKey('presentCount') && data.containsKey('absentCount') && data.containsKey('leaveCount')) {
          setState(() {
            presentCount = int.parse(data['presentCount'].toString());
            absentCount = int.parse(data['absentCount'].toString());
            leaveCount = int.parse(data['leaveCount'].toString());
            print('Present: $presentCount, Absent: $absentCount, Leave: $leaveCount');

          });
        } else {
          throw Exception('Unexpected response format');
        }
      } else {
        throw Exception('Failed to load present, absent, and leave count');
      }
    } catch (e) {
      print('Error fetching present, absent, and leave count: $e');
      setState(() {
        presentCount = 0;
        absentCount = 0;
        leaveCount = 0;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                DropdownButton<int>(
                  value: selectedYear,
                  onChanged: (int? newValue) {
                    if (newValue != null) {
                      setState(() {
                        selectedYear = newValue;
                      });
                      fetchMeetCount(newValue,widget.userType);
                      if (widget.userID != null) {
                        fetchPresentAndAbsentCount(newValue, widget.userID!, widget.userType);
                      }
                      if (widget.userID != null) {
                        fetchMeetingDetails(newValue, widget.userID!, widget.userType);
                      }
                    }
                  },
                  items: List.generate(11, (index) {
                    int year = DateTime.now().year - index;
                    return DropdownMenuItem<int>(
                      value: year,
                      child: Text(year.toString()),
                    );
                  }),
                ),
              ]
          ),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // FIRST CARD STARTS
                  SizedBox(
                    width: 130,
                    height: 120,
                    child: Padding(
                      padding: EdgeInsets.only(left: 5,right: 5,top: 5,bottom: 10),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
// Reset tap state of other cards
                            isAbsentCardTapped = false;
                            isLeaveCardTapped = false;
                            // Toggle the tap state of this card
                            isPresentCardTapped = !isPresentCardTapped;
                          });
                        },
                        child: Card(
                          // Change the color based on the state variable
                          color: isPresentCardTapped ? Colors.green.shade100 : Colors.white,
                          child: ListTile(
                            title: Padding(
                              padding: const EdgeInsets.fromLTRB(14, 15, 0, 0),
                              child: Text('$presentCount/$totalMeetCount', style: const TextStyle(fontSize: 25)),
                            ),
                            subtitle: const Padding(
                              padding: EdgeInsets.fromLTRB(13, 0, 0, 0),
                              child: Text('Present'),
                            ),
                          ),
                        ),
                      ),
                    ),

                  ),
                  SizedBox(width: 130,height: 120,
                    child:Padding(
                      padding: EdgeInsets.only(left: 5,right: 5,top: 5,bottom: 10),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            isPresentCardTapped = false;
                            isLeaveCardTapped = false;
                            // Toggle the tap state of this card
                            isAbsentCardTapped = !isAbsentCardTapped;
                          });
                        },
                        child: Card(
                          // Change the color based on the state variable
                          color: isAbsentCardTapped ? Colors.green.shade100 : Colors.white,
                          child: ListTile(
                            title: Padding(
                              padding: const EdgeInsets.fromLTRB(14, 15, 0, 0),
                              child: Text('$absentCount/$totalMeetCount', style: const TextStyle(fontSize: 25)),
                            ),
                            subtitle: const Padding(
                              padding: EdgeInsets.fromLTRB(13, 0, 0, 0),
                              child: Text('Absent'),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  //THIRD CARD STARTS
                  SizedBox(width: 130,height: 120,
                    child: Padding(
                      padding: EdgeInsets.only(left: 5,right: 5,top: 5,bottom: 10),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            isPresentCardTapped = false;
                            isAbsentCardTapped = false;
                            isLeaveCardTapped = !isLeaveCardTapped;
                          });
                        },
                        child: Card(
                          // Change the color based on the state variable
                          color: isLeaveCardTapped ? Colors.green.shade100 : Colors.white,
                          child: ListTile(
                            title: Padding(
                              padding: const EdgeInsets.fromLTRB(14, 15, 0, 0),
                              child: Text('$leaveCount/$totalMeetCount', style: const TextStyle(fontSize: 25)),
                            ),
                            subtitle: const Padding(
                              padding: EdgeInsets.fromLTRB(13, 0, 0, 0),
                              child: Text('Leave'),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SingleChildScrollView(
                child: Card(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: isPresentCardTapped
                        ? presentMeetings.length
                        : isAbsentCardTapped
                        ? absentMeetings.length
                        : leaveMeetings.length,
                    itemBuilder: (context, index) {
                      final meeting = isPresentCardTapped
                          ? presentMeetings[index]
                          : isAbsentCardTapped
                          ? absentMeetings[index]
                          : leaveMeetings[index];
                      return ListTile(
                        title:  Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('${index + 1}'),
                            Row(
                              children: [
                                const Icon(Icons.calendar_month_rounded),
                                Text('${meeting['meeting_type']}'),
                              ],
                            ),
                          ],
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('${meeting['meeting_date']}'),
                                Text('${meeting['meeting_name']} Meeting'),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('${meeting['district']}'),
                                Text('${meeting['chapter']}'),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('${meeting['from_time']}'),
                                const Text('-'),
                                Text('${meeting['to_time']}'),
                              ],
                            ),

                          ],
                        ),
                      );
                    },
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}


class TrainingProgram extends StatefulWidget {
  final String userType;
  final String? userID;
  TrainingProgram({super.key, required this.userType, required this.userID});

  @override
  _TrainingProgramState createState() => _TrainingProgramState();
}

class _TrainingProgramState extends State<TrainingProgram> {
  int selectedYear = DateTime.now().year;
  int totalMeetCount = 0;
  int presentCount = 0;
  int absentCount = 0;
  int leaveCount = 0;
  bool isPresentCardTapped = false;
  bool isAbsentCardTapped = false;
  bool isLeaveCardTapped = false;
  List<dynamic> presentMeetings = [];
  List<dynamic> absentMeetings = [];
  List<dynamic> leaveMeetings = [];

  @override
  void initState() {
    super.initState();
    fetchMeetCount(selectedYear,widget.userType);
    if (widget.userID != null) {
      fetchPresentAndAbsentCount(selectedYear, widget.userID!,  widget.userType);
    }
    if (widget.userID != null) {
      fetchMeetingDetails(selectedYear, widget.userID!,  widget.userType);
    }
  }
  Future<void> fetchMeetingDetails(int year, String userId, String userType) async {
    try {
      final response = await http.get(Uri.parse('http://mybudgetbook.in/GIBAPI/training_meeting_att.php?year=$year&user_id=$userId&member_type=$userType'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          presentMeetings = data['presentMeetings'];
          absentMeetings = data['absentMeetings'];
          leaveMeetings = data['leaveMeetings'];
        });
      } else {
        throw Exception('Failed to load meeting details');
      }
    } catch (e) {
      print('Error fetching meeting details: $e');
    }
  }
  Future<void> fetchMeetCount(int year,String userType) async {
    try {
      final response = await http.get(Uri.parse('http://mybudgetbook.in/GIBAPI/training_meeting_fetch.php?year=$year&member_type=$userType'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data is Map<String, dynamic> && data.containsKey('count')) {
          setState(() {
            totalMeetCount = int.parse(data['count'].toString());
            print(totalMeetCount);
          });
        } else {
          throw Exception('Unexpected response format');
        }
      } else {
        throw Exception('Failed to load meeting count');
      }
    } catch (e) {
      print('Error fetching meeting count: $e');
      setState(() {
        totalMeetCount = 0;
      });
    }
  }
  Future<void> fetchPresentAndAbsentCount(int year, String userId, String userType) async {
    try {
      final response = await http.get(Uri.parse('http://mybudgetbook.in/GIBAPI/training_meeting_att.php?year=$year&user_id=$userId&member_type=$userType'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data is Map<String, dynamic> && data.containsKey('presentCount') && data.containsKey('absentCount') && data.containsKey('leaveCount')) {
          setState(() {
            presentCount = int.parse(data['presentCount'].toString());
            absentCount = int.parse(data['absentCount'].toString());
            leaveCount = int.parse(data['leaveCount'].toString());
            print('Present: $presentCount, Absent: $absentCount, Leave: $leaveCount');

          });
        } else {
          throw Exception('Unexpected response format');
        }
      } else {
        throw Exception('Failed to load present, absent, and leave count');
      }
    } catch (e) {
      print('Error fetching present, absent, and leave count: $e');
      setState(() {
        presentCount = 0;
        absentCount = 0;
        leaveCount = 0;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                DropdownButton<int>(
                  value: selectedYear,
                  onChanged: (int? newValue) {
                    if (newValue != null) {
                      setState(() {
                        selectedYear = newValue;
                      });
                      fetchMeetCount(newValue,widget.userType);
                      if (widget.userID != null) {
                        fetchPresentAndAbsentCount(newValue, widget.userID!, widget.userType);
                      }
                      if (widget.userID != null) {
                        fetchMeetingDetails(newValue, widget.userID!, widget.userType);
                      }
                    }
                  },
                  items: List.generate(11, (index) {
                    int year = DateTime.now().year - index;
                    return DropdownMenuItem<int>(
                      value: year,
                      child: Text(year.toString()),
                    );
                  }),
                ),
              ]
          ),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // FIRST CARD STARTS
                  SizedBox(
                    width: 130,
                    height: 120,
                    child: Padding(
                      padding: EdgeInsets.only(left: 5,right: 5,top: 5,bottom: 10),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
// Reset tap state of other cards
                            isAbsentCardTapped = false;
                            isLeaveCardTapped = false;
                            // Toggle the tap state of this card
                            isPresentCardTapped = !isPresentCardTapped;
                          });
                        },
                        child: Card(
                          // Change the color based on the state variable
                          color: isPresentCardTapped ? Colors.green.shade100 : Colors.white,
                          child: ListTile(
                            title: Padding(
                              padding: const EdgeInsets.fromLTRB(14, 15, 0, 0),
                              child: Text('$presentCount/$totalMeetCount', style: const TextStyle(fontSize: 25)),
                            ),
                            subtitle: const Padding(
                              padding: EdgeInsets.fromLTRB(13, 0, 0, 0),
                              child: Text('Present'),
                            ),
                          ),
                        ),
                      ),
                    ),

                  ),
                  SizedBox(width: 130,height: 120,
                    child:Padding(
                      padding: EdgeInsets.only(left: 5,right: 5,top: 5,bottom: 10),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            isPresentCardTapped = false;
                            isLeaveCardTapped = false;
                            // Toggle the tap state of this card
                            isAbsentCardTapped = !isAbsentCardTapped;
                          });
                        },
                        child: Card(
                          // Change the color based on the state variable
                          color: isAbsentCardTapped ? Colors.green.shade100 : Colors.white,
                          child: ListTile(
                            title: Padding(
                              padding: const EdgeInsets.fromLTRB(14, 15, 0, 0),
                              child: Text('$absentCount/$totalMeetCount', style: const TextStyle(fontSize: 25)),
                            ),
                            subtitle: const Padding(
                              padding: EdgeInsets.fromLTRB(13, 0, 0, 0),
                              child: Text('Absent'),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  //THIRD CARD STARTS
                  SizedBox(width: 130,height: 120,
                    child: Padding(
                      padding: EdgeInsets.only(left: 5,right: 5,top: 5,bottom: 10),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            isPresentCardTapped = false;
                            isAbsentCardTapped = false;
                            isLeaveCardTapped = !isLeaveCardTapped;
                          });
                        },
                        child: Card(
                          // Change the color based on the state variable
                          color: isLeaveCardTapped ? Colors.green.shade100 : Colors.white,
                          child: ListTile(
                            title: Padding(
                              padding: const EdgeInsets.fromLTRB(14, 15, 0, 0),
                              child: Text('$leaveCount/$totalMeetCount', style: const TextStyle(fontSize: 25)),
                            ),
                            subtitle: const Padding(
                              padding: EdgeInsets.fromLTRB(13, 0, 0, 0),
                              child: Text('Leave'),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SingleChildScrollView(
                child: Card(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: isPresentCardTapped
                        ? presentMeetings.length
                        : isAbsentCardTapped
                        ? absentMeetings.length
                        : leaveMeetings.length,
                    itemBuilder: (context, index) {
                      final meeting = isPresentCardTapped
                          ? presentMeetings[index]
                          : isAbsentCardTapped
                          ? absentMeetings[index]
                          : leaveMeetings[index];
                      return ListTile(
                        title:  Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('${index + 1}'),
                            Row(
                              children: [
                                const Icon(Icons.calendar_month_rounded),
                                Text('${meeting['meeting_type']}'),
                              ],
                            ),
                          ],
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('${meeting['meeting_date']}'),
                                Text('${meeting['meeting_name']} Meeting'),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('${meeting['district']}'),
                                Text('${meeting['chapter']}'),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('${meeting['from_time']}'),
                                const Text('-'),
                                Text('${meeting['to_time']}'),
                              ],
                            ),

                          ],
                        ),
                      );
                    },
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
