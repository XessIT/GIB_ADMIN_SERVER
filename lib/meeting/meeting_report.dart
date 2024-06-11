import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../main.dart';

class CurrentMeetingUserRegistration extends StatelessWidget {
  const CurrentMeetingUserRegistration({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CurrentMeetingUserRegistrationPage(),
    );
  }
}

class CurrentMeetingUserRegistrationPage extends StatefulWidget {
  const CurrentMeetingUserRegistrationPage({Key? key}) : super(key: key);

  @override
  State<CurrentMeetingUserRegistrationPage> createState() =>
      _CurrentMeetingUserRegistrationPageState();
}

class _CurrentMeetingUserRegistrationPageState
    extends State<CurrentMeetingUserRegistrationPage> {
  late Future<List<Meeting>> futureMeetings;

  @override
  void initState() {
    super.initState();
    futureMeetings = fetchMeetings();
  }

  Future<List<Meeting>> fetchMeetings() async {
    final response = await http
        .get(Uri.parse('http://mybudgetbook.in/GIBADMINAPI/todaymeeting.php'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((meeting) => Meeting.fromJson(meeting)).toList();
    } else {
      throw Exception('Failed to load meetings');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      route: "/current_meeting_user_registration",
      body: Center(
        child: FutureBuilder<List<Meeting>>(
          future: futureMeetings,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            } else {
              return MeetingsDataTable(
                meetings: snapshot.data!,
                context: context, // Pass the context here
              );
            }
          },
        ),
      ),
    );
  }
}

class Meeting {
  final String? meetingId;
  final String? meetingName;
  final String? meetingDate;
  final String? chapter;
  final String? district;
  final String? teamName;
  final String? place;
  final String? memberType;
  final String? meetingType;

  Meeting({
    this.meetingId,
    this.meetingName,
    this.meetingDate,
    this.chapter,
    this.district,
    this.teamName,
    this.place,
    this.memberType,
    this.meetingType,
  });

  factory Meeting.fromJson(Map<String, dynamic> json) {
    return Meeting(
      meetingId: json['id'] as String?,
      meetingName: json['meeting_name'] as String?,
      meetingDate: json['meeting_date'] as String?,
      chapter: json['chapter'] as String?,
      district: json['district'] as String?,
      teamName: json['team_name'] as String?,
      place: json['place'] as String?,
      memberType: json['member_type'] as String?,
      meetingType: json['meeting_type'] as String?,
    );
  }
}

class MeetingsDataTable extends StatelessWidget {
  final List<Meeting> meetings;
  final BuildContext context;

  MeetingsDataTable({required this.meetings, required this.context});

  @override
  Widget build(BuildContext context) {
    return PaginatedDataTable(
      header: Text('Meeting Report'),
      columns: [
        DataColumn(
            label: Text('Meeting Name',
                style: Theme.of(context).textTheme.headlineSmall)),
        DataColumn(
            label: Text('Meeting Date',
                style: Theme.of(context).textTheme.headlineSmall)),
        DataColumn(
            label: Text('Chapter',
                style: Theme.of(context).textTheme.headlineSmall)),
        DataColumn(
            label: Text('District',
                style: Theme.of(context).textTheme.headlineSmall)),
        DataColumn(
            label: Text('Team Name',
                style: Theme.of(context).textTheme.headlineSmall)),
        DataColumn(
            label: Text('Place',
                style: Theme.of(context).textTheme.headlineSmall)),
        DataColumn(
            label: Text('Member Type',
                style: Theme.of(context).textTheme.headlineSmall)),
        DataColumn(
            label: Text('Meeting Type',
                style: Theme.of(context).textTheme.headlineSmall)),
        DataColumn(
            label: Text('Actions',
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall)), // New column for actions
      ],
      source: MeetingsDataSource(meetings, context),
    );
  }
}

class MeetingsDataSource extends DataTableSource {
  final List<Meeting> meetings;
  final BuildContext context;

