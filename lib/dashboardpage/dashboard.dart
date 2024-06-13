import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:gibadmin/dashboardpage/executive_member.dart';
import 'package:gibadmin/dashboardpage/total_members.dart';
import 'package:gibadmin/dashboardpage/women_executive.dart';
import '../main.dart';
import 'doctor_wing.dart';
import 'non_executive.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MainScreenPage(
        mobile: '',
      ),
    );
  }
}

class MainScreenPage extends StatefulWidget {
  static const String id = "MainScreen";
  final String mobile;
  MainScreenPage({required this.mobile});

  @override
  State<MainScreenPage> createState() => _MainScreenPageState();
}

bool isSwitched = false;

class _MainScreenPageState extends State<MainScreenPage> {
  int businessCount = 0;
  int totalgib = 0;
  String type = "Member";
  int exemem = 0;
  String Exemem = "Non-Executive";
  int g2g = 0;
  int guest = 0;
  int wexemem = 0;
  String Wexemem = "Executive Women's Wing";
  int doctor = 0;
  String docwing = "Doctor's Wing";
  int tnonexe = 0;
  String nonexe = "Non-Executive";
  int totalg = 0;
  String gold = "Gold";
  int totals = 0;
  String silver = "Silver";

  String? totalRows = "0";

  Future<void> getBusinessCount() async {
    try {
      final url = Uri.parse(
          'http://mybudgetbook.in/GIBAPI/gibBusiness.php?table=BusinessTotalYear');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        setState(() {
          totalRows = responseData['totalRows'];
        });
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  String accountingYear = '0';

  Future<void> getaccountBusinessCount() async {
    try {
      final url = Uri.parse(
          'http://mybudgetbook.in/GIBAPI/gibBusiness.php?table=BusinessCurrentYear');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        setState(() {
          accountingYear = responseData['totalRows'];
        });
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  String? g2gtotalRows = "0";

  Future<void> g2ggetBusinessCount() async {
    try {
      final url = Uri.parse(
          'http://mybudgetbook.in/GIBAPI/gibBusiness.php?table=g2gBusinessTotalYear');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        setState(() {
          g2gtotalRows = responseData['totalRows'];
        });
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  String g2gaccountingYear = '0';

  Future<void> g2ggetaccountBusinessCount() async {
    try {
      final url = Uri.parse(
          'http://mybudgetbook.in/GIBAPI/gibBusiness.php?table=g2gBusinessCurrentYear');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        setState(() {
          g2gaccountingYear = responseData['totalRows'];
        });
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  String? visitortotalRows = "0";

  Future<void> visitorgetBusinessCount() async {
    try {
      final url = Uri.parse(
          'http://mybudgetbook.in/GIBAPI/gibBusiness.php?table=visitorBusinessTotalYear');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        setState(() {
          visitortotalRows = responseData['totalRows'];
        });
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  String visitoraccountingYear = '0';

  Future<void> visitorgetaccountBusinessCount() async {
    try {
      final url = Uri.parse(
          'http://mybudgetbook.in/GIBAPI/gibBusiness.php?table=visitorBusinessCurrentYear');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        setState(() {
          visitoraccountingYear = responseData['totalRows'];
        });
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  String? honortotalRows = "0";

  Future<void> honorBusinessCount() async {
    try {
      final url = Uri.parse(
          'http://mybudgetbook.in/GIBAPI/gibBusiness.php?table=honorBusinessTotalYear');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        setState(() {
          honortotalRows = responseData['totalAmount'] ?? "0";
        });
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  String honoraccountingYear = '0';

  Future<void> honorgetaccountBusinessCount() async {
    try {
      final url = Uri.parse(
          'http://mybudgetbook.in/GIBAPI/gibBusiness.php?table=honorBusinessCurrentYear');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        setState(() {
          honoraccountingYear = responseData['totalAmount'];
        });
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  @override
  void initState() {
    getBusinessCount();
    getaccountBusinessCount();
    g2ggetBusinessCount();
    g2ggetaccountBusinessCount();
    visitorgetBusinessCount();
    visitorgetaccountBusinessCount();
    honorBusinessCount();
    honorgetaccountBusinessCount();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      route: '/',
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              Text(
                "Gounders In Business",
                style: Theme.of(context).textTheme.displayLarge,
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Container(
                  // color: Colors.white,
                  child: Wrap(
                    runSpacing: 20,
                    spacing: 10,
                    children: [
                      //Business Report
                      InkWell(
                        child: SizedBox(
                          width: 300,
                          height: 140,
                          child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(8)),
                                  gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      //      stops: const [0.1, 0.3, 0.7, 1],
                                      colors: [
                                        Colors.purple,
                                        Colors.purple.shade400,
                                        Colors.purple.shade300,
                                        Colors.purpleAccent.shade100
                                      ])),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          "Business Report",
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.white),
                                        ),
                                        Icon(
                                          Icons.sticky_note_2_outlined,
                                          color: Colors.white,
                                          size: 35,
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        13.0, 0, 0, 0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text("Business Year : $accountingYear",
                                            style: const TextStyle(
                                                fontSize: 16,
                                                color: Colors.white)),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text("Upto Date :  $totalRows",
                                            style: const TextStyle(
                                                fontSize: 16,
                                                color: Colors.white)),
                                      ],
                                    ),
                                  ),
                                ],
                              )),
                        ),
                        onTap: () {
                          //  Navigator.push(context, MaterialPageRoute(builder: (context)=>const BusinessReport()));
                          Navigator.pushNamed(context, '/business_report');
                          //   MaterialPageRoute(builder: (context)=> '/business_report'()));
                        },
                      ),
                      //G2G
                      InkWell(
                        child: SizedBox(
                          width: 300,
                          height: 140,
                          child: Container(
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8)),
                                  gradient: LinearGradient(
                                      begin: Alignment.centerLeft,
                                      end: Alignment.bottomRight,
                                      //stops: const [0.1, 0.3, 0.7, 1],
                                      colors: [
                                        Colors.brown.shade900,
                                        Colors.brown.shade700,
                                        Colors.brown.shade600,
                                        Colors.brown.shade400
                                      ])),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          "G2G",
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.white),
                                        ),
                                        Icon(
                                          Icons.sticky_note_2_outlined,
                                          color: Colors.white,
                                          size: 35,
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        13.0, 0, 0, 0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            "Business Year : $g2gaccountingYear",
                                            style: const TextStyle(
                                                fontSize: 16,
                                                color: Colors.white)),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text("Upto Date :  $g2gtotalRows",
                                            style: const TextStyle(
                                                fontSize: 16,
                                                color: Colors.white)),
                                      ],
                                    ),
                                  ),
                                ],
                              )),
                        ),
                        onTap: () {
                          //  Navigator.push(context, MaterialPageRoute(builder: (context)=>const BusinessReport()));
                          Navigator.pushNamed(context, '/business_report');
                          //   MaterialPageRoute(builder: (context)=> '/business_report'()));
                        },
                      ),

                      //guest
                      InkWell(
                        child: SizedBox(
                          width: 300,
                          height: 140,
                          child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(8)),
                                  gradient: LinearGradient(
                                      begin: Alignment.bottomRight,
                                      end: Alignment.topLeft,
                                      stops: const [
                                        0.1,
                                        0.3,
                                        0.7,
                                        1
                                      ],
                                      colors: [
                                        Colors.orange.shade900,
                                        Colors.deepOrange.shade300,
                                        Colors.deepOrangeAccent,
                                        Colors.orangeAccent
                                      ])),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          "Guest Report",
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.white),
                                        ),
                                        Icon(
                                          Icons.sticky_note_2_outlined,
                                          color: Colors.white,
                                          size: 35,
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        13.0, 0, 0, 0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            "Business Year : $visitoraccountingYear",
                                            style: const TextStyle(
                                                fontSize: 16,
                                                color: Colors.white)),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text("Upto Date :  $visitortotalRows",
                                            style: const TextStyle(
                                                fontSize: 16,
                                                color: Colors.white)),
                                      ],
                                    ),
                                  ),
                                ],
                              )),
                        ),
                        onTap: () {
                          //  Navigator.push(context, MaterialPageRoute(builder: (context)=>const BusinessReport()));
                          Navigator.pushNamed(context, '/business_report');
                          //   MaterialPageRoute(builder: (context)=> '/business_report'()));
                        },
                      ),

                      //Honoring Report
                      InkWell(
                        child: SizedBox(
                          width: 300,
                          height: 140,
                          child: Container(
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8)),
                                  gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Colors.teal.shade900,
                                        Colors.teal.shade300,
                                        Colors.teal.shade200,
                                        Colors.tealAccent
                                      ])),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          "Honoring Report",
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.white),
                                        ),
                                        Icon(
                                          Icons.sticky_note_2_outlined,
                                          color: Colors.white,
                                          size: 35,
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        13.0, 0, 0, 0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            "Business Year : ₹ $honoraccountingYear",
                                            style: const TextStyle(
                                                fontSize: 16,
                                                color: Colors.white)),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text("Upto Date : ₹ $honortotalRows",
                                            style: const TextStyle(
                                                fontSize: 16,
                                                color: Colors.white)),
                                      ],
                                    ),
                                  ),
                                ],
                              )),
                        ),
                        onTap: () {
                          //  Navigator.push(context, MaterialPageRoute(builder: (context)=>const BusinessReport()));
                          Navigator.pushNamed(context, '/business_report');
                          //   MaterialPageRoute(builder: (context)=> '/business_report'()));
                        },
                      ),

                      InkWell(
                        child: SizedBox(
                          width: 300,
                          height: 140,
                          child: Container(
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                                gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    stops: const [
                                      0.1,
                                      0.3,
                                      0.7,
                                      1
                                    ],
                                    colors: [
                                      Colors.pink.shade700,
                                      Colors.pink.shade500,
                                      Colors.pink.shade400,
                                      Colors.pink.shade200
                                    ]),
                              ),
                              child: Column(
                                children: [
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  const Text(
                                    "Executive Member",
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.white),
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Text(
                                    exemem.toString(),
                                    style: const TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Wrap(
                                    runSpacing: 20,
                                    spacing: 20,
                                    // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text(
                                        "Gold : ${totalg.toString()}",
                                        style: const TextStyle(
                                            color: Colors.white, fontSize: 10),
                                      ),
                                      Text(
                                        "Silver : ${totals.toString()}",
                                        style: const TextStyle(
                                            color: Colors.white, fontSize: 10),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                ],
                              )),
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ExeMember()));
                          //  Navigator.pushNamed(context, '/executive_member');
                        },
                      ),
                      //Women's Executing wing
                      InkWell(
                        child: SizedBox(
                          width: 300,
                          height: 140,
                          child: Container(
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8)),
                                  gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      stops: const [
                                        0.1,
                                        0.3,
                                        0.7,
                                        1
                                      ],
                                      colors: [
                                        Colors.cyan,
                                        Colors.indigoAccent,
                                        Colors.indigoAccent.shade400,
                                        Colors.cyan.shade200
                                      ])),
                              child: Column(
                                children: [
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  const Text(
                                    "Women's Executive wing",
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.white),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    wexemem.toString(),
                                    style: const TextStyle(
                                        fontSize: 18, color: Colors.white),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Icon(
                                    Icons.energy_savings_leaf_outlined,
                                    color: Colors.lightGreenAccent[400],
                                    size: 35,
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                ],
                              )),
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => WExecutive()));
                          //  Navigator.pushNamed(context, '/women_executive_member');
                        },
                      ),

                      //Doctor's wing
                      InkWell(
                        child: SizedBox(
                          width: 300,
                          height: 140,
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                                gradient: LinearGradient(
                                    begin: Alignment.centerRight,
                                    end: Alignment.bottomLeft,
                                    stops: const [
                                      0.1,
                                      0.3,
                                      0.7,
                                      1
                                    ],
                                    colors: [
                                      Colors.deepPurple.shade700,
                                      Colors.deepPurpleAccent.shade400,
                                      Colors.deepPurple.shade400,
                                      Colors.deepPurpleAccent.shade200
                                    ])),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                const Text(
                                  "Doctor's wing",
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.white),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  doctor.toString(),
                                  style: const TextStyle(
                                      fontSize: 18, color: Colors.white),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                const Icon(
                                  Icons.favorite_border_rounded,
                                  color: Colors.white,
                                  size: 35,
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                              ],
                            ),
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DoctorsWing()));
                        },
                      ),

                      //Student's wing
                      /* SizedBox(
                        width: 300,height: 130,
                        child: Container(
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  stops: const [0.1, 0.3, 0.7, 1],
                                  colors:[Colors.green.shade700,Colors.green.shade400,Colors.greenAccent.shade400,Colors.lightGreenAccent]

                              )
                          ),
                          child: Column(
                            children: const [
                              SizedBox(height: 10,),
                              Text("Student's wing",
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white),),
                              SizedBox(height: 10,),
                              Text("1",style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white),),
                              SizedBox(height: 10,),
                              Icon(Icons.laptop_chromebook,
                                color: Colors.yellow,
                                size: 35,),
                              SizedBox(height: 20,),
                            ],
                          ),
                        ),
                      ),*/

                      //Non Executive Members
                      InkWell(
                        child: SizedBox(
                          width: 300,
                          height: 140,
                          child: Container(
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8)),
                                  gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      stops: const [
                                        0.1,
                                        0.3,
                                        0.7,
                                        1
                                      ],
                                      colors: [
                                        Colors.yellow.shade900,
                                        Colors.yellow.shade800,
                                        Colors.yellow.shade600,
                                        Colors.yellow.shade300
                                      ])),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 10,
                                  ),
                                  const Text(
                                    "Non Executive Members",
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.white),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    tnonexe.toString(),
                                    style: const TextStyle(
                                        fontSize: 18, color: Colors.white),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  const Icon(
                                    Icons.people,
                                    color: Colors.white,
                                    size: 35,
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                ],
                              )),
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => NonExecutive()));
                          // Navigator.pushNamed(context, '/non_executive');
                        },
                      ),

                      //Total Gib Members
                      InkWell(
                        child: SizedBox(
                          width: 300,
                          height: 140,
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                                gradient: LinearGradient(
                                    begin: Alignment.bottomLeft,
                                    end: Alignment.topRight,
                                    stops: const [
                                      0.1,
                                      0.3,
                                      0.7,
                                      1
                                    ],
                                    colors: [
                                      Colors.lime.shade900,
                                      Colors.green.shade700,
                                      Colors.lightGreen.shade900,
                                      Colors.limeAccent.shade700
                                    ])),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                const Text(
                                  "Total Gib Members",
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.white),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  totalgib.toString(),
                                  style: const TextStyle(
                                      fontSize: 18, color: Colors.white),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                const Icon(
                                  Icons.people,
                                  color: Colors.white,
                                  size: 35,
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                              ],
                            ),
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => TotalMembers()));
                        },
                      ),
                      //Current Year Transaction(From Thank note)
                      /*SizedBox(
                        width: 300,height: 130,
                        child: Container(
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end:Alignment.bottomRight,
                                  stops: const [0.1, 0.3, 0.7, 1],
                                  colors: [Colors.red,Colors.redAccent.shade400,Colors.red.shade300,Colors.red.shade100]
                              )
                          ),
                          child: Column(
                            children: const [
                              SizedBox(height: 10,),
                              Text("Current Year Transaction\n(From Thank note)",
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white),),
                              SizedBox(height: 10,),
                              Text("₹",
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white),),
                              SizedBox(height: 10,),
                              Icon(
                                Icons.people,
                                color: Colors.yellow,
                                size: 35,),
                              SizedBox(height: 10,),
                            ],
                          ),
                        ),
                      ),*/
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/* MyScaffold(
    route: '/',
      body: Center(
        child: Column(
          children:  [
         const SizedBox(height: 35),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Container(
               // color: Colors.white,
                child: Wrap(
                  runSpacing: 20,
                 spacing: 10,
                  children: [
                    //Business Report
                InkWell(
                  child: SizedBox(
                    width: 300,height: 130,
                    child: Card(
                        color: Colors.indigo[900],
                        child: Column(
                          children: const [
                            SizedBox(height: 10,),
                            Text("Business Report",
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white),),
                            SizedBox(height: 10,),
                            Text("2",
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white),),
                            SizedBox(height: 10,),
                            Icon(
                              Icons.sticky_note_2_outlined,
                              color: Colors.black87,size: 35,),
                            SizedBox(height: 20,),
                          ],
                        )
                    ),
                  ),
                  onTap: (){
                  //  Navigator.push(context, MaterialPageRoute(builder: (context)=>const BusinessReport()));
                 Navigator.pushNamed(context, '/business_report');
                     //   MaterialPageRoute(builder: (context)=> '/business_report'()));
                  },
                ),
                //G2G

                SizedBox(
                  width: 300,height: 130,
                  child: Card(
                      color: Colors.brown[800],
                      child: Column(
                        children: const [
                          SizedBox(height: 10,),
                          Text("G2G",
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.white),),
                          SizedBox(height: 10,),
                          Text("3",
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.white),),
                          SizedBox(height: 10,),
                          Icon(
                            Icons.sticky_note_2_outlined,
                            color: Colors.blue,size: 35,),
                          SizedBox(height: 20,),

                        ],

                      )
                  ),
                ),

                //Guest Report
                SizedBox(
                  width: 300,height: 130,
                  child: Card(
                    color: Colors.orange[900],
                    child: Column(
                      children: const [
                        SizedBox(height: 10,),
                        Text("Guest Report",
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.white),),
                        SizedBox(height: 10,),
                        Text("4",
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.white),),
                        SizedBox(height: 10,),
                        Icon(
                          Icons.sticky_note_2_outlined,
                          color: Colors.yellow,size: 35,),
                        SizedBox(height: 20,),

                      ],
                    ),
                  ),
                ),

                //Honoring Report
                SizedBox(
                  width: 300,height: 130,
                  child: Card(
                    color: Colors.teal[900],
                    child: Column(
                      children: const [
                        SizedBox(height: 10,),
                        Text("Honoring Report",
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.white),),
                        SizedBox(height: 10,),
                        Text("₹6,00,003.00",
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.white),),
                        SizedBox(height: 10,),
                        Icon(
                          Icons.sticky_note_2_outlined,
                          color: Colors.yellow,size: 35,),
                        SizedBox(height: 20,),
                      ],
                    ),
                  ),
                ),
                //G2G
                SizedBox(
                  width: 300,height: 130,
                  child: Card(
                      color: Colors.pink[900],
                      child: Column(
                        children:  [
                          const SizedBox(height: 15,),
                          const Text("Executive member Erode",
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.white),),
                          const SizedBox(height: 15,),
                          const Text("211",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,),),
                          const SizedBox(height: 15,),

                          Wrap(
                            runSpacing: 20,
                           spacing: 20,
                           // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: const [

                              Text("Gold : 27",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10),),

                              Text("Silver : 83",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10),),
                            ],
                          ),
                          const SizedBox(height: 20,),

                        ],

                      )
                  ),
                ),

                //Executive member Gobi
                SizedBox(
                  width: 300,height: 130,
                  child: Card(
                      color: Colors.red[900],
                      child: Column(
                        children: const [
                          SizedBox(height: 10,),
                          Text("Executive member Gobi",
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.white),),
                          SizedBox(height: 10,),
                          Text("2",
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.white),),
                          SizedBox(height: 10,),
                          Icon(Icons.person_add_alt,
                            color: Colors.yellow,
                            size: 35,),
                          SizedBox(height: 20,),

                        ],

                      )
                  ),
                ),

                //Doctor's wing
                SizedBox(
                  width: 300,height: 130,
                  child: Card(
                    color: Colors.lime[900],
                    child: Column(
                      children: const [
                        SizedBox(height: 10,),
                        Text("Doctor's wing",
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.white),),
                        SizedBox(height: 10,),
                        Text("2",
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.white),),
                        SizedBox(height: 10,),
                        Icon(
                          Icons.favorite_border_rounded,
                          color: Colors.pinkAccent,
                          size: 35,),
                        SizedBox(height: 20,),

                      ],
                    ),
                  ),
                ),

                //Student's wing
                SizedBox(
                  width: 300,height: 130,
                  child: Card(
                    color: Colors.lightGreen[900],
                    child: Column(
                      children: const [
                        SizedBox(height: 10,),
                        Text("Student's wing",
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.white),),
                        SizedBox(height: 10,),
                        Text("1",style: TextStyle(
                            fontSize: 14,
                            color: Colors.white),),
                        SizedBox(height: 10,),
                        Icon(Icons.laptop_chromebook,
                          color: Colors.yellow,
                          size: 35,),
                        SizedBox(height: 20,),
                      ],
                    ),
                  ),
                ),

                //Women's Executing wing
                SizedBox(width: 300,height: 130,
                  child: Card(
                      color: Colors.cyan[900],
                      child: Column(
                        children: [
                          const SizedBox(height: 10,),
                          const Text("Women's Executive wing",
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.white),),
                          const SizedBox(height: 10,),
                          const Text("44",style: TextStyle(
                              fontSize: 14,
                              color: Colors.white),),
                          const SizedBox(height: 10,),
                          Icon(
                            Icons.energy_savings_leaf_outlined,
                            color: Colors.lightGreenAccent[400],
                            size: 35,),
                          const SizedBox(height: 20,),

                        ],

                      )
                  ),
                ),

                //Non Executive Members
                SizedBox(width: 300,height: 130,
                  child: Card(
                      color: Colors.yellow[900],
                      child: Column(
                        children: const [
                          SizedBox(height: 10,),
                          Text("Non Executive Members",
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.white),),
                          SizedBox(height: 10,),
                          Text("437",
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.white),),
                          SizedBox(height: 10,),
                          Icon(
                            Icons.people,
                            color: Colors.yellow,
                            size: 35,),
                          SizedBox(height: 20,),
                        ],
                      )
                  ),
                ),

                //Total Gib Members
                SizedBox(
                  width: 300,height: 130,
                  child: Card(
                    color: Colors.pink,
                    child: Column(
                      children: const [
                        SizedBox(height: 10,),
                        Text("Total Gib Members",
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.white),),
                        SizedBox(height: 10,),
                        Text("1015",
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.white),),
                        SizedBox(height: 10,),
                        Icon(
                          Icons.people,
                          color: Colors.limeAccent,
                          size: 35,),
                        SizedBox(height: 20,),

                      ],
                    ),
                  ),
                ),

                //Current Year Transaction(From Thank note)
                SizedBox(
                  width: 300,height: 130,
                  child: Card(
                    color: Colors.blueGrey[900],
                    child: Column(
                      children: const [
                        SizedBox(height: 10,),
                        Text("Current Year Transaction\n(From Thank note)",
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.white),),
                        SizedBox(height: 10,),
                        Text("₹",
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.white),),
                        SizedBox(height: 10,),
                        Icon(
                          Icons.people,
                          color: Colors.yellow,
                          size: 35,),
                        SizedBox(height: 10,),
                      ],
                    ),
                  ),
                ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );*/
