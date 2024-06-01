import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gibadmin/main.dart';
class Setting extends StatelessWidget {
  const Setting({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SettingClass(),
    );
  }
}

class SettingClass extends StatefulWidget {
  const SettingClass({Key? key}) : super(key: key);

  @override
  State<SettingClass> createState() => _SettingClassState();
}

class _SettingClassState extends State<SettingClass> {
  String? type = "Guest";
  String? selectedDistrict;
  String? selectedChapter;
  String membertype = "Member Type";
  String membercategory = "Member Category";
  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      route: "/settingspage",
      body: Column(
        children: [

          Padding(
            padding: const EdgeInsets.all(25.0),
            child: Container(
              color: Colors.white,

              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    //Padding(padding: EdgeInsets.all(8)),
                    const SizedBox(height: 20,),
                    Text("Settings",style: Theme.of(context).textTheme.headlineMedium,),
                    const SizedBox(height: 30,),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("District"),
                        const SizedBox(width: 73,),
                        StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance.collection(
                              "District").snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              const Text('Loading');
                            } else {
                              List<DropdownMenuItem> districtItems = [];
                              for (int i = 0; i <
                                  snapshot.data!.docs.length; i++) {
                                DocumentSnapshot snap = snapshot.data!.docs[i];
                                districtItems.add(
                                  DropdownMenuItem(
                                      value: snap.id,
                                      child: Text(
                                        snap.id,
                                      )
                                  ),
                                );
                              }
                              return Container(
                                width:300,height: 52,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey,
                                  ),
                                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<dynamic>(
                                    items: districtItems,
                                    onChanged: (districtValue) {
                                      setState(() {
                                        selectedDistrict = districtValue;
                                      });
                                    },
                                    value: selectedDistrict,
                                    isExpanded: true,
                                    hint: const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                        "Choose District",
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Chapter"),
                        const SizedBox(width: 70,),
                        StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance.collection(
                              "District").doc(selectedDistrict).collection(
                              "Chapter").snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              const Text('Loading');
                            } else {
                              List<DropdownMenuItem> chapterItems = [];
                              for (int i = 0; i <
                                  snapshot.data!.docs.length; i++) {
                                DocumentSnapshot snap = snapshot.data!.docs[i];
                                chapterItems.add(
                                  DropdownMenuItem(
                                      value: snap.id,
                                      child: Text(
                                        snap.id,
                                      )
                                  ),
                                );
                              }
                              return Container(
                                width:300,height: 52,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey,
                                  ),
                                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                                ),


                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<dynamic>(
                                    items: chapterItems,
                                    onChanged: (chapterValue) {
                                      setState(() {
                                        selectedChapter = chapterValue;
                                      });
                                    },
                                    value: selectedChapter,
                                    isExpanded: true,
                                    hint: const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                        "Choose Chapter",
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Member Type"),
                        const SizedBox(width: 35,),
                        SizedBox(
                          width: 300,
                          child: DropdownButtonFormField<String>(
                            value: membertype,
                            hint: const Text("Member Type"),
                            icon: const Icon(Icons.arrow_drop_down),
                            isExpanded: true,
                            items: <String>[
                              "Member Type",
                              "Executive",
                              "Non-Executive",
                              "Women's Wing",
                              "Men's Wing",
                            ]
                                .map<DropdownMenuItem<String>>((String Value) {
                              return DropdownMenuItem<String>(
                                  value: Value,
                                  child: Text(Value));
                            }
                            ).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                membertype = newValue!;
                              });
                            },
                            validator: (value) {
                              if (membertype == "Member Type") return 'Select Member Type';
                              return null;
                            },
                          ),
                        ),


                      ],
                    ),
                    const SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Member Category"),
                        const SizedBox(width: 10,),
                        SizedBox(
                          width: 300,
                          child: DropdownButtonFormField<String>(
                            value: membertype,
                            hint: const Text("Member Category "),
                            icon: const Icon(Icons.arrow_drop_down),
                            isExpanded: true,
                            items: <String>[
                              "Member Type",
                              "Executive",
                              "NonExecutive",
                              "Women's Wing",
                              "Men's Wing",
                            ]
                                .map<DropdownMenuItem<String>>((String Value) {
                              return DropdownMenuItem<String>(
                                  value: Value,
                                  child: Text(Value));
                            }
                            ).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                membertype = newValue!;
                              });
                            },
                            validator: (value) {
                              if (membertype == "Member Type") return 'Select Member Category ';
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10,),
                    Column(
                      children: [
                        Row(
                          // runSpacing: 10,
                          // spacing: 10,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Total Meeting"),
                            const SizedBox(width: 35,),
                            SizedBox(
                              width: 300,
                              child: TextFormField(
                                // controller: companynamecontroller,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return '* Enter your Total Meeting';
                                  }
                                  {
                                    return null;
                                  }

                                },
                                decoration: const InputDecoration(
                                  hintText: "Total Meeting",
                                  //   suffixIcon: Icon(Icons.mem),
                                ),),
                            ),




                          ],
                        ),
                        const SizedBox(height: 10,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Need To Attend"),
                            const SizedBox(width: 25,),
                            SizedBox(
                              width: 300,
                              child: TextFormField(
                                // controller: companynamecontroller,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return '*Need To Attend';
                                  }
                                  {
                                    return null;
                                  }

                                },
                                decoration: const InputDecoration(
                                  labelText: "Need To Attend",
                                  //   suffixIcon: Icon(Icons.mem),
                                ),),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10,),
                        Row(
                          //   runSpacing: 10,
                          // spacing: 10,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Absent Permit"),
                            const SizedBox(width: 32,),
                            SizedBox(
                              width: 300,
                              child: TextFormField(
                                // controller: companynamecontroller,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return '* Absent Permit';
                                  }
                                  {
                                    return null;
                                  }
                                },
                                decoration: const InputDecoration(
                                  labelText: "Absent Permit",
                                  //   suffixIcon: Icon(Icons.mem),
                                ),),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Leave Permit"),
                            const SizedBox(width: 37,),
                            SizedBox(
                              width: 300,
                              child: TextFormField(
                                // controller: companynamecontroller,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return '*Leave Permit';
                                  }
                                  {
                                    return null;
                                  }
                                },
                                decoration: const InputDecoration(
                                  labelText: "Leave Permit",
                                  //   suffixIcon: Icon(Icons.mem),
                                ),),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10,),
                      ],
                    ),
                    const SizedBox(height: 15,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Can See Business Transaction" ),
                        const SizedBox(width: 23,),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Radio(
                                // title: const Text("Male"),
                                value: "Yes",
                                groupValue: type,
                                onChanged: (value) {
                                  setState(() {
                                    //  isVisible = false;
                                    type = value.toString();
                                  });
                                },
                              ),
                              const Text("Yes"),
                              const SizedBox(width: 30,),
                              Radio(
                                // title: const Text("Female"),
                                value: "No",
                                groupValue: type,
                                onChanged: (value) {
                                  setState(() {
                                    //  isVisible = true;
                                    type = value.toString();
                                  });
                                },
                              ),
                              const Text("No"),
                            ]
                        ),
                      ],
                    ),
                    const SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Can See Business G2G" ),
                        const SizedBox(width: 66,),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Radio(
                                // title: const Text("Male"),
                                value: "Yes",
                                groupValue: type,
                                onChanged: (value) {
                                  setState(() {
                                    //  isVisible = false;
                                    type = value.toString();
                                  });
                                },
                              ),
                              const Text("Yes"),
                              const SizedBox(width: 30,),
                              Radio(
                                // title: const Text("Female"),
                                value: "No",
                                groupValue: type,
                                onChanged: (value) {
                                  setState(() {
                                    //  isVisible = true;
                                    type = value.toString();
                                  });
                                },
                              ),
                              const Text("No"),
                            ]
                        ),
                      ],
                    ),
                    const SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Can See Business Guest" ),
                        const SizedBox(width: 58,),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Radio(
                                // title: const Text("Male"),
                                value: "Yes",
                                groupValue: type,
                                onChanged: (value) {
                                  setState(() {
                                    //  isVisible = false;
                                    type = value.toString();
                                  });
                                },
                              ),
                              const Text("Yes"),
                              const SizedBox(width: 30,),
                              Radio(
                                // title: const Text("Female"),
                                value: "No",
                                groupValue: type,
                                onChanged: (value) {
                                  setState(() {
                                    //  isVisible = true;
                                    type = value.toString();
                                  });
                                },
                              ),
                              const Text("No"),
                            ]
                        ),
                      ],
                    ),
                    const SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Can See Business Honoring" ),
                        const SizedBox(width: 40,),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Radio(
                                // title: const Text("Male"),
                                value: "Yes",
                                groupValue: type,
                                onChanged: (value) {
                                  setState(() {
                                    //  isVisible = false;
                                    type = value.toString();
                                  });
                                },
                              ),
                              const Text("Yes"),
                              const SizedBox(width: 30,),
                              Radio(
                                // title: const Text("Female"),
                                value: "No",
                                groupValue: type,
                                onChanged: (value) {
                                  setState(() {
                                    //  isVisible = true;
                                    type = value.toString();
                                  });
                                },
                              ),
                              const Text("No"),
                            ]
                        ),
                      ],
                    ),
                    const  SizedBox(height: 20,),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        MaterialButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0)),
                            minWidth: 130,
                            height: 48,
                            color: Colors.green[800],

                            onPressed: () {
                              //  if (_formKey.currentState!.validate()) {}

                            },
                            child: const Text('Submit',
                              style: TextStyle(color: Colors.white),)),
                        const  SizedBox(width: 60,),
                        MaterialButton(
                            minWidth: 130,
                            height: 48,
                            color: Colors.orangeAccent,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0)),
                            onPressed: () {},
                            child: const Text('Cancel',
                              style: TextStyle(color: Colors.white),)),
                        // Sign up button ends
                      ],
                    ),
                    const  SizedBox(height: 20,),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

