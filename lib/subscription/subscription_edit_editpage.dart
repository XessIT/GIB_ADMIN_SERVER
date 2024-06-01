import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:gibadmin/main.dart';
import 'package:gibadmin/subscription/subscription_edit_delete.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart'as http;

class SubscriptionEditPage extends StatefulWidget {
  final String? id;
  final String? currentfromyear;
  final String? currenttoyear;
  final String? currentmembertype;
  final String? currentmembercategory;
  final String? currentsubscriptionamount;
  final String? currentscheduledate;
  final String? currentdistrict;
  final String? currentchapter;

  const SubscriptionEditPage({Key? key,
    required this.id,
    required this.currentfromyear,
    required this.currenttoyear,
    required this.currentmembertype,
    required this.currentmembercategory,
    required this.currentsubscriptionamount,
    required this.currentscheduledate,
    required this.currentdistrict,
    required this.currentchapter
  }) : super(key: key);

  @override
  State<SubscriptionEditPage> createState() => _SubscriptionEditPageState();
}

class _SubscriptionEditPageState extends State<SubscriptionEditPage> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? docid;
  String? membercategory;
  DateTime date =DateTime(2022,22,08);
  TextEditingController subscriptionamount = TextEditingController();
  TextEditingController fromyear = TextEditingController();
  TextEditingController toyear = TextEditingController();
  TextEditingController scheduledate = TextEditingController();
  TextEditingController warningfrom = TextEditingController();
  TextEditingController warningto = TextEditingController();
  TextEditingController membertype = TextEditingController();
  TextEditingController membercategor = TextEditingController();
  TextEditingController districtController = TextEditingController();
  TextEditingController chapterController = TextEditingController();

  @override
  void initState() {
    docid = widget.id;
    membertype.text = widget.currentmembertype!;
    membercategory = widget.currentmembercategory;
    subscriptionamount = TextEditingController(text: widget.currentsubscriptionamount);
    fromyear = TextEditingController(text: widget.currentfromyear);
    toyear = TextEditingController(text: widget.currenttoyear);
    scheduledate = TextEditingController(text: widget.currentscheduledate);
    warningfrom = TextEditingController(text: widget.currentdistrict);
    warningto = TextEditingController(text: widget.currentchapter);
    membertype.text = widget.currentmembertype!;
    membercategor.text = widget.currentmembercategory!;
    getMemberType();
    getMemberCategory();
    getDistrict();
    super.initState();
  }

  ///member type
  List<Map<String, dynamic>> memberSuggestion = [];
  Future<void> getMemberType() async {
    try {
      final url = Uri.parse('http://mybudgetbook.in/GIBADMINAPI/member_type.php');
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

  ///member category
  List<Map<String, dynamic>> categoryData = [];
  Future<void> getMemberCategory() async {
    try {
      final url = Uri.parse('http://mybudgetbook.in/GIBADMINAPI/subscription.php?table=member_category');
      print('member_category_url :$url');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final List<dynamic> member = responseData;
        print("Cat-status code :${response.statusCode}");
        print("Cat-response body :${response.body}");

        setState(() {
          categoryData = member.cast<Map<String, dynamic>>();
          print("member_category--: $categoryData");

        });
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<void> dataUpdatetoSubscription() async {
    try {
      String url = "http://mybudgetbook.in/GIBADMINAPI/subscription.php?table=chapter";
      print("put url: $url");
      DateTime fromDate = DateFormat('dd/MM/yyyy').parse(fromyear.text);
      DateTime toDate = DateFormat('dd/MM/yyyy').parse(toyear.text);
      DateTime schedule = DateFormat('dd/MM/yyyy').parse(scheduledate.text);

      // Format the parsed dates to "yyyy-MM-dd" format
      String fromYearFormatted = DateFormat('yyyy-MM-dd').format(fromDate);
      String toYearFormatted = DateFormat('yyyy-MM-dd').format(toDate);
      String scheduledateformatted = DateFormat('yyyy-MM-dd').format(schedule);
      var res = await http.put(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },

        body: jsonEncode({
          "from_year": fromYearFormatted,
          "to_year": toYearFormatted,
          "member_type": membertype.text.trim(),
          "member_category": membercategor.text.trim(),
          "subscription_amount": subscriptionamount.text.trim(),
          "schedule_date": scheduledateformatted,
          "district": districtController.text.trim(),
          "chapter": chapterController.text.trim(),
          'id': widget.id,
        }),
      );

      if (res.statusCode == 200) {
        print(url);
        print("put Status: ${res.statusCode}");
        print("put Body: ${res.body}");
        var response = jsonDecode(res.body);

        if (response.containsKey("message")) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SubcriptionEditDelete()),
          );
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


  List<Map<String, dynamic>> suggesstiondata = [];
  List district = [];
  Future<void> getDistrict() async {
    try {
      final url = Uri.parse('http://localhost/GIBAPI/district.php');
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


  List<String> chapters = [];
  List<Map<String, dynamic>> suggesstiondataitemName = [];
  Future<void> getchapter(String district) async {
    try {
      final url = Uri.parse('http://localhost/GIBAPI/chapter.php?district=$district'); // Fix URL
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
          setState(() {
          });
          chapterController.clear();
        });
      } else {
        print('chapter Error: ${response.statusCode}');
      }
    } catch (error) {
      print(' chapter Error: $error');
    }
  }


  ///member category
  List<Map<String, dynamic>> data=[];

  Future<void> getData(String districts, String chapters, String member_type) async {
    print('Attempting to make HTTP request...');
    try {
      final url = Uri.parse('http://mybudgetbook.in/GIBADMINAPI/add_member_category.php?table=withFilter&district=$districts&chapter=$chapters&member_type=$member_type');
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
          data = itemGroups.cast<Map<String, dynamic>>();
        });
        print('gib members Data: $data');
      } else {
        print('Error: ${response.statusCode}');
      }
      print('HTTP request completed. Status code: ${response.statusCode}');
    } catch (e) {
      print('Error making HTTP request: $e');
      throw e; // rethrow the error if needed
    }
  }


  @override
  Widget build(BuildContext context) {
    return MyScaffold(route: "/subscription_edit_page", body: Center(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
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
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 20,),
                      const Text("SUBSCRIPTION EDIT",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,)),
                      const SizedBox(height: 20,),
                      Wrap(
                        runSpacing: 20,
                        spacing: 10,
                      //  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          //from Year Starts Textformfield
                          SizedBox(
                            width: 350,
                            child: TextFormField(
                                controller: fromyear,
                                validator: (value) {
                                  if(value!.isEmpty){
                                    return "* Select a From Year";
                                  }else{
                                    return null;
                                  }
                                },
                                onTap: () async {
                                  DateTime initialDate = DateTime.now();
                                  DateTime firstDate = DateTime(1900);
                                  DateTime lastDate = DateTime(2100);

                                  // Calculate the current account year start
                                  DateTime now = DateTime.now();
                                  DateTime accountYearStart;
                                  if (now.month < 4) {
                                    accountYearStart = DateTime(now.year - 1, 4, 1);
                                  } else {
                                    accountYearStart = DateTime(now.year, 4, 1);
                                  }

                                  DateTime? pickDate = await showDatePicker(
                                    context: context,
                                    initialDate: accountYearStart,
                                    firstDate: firstDate,
                                    lastDate: lastDate,
                                  );
                                  if (pickDate == null) return;
                                  setState(() {
                                    fromyear.text = DateFormat('dd/MM/yyyy').format(pickDate);
                                  });
                                },
                                //pickDate From Year
                                decoration:  InputDecoration(
                                  labelText: "From Year",
                                  suffixIcon:const Icon(
                                      Icons.calendar_today_outlined,
                                    color: Colors.green,),
                                )
                            ),
                          ),
                          //from Year end Textformfield
                          //To Year Starts Textformfield
                          SizedBox(
                            width: 350,
                            child: TextFormField(
                                controller: toyear,
                                validator: (value) {
                                  if(value!.isEmpty){
                                    return "* Select a To Year";
                                  }else{
                                    return null;
                                  }},

                                //pickDate From Year
                                decoration:  const InputDecoration(
                                  labelText: "To Year",
                                  suffixIcon:  Icon(
                                      Icons.calendar_today_outlined,
                                    color: Colors.green,),
                                )
                            ),
                          ),
                          //To Year ends Textformfield
                        ],
                      ),
                      const SizedBox(height: 20,),
                      Wrap(
                        runSpacing: 20,
                        spacing: 10,
                        children: [
                          SizedBox(
                            width: 350,
                            // height: ,
                            child: TypeAheadFormField<String>(
                              textFieldConfiguration: TextFieldConfiguration(
                                controller: districtController,
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
                                    getchapter(districtController.text.trim());

                                  });
                                });
                                //   print('Selected Item Group: $suggestion');
                              },
                            ),
                          ),

                          SizedBox(
                            width: 350,
                            //  height: 50,
                            child: TypeAheadFormField<String>(
                              textFieldConfiguration: TextFieldConfiguration(
                                controller: chapterController,
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
                                });
                              },
                            ),
                          ),

                        ],
                      ),
                      const SizedBox(height: 20,),
                      Wrap(
                        runSpacing: 20,
                        spacing: 10,
                        children: [
                          //dropdown button
                          ///Member Type
                          SizedBox(
                            width: 350,
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
                                  title: Text(suggestion),
                                );
                              },
                              onSuggestionSelected: (suggestion) async {
                                setState(() {
                                  membertype?.text = suggestion;
                                  getData(districtController.text, chapterController.text,suggestion );
                                });
                                //   print('Selected Item Group: $suggestion');
                              },
                            ),
                          ),
                          ///Member Category
                          SizedBox(
                            width: 350,
                            child: TypeAheadFormField<String>(
                              validator: (value) {
                                if(value!.isEmpty){
                                  return "* Select the Member Category";
                                }else{
                                  return null;
                                }
                              },
                              textFieldConfiguration: TextFieldConfiguration(
                                controller: membercategor,
                                decoration: const InputDecoration(
                                    fillColor: Colors.white,
                                    filled: true,
                                    labelText: "Member Category",
                                    suffixIcon: Icon(Icons.category_outlined,color: Colors.green,)
                                ),
                              ),
                              suggestionsCallback: (pattern) async {
                                return
                                  data
                                      .where((item) =>
                                      (item['member_category']?.toString().toLowerCase() ?? '')
                                          .startsWith(pattern.toLowerCase()))
                                      .map((item) => item['member_category'].toString())
                                      .toList();
                              },
                              itemBuilder: (context, suggestion) {
                                return ListTile(
                                  title: Text(suggestion),
                                );
                              },
                              onSuggestionSelected: (suggestion) async {
                                setState(() {
                                  membercategor.text = suggestion;
                                  setState(() {
                                  });
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      //schedule Date & Waring From Text
                      const SizedBox(height: 20,),
                      //schedule Date & Waring From TextForm Field

                      Wrap(
                        runSpacing: 20,
                        spacing: 10,
                        //  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          //Subscription Amount TextFormField starts
                          SizedBox(width:350,
                            child: TextFormField(
                              controller: subscriptionamount,
                              validator: (value) {
                                if(value!.isEmpty){
                                  return "* Enter the Subscription Amount";
                                }else{
                                  return null;
                                }
                              },
                              decoration: const InputDecoration(
                                  labelText: "Subscription Amount",
                                suffixIcon: Icon(Icons.currency_rupee,color: Colors.green,)
                              ),
                            ),
                          ),

                          //schedule date
                          SizedBox(width: 350,
                            child: TextFormField(
                                controller: scheduledate,
                                validator: (value) {
                                  if(value!.isEmpty){
                                    return "* Select the schedule date";
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
                                      scheduledate.text =DateFormat('dd/MM/yyyy').format(pickDate);
                                    });
                                  }
                                },
                                decoration:  InputDecoration(
                                  labelText: "schedule date",
                                  suffixIcon:
                                  const Icon(
                                      Icons.calendar_today_outlined,
                                    color: Colors.green,),
                                )
                            ),
                          ),

                          // const SizedBox(width: 20,),
                        ],
                      ),

                      const SizedBox(height: 30,),

                      Row(
                        mainAxisAlignment:MainAxisAlignment.center ,
                        children: [
                          ElevatedButton(
                            style: OutlinedButton.styleFrom(),
                            onPressed: ()async {
                              if(_formKey.currentState!.validate()){
                                dataUpdatetoSubscription();
                              }
                            },
                            child: const Text('SUBMIT',
                                style:TextStyle(fontSize: 15,color: Colors.white)),
                          ),
                          //ElevatedButton end
                          const SizedBox(width: 15,),
                        ],
                      ),
                      const SizedBox(height: 40,),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    ));
  }
}

