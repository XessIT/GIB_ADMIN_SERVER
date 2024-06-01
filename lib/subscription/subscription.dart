import 'dart:convert';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:http/http.dart'as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../main.dart';

class Subscription extends StatelessWidget {
  const Subscription({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SubscriptionPage(),
    );
  }
}
class SubscriptionPage extends StatefulWidget {
  const SubscriptionPage({Key? key}) : super(key: key);

  @override
  State<SubscriptionPage> createState() => _SubscriptionPageState();
}
class _SubscriptionPageState extends State<SubscriptionPage> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  //String? membertype;
  String? membercategory;
  String? selectgibid;
  DateTime date =DateTime(2022,22,08);
  TextEditingController subscriptionamount = TextEditingController();
  final TextEditingController fromyear = TextEditingController();
  final TextEditingController toyear = TextEditingController();
  final TextEditingController scheduledate = TextEditingController();
  final TextEditingController warningfrom = TextEditingController();
  final TextEditingController warningto = TextEditingController();
  final TextEditingController mobile = TextEditingController();
  final TextEditingController membertype = TextEditingController();
  final TextEditingController userID = TextEditingController();
  final TextEditingController memberID = TextEditingController();
  final TextEditingController membercategor = TextEditingController();
  TextEditingController districtController = TextEditingController();
  TextEditingController chapterController = TextEditingController();
  ///member type
  List<Map<String, dynamic>> memberData = [];

  Future<void> getMember() async {
    try {
      final url = Uri.parse('http://mybudgetbook.in/GIBADMINAPI/subscription.php?table=member_type');
      print('memeber_type_url :$url');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final List<dynamic> member = responseData;
        print("M-status code :$response.statusCode ");
        print("M-response body :$response.body ");

        setState(() {
          memberData = member.cast<Map<String, dynamic>>();
          print("memberData: $memberData");

        });
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (error) {
        print('Error: $error');
    }
  }

  ///member category
  List<Map<String, dynamic>> data=[];

  Future<void> getData(String districts, String chapters, String member_type, String fromYear, String toYear) async {
    print('Attempting to make HTTP request...');
    try {
      final url = Uri.parse(
          'http://mybudgetbook.in/GIBADMINAPI/add_member_category.php?table=withFilter&district=$districts&chapter=$chapters&member_type=$member_type&from_year=$fromYear&to_year=$toYear');
      print("gib members url =$url");
      final response = await http.get(url);
      print("gib members ResponseStatus: ${response.statusCode}");
      print("gib members Response: ${response.body}");
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print("gib members ResponseData: $responseData");

        if (responseData is List) {
          // Filter out members with member_type "Guest" and "Non-Executive"
          final List<dynamic> itemGroups = responseData.where((item) {
            return item['member_type'] != 'Guest' && item['member_type'] != 'Non-Executive';
          }).toList();

          setState(() {
            data = itemGroups.cast<Map<String, dynamic>>();
          });
          print('gib members Data: $data');
        } else if (responseData is Map && responseData.containsKey('message')) {
          print('Message: ${responseData['message']}');
        } else {
          print('Error: Unexpected response type ${responseData.runtimeType}');
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

  List<Map<String, dynamic>> mobileGetData = [];
  Future<void> getMobileNumber(String mID) async {
    try {
      final url = Uri.parse('http://mybudgetbook.in/GIBADMINAPI/subscription.php?table=registration&member_id=$mID');
      print('register_url :$url');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final List<dynamic> member = responseData;
        print("r-status code :${response.statusCode}");
        print("r-response body :${response.body} ");
        setState(() {
          mobileGetData = member.cast<Map<String, dynamic>>();
          print("mobileData: $mobileGetData");
          print("values get for mobile data ---${mobileGetData[0]['mobile']},${mobileGetData[0]['member_category']},${mobileGetData[0]['member_type']}");


          mobile.text = mobileGetData[0]['mobile'];
          membercategor.text = mobileGetData[0]['member_category'];
          membertype.text = mobileGetData[0]['member_type'];
        });
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  ///member id get
  ///
  List<Map<String, dynamic>> memeberIdGetData = [];
  Future<void> getMemberId() async {
    try {
      final url = Uri.parse('http://mybudgetbook.in/GIBADMINAPI/subscription.php?table=registration');
      print('getMemberId :$url');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final List<dynamic> member = responseData;
        print("getMemberId-status code :$response.statusCode ");
        print("getMemberId-response body :$response.body ");
        setState(() {
          memeberIdGetData = member.cast<Map<String, dynamic>>();
          print("memberData: $memeberIdGetData");
          mobile.clear();
        });
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  /// data store
  Future<void> dataStroetoSubscription () async {
    try {
      String url = "http://mybudgetbook.in/GIBADMINAPI/subscription.php?table=AddSubscription";
      print("store url :$url");
      print("from_year text: ${fromyear.text}");
      print("to_year text: ${toyear.text}");
      DateTime fromDate = DateFormat('dd/MM/yyyy').parse(fromyear.text);
      DateTime toDate = DateFormat('dd/MM/yyyy').parse(toyear.text);
      DateTime schedule = DateFormat('dd/MM/yyyy').parse(scheduledate.text);

      // Format the parsed dates to "yyyy-MM-dd" format
      String fromYearFormatted = DateFormat('yyyy-MM-dd').format(fromDate);
      String toYearFormatted = DateFormat('yyyy-MM-dd').format(toDate);
      String scheduledateformatted = DateFormat('yyyy-MM-dd').format(schedule);

      var res = await http.post(Uri.parse(url),
          body: jsonEncode( {
        "member_category": membercategor.text,
            "from_year": fromYearFormatted,
            "to_year": toYearFormatted,
        "member_type":membertype.text.trim(),
        "subscription_amount":subscriptionamount.text.trim(),
        "schedule_date":scheduledateformatted,
        "district":districtController.text.trim(),
        "chapter":chapterController.text.trim(),
        "current_date": DateTime.now().toIso8601String(), // Convert DateTime to String
      }));
      if (res.statusCode == 200) {
        print(url);
        print("store Status: ${res.statusCode}");
        print("store Body: ${res.body}");
        var response = jsonDecode(res.body);
          Navigator.push(context, MaterialPageRoute(builder: (context)=>const SubscriptionPage()));
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Subscription Submitted Successfully ")));
          print("Subscription Server response: ${response["message"]}");

      } else {
        print("Failed to Subscription Server returned status code: ${res.statusCode}");
      }
    } catch (e) {
      print("Error Subscription: $e");
    }
  }

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



  /// chapter code
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


  @override
  void initState() {
    // TODO: implement initState
    getMember();
    getMemberId();
    getMemberType();//mobile number base fetch a member id
    getDistrict();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return
      MyScaffold(
      route:'/subscription' ,
      body: Form(
        key: _formKey,
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Container(
                 // width: 1500,

                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 3,
                        blurRadius: 7,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Column(
                                children: [
                                const SizedBox(height: 30,),
                                Text("SUBSCRIPTION DETAILS",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,),
                                    //style: Theme.of(context).textTheme.displayLarge,
                                ),
                                const SizedBox(height: 20,),
                                Wrap(
                                  runSpacing: 20,
                                 spacing: 10,
                  children: [

                    SizedBox(
                      width: 350,
                      child: TextFormField(
                        controller: fromyear,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "* Select The From Year";
                          } else {
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
                        decoration: const InputDecoration(
                          labelText: "From Year",
                          suffixIcon: Icon(
                            Icons.calendar_today_outlined,
                            color: Colors.green,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 350,
                      child: TextFormField(
                        controller: toyear,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "* Select the To Year";
                          } else {
                            return null;
                          }
                        },
                        onTap: () async {
                          DateTime initialDate = DateTime.now();
                          DateTime firstDate = DateTime(1900);
                          DateTime lastDate = DateTime(2100);

                          // Calculate the current account year end
                          DateTime now = DateTime.now();
                          DateTime accountYearEnd;
                          if (now.month < 4) {
                            accountYearEnd = DateTime(now.year, 3, 31);
                          } else {
                            accountYearEnd = DateTime(now.year + 1, 3, 31);
                          }

                          DateTime? pickDate = await showDatePicker(
                            context: context,
                            initialDate: accountYearEnd,
                            firstDate: firstDate,
                            lastDate: lastDate,
                          );
                          if (pickDate == null) return;
                          setState(() {
                            toyear.text = DateFormat('dd/MM/yyyy').format(pickDate);
                          });
                        },
                        decoration: const InputDecoration(
                          labelText: "To Year",
                          suffixIcon: Icon(
                            Icons.calendar_today_outlined,
                            color: Colors.green,
                          ),
                        ),
                      ),
                    ),
                    //To Year TextFormField starts
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
                                //Subscription Amount & Member Type TextFormField,DropDown Button
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
                            DateFormat inputFormat = DateFormat('dd/MM/yyyy');
                            DateFormat outputFormat = DateFormat('yyyy-MM-dd');
                            String formattedFromYear = outputFormat.format(inputFormat.parse(fromyear.text));
                            String formattedToYear = outputFormat.format(inputFormat.parse(toyear.text));

                            print("form year : $formattedFromYear & $formattedToYear");
                            getData(districtController.text, chapterController.text, suggestion, formattedFromYear, formattedToYear);
                            print("member_category--: $data");
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
                            return "* Enter the Member Category ";
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
                            suffixIcon: const Icon(
                            Icons.category_outlined,color: Colors.green,),
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
                           suffixIcon: const Icon(
                            Icons.currency_rupee,color: Colors.green,),
                        ),
                      ),
                    ),

                   //schedule date
                    SizedBox(width: 350,
                      child: TextFormField(
                        controller: scheduledate,
                        validator: (value) {
                          if(value!.isEmpty){
                            return "* Select the Schedule date Field";
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
                            labelText: "Schedule date",
                            suffixIcon: const Icon(
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

                  //ElevatedButton starts
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      style: OutlinedButton.styleFrom(),
                      onPressed: ()async{
                        if(_formKey.currentState!.validate()){
                          dataStroetoSubscription();
                        }
                      },
                      child: const Text('SUBMIT',
                          style:TextStyle(fontSize: 15,color: Colors.white)),
                    ),
                  ),
                  //ElevatedButton end
                  //OutlinedButton end
                                    ],
                                  ),
                                ],),
                ),
              )
            ],

          ),
        ),
      ),
    );
  }
}
