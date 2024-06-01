import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gibadmin/dashboardpage/dashboard.dart';
import 'package:gibadmin/settings/add_member_category.dart';
import 'package:http/http.dart' as http;
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'members/executive_member_updation.dart';

class AdminLogin extends StatelessWidget {
  const AdminLogin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: AdminLoginPages(),
    );
  }
}

class AdminLoginPages extends StatefulWidget {
  const AdminLoginPages({Key? key}) : super(key: key);

  @override
  State<AdminLoginPages> createState() => _AdminLoginPagesState();
}

class _AdminLoginPagesState extends State<AdminLoginPages> {
  bool _isObscure = true;
  String? mobileNo;
  final _formKey = GlobalKey<FormState>();
  TextEditingController mobilecontroller = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  List<Map<String, dynamic>> data = [];

// Update your checkLoginStatus function to return a boolean
  Future<bool> checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    return isLoggedIn;
  }

  Future<void> login(String mobile, String password) async {
    try {
      final url =
          Uri.parse('http://mybudgetbook.in/GIBADMINAPI/signup.php');
      final response = await http.get(url.replace(queryParameters: {
        'mobile': mobile,
        'password': password,
      }));

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse.containsKey('success')) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setBool('isLoggedIn', true);

          if (jsonResponse.containsKey('mobile')) {
            String mobileNumber = jsonResponse['mobile'];
            await prefs.setString('userMobile', mobileNumber);
            print("mobileNO : $mobileNumber");

            // Navigate to MainScreenPage with mobile number
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => MainScreenPage(mobile: mobileNumber),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Mobile number not found in response.'),
              ),
            );
          }
        } else if (jsonResponse.containsKey('error')) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(jsonResponse['error']),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Unknown response format.'),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to connect to the server.'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/green.jpg"),
              fit:
                  BoxFit.cover, // Adjust the image to cover the whole container
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(50.0),
            child: Column(
              children: [
                Image.asset("assets/logo.png"),
                SizedBox(
                  height: 30,
                ),
                // Expanded(
                //   child: Container(
                //     decoration: BoxDecoration(
                //       gradient: LinearGradient(
                //         begin: Alignment.topLeft,
                //         stops: const [0.1, 0.3, 0.7, 1],
                //         colors: [
                //           Colors.blueAccent,
                //           Colors.blueAccent.shade400,
                //           Colors.blue.shade300,
                //           Colors.blueAccent.shade100
                //         ],
                //       ),
                //     ),
                //     child: Column(
                //       children: [
                //         const SizedBox(
                //           height: 120,
                //         ),
                //         // Logo
                //
                //         // Title
                //         const Text(
                //           'Gounders In Business',
                //           style: TextStyle(color: Colors.white, fontSize: 20),
                //         ),
                //         const SizedBox(
                //           height: 5,
                //         ),
                //         const Text(
                //           'Since 2015',
                //           style: TextStyle(
                //               color: Colors.white,
                //               fontSize: 15,
                //               fontStyle: FontStyle.italic),
                //         ),
                //         // Mobile number textfield starts
                //         const SizedBox(
                //           height: 15,
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.deepOrangeAccent,
                    borderRadius: BorderRadius.circular(20.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.green.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3),
                      ),
                    ],
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        // Light green color with opacity
                        Colors.white,
                        Colors.white,
                        // Another shade of green with opacity
                      ],
                    ),
                    border: Border.all(
                      color: Colors.green, // Deep green border color
                      width: 1.0, // Border width
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Expanded(
                      child: Container(
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              const Text(
                                "Signup",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              SizedBox(
                                width: 220,
                                height: 50,
                                child: TextFormField(
                                  controller: mobilecontroller,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return '* Enter your Mobile Number';
                                    } else {
                                      return null;
                                    }
                                  },
                                  decoration: InputDecoration(
                                    labelText: "Mobile Number",
                                    suffixIcon: Icon(Icons.phone_android),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                  ),
                                  keyboardType: TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(10),
                                  ],
                                ),
                              ),
                              // Mobile number textfield ends here
                              // Password textfield starts
                              const SizedBox(
                                height: 10,
                              ),
                              SizedBox(
                                width: 220,
                                height: 50,
                                child: TextFormField(
                                  controller: passwordController,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "* Enter M-Pin";
                                    } else if (value.length < 6) {
                                      return "M-Pin should be at least 6 characters";
                                    } else {
                                      return null;
                                    }
                                  },
                                  obscureText: _isObscure,
                                  decoration: InputDecoration(
                                    labelText: 'M-Pin',
                                    //prefix: Text("+91"),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _isObscure
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _isObscure = !_isObscure;
                                        });
                                      },
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                  ),
                                  keyboardType: TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(6),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 25,
                              ),
                              MaterialButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25.0),
                                ),
                                elevation: 20,
                                minWidth: 130,
                                height: 45,
                                color: Colors.green[800],
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    final mobile = mobilecontroller.text;
                                    final password = passwordController.text;
                                    login(mobile, password);
                                  }
                                  mobilecontroller.clear();
                                  passwordController.clear();
                                },
                                child: const Text(
                                  "Login",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
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
