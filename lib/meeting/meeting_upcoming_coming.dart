import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../main.dart';

class UpcomingMeeting extends StatelessWidget {
  const UpcomingMeeting({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: UpcomingMeetingPage(),
    );
  }
}
class UpcomingMeetingPage extends StatefulWidget {
  const UpcomingMeetingPage({Key? key}) : super(key: key);

  @override
  State<UpcomingMeetingPage> createState() => _UpcomingMeetingPageState();
}

class _UpcomingMeetingPageState extends State<UpcomingMeetingPage> {
  final _formKey = GlobalKey<FormState>();
  String? selectedDistrict;
  String? selectedChapter;
  String chapter = "Chapter";
  // CollectionReference meeting = FirebaseFirestore.instance.collection("Meeting");
  ///First Letter capital code
  String capitalizeFirstLetter(String text) {
    if (text.isEmpty) return text;
    return text.substring(0, 1).toUpperCase() + text.substring(1);
  }


  @override
  Widget build(BuildContext context) {
    return MyScaffold(
        route: "/upcomingmeeting_page",
        body:Form(
          key: _formKey,
          child: Center(
              child: Column(
                  children: [

                  ]
              )
          ),
        )
    );
  }
}