  MeetingsDataSource(this.meetings, this.context);

  @override
  DataRow? getRow(int index) {
    if (index >= meetings.length) return null;
    final meeting = meetings[index];

    return DataRow.byIndex(
      index: index,
      cells: [
        DataCell(Text(meeting.meetingName ?? 'N/A',
            style: Theme.of(context).textTheme.bodySmall)),
        DataCell(Text(meeting.meetingDate ?? 'N/A',
            style: Theme.of(context).textTheme.bodySmall)),
        DataCell(Text(meeting.chapter ?? 'N/A',
            style: Theme.of(context).textTheme.bodySmall)),
        DataCell(Text(meeting.district ?? 'N/A',
            style: Theme.of(context).textTheme.bodySmall)),
        DataCell(Text(meeting.teamName ?? 'N/A',
            style: Theme.of(context).textTheme.bodySmall)),
        DataCell(Text(meeting.place ?? 'N/A',
            style: Theme.of(context).textTheme.bodySmall)),
        DataCell(Text(meeting.memberType ?? 'N/A',
            style: Theme.of(context).textTheme.bodySmall)),
        DataCell(Text(meeting.meetingType ?? 'N/A',
            style: Theme.of(context).textTheme.bodySmall)),
        DataCell(
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      GuestListPage(meetingId: meeting.meetingId ?? 'Unknown'),
                ),
              );
            },
            child: Text('View'),
          ),
        ),
      ],
    );
  }

  @override
  int get rowCount => meetings.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => 0;
}

class GuestListPage extends StatefulWidget {
  final String meetingId;

  GuestListPage({required this.meetingId});

  @override
  _GuestListPageState createState() => _GuestListPageState();
}

class _GuestListPageState extends State<GuestListPage> {
  late Future<List<Map<String, dynamic>>> _guestList;

  @override
  void initState() {
    super.initState();
    _guestList = fetchGuestList();
  }

