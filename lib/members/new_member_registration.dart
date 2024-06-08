import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gibadmin/members/member_create_regisitration.dart';
import '../main.dart';
import 'package:http/http.dart'as http;

import 'member_update_registration.dart';

class NewMemberRegistration extends StatelessWidget {
  const NewMemberRegistration({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: MemberRegistration(),
    );
  }
}
class MemberRegistration extends StatefulWidget {
   MemberRegistration({Key? key}) : super(key: key);

  @override
  State<MemberRegistration> createState() => _MemberRegistrationState();
}

class _MemberRegistrationState extends State<MemberRegistration> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController idController =TextEditingController();
  bool buttonVisibilityUpdate = false;
  bool buttonVisibiltyCreate =true;
  List mobileBaseFetchIDdata=[];
  Future<void> mobileBaseIdFetched(String mobile) async {
    try {
      print("Mobile :$mobile");

      final url = Uri.parse('http://mybudgetbook.in/GIBAPI/registration.php?table=registration&mobile=$mobile');
      final response = await http.get(url);
      print("id fetch URL :$url" );
      if (response.statusCode == 200) {
        print("response.statusCode :${response.statusCode}" );
        print("response .body :${response.body}" );
        final responseData = json.decode(response.body);
        if (responseData is List<dynamic>) {
          setState(() {
            mobileBaseFetchIDdata = responseData.cast<Map<String, dynamic>>();
            if (mobileBaseFetchIDdata.isNotEmpty ) {
              idController.text = mobileBaseFetchIDdata[0]["id"];
              print("User ID--${idController.text}");

              // User exists, show the Update button
              buttonVisibiltyCreate = false;
              buttonVisibilityUpdate = true;
            }
            else{
            }

          });
        } else {
          print('Invalid response data format');
          setState(() {
            idController.text = "Invalid response data format";
            print("userId :${idController.text}");
             if(idController.text == "Invalid response data format"){
            // User doesn't exist, show the Create button
            setState(() {
            buttonVisibiltyCreate = true;
            buttonVisibilityUpdate = false;
            });
            }

          });
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



  TextEditingController mobilecontroller = TextEditingController();
  String typem = "Member";
  bool visibility = false;
  String? mobilenumber ="";
  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      route:'/new_member_registration',
      body: Form(
        key: _formKey,
        child: Center(
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
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 3,
                          blurRadius: 7,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                  height: 500,
                  child:Column(
                children:  [
                  const SizedBox(height: 40,),
                  //New Member Registration text starts
                   Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("New Member Registration",
                      style: Theme.of(context).textTheme.headlineMedium),
                  ),
                  //New Member Registration text end

                  const SizedBox(height: 40,),

                  //Mobile Number TextFormField starts
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(width: 400,

                      child: TextFormField(
                        controller: mobilecontroller,
                        validator: (value) {
                          if(value!.isEmpty){
                            return "*Enter the Mobile Number";
                          }else if(value.length < 10){
                            return "Mobile Number should be 10 digits";
                          }else {
                            return null;
                          }
                        },
                          onChanged: (value){
                         mobileBaseIdFetched(mobilecontroller.text);
                          },
                        decoration: const InputDecoration(
                          label: Text("Mobile Number"),
                          hintText: "Mobile Number",
                        ),
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(10)
                      ]),
                    ),
                  ),
                  //Mobile Number TextFormField end

                  const SizedBox(height: 40,),

                  //Submit Elevated button starts
                  Visibility(
                    visible: visibility,
                    child: ElevatedButton(onPressed: () async {
                  Navigator.pushNamed(context, '/executive_member_updation');
                    }, child: const Text("Update")),
                  ),
                  //Submit Elevated button ends

                 const SizedBox(height: 20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      //ElevatedButton Create starts
                      Visibility(
                        visible:buttonVisibiltyCreate,
                        child: ElevatedButton(onPressed: (){
                          if(_formKey.currentState!.validate()){
                          //  Navigator.pushNamed(context, "/createRegistrationPage");

                            Navigator.push(context, MaterialPageRoute(builder: (context)=>Registration(mobile:mobilecontroller.text)));
                          }

                        }, child: const Text("Create")),
                      ),
                      //ElevatedButton Create ends

                      const SizedBox(width: 20,),

                      //ElevatedButton Update starts
                      Visibility(
                        visible: buttonVisibilityUpdate,
                        child: ElevatedButton(onPressed: (){
                          if(_formKey.currentState!.validate()){}
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>UpdateRegisterationPage(currentID: idController.text,)));

                        //  Navigator.pushNamed(context, "/updateregisterationpage");
                        }, child: const Text("Update")),
                      ),
                      //ElevatedButton Create end
                    ],
                  ),
                ],
                  )
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

