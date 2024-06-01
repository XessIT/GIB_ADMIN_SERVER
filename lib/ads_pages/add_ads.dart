import 'dart:convert';
import 'dart:html' as html;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import '../main.dart';

class AddAdsPage extends StatefulWidget {
  const AddAdsPage({Key? key}) : super(key: key);

  @override
  State<AddAdsPage> createState() => _AddAdsPageState();
}

final TextEditingController pricecontroller = TextEditingController();
final TextEditingController fromDate = TextEditingController();
final TextEditingController todate = TextEditingController();
final TextEditingController membernameController = TextEditingController();

class _AddAdsPageState extends State<AddAdsPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? type = "";
  bool executive = false;
  bool nonexecutive = false;
  bool guest = false;
  List<bool> checkboxStatus = [];
  String selectedMemberId = '';
  List<Uint8List> selectedImages = [];
  List<String> imageNames = [];
  List<String> imageDatas = [];

  Future<void> getImages() async {
    final html.FileUploadInputElement input = html.FileUploadInputElement();
    input.multiple = true; // Allow multiple file selection
    input.click();

    input.onChange.listen((e) {
      final List<html.File> files = input.files!;
      for (final html.File file in files) {
        final reader = html.FileReader();
        reader.onLoadEnd.listen((e) {
          setState(() {
            final Uint8List selectedImage = reader.result as Uint8List;
            selectedImages.add(selectedImage);
            imageNames.add(file.name);
            imageDatas.add(base64Encode(selectedImage));
          });
        });
        reader.readAsArrayBuffer(file);
      }
    });
  }

  // Member name code
  List<Map<String, dynamic>> membernamesuggesstion = [];
  List member = [];
  Future<void> getMemberName() async {
    try {
      final url = Uri.parse(
          'http://mybudgetbook.in/GIBADMINAPI/ads.php?table=registration');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final List<dynamic> itemGroups = responseData;
        setState(() {
          membernamesuggesstion = itemGroups.cast<Map<String, dynamic>>();
        });
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  // Method to count selected member types
  int countSelectedMemberTypes() {
    int count = 0;
    if (executive) count++;
    if (nonexecutive) count++;
    if (guest) count++;
    return count;
  }

  Future<void> addAds() async {
    try {
      final DateTime parsedFromDate =
          DateFormat('dd/MM/yyyy').parse(fromDate.text);
      final formattedFromDate = DateFormat('yyyy/MM/dd').format(parsedFromDate);
      final DateTime parsedToDate = DateFormat('dd/MM/yyyy').parse(todate.text);
      final formattedToDate = DateFormat('yyyy/MM/dd').format(parsedToDate);

      final url =
          Uri.parse('http://mybudgetbook.in/GIBADMINAPI/ads.php');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "member_name": membernameController.text,
          "member_id": selectedMemberId,
          "imagename": imageNames, // Send list directly
          "imagedata": imageDatas, // Send list directly
          "from_date": formattedFromDate,
          "to_date": formattedToDate,
          "price": pricecontroller.text,
          "selected_member_types":
              getSelectedMemberTypes(), // Include count of selected member types
        }),
      );

      if (response.statusCode == 200) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: const Text("Ads Added Successfully"),
              actions: <Widget>[
                TextButton(
                  child: const Text("OK"),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AddAdsPage()));
                  },
                ),
              ],
            );
          },
        );
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Failed to Add")));
      }
    } catch (e) {
      print("Error during adding ads: $e");
    }
  }

  String getSelectedMemberTypes() {
    List<String> selectedTypes = [];
    if (executive) selectedTypes.add('Executive');
    if (nonexecutive) selectedTypes.add('NonExecutive');
    if (guest) selectedTypes.add('Guest');
    return selectedTypes
        .join(','); // Send comma-separated list of selected types
  }

  @override
  void initState() {
    getMemberName();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      route: '/add_ads',
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
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
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Checkbox(
                            value: executive,
                            onChanged: (value) {
                              setState(() {
                                executive = value!;
                              });
                            },
                            activeColor: Colors.lightBlue,
                            checkColor: Colors.white,
                          ),
                          const Text("Executive"),
                        ],
                      ),
                      const SizedBox(width: 30),
                      Row(
                        children: [
                          Checkbox(
                            value: nonexecutive,
                            onChanged: (value) {
                              setState(() {
                                nonexecutive = value!;
                              });
                            },
                            activeColor: Colors.lightBlue,
                            checkColor: Colors.white,
                          ),
                          const Text("NonExecutive"),
                        ],
                      ),
                      const SizedBox(width: 30),
                      Row(
                        children: [
                          Checkbox(
                            value: guest,
                            onChanged: (value) {
                              setState(() {
                                guest = value!;
                              });
                            },
                            activeColor: Colors.lightBlue,
                            checkColor: Colors.white,
                          ),
                          const Text("Guest"),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Ad's should be in Jpg, Jpeg, Png, and Gif format",
                    style: TextStyle(
                        color: Colors.red, fontStyle: FontStyle.italic),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Ad's Image",
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.white),
                        ),
                        onPressed: () {
                          getImages();
                        },
                        child: Text(
                          'Pick File',
                          style: TextStyle(color: Colors.black87),
                        ),
                      ),
                      const SizedBox(width: 9),
                      selectedImages.isEmpty
                          ? Text("No File Chosen")
                          : Column(
                              children:
                                  imageNames.map((name) => Text(name)).toList(),
                            ),
                    ],
                  ),
                  const SizedBox(height: 60),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.center,
                    child: Row(
                      children: [
                        SizedBox(width: 300),
                        Container(
                          width: 200,
                          height: 40,
                          child: TypeAheadFormField<String>(
                            textFieldConfiguration: TextFieldConfiguration(
                              controller: membernameController,
                              decoration: const InputDecoration(
                                  fillColor: Colors.white,
                                  filled: true,
                                  labelText: "Member Name"),
                            ),
                            suggestionsCallback: (pattern) async {
                              if (pattern.isEmpty) {
                                return [];
                              }
                              List<String> suggestions = membernamesuggesstion
                                  .where((item) {
                                    String firstName = item['first_name']
                                            ?.toString()
                                            .toLowerCase() ??
                                        '';
                                    String lastName = item['last_name']
                                            ?.toString()
                                            .toLowerCase() ??
                                        '';
                                    return firstName
                                            .contains(pattern.toLowerCase()) ||
                                        lastName
                                            .contains(pattern.toLowerCase());
                                  })
                                  .map<String>((item) =>
                                      '${item['first_name']} ${item['last_name']}')
                                  .toSet()
                                  .toList();
                              return suggestions;
                            },
                            itemBuilder: (context, suggestion) {
                              return ListTile(
                                title: Text(suggestion),
                              );
                            },
                            onSuggestionSelected: (suggestion) async {
                              var selectedMember =
                                  membernamesuggesstion.firstWhere(
                                (item) =>
                                    '${item['first_name']} ${item['last_name']}' ==
                                    suggestion,
                              );
                              if (selectedMember != null &&
                                  selectedMember['id'] != null) {
                                setState(() {
                                  selectedMemberId =
                                      selectedMember['member_id'].toString();
                                  membernameController.text = suggestion;
                                });
                              }
                            },
                          ),
                        ),
                        SizedBox(width: 20),
                        SizedBox(
                          width: 200,
                          height: 40,
                          child: TextFormField(
                            controller: fromDate,
                            onTap: () async {
                              DateTime? pickDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(1900),
                                  lastDate: DateTime(2100));
                              if (pickDate == null) return;
                              setState(() {
                                fromDate.text =
                                    DateFormat('dd/MM/yyyy').format(pickDate);
                              });
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "*Enter the Field";
                              } else {
                                return null;
                              }
                            },
                            decoration: const InputDecoration(
                                suffixIcon: Icon(
                                  Icons.calendar_today_outlined,
                                  color: Colors.green,
                                ),
                                labelText: "From Date"),
                          ),
                        ),
                        SizedBox(width: 20),
                        SizedBox(
                          width: 200,
                          height: 40,
                          child: TextFormField(
                            controller: todate,
                            readOnly: true,
                            onTap: () async {
                              DateTime? pickDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(1900),
                                  lastDate: DateTime(2100));
                              if (pickDate == null) return;
                              setState(() {
                                todate.text =
                                    DateFormat('dd/MM/yyyy').format(pickDate);
                              });
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "*Enter the Field";
                              } else {
                                return null;
                              }
                            },
                            decoration: const InputDecoration(
                                suffixIcon: Icon(
                                  Icons.calendar_today_outlined,
                                  color: Colors.green,
                                ),
                                labelText: "To Date"),
                          ),
                        ),
                        SizedBox(width: 20),
                        SizedBox(
                          width: 200,
                          height: 40,
                          child: TextFormField(
                            controller: pricecontroller,
                            decoration:
                                const InputDecoration(labelText: "Price"),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 10,
                          shadowColor: Colors.pinkAccent,
                        ),
                        onPressed: () {},
                        child: const Text("Reset"),
                      ),
                      SizedBox(width: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 10,
                          shadowColor: Colors.pinkAccent,
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            addAds();
                          }
                        },
                        child: const Text("Submit"),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
