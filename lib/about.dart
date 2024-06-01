import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gibadmin/main.dart';
import 'package:http/http.dart' as http;

class AboutGib extends StatefulWidget {
  const AboutGib({Key? key}) : super(key: key);

  @override
  State<AboutGib> createState() => _AboutGibState();
}

class _AboutGibState extends State<AboutGib> {
  TextEditingController aboutGIBdatacontent_1 = TextEditingController();
  TextEditingController aboutGIBdatacontent_2 = TextEditingController();
  TextEditingController aboutGIBdatacontent_3 = TextEditingController();
  TextEditingController aboutVisiondatacontent_1 = TextEditingController();
  TextEditingController aboutMissiondatacontent_1 = TextEditingController();
  TextEditingController aboutMissiondatacontent_2 = TextEditingController();


  List<Map<String, dynamic>> aboutVisiondata = [];
  List<Map<String, dynamic>> aboutGIBdata = [];
  List<Map<String, dynamic>> aboutMissiondata = [];

  Future<void> aboutVision() async {
    try {
      final url =
      Uri.parse('http://localhost/GIB/lib/GIBAPI/about.php?table=about_vision');
      if (kDebugMode) {
        print("Url:$url");
      }

      final response = await http.get(url);
      if (kDebugMode) {
        print("Response:$response");
      }
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final List<dynamic> itemGroups = responseData;
        if (kDebugMode) {
          print("responseData:$responseData");
        }
        if (kDebugMode) {
          print("statusCode:${response.statusCode}");
        }
        if (kDebugMode) {
          print("statusCode:${response.body}");
        }
        setState(() {
          aboutVisiondata = itemGroups.cast<Map<String, dynamic>>();
          aboutVisiondatacontent_1.text = aboutVisiondata.isEmpty
              ? 'No data available'
              : aboutVisiondata[0]["vision_content_1"] ?? 'No data available';

          print("aboutVision:$aboutVisiondata");
        });
      } else {
        // Handle error
      }
    } catch (error) {
      // Handle error
    }
  }

  Future<void> aboutGIB() async {
    try {
      final url =
      Uri.parse('http://localhost/GIB/lib/GIBAPI/about.php?table=about_gib');
      if (kDebugMode) {
        print("Url:$url");
      }

      final response = await http.get(url);
      if (kDebugMode) {
        print("Response:$response");
      }
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final List<dynamic> itemGroups = responseData;
        if (kDebugMode) {
          print("responseData:$responseData");
        }
        if (kDebugMode) {
          print("statusCode:${response.statusCode}");
        }
        if (kDebugMode) {
          print("statusCode:${response.body}");
        }
        setState(() {
          aboutGIBdata = itemGroups.cast<Map<String, dynamic>>();
          aboutGIBdatacontent_1.text = aboutGIBdata.isEmpty
              ? 'No data available2'
              : aboutGIBdata[0]["gib_content_1"] ?? 'No data available1';
          aboutGIBdatacontent_2.text = aboutGIBdata.isEmpty
              ? 'No data available'
              : aboutGIBdata[0]["gib_content_2"] ?? 'No data available';
          aboutGIBdatacontent_3.text = aboutGIBdata.isEmpty
              ? 'No data available'
              : aboutGIBdata[0]["gib_content_3"] ?? 'No data available';

          print("about_gib:$aboutGIBdata");
        });
      } else {
        // Handle error
      }
    } catch (error) {
      // Handle error
    }
  }

  Future<void> aboutMission() async {
    try {
      final url =
      Uri.parse('http://localhost/GIB/lib/GIBAPI/about.php?table=about_mission');
      if (kDebugMode) {
        print("aboutMission Url:$url");
      }

      final response = await http.get(url);
      if (kDebugMode) {
        print("aboutMission Response:$response");
      }
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final List<dynamic> itemGroups = responseData;
        if (kDebugMode) {
          print("aboutMission responseData:$responseData");
        }
        if (kDebugMode) {
          print("aboutMission statusCode:${response.statusCode}");
        }
        if (kDebugMode) {
          print("aboutMission statusCode:${response.body}");
        }
        setState(() {
          aboutMissiondata = itemGroups.cast<Map<String, dynamic>>();
          aboutMissiondatacontent_1 .text = aboutMissiondata.isEmpty
              ? 'No data available'
              : aboutMissiondata[0]["mission_content_1"] ?? 'No data available';
          aboutMissiondatacontent_2 .text = aboutMissiondata.isEmpty
              ? 'No data available'
              : aboutMissiondata[0]["mission_content_2"] ?? 'No data available';
          print("about Mission data:$aboutMissiondata");
        });
      } else {
        // Handle error
      }
    } catch (error) {
      // Handle error
    }
  }



  Future<void> updateGIBdata() async {
    try {
      final url = Uri.parse('http://localhost/GIB/lib/GIBAPI/about.php?table=about_gib');
      print("update url:$url");
      final Map<String, dynamic> requestData = {
        'id': aboutGIBdata[0]["id"],
        'gib_content_1': aboutGIBdatacontent_1.text,
        'gib_content_2': aboutGIBdatacontent_2.text,
        'gib_content_3': aboutGIBdatacontent_3.text,
      };

      final response = await http.put(
        url,
        body: jsonEncode(requestData),
        headers: {'Content-Type': 'application/json'},
      );
      print("Ed Response :${response.body}");
      print("Ed status code :${response.statusCode}");

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Updated")));
        print('Update successful');
      } else {
        // Update failed, handle as needed
        print('Update failed');
      }
    } catch (error) {
      // Handle error
      print('Error updating: $error');
    }
  }

  Future<void> updateVisiondata() async {
    try {
      final url = Uri.parse('http://localhost/GIB/lib/GIBAPI/about.php?table=about_vision');
      print("Vision update url:$url");
      final Map<String, dynamic> requestData = {
        'id': aboutVisiondata[0]["id"],
        'vision_content_1': aboutVisiondatacontent_1.text,
      };

      final response = await http.put(
        url,
        body: jsonEncode(requestData),
        headers: {'Content-Type': 'application/json'},
      );
      print("Ed Response :${response.body}");
      print("Ed status code :${response.statusCode}");

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Updated")));
        print('Update successful');
      } else {
        // Update failed, handle as needed
        print('Update failed');
      }
    } catch (error) {
      // Handle error
      print('Error updating: $error');
    }
  }
  Future<void> updateMissiondata() async {
    try {
      final url = Uri.parse('http://localhost/GIB/lib/GIBAPI/about.php?table=about_mission');
      print("Vision update url:$url");
      final Map<String, dynamic> requestData = {
        'id': aboutVisiondata[0]["id"],
        'mission_content_1': aboutMissiondatacontent_1.text,
        'mission_content_2': aboutMissiondatacontent_2.text,
      };

      final response = await http.put(
        url,
        body: jsonEncode(requestData),
        headers: {'Content-Type': 'application/json'},
      );
      print("mission Response :${response.body}");
      print("mission status code :${response.statusCode}");

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Updated")));
        print('Update successful');
      } else {
        // Update failed, handle as needed
        print('Update failed');
      }
    } catch (error) {
      // Handle error
      print('Error updating: $error');
    }
  }


  @override
  void initState() {
    super.initState();
    aboutVision();
    aboutGIB();
    aboutMission();
  }

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      route: "aboutGib",
      body: DefaultTabController(
        length: 3,
        child: Center(
          child: Column(
            children: [
              const TabBar(
                tabAlignment: TabAlignment.center,
                isScrollable: true,
                labelColor: Colors.green,
                unselectedLabelColor: Colors.black,
                tabs: [
                  Tab(text: 'GIB',),
                  Tab(text: 'Vision',),
                  Tab(text: 'Mission',)
                ],
              ),
              // IconButton(onPressed: (){
              // }, icon: Icon(Icons.edit)),
              Container(
                width: 7000.0,
                height: 7000.0,
                child: TabBarView(
                  children: [
                    SingleChildScrollView(
                      child: Center(
                        child: Column(
                          children: [
                            Image.asset('assets/logo.png', width: 300,),
                           /* Padding(
                              padding: EdgeInsets.all(12.0),
                              child: aboutGIBdata.isEmpty
                                  ? CircularProgressIndicator()
                                  : Text("${aboutGIBdata[0]["content_1"] ?? 'No data available'}",
                                  textAlign: TextAlign.justify),
                            ),*/
                            Padding(
                              padding: EdgeInsets.all(12.0),
                              child: TextFormField(
                                controller: aboutGIBdatacontent_1,
                                decoration: InputDecoration(
                                  labelText: 'Content 1',
                                ),
                                onChanged: (value){
                                  updateGIBdata();
                                },
                                maxLines: null,
                              ),
                            ),
                            const SizedBox(height: 10,),
                            Padding(
                              padding: EdgeInsets.all(12.0),
                              child: TextFormField(
                                controller: aboutGIBdatacontent_2,
                                //  readOnly: !_isEditing,
                                decoration: InputDecoration(
                                  labelText: 'Content 2',
                                ),
                                onChanged: (value){
                                  updateGIBdata();
                                },
                                maxLines: null, // Allows for multiline text
                              ),
                            ),
                           /* Padding(
                              padding: EdgeInsets.all(12.0),
                              child: aboutGIBdata.isEmpty
                                  ? CircularProgressIndicator()
                                  : Text("${aboutGIBdata[0]["content_2"] ?? 'No data available'}",
                                  textAlign: TextAlign.justify),
                            ),*/
                            const SizedBox(height: 10,),
                            Padding(
                              padding: EdgeInsets.all(12.0),
                              child: TextFormField(
                                controller: aboutGIBdatacontent_3,
                                //  readOnly: !_isEditing,
                                decoration: InputDecoration(
                                  labelText: 'Content 3',
                                ),
                                onChanged: (value){
                                  updateGIBdata();
                                },
                                maxLines: null, // Allows for multiline text
                              ),
                            ),
                            /*Padding(
                              padding: EdgeInsets.all(12.0),
                              child: aboutGIBdata.isEmpty
                                  ? CircularProgressIndicator()
                                  : Text("${aboutGIBdata[0]["content_3"] ?? 'No data available'}",
                                  textAlign: TextAlign.justify),
                            ),*/
                          ],
                        ),
                      ),
                    ),
                    SingleChildScrollView(
                      child: Center(
                        child: Column(
                          children: [
                            Image.asset('assets/logo.png', width: 300,),

                            Padding(
                              padding: EdgeInsets.all(12.0),
                              child: TextFormField(
                                controller: aboutVisiondatacontent_1,
                                decoration: InputDecoration(
                                  labelText: 'Content 1',
                                ),
                                onChanged: (value){
                                  updateVisiondata();
                                },
                                maxLines: null,
                              ),
                            ),

                           /* Padding(
                              padding: EdgeInsets.all(12.0),
                              child: aboutVisiondata.isEmpty
                                  ? CircularProgressIndicator()
                                  : Text("${aboutVisiondata[0]["content_1"] ?? 'No data available'}",
                                  textAlign: TextAlign.justify),
                            ),*/
                          ],
                        ),
                      ),
                    ),
                    SingleChildScrollView(
                      child: Center(
                        child: Column(
                          children: [
                            Image.asset('assets/logo.png', width: 300,),
                            Padding(
                              padding: EdgeInsets.all(12.0),
                              child: TextFormField(
                                controller: aboutMissiondatacontent_1,
                                //  readOnly: !_isEditing,
                                decoration: InputDecoration(
                                  labelText: 'Content 1',
                                ),
                                onChanged: (value){
                                  updateMissiondata();
                                },
                                maxLines: null,
                              ),
                            ),
                           /* Padding(
                              padding: EdgeInsets.all(12.0),
                              child: aboutMissiondata.isEmpty
                                  ? CircularProgressIndicator()
                                  : Text("${aboutMissiondata[0]["content_1"] ?? 'No data available'}",
                                  textAlign: TextAlign.justify),
                            ),*/
                            const SizedBox(height: 10,),
                            Padding(
                              padding: EdgeInsets.all(12.0),
                              child: TextFormField(
                                controller: aboutMissiondatacontent_2,
                                //  readOnly: !_isEditing,
                                decoration: const InputDecoration(
                                  labelText: 'Content 2',
                                ),
                                onChanged: (value){
                                  updateMissiondata();
                                },
                                maxLines: null,
                              ),
                            ),
                           /* Padding(
                              padding: EdgeInsets.all(12.0),
                              child: aboutMissiondata.isEmpty
                                  ? CircularProgressIndicator()
                                  : Text("${aboutMissiondata[0]["content_2"] ?? 'No data available'}",
                                  textAlign: TextAlign.justify),
                            ),*/
                          ],
                        ),
                      ),
                    ),

                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