  Future<List<Map<String, dynamic>>> fetchGuestList() async {
    final response = await http.get(
      Uri.parse(
          'http://mybudgetbook.in/GIBADMINAPI/currentmeeting.php?meeting_id=${widget.meetingId}'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> guestList = json.decode(response.body);
      return guestList.isNotEmpty ? guestList.cast<Map<String, dynamic>>() : [];
    } else {
      throw Exception('Failed to load guest list');
    }
  }

  Future<void> fetchGuestDetails(String userId) async {
    final response = await http.get(
      Uri.parse(
          'http://mybudgetbook.in/GIBADMINAPI/currentmeetingvisitor.php?meeting_id=${widget.meetingId}&user_id=$userId'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> guestDetails = json.decode(response.body);
      showGuestDetails(guestDetails);
    } else {
      throw Exception('Failed to load guest details');
    }
  }

  void showGuestDetails(List<dynamic> guestDetails) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Guest Details'),
          content: SingleChildScrollView(
            child: DataTable(
              columns: [
                DataColumn(
                    label: Text(
                  'Guest Name',
                  style: Theme.of(context).textTheme.headlineSmall,
                )),
                DataColumn(
                    label: Text(
                  'Company Name',
                  style: Theme.of(context).textTheme.headlineSmall,
                )),
                DataColumn(
                    label: Text(
                  'Location',
                  style: Theme.of(context).textTheme.headlineSmall,
                )),
                DataColumn(
                    label: Text(
                  'Koottam',
                  style: Theme.of(context).textTheme.headlineSmall,
                )),
                DataColumn(
                    label: Text(
                  'Kovil',
                  style: Theme.of(context).textTheme.headlineSmall,
                )),
                DataColumn(
                    label: Text(
                  'Mobile',
                  style: Theme.of(context).textTheme.headlineSmall,
                )),
              ],
              rows: guestDetails.map<DataRow>((detail) {
                return DataRow(cells: [
                  DataCell(Text(
                    detail['guest_name'] != null
                        ? detail['guest_name'].toString()
                        : '',
                    style: Theme.of(context).textTheme.bodySmall,
                  )),
                  DataCell(Text(
                    detail['company_name'] != null
                        ? detail['company_name'].toString()
                        : '',
                    style: Theme.of(context).textTheme.bodySmall,
                  )),
                  DataCell(Text(
                    detail['location'] != null
                        ? detail['location'].toString()
                        : '',
                    style: Theme.of(context).textTheme.bodySmall,
                  )),
                  DataCell(Text(
                    detail['koottam'] != null
                        ? detail['koottam'].toString()
                        : '',
                    style: Theme.of(context).textTheme.bodySmall,
                  )),
                  DataCell(Text(
                    detail['kovil'] != null ? detail['kovil'].toString() : '',
                    style: Theme.of(context).textTheme.bodySmall,
                  )),
                  DataCell(Text(
                    detail['mobile'] != null ? detail['mobile'].toString() : '',
                    style: Theme.of(context).textTheme.bodySmall,
                  )),
                ]);
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Guest List'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _guestList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No Guest found'));
          } else {
            return SingleChildScrollView(
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 1000),
                  child: PaginatedDataTable(
                    columns: [
                      DataColumn(
                          label: Text(
                        'Serial No.',
                        style: Theme.of(context).textTheme.headlineSmall,
                      )),
                      DataColumn(
                          label: Text(
                        'Meeting ID',
                        style: Theme.of(context).textTheme.headlineSmall,
                      )),
                      // DataColumn(
                      //     label: Text(
                      //   'User ID',
                      //   style: Theme.of(context).textTheme.headlineSmall,
                      // )),
                      DataColumn(
                          label: Text(
                        'Member Type',
                        style: Theme.of(context).textTheme.headlineSmall,
                      )),
                      DataColumn(
                          label: Text(
                        'Status',
                        style: Theme.of(context).textTheme.headlineSmall,
                      )),
                      DataColumn(
                          label: Text(
                        'Guest Count',
                        style: Theme.of(context).textTheme.headlineSmall,
                      )),
                      DataColumn(
                          label: Text(
                        'Actions',
                        style: Theme.of(context).textTheme.headlineSmall,
                      )), // Add Action column
                    ],
                    source: GuestDataSource(snapshot.data!, fetchGuestDetails,
                        context), // Pass context here

                    rowsPerPage: 10,
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}

class GuestDataSource extends DataTableSource {
  final List<Map<String, dynamic>> data;
  final Function(String) fetchGuestDetails;
  final BuildContext context; // Add context here

  GuestDataSource(
      this.data, this.fetchGuestDetails, this.context); // Update constructor

  @override
  DataRow getRow(int index) {
    assert(index >= 0);
    if (index >= data.length) return null!;

    final guest = data[index];
    return DataRow.byIndex(index: index, cells: [
      DataCell(Text((index + 1).toString(),
          style: Theme.of(context).textTheme.bodySmall)), // Use context here
      DataCell(Text(guest['meeting_id'].toString(),
          style: Theme.of(context).textTheme.bodySmall)), // Use context here
      // DataCell(Text(guest['user_id'].toString(),
      //     style: Theme.of(context).textTheme.bodySmall)), // Use context here
      DataCell(Text(guest['member_type'] ?? 'No Member Type',
          style: Theme.of(context).textTheme.bodySmall)), // Use context here
      DataCell(Text(guest['status'] ?? 'No Status',
          style: Theme.of(context).textTheme.bodySmall)), // Use context here
      DataCell(Text(guest['guest_count']?.toString() ?? '0',
          style: Theme.of(context).textTheme.bodySmall)), // Use context here
      DataCell(
        ElevatedButton(
          child: Text('Details'),
          onPressed: () {
            // Handle the view action here
            fetchGuestDetails(guest['user_id'].toString());
          },
        ),
      ), // Action button
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => data.length;

  @override
  int get selectedRowCount => 0;
}
