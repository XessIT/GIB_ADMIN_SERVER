import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:gibadmin/main.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class SetPersonSubscrption extends StatefulWidget {
  const SetPersonSubscrption({Key? key}) : super(key: key);

  @override
  State<SetPersonSubscrption> createState() => _SetPersonSubscrptionState();
}

class _SetPersonSubscrptionState extends State<SetPersonSubscrption> {
  String? selectgibid;
  String? selectmobile;
  TextEditingController mobile=TextEditingController();
  TextEditingController name=TextEditingController();
  TextEditingController scheduledate=TextEditingController();
  TextEditingController membertype=TextEditingController();
  TextEditingController members=TextEditingController();
  TextEditingController membercategory=TextEditingController();
  TextEditingController subscriptionamount=TextEditingController();
  TextEditingController subscriptiondate=TextEditingController();
  TextEditingController districtController=TextEditingController();
  TextEditingController chapterController=TextEditingController();
  TextEditingController scheduleDateController=TextEditingController();
  TextEditingController dueDateController=TextEditingController();
  TextEditingController fromyear=TextEditingController();
  TextEditingController toyear=TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List<Map<String, dynamic>> membersData = [];
  Future<void> getMembers() async {
    try {
      final url = Uri.parse('http://mybudgetbook.in/GIBADMINAPI/subscription.php?table=member_details');
      print('member_category_url :$url');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final List<dynamic> member = responseData;
        print("Cat-status code :${response.statusCode}");
        print("Cat-response body :${response.body}");

        setState(() {
          membersData = member.cast<Map<String, dynamic>>();
          print("member_category--: $membersData");

        });
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  String capitalizeFirstLetter(String text) {
    if (text.isEmpty) return text;
    return text.substring(0, 1).toUpperCase() + text.substring(1);
  }
  //List<Map<String, dynamic>> data=[];
  List<Map<String, dynamic>> memberSuggestion = [];

  Future<void> getMemberType(String districts, String chapters) async {
    print('Attempting to make HTTP request...');
    try {
      final url = Uri.parse('http://mybudgetbook.in/GIBADMINAPI/subscription.php?table=subscription_member_type&district=$districts&chapter=$chapters');
      print("gib members url =$url");
      final response = await http.get(url);
      print("gib members ResponseStatus: ${response.statusCode}");
      print("gib members Response: ${response.body}");
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print("gib members ResponseData: $responseData");

        // Filter out members with member_type "Guest" and "Non-Executive"
        final List<dynamic> itemGroups = responseData.where((item) {
          return item['member_type'] != 'Guest' && item['member_type'] != 'Non-Executive';
        }).toList();

        setState(() {
          memberSuggestion = itemGroups.cast<Map<String, dynamic>>();
        });
        print('gib members Data: $memberSuggestion');
      } else {
        print('Error: ${response.statusCode}');
      }
      print('HTTP request completed. Status code: ${response.statusCode}');
    } catch (e) {
      print('Error making HTTP request: $e');
      throw e; // rethrow the error if needed
    }
  }



  // Future<void> getMemberType() async {
  //   try {
  //     final url = Uri.parse('http://mybudgetbook.in/GIBADMINAPI/member_type.php');
  //     final response = await http.get(url);
  //     if (response.statusCode == 200) {
  //       final responseData = json.decode(response.body);
  //       final List<dynamic> itemGroups = responseData;
  //       setState(() {
  //         memberSuggestion = itemGroups.cast<Map<String, dynamic>>();
  //       });
  //     } else {
  //       //print('Error: ${response.statusCode}');
  //     }
  //   } catch (error) {
  //     //  print('Error: $error');
  //   }
  // }

  // List<Map<String, dynamic>> categoryData = [];
  // Future<void> getMemberCategory() async {
  //   try {
  //     final url = Uri.parse('http://mybudgetbook.in/GIBADMINAPI/subscription.php?table=member_category');
  //     print('member_category_url :$url');
  //     final response = await http.get(url);
  //     if (response.statusCode == 200) {
  //       final responseData = json.decode(response.body);
  //       final List<dynamic> member = responseData;
  //       print("Cat-status code :${response.statusCode}");
  //       print("Cat-response body :${response.body}");
  //       setState(() {
  //         categoryData = member.cast<Map<String, dynamic>>();
  //         print("member_category--: $categoryData");
  //
  //       });
  //     } else {
  //       print('Error: ${response.statusCode}');
  //     }
  //   } catch (error) {
  //     print('Error: $error');
  //   }
  // }
  String memberID = "";
  String member_name = "";
  String userID = "";
  String currentType = "";
  String formyear = "";
  Map<String, dynamic> memberDetails = {};


  Future<void> getMemberDetails(String memberId) async {
    print("MemberId: $memberId");
    try {
      final url = Uri.parse('http://mybudgetbook.in/GIBADMINAPI/subscription.php?table=member_fulldetails&member_id=$memberId');
      print("Id $url");
      final response = await http.get(url);
      if (response.statusCode == 200) {
        print("response body id base fetch: ${response.body}");
        final responseData = json.decode(response.body);
        setState(() {
          memberDetails = responseData;
          memberID = memberDetails["member_id"]; // Assuming memberID is of type String
          member_name = "${memberDetails["first_name"]} ${memberDetails["last_name"]}";
          userID = memberDetails["id"]; // Assuming memberID is of type String
          currentType = memberDetails["member_type"];
          print("Mem: $memberID");
          print("user_id: $userID");
          print("user_id: $member_name");
        });
        print("memberdetails : $memberDetails");
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  List<Map<String, dynamic>> data=[];

  Future<void> getsubscription(String from_year ,String district, String chapter,String member_type, String member_category ) async {
    print('Attempting to make HTTP request...');
    try {
      final url = Uri.parse('http://mybudgetbook.in/GIBADMINAPI/subscription.php?table=subscription_amount&from_year=$from_year&district=$district&chapter=$chapter&member_type=$member_type&member_category=$member_category');
      print("gib members url = $url");
      final response = await http.get(url);
      print("gib members ResponseStatus: ${response.statusCode}");
      print("gib members Response: ${response.body}");
      if (response.statusCode == 200) {
        try {
          final responseData = json.decode(response.body);
          if (responseData.containsKey('subscription_amount')) {
            setState(() {
              subscriptionamount.text = responseData['subscription_amount'];
              scheduleDateController.text = responseData['schedule_date'];
              dueDateController.text = responseData['to_year'];
            });

            print('Subscription Amount: ${subscriptionamount.text}');
            print('Schedule Date: ${scheduleDateController.text}');
            print('Due Date: ${dueDateController.text}');
          } else {
            print('No subscription amount found');
          }
        } catch (e) {
          print('Error parsing JSON: $e');
        }
      } else {
        print('Error: ${response.statusCode}');
      }
      print('HTTP request completed. Status code: ${response.statusCode}');
    } catch (e) {
      print('Error making HTTP request: $e');
      throw e; // rethrow the error if needed
    }
  }

  bool showDetails = false;

  Future<void> dataUpdatetoSubscription() async {
    print("Update starts");
    try {
      String url = "http://mybudgetbook.in/GIBADMINAPI/subscription.php?table=subscription";
      print("put url: $url");
      var res = await http.put(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "member_type": membertype.text.trim(),
          "member_category": membercategory.text.trim(),
          "schedule_date": scheduleDateController.text.trim(),
          'due_date':dueDateController.text,
          'id': userID.toString(),
        }),
      );

      if (res.statusCode == 200) {
        print(url);
        print("put Status: ${res.statusCode}");
        print("put Body: ${res.body}");
        var response = jsonDecode(res.body);

        if (response.containsKey("message")) {
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(builder: (context) => SubcriptionEditDelete()),
          // );
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Subscription Updated Successfully")),
          );
          print("Subscription update response: ${response["message"]}");
        } else if (response.containsKey("error")) {
          print("Error updating subscription: ${response["error"]}");
        }
      } else {
        print("Failed to update subscription. Server returned status code: ${res.statusCode}");
      }
    } catch (e) {
      print("Error Subscription: $e");
    }
  }

  List<Map<String, dynamic>> getyear = [];

  Future<void> getfromyear() async {
    try {
      final url = Uri.parse('http://mybudgetbook.in/GIBADMINAPI/subscription.php?table=from_year');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final List<dynamic> itemGroups = responseData;
        setState(() {
          getyear = itemGroups.cast<Map<String, dynamic>>();
        });
      } else {
      }
    } catch (error) {
      //  print('Error: $error');
    }
  }

