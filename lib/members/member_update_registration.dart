


import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:gibadmin/main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart'as http;

import 'new_member_registration.dart';
//update_prodile.php
class UpdateRegisterationPage extends StatefulWidget {

  final String? currentID;

  const UpdateRegisterationPage({Key? key,
    required this.currentID,

  }) : super(key: key);



  @override
  State<UpdateRegisterationPage> createState() => _UpdateRegisterationPageState();
}

class _UpdateRegisterationPageState extends State<UpdateRegisterationPage> {

  static final RegExp nameRegExp = RegExp('[a-zA-Z]');


  TextEditingController firstnamecontroller = TextEditingController();
  TextEditingController lastnamecontroller = TextEditingController();
  TextEditingController skovilcontroller = TextEditingController();
  TextEditingController membercontroller = TextEditingController();
  TextEditingController locationcontroller = TextEditingController();
  TextEditingController bloodcontroller = TextEditingController();
  TextEditingController kovilcontroller = TextEditingController();
  TextEditingController mobilecontroller = TextEditingController();
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController spousenamecontroller = TextEditingController();
  TextEditingController spousenativecontroller = TextEditingController();
  TextEditingController spousekovilcontroller = TextEditingController();
  TextEditingController educationcontroller = TextEditingController();
  TextEditingController pastexpcontroller = TextEditingController();
  TextEditingController districtController = TextEditingController();
  TextEditingController chapterController = TextEditingController();
  String businesstype = "Business Type";
  String? status;
  TextEditingController businesskeywordscontroller = TextEditingController();
  TextEditingController websitecontroller = TextEditingController();
  TextEditingController yearcontroller = TextEditingController();
  TextEditingController companynamecontroller = TextEditingController();
  TextEditingController companyaddresscontroller = TextEditingController();
  TextEditingController role = TextEditingController();
  TextEditingController membertype = TextEditingController();



  List<Map<String,dynamic>>data=[];

  ///capital letter starts code
  String capitalizeFirstLetter(String text) {
    if (text.isEmpty) return text;
    return text.substring(0, 1).toUpperCase() + text.substring(1);
  }
  bool depVisible=false;
  @override
  void initState() {
    setState(() {
      userID = widget.currentID.toString();
      fetchData(widget.currentID.toString());
      getRole();
    });
    getMemberType();
    super.initState();
  }


  final RegExp _alphabetPattern = RegExp(r'^[a-zA-Z]+$');

  String? selectedDistrict;
  String? selectedChapter;
  String blood = "Blood Group";
  String gender = "Gender";
  String koottam = "Koottam";
  String spousekoottam = "Spouse Father Koottam";
  String userID="";
  List dynamicdata=[];
  bool guestVisibility = false;

  Future<void> fetchData(String userId) async {
    try {
      final url = Uri.parse('http://mybudgetbook.in/GIBAPI/registration.php?table=registration&id=$userId');
      final response = await http.get(url);
      print("fetch url: $url");

      if (response.statusCode == 200) {
        print("fetch status code: ${response.statusCode}");
        print("fetch body: ${response.body}");

        final responseData = json.decode(response.body);
        if (responseData is List<dynamic>) {
          setState(() {
            dynamicdata = responseData.cast<Map<String, dynamic>>();
            if (dynamicdata.isNotEmpty) {
              final data = dynamicdata[0];
              setState(() {
                firstnamecontroller.text = data["first_name"] ?? '';
                lastnamecontroller.text = data['last_name'] ?? '';
                locationcontroller.text = data["place"] ?? '';
                _dobdate.text = data["dob"] ?? '';
                districtController.text = data["district"] ?? '';
                mobilecontroller.text = data["mobile"] ?? '';
                chapterController.text = data["chapter"] ?? '';
                kovilcontroller.text = data["kovil"] ?? '';
                emailcontroller.text = data["email"] ?? '';
                spousenamecontroller.text = data["s_name"] ?? '';
                companynamecontroller.text = data["company_name"] ?? '';
                companyaddresscontroller.text = data["company_address"] ?? '';
                _waddate.text = data["WAD"] ?? '';
                spousekovilcontroller.text = data["s_father_kovil"] ?? '';
                educationcontroller.text = data["education"] ?? '';
                pastexpcontroller.text = data["past_experience"] ?? '';
                membertype.text = data["member_type"] ?? '';
                gender = data["gender"] ?? '';
                koottam = data["koottam"] ?? '';
                spousekoottam = data["s_father_koottam"] ?? '';
                blood = data["blood_group"] ?? '';
                businesskeywordscontroller.text = data["business_keywords"] ?? '';
                businesstype = data["business_type"] ?? '';
                websitecontroller.text = data["website"] ?? '';
                yearcontroller.text = data["b_year"] ?? '';
                status = data["marital_status"] ?? '';
                spousenativecontroller.text = data["native"] ?? '';
                role.text = data['role'] ?? '';

                String profileImage = data["profile_image"] ?? '';
                if (profileImage.isNotEmpty) {
                  imageUrl = 'http://mybudgetbook.in/GIBAPI/$profileImage';
                } else {
                  imageUrl = 'default_image_url'; // Set to a default image URL or handle accordingly
                }
                print("Raw image: $profileImage");
                print("image: $imageUrl");
              });
            }
          });
        } else {
          // Handle invalid response data (not a List)
          print('Invalid response data format');
        }
      } else {
        // Handle non-200 status code
        print('Error: ${response.statusCode}');
      }
    } catch (error) {
      // Handle other errors
      print('Error: $error');
    }
  }

  Future updatedetails() async {
    setState(() {
      if(status == "Married"){
        spousenamecontroller.text;
        spousenativecontroller.text;
        spousekovilcontroller.text;
        spousekoottam.toString();
      }
      else {
        spousenamecontroller.clear();
        spousenativecontroller.clear();
        spousekoottam="Spouse Father Koottam";
        spousekovilcontroller.clear();

      }
    });

    try {
      final url = Uri.parse('http://mybudgetbook.in/GIBAPI/update_profile.php');
      print("edit url:$url");
      final response = await http.post(
        url,
        body: {
          'first_name': firstnamecontroller.text,
          'mobile': mobilecontroller.text,
          'last_name': lastnamecontroller.text,
          'district': districtController.text,
          'chapter': chapterController.text,
          'place': locationcontroller.text,
          'dob': _dobdate.text,
          'WAD': _waddate.text,
          'koottam': koottam.toString(),
          'kovil': kovilcontroller.text,
          'blood_group': blood.toString(),
          'email': emailcontroller.text,
          's_name': spousenamecontroller.text,
          'native': spousenativecontroller.text,
          's_father_koottam': spousekoottam.toString(),
          's_father_kovil':spousekovilcontroller.text,
          'education': educationcontroller.text,
          'past_experience': pastexpcontroller.text,
          "company_name":companynamecontroller.text,
          "company_address":companyaddresscontroller.text,
          "website":websitecontroller.text,
          "business_keywords":businesskeywordscontroller.text,
          'business_type':businesstype.toString(),
          'marital_status':status.toString(),
          "b_year":yearcontroller.text,
          'member_type':membertype.text,
          'gender':gender.toString(),
          'role':role.text.trim(),
          'id': widget.currentID,
        },
      );

      print("edit body:${response.body}");

      if (response.statusCode == 200) {
        print("edit status code:${response.statusCode}");
        print("edit check body:${response.body}");


        print('User updated successfully');
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => UpdateRegisterationPage(currentID: widget.currentID,)),
        );
      } else {
        // Error handling, e.g., show an error message
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      // Handle network or server errors
      print('Error making HTTP request: $e');
    }
  }


  String category = 'Business';
  var categorylist = ['Business','Service'];

  final _formKey = GlobalKey<FormState>();

  DateTime date =DateTime.now();
  late TextEditingController _dobdate = TextEditingController();
  late TextEditingController _waddate = TextEditingController();
  String imageUrl = "";
  bool showLocalImage = false;
  File? pickedimage;
  pickImageFromGallery() async {
    ImagePicker imagepicker = ImagePicker();
    XFile? file = await imagepicker.pickImage(source: ImageSource.gallery);
    showLocalImage = true;
    print('${file?.path}');
    pickedimage = File(file!.path);
    setState(() {
    });
    if(file == null) return;
    String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();

  }


  String Email = "";
  @override
  void dispose() {
    emailcontroller.dispose();
    super.dispose();
  }


  ///district code
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
  Future<void> getChapter(String district) async {
    try {
      final url = Uri.parse('http://mybudgetbook.in/GIBADMINAPI/chapter.php?district=$district'); // Fix URL
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



  ///getRole
  List<Map<String, dynamic>> roleget = [];
  Future<void> getRole() async {
    try {
      final url = Uri.parse('http://mybudgetbook.in/GIBADMINAPI/add_member_role.php');
      final response = await http.get(url);
      print("role URL:$url");
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print("role response status code:${response.statusCode}");
        print("role response body:${response.body}");

        final List<dynamic> itemGroups = responseData;
        setState(() {
          roleget = itemGroups.cast<Map<String, dynamic>>();
        });
      } else {
      }
    } catch (error) {
      //  print('Error: $error');
    }
  }

  Future<void> Edit() async {
    setState(() {
      if (status != "Married") {
        spousenamecontroller.clear();
        spousenativecontroller.clear();
        spousekoottam = "Spouse Father Koottam";
        spousekovilcontroller.clear();
      }
    });
    try {
      final url = Uri.parse('http://mybudgetbook.in/GIBADMINAPI/member_update_registration.php');
      // final url = Uri.parse('http://192.168.29.129/API/offers.php');
      final response = await http.put(
        url,
        body: jsonEncode({
          'first_name': firstnamecontroller.text,
          'mobile': mobilecontroller.text,
          'last_name': lastnamecontroller.text,
          'district': districtController.text,
          'chapter': chapterController.text,
          'place': locationcontroller.text,
          'dob': _dobdate.text,
          'WAD': _waddate.text,
          'koottam': koottam.toString(),
          'member_type': membertype.text,
          'gender': gender.toString(),
          'kovil': kovilcontroller.text,
          'blood_group': blood.toString(),
          'email': emailcontroller.text,
          's_name': spousenamecontroller.text,
          'native': spousenativecontroller.text,
          's_father_koottam': spousekoottam.toString(),
          's_father_kovil': spousekovilcontroller.text,
          'education': educationcontroller.text,
          'past_experience': pastexpcontroller.text,
          'marital_status': status.toString(),
          'id': widget.currentID,
          "company_name": companynamecontroller.text,
          "company_address": companyaddresscontroller.text,
          "website": websitecontroller.text,
          "b_year": yearcontroller.text,
          "business_keywords": businesskeywordscontroller.text,
          "business_type": businesstype,
        }),
      );
      print(url);
      print("ResponseStatus: ${response.statusCode}");
      if (response.statusCode == 200) {
        print("Offers response: ${response.body}");
        Navigator.push(context, MaterialPageRoute(builder: (context)=>const NewMemberRegistration()));
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Profile Successfully Updated")));
      } else {
        print("Error: ${response.statusCode}");
      }
    } catch (e) {
      print("Error during signup: $e");
      // Handle error as needed
    }
  }
  List<Map<String, dynamic>> memberSuggestion = [];
  Future<void> getMemberType() async {
    try {
      final url = Uri.parse('http://mybudgetbook.in/GIBADMINAPI/subscription.php?table="member_type"');
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

  @override
  Widget build(BuildContext context) {
    status=="Married"?
    depVisible = true :depVisible = false;
    getDistrict();

    return MyScaffold(
      route: "/updateregisterationpage",
           body: SingleChildScrollView(
        child: Center(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
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
                    const SizedBox(height: 10,),
                    Text('Update Profile',
                      style: Theme.of(context).textTheme.headlineMedium,),

                    const SizedBox(height: 20,),
                    InkWell(
                      child: CircleAvatar(
                        backgroundImage:NetworkImage(imageUrl),
                        radius: 50,
                      ),
                      onTap: () {
                        showModalBottomSheet(context: context, builder: (ctx){
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                leading: const Icon(Icons.camera_alt),
                                title: const Text("With Camera"),
                                onTap: () async {
                                  // pickImageFromCamera();
                                  Navigator.of(context).pop();
                                },
                              ),
                              ListTile(
                                leading: const Icon(Icons.storage),
                                title: const Text("From Gallery"),
                                onTap: () {
                                  pickImageFromGallery();
                                  //  pickImageFromDevice();
                                  Navigator.of(context).pop();
                                },
                              )
                            ],
                          );
                        });
                      },
                    ),
                  Wrap(
                    runAlignment: WrapAlignment.spaceBetween,
                    children: [
                      //first name
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: 300,
                          child: TextFormField(
                            controller: firstnamecontroller,
                            validator: (value){
                              if (value!.isEmpty) {
                                return '* Enter your First Name';
                              } else if(nameRegExp.hasMatch(value)){
                                return null;
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              labelText: "First Name",
                              // hintText: name!,
                            ),),
                        ),
                      ),
                      //last name
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: 300,
                          child: TextFormField(
                            controller: lastnamecontroller,
                            validator: (value){
                              if (value!.isEmpty) {
                                return '* Enter your Last Name';
                              } else if(nameRegExp.hasMatch(value)){
                                return null;
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              labelText: "Last Name",
                              // hintText: name!,
                            ),),
                        ),
                      ),
                      //company name
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: 300,
                          child: TextFormField(
                            controller: companynamecontroller,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return '* Enter your Company Name/Occupation';
                              } else if (_alphabetPattern.hasMatch(value)) {
                                return null;
                              }
                              return null;
                            },
                            onChanged: (value) {
                              String capitalizedValue = capitalizeFirstLetter(value);
                              companynamecontroller.value = companynamecontroller.value.copyWith(
                                text: capitalizedValue,
                                selection: TextSelection.collapsed(offset: capitalizedValue.length),
                              );
                            },
                            decoration: const InputDecoration(
                              labelText: "Company Name/Occupation",
                              hintText: "Company Name/Occupation",
                              suffixIcon: Icon(Icons.business),
                            ),
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(20),
                            ],
                          ),
                        ),
                      ),
                      //email
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: 300,
                          child: TextFormField(
                            controller: emailcontroller,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Enter your Email Address';
                              }
                              // Check if the entered email has the right format
                              if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                                return 'Enter a valid Email Address';
                              }
                              // Return null if the entered email is valid
                              return null;
                            },
                            decoration:  const InputDecoration(
                              labelText: "Email",
                              // hintText: email!,
                            ),),
                        ),
                      ),
                      //mobile
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: 300,
                          child: TextFormField(
                            controller: mobilecontroller,
                            validator: (value){
                              if (value!.isEmpty) {
                                return '* Enter your Mobile Number';
                              } else if(nameRegExp.hasMatch(value)){
                                return null;
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              labelText: "Mobile Number",
                              //  hintText: mobile!,
                              suffixIcon: Icon(Icons.phone_android),
                            ),
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(10)
                            ],
                          ),
                        ),
                      ),
                      //blood
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                         width: 300,
                         // height: 54,
                         // padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 4),
                          child: DropdownButtonFormField<String>(
                            value: blood,
                            hint: Text("Blood Group"),
                            icon: const Icon(Icons.arrow_drop_down),
                            isExpanded: true,
                            items: <String>["Blood Group","A+", "A-", "A1+", "A1-", "A2+", "A2-", "A1B+", "A1B-", "A2B+", "A2B-", "AB+", "AB-", "B+", "B-", "O+", "O-", "BBG", "INRA"]
                                .map<DropdownMenuItem<String>>((String Value) {
                              return DropdownMenuItem<String>(
                                  value: Value,
                                  child: Text(Value));
                            }
                            ).toList(),
                            onChanged: (String? newValue){
                              setState(() {
                                blood = newValue!;
                              });
                            },
                            validator: (value) {
                              if (blood == 'Blood Group') return 'Select Blood Group';
                              return null;
                            },
                          ),
                        ),
                      ),
                      //locatrion
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: 300,
                          child: TextFormField(
                            controller: locationcontroller,
                            validator: (value){
                              if (value!.isEmpty) {
                                return '* Enter your Native';
                              } else if(nameRegExp.hasMatch(value)){
                                return null;
                              }
                              return null;
                            },
                            decoration:  const InputDecoration(
                              labelText: "Native",
                              // hintText: location!,
                            ),),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: 300,
                          height: 63,
                          child: TypeAheadFormField<String>(
                            textFieldConfiguration: TextFieldConfiguration(
                              controller: membertype,
                              decoration: const InputDecoration(
                                  fillColor: Colors.white,
                                  filled: true,
                                  labelText: "Member Type"
                              ),
                            ),
                            suggestionsCallback: (pattern) async {
                              return memberSuggestion
                                  .where((item) =>
                                  (item['member_type']?.toString().toLowerCase() ?? '')
                                      .startsWith(pattern.toLowerCase()))
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
                                membertype.text = suggestion;
                              });
                              //   print('Selected Item Group: $suggestion');
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: 300,
                          // height: ,
                          child: TypeAheadFormField<String>(
                            textFieldConfiguration: TextFieldConfiguration(
                              controller: role,
                              decoration: const InputDecoration(
                                  fillColor: Colors.white,
                                  filled: true,
                                  labelText: "Role"
                              ),
                            ),
                            suggestionsCallback: (pattern) async {
                              return roleget
                                  .where((item) =>
                                  (item['role']?.toString().toLowerCase() ?? '')
                                      .startsWith(pattern.toLowerCase()))
                                  .map((item) => item['role'].toString())
                                  .toList();
                            },
                            itemBuilder: (context, suggestion) {
                              return ListTile(
                                title: Text(suggestion),
                              );
                            },
                            onSuggestionSelected: (suggestion) async {
                              setState(() {
                                role.text = suggestion;

                              });
                              //   print('Selected Item Group: $suggestion');
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                    Row(
                      children: [
                        SizedBox(width: 75,),
                        Text('Personal Details',
                          style: Theme.of(context).textTheme.headlineSmall,),
                      ],
                    ),
                    Wrap(
                      runAlignment: WrapAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            width: 300,
                           // height: ,
                            child: TypeAheadFormField<String>(
                              textFieldConfiguration: TextFieldConfiguration(
                                controller: districtController,
                                decoration: const InputDecoration(
                                    fillColor: Colors.white,
                                    filled: true,
                                    labelText: "District"
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
                            width: 300,
                          //  height: 50,
                            child: TypeAheadFormField<String>(
                              textFieldConfiguration: TextFieldConfiguration(
                                controller: chapterController,
                                decoration: const InputDecoration(
                                    fillColor: Colors.white,
                                    filled: true,
                                    labelText: "Chapter"
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
                        ),

                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            width: 300,
                            child: TextFormField(
                              controller: _dobdate ,
                              validator: (value){
                                if (value!.isEmpty) {
                                  return '* Enter your Date of Birth';
                                } else if(nameRegExp.hasMatch(value)){
                                  return null;
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                labelText: "DOB",
                                // hintText:dob!,
                                suffixIcon: IconButton(onPressed: ()async{
                                  DateTime? pickDate = await showDatePicker(
                                      context: context,
                                      initialDate: date,
                                      firstDate: DateTime(1900),
                                      lastDate: DateTime(2100));
                                  if(pickDate==null) return;{
                                    setState(() {
                                      _dobdate.text =DateFormat('dd/MM/yyyy').format(pickDate);
                                    });
                                  }
                                }, icon: const Icon(
                                    Icons.calendar_today_outlined),
                                  color: Colors.green,),
                              ),
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            width: 300,
                            child: DropdownButtonFormField<String>(
                              value: gender,
                              icon: const Icon(Icons.arrow_drop_down),
                              isExpanded: true,
                              items: <String>["Gender", "Male", "Female", "Other"]
                                  .map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value));
                              }
                              ).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  gender = newValue!;
                                });
                              },
                              validator: (value) {
                                if (gender == 'Gender') {
                                  return '* Select your Gender';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            width: 300,
                           // padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 4),
                            child: DropdownButtonFormField<String>(
                              value: koottam,
                              hint: Text("Koottam"),
                              icon: const Icon(Icons.arrow_drop_down),
                              isExpanded: true,
                              items: <String>["Koottam","Adhitreya Kumban", "Aadai", "Aadhirai", "Aavan", "Andai", "Akini", "Anangan", "Andhuvan",
                                "Ariyan", "Alagan", "Bharatan", "Bramman", "Devendran", "Dananjayan", "Danavantan", "Eenjan","ElumathurKadais", "Ennai", "Indran",
                                "Kaadan", "Kaadai", "Kaari", "Kaavalar", "Kadunthuvi", "Kalinji", "Kambakulathaan", "Kanakkan", "Kanavaalan",
                                "Kannan", "Kannandhai", "Karunkannan", "Kauri", "Kavalan", "Kiliyan", "Keeran", "Kodarangi", "Koorai", "Kuruppan",
                                "Kotrandhai", "Kottaarar", "Kovar", "Koventhar", "Kumarandhai", "Kundali", "Kungili", "Kuniyan", "Kunnukkan", "Kuyilan",
                                "Kuzhlaayan", "Maadai", "Maadhaman", "Maathuli", "Maavalar", "Maniyan", "MaruthuraiKadais", "Mayilan", "Mazhluazhlagar", "Madhi", "Meenavan",
                                "Moimban", "Moolan", "Mooriyan", "Mukkannan", "Munaiveeran", "Muthan", "Muzhlukkadhan", "Naarai", "Nandhan", "Neelan",
                                "Neerunni", "Neidhali", "Neriyan", "Odhaalar", "Ozhukkar", "Paaliyan", "Paamban", "Paanan", "Paandian", "Paadhuri", "Paadhuman",
                                "Padukkunni", "Paidhali", "Panaiyan", "Panangadan", "Panjaman", "Pannai", "Pannan", "Paamaran", "Pavalan", "Payiran",
                                "Periyan", "Perunkudi", "Pillan", "Podiyan", "Ponnan", "Poochadhai", "Poodhiyan", "Poosan", "Porulthantha or Mulukadhan",
                                "Punnai", "Puthan", "Saakadai or Kaadai", "Sathandhai", "Sathuvaraayan", "Sanagan", "Sedan", "Sellan", "Semponn", "Sempoothan",
                                "Semvan", "Sengannan", "Sengunni", "Seralan", "Seran", "Sevadi", "Sevvayan", "Silamban", "Soman", "Soolan", "Sooriyan",
                                "Sothai", "Sowriyan", "Surapi", "Thanakkavan", "Thavalayan", "Thazhinji", "Theeman", "Thodai(n)", "Thooran", "Thorakkan",
                                "Thunduman", "Uvanan", "Uzhavan", "Vaanan or Vaani", "Vannakkan", "Veliyan", "Vellamban", "Vendhai", "Viliyan", "Velli",
                                "Vilosanan", "Viradhan", "Viraivulan"]
                                  .map<DropdownMenuItem<String>>((String Value) {
                                return DropdownMenuItem<String>(
                                    value: Value,
                                    child: Text(Value));
                              }
                              ).toList(),
                              onChanged: (String? newValue){
                                setState(() {
                                  koottam = newValue!;
                                });
                              },
                              validator: (value) {
                                if (koottam == 'Koottam') return 'Select Koottam';
                                return null;
                              },
                            ),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            width: 300,
                            child: TextFormField(
                              controller: kovilcontroller,
                              validator: (value){
                                if (value!.isEmpty) {
                                  return '* Enter your Kovil';
                                } else if(nameRegExp.hasMatch(value)){
                                  return null;
                                }
                                return null;
                              },
                              decoration:  const InputDecoration(
                                labelText: "Kovil",
                                // hintText: kovil!,
                              ),),
                          ),
                        ),
                      ],
                    ),


                    Row(
                      children: [

                        SizedBox(width: 75,),
                        Text('Marital Status    ',
                          style: Theme
                              .of(context)
                              .textTheme
                              .headlineSmall,),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // const Text("Marital Status:"),
                              Radio(
                                // title: const Text("Male"),
                                value: "Unmarried",
                                groupValue: status,
                                onChanged: (value) {
                                  setState(() {
                                    depVisible = false;
                                    status = value.toString();
                                  });
                                },
                              ),
                              const Text("Unmarried"),
                              const SizedBox(width: 30,),
                              Radio(
                                // title: const Text("Female"),
                                value: "Married",
                                groupValue: status,
                                onChanged: (value) {
                                  setState(() {
                                    depVisible = true;
                                    status = value.toString();
                                  });
                                },
                              ),
                              const Text("Married"),
                            ]
                        ),
                      ],
                    ),

                    const SizedBox(height:8,),
                    // Radio button starts here

                    Visibility(
                      visible: depVisible,

                      child: Row(
                        children: [
                          SizedBox(width: 75,),

                          Text('Dependents',
                            style: Theme.of(context).textTheme.headlineSmall,),
                        ],
                      ),
                    ),


                    const SizedBox(height: 5,),
                    Visibility(
                      visible: depVisible,
                      child: Wrap(
                        runAlignment: WrapAlignment.spaceBetween,
                        children: [

                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              width: 300,
                              child: TextFormField(
                                controller: spousenamecontroller,
                                validator: (value){
                                  if (value!.isEmpty) {
                                    return '* Enter your Spouse Name';
                                  } else if(nameRegExp.hasMatch(value)){
                                    return null;
                                  }
                                  return null;
                                },
                                decoration:  const InputDecoration(
                                  labelText: "Spouse Name",
                                  // hintText: spousename!,
                                ),),
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              width: 300,
                              child: TextFormField(
                                controller: spousenativecontroller,
                                validator: (value){
                                  if (value!.isEmpty) {
                                    return '* Enter your Spouse Native';
                                  } else if(nameRegExp.hasMatch(value)){
                                    return null;
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                  labelText: "Spouse Native",
                                  //  hintText: spousenative!,
                                ),),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              width: 300,
                              child: TextFormField(
                                controller: _waddate,
                                decoration: InputDecoration(
                                  labelText: "WAD",
                                  // hintText: wad!,
                                  suffixIcon: IconButton(onPressed: ()async{
                                    DateTime? pickDate = await showDatePicker(
                                        context: context,
                                        initialDate: date,
                                        firstDate: DateTime(1900),
                                        lastDate: DateTime(2100));
                                    if(pickDate==null) return;{
                                      setState(() {
                                        _waddate.text =DateFormat('dd/MM/yyyy').format(pickDate);
                                      });
                                    }
                                  }, icon: const Icon(
                                      Icons.calendar_today_outlined),
                                    color: Colors.green,),
                                ),
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              width: 300,
                            //  padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 4),
                              child: DropdownButtonFormField<String>(
                                value: spousekoottam,
                                hint: const Text("Koottam"),
                                icon: const Icon(Icons.arrow_drop_down),
                                isExpanded: true,
                                items: <String>["Spouse Father Koottam","Adhitreya Kumban", "Aadai", "Aadhirai", "Aavan", "Andai", "Akini", "Anangan", "Andhuvan",
                                  "Ariyan", "Alagan", "Bharatan", "Bramman", "Devendran", "Dananjayan", "Danavantan", "Eenjan","ElumathurKadais", "Ennai", "Indran",
                                  "Kaadan", "Kaadai", "Kaari", "Kaavalar", "Kadunthuvi", "Kalinji", "Kambakulathaan", "Kanakkan", "Kanavaalan",
                                  "Kannan", "Kannandhai", "Karunkannan", "Kauri", "Kavalan", "Kiliyan", "Keeran", "Kodarangi", "Koorai", "Kuruppan",
                                  "Kotrandhai", "Kottaarar", "Kovar", "Koventhar", "Kumarandhai", "Kundali", "Kungili", "Kuniyan", "Kunnukkan", "Kuyilan",
                                  "Kuzhlaayan", "Maadai", "Maadhaman", "Maathuli", "Maavalar", "Maniyan", "MaruthuraiKadais", "Mayilan", "Mazhluazhlagar", "Madhi", "Meenavan",
                                  "Moimban", "Moolan", "Mooriyan", "Mukkannan", "Munaiveeran", "Muthan", "Muzhlukkadhan", "Naarai", "Nandhan", "Neelan",
                                  "Neerunni", "Neidhali", "Neriyan", "Odhaalar", "Ozhukkar", "Paaliyan", "Paamban", "Paanan", "Paandian", "Paadhuri", "Paadhuman",
                                  "Padukkunni", "Paidhali", "Panaiyan", "Panangadan", "Panjaman", "Pannai", "Pannan", "Paamaran", "Pavalan", "Payiran",
                                  "Periyan", "Perunkudi", "Pillan", "Podiyan", "Ponnan", "Poochadhai", "Poodhiyan", "Poosan", "Porulthantha or Mulukadhan",
                                  "Punnai", "Puthan", "Saakadai or Kaadai", "Sathandhai", "Sathuvaraayan", "Sanagan", "Sedan", "Sellan", "Semponn", "Sempoothan",
                                  "Semvan", "Sengannan", "Sengunni", "Seralan", "Seran", "Sevadi", "Sevvayan", "Silamban", "Soman", "Soolan", "Sooriyan",
                                  "Sothai", "Sowriyan", "Surapi", "Thanakkavan", "Thavalayan", "Thazhinji", "Theeman", "Thodai(n)", "Thooran", "Thorakkan",
                                  "Thunduman", "Uvanan", "Uzhavan", "Vaanan or Vaani", "Vannakkan", "Veliyan", "Vellamban", "Vendhai", "Viliyan", "Velli",
                                  "Vilosanan", "Viradhan", "Viraivulan"]
                                    .map<DropdownMenuItem<String>>((String Value) {
                                  return DropdownMenuItem<String>(
                                      value: Value,
                                      child: Text(Value));
                                }
                                ).toList(),
                                onChanged: (String? newValue){
                                  setState(() {
                                    spousekoottam = newValue!;
                                  });
                                },
                                validator: (value) {
                                  if (spousekoottam == 'Spouse Father Koottam') return 'Select Spouse Father Koottam';
                                  return null;
                                },
                              ),
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              width: 300,
                              child: TextFormField(
                                controller: spousekovilcontroller,
                                validator: (value){
                                  if (value!.isEmpty) {
                                    return '* Enter your Spouse Father Kovil';
                                  } else if(nameRegExp.hasMatch(value)){
                                    return null;
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                  labelText: "Spouse Father Kovil",

                                  suffixIcon: Icon(Icons.account_circle),
                                ),),
                            ),
                          ),
                        ],
                      ),
                    ),


                    Row(
                      children: [
                        SizedBox(width: 75,),
                        Text('Business Details',
                          style: Theme
                              .of(context)
                              .textTheme
                              .headlineSmall,),
                      ],
                    ),

                    const SizedBox(height: 15,),
                    Wrap(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            width: 300,
                            child: DropdownButtonFormField<String>(
                              value: businesstype,
                              icon: const Icon(Icons.arrow_drop_down),
                              isExpanded: true,
                              items: <String>[
                                "Business Type",
                                "Manufacturer",
                                "Whole Sale",
                                "Ditributor",
                                "Service",
                                "Retail"
                              ]
                                  .map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value));
                              }
                              ).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  businesstype = newValue!;
                                });
                              },
                              validator: (value) {
                                if (businesstype == 'Business Type') {
                                  return '* Select Business Type';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            width: 300,
                            child: TextFormField(
                              minLines: 1,
                              maxLines: 5,
                              maxLength: 100,
                              controller: companyaddresscontroller,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return '* Enter your Company Address';
                                } else if (nameRegExp.hasMatch(value)) {
                                  return null;
                                }
                                return null;
                              },
                              onChanged: (value) {
                                String capitalizedValue = capitalizeFirstLetter(value);
                                companyaddresscontroller.value = companyaddresscontroller.value.copyWith(
                                  text: capitalizedValue,
                                  selection: TextSelection.collapsed(offset: capitalizedValue.length),
                                );
                              },
                              decoration: const InputDecoration(
                                labelText: "Company Address",
                                hintText: "Company Address",
                                suffixIcon: Icon(Icons.business),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            width: 300,
                            child: TextFormField(
                              controller: businesskeywordscontroller,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return '* Enter your Business Keywords';
                                } else if (nameRegExp.hasMatch(value)) {
                                  return null;
                                }
                                return null;
                              },
                              onChanged: (value) {
                                String capitalizedValue = capitalizeFirstLetter(value);
                                businesskeywordscontroller.value = businesskeywordscontroller.value.copyWith(
                                  text: capitalizedValue,
                                  selection: TextSelection.collapsed(offset: capitalizedValue.length),
                                );
                              },
                              decoration: const InputDecoration(
                                labelText: "Business keywords",
                                hintText: "Business keywords",
                                suffixIcon: Icon(Icons.business),
                              ),
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(30),
                              ],
                            ),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            width: 300,
                            child: TextFormField(
                              controller: websitecontroller,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return '* Enter your Website';
                                }else if (value.length<5) {
                                  return '* Enter a valid Website';
                                }
                                else if (nameRegExp.hasMatch(value)) {
                                  return null;
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                labelText: "Website",
                                hintText: "Website",
                                suffixIcon: Icon(Icons.web),
                              ),
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(30),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            width: 300,
                            child: TextFormField(
                              controller: yearcontroller,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return '* Enter your year of business established';
                                } else if (nameRegExp.hasMatch(value)) {
                                  return null;
                                }
                                else if(value.length<4){
                                  return "* Enter a correct year";
                                }
                                return null;
                              },
                              /*onTap: () async {
                                      DateTime currentDate = DateTime.now();
                                      DateTime firstSelectableYear = DateTime(1900);
                                      DateTime lastSelectableYear = DateTime(currentDate.year, 12, 31);
                                      DateTime? pickedDate = await showDatePicker(
                                        context: context,
                                        initialDate: firstSelectableYear,
                                        firstDate: firstSelectableYear,
                                        lastDate: lastSelectableYear,
                                        initialDatePickerMode: DatePickerMode.year,
                                      );

                                      if (pickedDate != null) {
                                        setState(() {
                                          yearcontroller.text = DateFormat('yyyy').format(pickedDate);
                                        });
                                      }

                                    },*/

                              decoration: const InputDecoration(
                                labelText: "business established year",
                                hintText: "yyyy",
                                suffixIcon:
                                Icon(Icons.calendar_today_outlined),
                              ),
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(4),
                              ],

                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            width: 300,
                            child: TextFormField(
                              controller: educationcontroller,
                              validator: (value){
                                if (value!.isEmpty) {
                                  return '* Please enter your qualification';
                                } else if(nameRegExp.hasMatch(value)){
                                  return null;
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                labelText: "Education",
                                hintText: "",
                                suffixIcon: Icon(Icons.cast_for_education_outlined),
                              ),),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            width: 300,
                            child: TextFormField(
                              controller: pastexpcontroller,
                              validator: (value){
                                if (value!.isEmpty) {
                                  return '* Please enter your past experience';
                                } else if(nameRegExp.hasMatch(value)){
                                  return null;
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                labelText: "Past Experience",
                                labelStyle: Theme.of(context).textTheme.bodySmall,
                                hintText: "",
                                suffixIcon: Icon(Icons.work_history),
                              ),),
                          ),
                        ),
                      ],
                    ),

                    const Wrap(
                      children: [
                      ],
                    ),
                    const SizedBox(height: 30,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [

                        /*// Cancel button starts
                        MaterialButton(
                            minWidth: 130,
                            height: 50,
                            color: Colors.orangeAccent,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)  ),
                            onPressed: (){
                              Navigator.pop(context);
                            },
                            child: const Text('Cancel',
                              style: TextStyle(color: Colors.white),)),
                        // Cancel button ends*/
                        // Save button starts
                        MaterialButton(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)  ),
                            minWidth: 200,
                            height: 50,
                            color: Colors.green[800],
                            onPressed: ()  {
                              if (_formKey.currentState!.validate()) {
                                Edit();
                                }
                            },
                            child: const Text('Update',
                              style: TextStyle(color: Colors.white),)),
                        // Save button ends
                      ],
                    ),
                    const SizedBox(height: 20,)

                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}