  List<Map<String, dynamic>> suggesstiondata = [];

  Future<void> getDistrict() async {
    try {
      final url = Uri.parse('http://mybudgetbook.in/GIBADMINAPI/subscription.php?table=district');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final List<dynamic> itemGroups = responseData;
        setState(() {
          suggesstiondata = itemGroups.cast<Map<String, dynamic>>();
        });
      } else {
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
      final url = Uri.parse('http://mybudgetbook.in/GIBADMINAPI/subscription.php?table=chapter&district=$district');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        if (responseData is Map<String, dynamic>) {
          setState(() {
            suggesstiondataitemName = [responseData];
          });
          print('Sorted chapter Names: $suggesstiondataitemName');
        } else {
          print('chapter Error: Unexpected response format');
        }

        print('chapter: $chapters');
        chapterController.clear();
      } else {
        print('chapter Error: ${response.statusCode}');
      }
    } catch (error) {
      print('chapter Error: $error');
    }
  }

  List<Map<String, dynamic>> categoryData=[];

  Future<void> getMemberCategory(String districts, String chapters, String member_type) async {
    print('Attempting to make HTTP request...');
    try {
      final url = Uri.parse('http://mybudgetbook.in/GIBADMINAPI/subscription.php?table=member_category&district=$districts&chapter=$chapters&member_type=$member_type');
      print("gib members url =$url");
      final response = await http.get(url);
      print("gib members ResponseStatus: ${response.statusCode}");
      print("gib members Response: ${response.body}");
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print("gib members ResponseData: $responseData");

        // Filter out members with member_type "Guest" and "Non-Executive"
        final List<dynamic> itemGroups = responseData.where((item) {
          return item['member_type'] != 'Guest' && item['member_type'] != 'Non-Executive';
        }).toList();

        setState(() {
          categoryData = itemGroups.cast<Map<String, dynamic>>();
        });
        print('gib members Data: $categoryData');
      } else {
        print('Error: ${response.statusCode}');
      }
      print('HTTP request completed. Status code: ${response.statusCode}');
    } catch (e) {
      print('Error making HTTP request: $e');
      throw e; // rethrow the error if needed
    }
  }

  Future<void> dataStroetoSubscription () async {
    try {
      String url = "http://mybudgetbook.in/GIBADMINAPI/subscription.php?table=AddMember";
      print("store url :$url");
      DateTime subscription = DateFormat('dd/MM/yyyy').parse(subscriptiondate.text);
      // Format the parsed dates to "yyyy-MM-dd" format
      String subscriptionFormatted = DateFormat('yyyy-MM-dd').format(subscription);

      var res = await http.post(Uri.parse(url),
          body: jsonEncode( {
            "member_id": memberID.toString(),
            "member_name": member_name.toString(),
            "subscribe_date":subscriptionFormatted,
            "due_date": dueDateController.text,
            "member_type":membertype.text.trim(),
            "member_category":membercategory.text.trim(),
            "subscription_amount":subscriptionamount.text.trim(),
          })
      );
      if (res.statusCode == 200) {
        print(url);
        print("store Status: ${res.statusCode}");
        print("store Body: ${res.body}");
        var response = jsonDecode(res.body);
        //Navigator.push(context, MaterialPageRoute(builder: (context)=>const SubscriptionPage()));
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Subscription Submitted Successfully ")));
        print("Subscription Server response: ${response["message"]}");

      } else {
        print("Failed to Subscription Server returned status code: ${res.statusCode}");
      }
    } catch (e) {
      print("Error Subscription: $e");
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    getMembers();
    getfromyear();
    getDistrict();
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        showDetails = true;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      route: "/SetPersonSubscription",
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.green.withOpacity(0.5),
                      spreadRadius: 3,
                      blurRadius: 7,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                    if (members.text.isNotEmpty)
                      Align(
                        alignment: Alignment.topLeft,
                        child: AnimatedContainer(
                          duration: Duration(seconds: 1),
                          padding: const EdgeInsets.all(16.0),
                          margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: Offset(0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          child: AnimatedOpacity(
                            opacity: showDetails ? 1.0 : 0.0,
                            duration: Duration(seconds: 1),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Align(
                                        alignment: Alignment.topRight,
                                        child: Icon(
                                          Icons.person,
                                          color: Colors.green,
                                          size: 30.0,
                                        ),
                                      ),
                                      Text(
                                        "GiB ID: $memberID",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Row(children: [
                                  const Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                    Text("Name"),
                                    SizedBox(height: 5,),
                                    Text("Contact"),
                                    SizedBox(height: 5,),
                                    Text("Current Type"),
                                  ],),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                    Text(
                                      " : ${memberDetails["first_name"] ?? ""} ${memberDetails["last_name"] ?? ""}",
                                      style: TextStyle(
                                        fontSize: 16.0,
                                      ),
                                    ),
                                      SizedBox(height: 5,),
                                    Text(
                                      " : ${memberDetails["mobile"] ?? ""}",
                                      style: TextStyle(
                                        fontSize: 16.0,
                                      ),
                                    ),
                                      SizedBox(height: 5,),
                                    Text(
                                      " : ${memberDetails["member_type"] ?? ""} - ${memberDetails["member_category"] ?? ""}",
                                      style: TextStyle(
                                        fontSize: 16.0,
                                      ),
                                    ),
                                  ],)
                                ],),
                              ],
                            ),
                          ),
                        ),
                      )
                    else
                      Container(),
                    Align(
                      alignment: Alignment.topRight,
                      child: Row(children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            width: 250,
                            height: 50,
                            // height: ,
                            child:TypeAheadFormField<Map<String, dynamic>>(
                              textFieldConfiguration: TextFieldConfiguration(
                                controller: fromyear,
                                style: const TextStyle(fontSize: 14),
                                decoration: const InputDecoration(
                                  fillColor: Colors.white,
                                  filled: true,
                                  labelText: "Accounting year",
                                  suffixIcon: Icon(
                                    Icons.local_convenience_store_outlined,
                                    color: Colors.green,
                                  ),
                                ),
                              ),
                              suggestionsCallback: (pattern) async {
                                final DateFormat formatter = DateFormat.yMMMM(); // Formatter for month and year
                                final Set<String> seenSuggestions = {};
                                final List<Map<String, dynamic>> uniqueSuggestions = [];
                                for (var item in getyear) {
                                  final fromYearOriginal = item['from_year'];
                                  final toYearOriginal = item['to_year'];
                                  final fromYearFormatted = formatter.format(DateTime.parse(fromYearOriginal));
                                  final toYearFormatted = formatter.format(DateTime.parse(toYearOriginal));
                                  final suggestion = {
                                    'from_year_original': fromYearOriginal,
                                    'to_year_original': toYearOriginal,
                                    'from_year_formatted': fromYearFormatted,
                                    'to_year_formatted': toYearFormatted,
                                  };
                                  final suggestionString = '${fromYearFormatted}-${toYearFormatted}';
                                  if (fromYearFormatted.toLowerCase().startsWith(pattern.toLowerCase()) && !seenSuggestions.contains(suggestionString)) {
                                    seenSuggestions.add(suggestionString);
                                    uniqueSuggestions.add(suggestion);
                                  }
                                }
                                return uniqueSuggestions;
                              },
                              itemBuilder: (context, suggestion) {
                                return ListTile(
                                  title: Text('${suggestion['from_year_formatted']} - ${suggestion['to_year_formatted']}'),
                                );
                              },
                              onSuggestionSelected: (suggestion) {
                                setState(() {
                                  fromyear.text = '${suggestion['from_year_formatted']} - ${suggestion['to_year_formatted']}';
                                  // Set the original from_year value in the toyear text field
                                  toyear.text = suggestion['from_year_original'];
                                  print(toyear.text);
                                });
                              },
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 250,
                          child: TypeAheadFormField<Map<String, dynamic>>(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "* Select the Member Type ";
                              } else {
                                return null;
                              }
                            },
                            textFieldConfiguration: TextFieldConfiguration(
                              style: TextStyle(fontSize: 14),
                              onChanged: (value) {
                                String capitalizedValue = capitalizeFirstLetter(value);
                                members.value = members.value.copyWith(
                                  text: capitalizedValue,
                                );
                              },
                              controller: members,
                              decoration: const InputDecoration(
                                fillColor: Colors.white,
                                filled: true,
                                labelText: "Members",
                                suffixIcon: Icon(
                                  Icons.person_search_outlined,
                                  color: Colors.green,
                                ),
                              ),
                            ),
                            suggestionsCallback: (pattern) async {
                              return membersData
                                  .where((item) =>
                              (item['first_name']?.toString().toLowerCase() ?? '')
                                  .startsWith(pattern.toLowerCase()) ||
                                  (item['last_name']?.toString().toLowerCase() ?? '')
                                      .startsWith(pattern.toLowerCase()) ||
                                  (item['member_id']?.toString().toLowerCase() ?? '')
                                      .startsWith(pattern.toLowerCase()))
                                  .toList();
                            },
                            itemBuilder: (context, suggestion) {
                              return ListTile(
                                title: Text(
                                    '${suggestion['member_id']} - ${suggestion['first_name']} ${suggestion['last_name']}'),
                              );
                            },
                            onSuggestionSelected: (suggestion) async {
                              setState(() {
                                members.text = '${suggestion['member_id']} - ${suggestion['first_name']} ${suggestion['last_name']}';
                                selectgibid=suggestion['member_id'];
                                print("mmeber_idoo :$selectgibid");
                                getMemberDetails(selectgibid.toString());
                              });
                            },
                          ),
                        ),
                      ],),
                    ),
                  ],),

                  const SizedBox(height: 20,),
                  Wrap(
                    runSpacing: 20,
                    spacing: 10,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: 250,
                          child: TextFormField(
                              style: TextStyle(fontSize: 14),
                              controller: subscriptiondate,
                              validator: (value) {
                                if(value!.isEmpty){
                                  return "* Select the Subscription date";
                                }else{
                                  return null;
                                }
                              },
                              onTap: ()async{
                                DateTime? pickDate = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(1900),
                                    lastDate: DateTime(2100));
                                if(pickDate==null) return;{
                                  setState(() {
                                    subscriptiondate.text =DateFormat('dd/MM/yyyy').format(pickDate);
                                  });
                                }
                              },
                              decoration: const InputDecoration(
                                labelText: "Subscription Date",
                                suffixIcon:
                                Icon(
                                  Icons.calendar_today_outlined,
                                  color: Colors.green,),
                              )

                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: 250,
                          height: 50,
                          // height: ,
                          child: TypeAheadFormField<String>(
                            textFieldConfiguration: TextFieldConfiguration(
                              controller: districtController,
                              style: TextStyle(fontSize: 14),
                              decoration: const InputDecoration(
                                  fillColor: Colors.white,
                                  filled: true,
                                  labelText: "District",
                                  suffixIcon: Icon(Icons.local_convenience_store_outlined,color: Colors.green,)
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
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: 250,
                          height: 50,
                          //  height: 50,
                          child: TypeAheadFormField<String>(
                            textFieldConfiguration: TextFieldConfiguration(
                              controller: chapterController,
                              style: TextStyle(fontSize: 14),
                              decoration: const InputDecoration(
                                fillColor: Colors.white,
                                filled: true,
                                labelText: "Chapter",
                                suffixIcon: const Icon(
                                  Icons.local_convenience_store_rounded,color: Colors.green,),
                              ),
                            ),
                            suggestionsCallback: (pattern) async {
                              return suggesstiondataitemName
                                  .where((item) =>
                                  (item['chapter']?.toString().toLowerCase() ?? '')
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
                                getMemberType(districtController.text,suggestion);
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),

                   // Or SizedBox.shrink() to make it completely invisible
                  const SizedBox(height: 20,),
                  //Subscription Amount & Member Type TextFormField,DropDown Button
                  Wrap(
                    runSpacing: 20,
                    spacing: 10,
                    children: [
                      ///Member Type
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: 250,
                          height: 50,
                          child: TypeAheadFormField<String>(
                            validator: (value) {
                              if(value!.isEmpty){
                                return "* Select the Member Type ";
                              }else{
                                return null;
                              }
                            },
                            textFieldConfiguration: TextFieldConfiguration(
                              controller: membertype,
                              style: TextStyle(fontSize: 14),
                              decoration: const InputDecoration(
                                fillColor: Colors.white,
                                filled: true,
                                labelText: "Member Type",
                                suffixIcon: const Icon(
                                  Icons.card_membership,color: Colors.green,),
                              ),
                            ),
                            suggestionsCallback: (pattern) async {
                              return memberSuggestion
                                  .where((item) =>
                              (item['member_type']?.toString().toLowerCase() ?? '')
                                  .startsWith(pattern.toLowerCase()) &&
                                  item['member_type']?.toString().toLowerCase() != 'non-executive')
                                  .map((item) => item['member_type'].toString())
                                  .toList();
                            },
                            itemBuilder: (context, suggestion) {
                              return ListTile(
                                title: Text(suggestion,style: TextStyle(fontSize: 14),),
                              );

                            },
                            onSuggestionSelected: (suggestion) async {
                              setState(() {
                                membertype?.text = suggestion;
                                getMemberCategory(districtController.text,chapterController.text,suggestion);
                              });
                              //   print('Selected Item Group: $suggestion');
                            },
                          ),
                        ),
                      ),
                      ///Member Category
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: 250,
                          height: 50,
                          child: TypeAheadFormField<String>(
                            validator: (value) {
                              if(value!.isEmpty){
                                return "* Enter the Member Category ";
                              }else{
                                return null;
                              }
                            },
                            textFieldConfiguration: TextFieldConfiguration(
                              style: TextStyle(fontSize: 14),
                              controller: membercategory,
                              decoration: const InputDecoration(
                                fillColor: Colors.white,
                                filled: true,
                                labelText: "Member Category",
                                suffixIcon: const Icon(
                                  Icons.category_outlined,color: Colors.green,),
                              ),
                            ),
                            suggestionsCallback: (pattern) async {
                              return
                                categoryData
                                    .where((item) =>
                                    (item['member_category']?.toString().toLowerCase() ?? '')
                                        .startsWith(pattern.toLowerCase()))
                                    .map((item) => item['member_category'].toString())
                                    .toList();
                            },
                            itemBuilder: (context, suggestion) {
                              return ListTile(
                                title: Text(suggestion,style: TextStyle(fontSize: 14),),
                              );
                            },
                            onSuggestionSelected: (suggestion) async {
                              setState(() {
                                membercategory.text = suggestion;
                                setState(() {
                                  getsubscription(toyear.text,districtController.text,chapterController.text,membertype.text,suggestion);
                                });
                              });
                            },
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: 250,
                          height: 50,
                          child: TextFormField(
                            style: TextStyle(fontSize: 14),
                            controller: subscriptionamount,
                            readOnly: true,
                            validator: (value) {
                              if(value!.isEmpty){
                                return "* Enter the Subscription Amount";
                              }else{
                                return null;
                              }
                            },
                            decoration: const InputDecoration(
                              labelText: "Subscription Amount",
                              suffixIcon: const Icon(
                                Icons.currency_rupee,color: Colors.green,),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30,),

                  Row(
                    mainAxisAlignment:MainAxisAlignment.center ,
                    children: [
                      ElevatedButton(
                        style: OutlinedButton.styleFrom(),
                        onPressed: ()async {
                            dataUpdatetoSubscription();
                            dataStroetoSubscription();
                        },
                        child: const Text('SUBMIT',
                            style:TextStyle(fontSize: 15,color: Colors.white)),
                      ),
                      //ElevatedButton end
                      const SizedBox(width: 15,),
                    ],
                  ),
                  const SizedBox(height: 30,),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
