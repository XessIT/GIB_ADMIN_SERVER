import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '../main.dart';
import 'member_update_registration.dart';

class ExecutiveMembers extends StatelessWidget {
  const ExecutiveMembers({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: ExecutiveMembersPage(),
    );
  }
}

class ExecutiveMembersPage extends StatefulWidget {
  const ExecutiveMembersPage({Key? key}) : super(key: key);

  @override
  State<ExecutiveMembersPage> createState() => _ExecutiveMembersPageState();
}

final _formKey = GlobalKey<FormState>();
String dropdownvalue = '10';
var items = [
  '10',
  '25',
  '50',
  '100',
];

class _ExecutiveMembersPageState extends State<ExecutiveMembersPage> {
  TextEditingController search = TextEditingController();
  String name = "";
  // String companyname ="";
  String membertype = "Executive Men's Wing";
  String sno = "";
  @override
  void initState() {
    getData();
    // TODO: implement initState
    super.initState();
  }

  List<Map<String, dynamic>> data = [];
  Future<void> getData() async {
    print('Attempting to make HTTP request...');
    try {
      final url = Uri.parse(
          'http://mybudgetbook.in/GIBADMINAPI/womens_executive.php?member_type=$membertype');
      print(url);
      final response = await http.get(url);
      print("ResponseStatus: ${response.statusCode}");
      print("Response: ${response.body}");
      // http.Response response = await http.get(url);
      //  var data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print("ResponseData: $responseData");
        final List<dynamic> itemGroups = responseData;
        setState(() {});
        data = itemGroups.cast<Map<String, dynamic>>();
        print('Data: $data');
        print("Id: ${data[0]["ID"]}");
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
    return MyScaffold(
      route: '/view_executive_members',
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Container(
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
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(children: [
                    const SizedBox(
                      height: 20,
                    ),
                    //  View Executive Members text and icon starts
                    Text(
                      " View Executive Members",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(
                          width: 300,
                          child: TextFormField(
                            onChanged: (val) {
                              setState(() {
                                name = val;
                                // companyname =val;
                              });
                            },
                            controller: search,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.search),
                              border: OutlineInputBorder(),
                              hintText: 'Search ',
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Container(
                      height: 300,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Table(
                          border: TableBorder.all(),
                          defaultColumnWidth: const FixedColumnWidth(190.0),
                          columnWidths: const <int, TableColumnWidth>{
                            0: FixedColumnWidth(70),
                            2: FixedColumnWidth(100),
                            5: FixedColumnWidth(70)
                          },
                          //  5:FixedColumnWidth(140),},
                          defaultVerticalAlignment:
                              TableCellVerticalAlignment.middle,
                          children: [
                            TableRow(children: [
                              //s.no
                              TableCell(
                                  child: Center(
                                child: Column(
                                  children: [
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    Text('S.No',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                  ],
                                ),
                              )),
                              //name
                              TableCell(
                                child: Center(
                                  child: Text('Name',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall),
                                ),
                              ),
                              // user id
                              TableCell(
                                child: Center(
                                  child: Text('User Id',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall),
                                ),
                              ),
                              // email
                              TableCell(
                                child: Center(
                                  child: Text('Email',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall),
                                ),
                              ),
                              // mobile
                              TableCell(
                                child: Center(
                                  child: Text('Mobile',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall),
                                ),
                              ),
                              // Edit
                              TableCell(
                                child: Center(
                                  child: Text('Edit',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall),
                                ),
                              ),
                            ]),
                            for (var i = 0; i < data.length; i++) ...[
                              if (data[i]["first_name"]
                                  .toString()
                                  .toLowerCase()
                                  .startsWith(name.toLowerCase()))

                                //   if( storedocs[i]["Company Name"].toString().toLowerCase().startsWith(name.toLowerCase()))

                                TableRow(
                                    decoration:
                                        BoxDecoration(color: Colors.grey[200]),
                                    children: [
                                      //s.no
                                      TableCell(
                                        child: Center(
                                            child: Text(
                                          '${i + 1}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall,
                                        )),
                                      ),
                                      // name
                                      TableCell(
                                        child: Center(
                                            child: Text(
                                          '${data[i]["first_name"]}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall,
                                        )),
                                      ),
                                      //User id
                                      TableCell(
                                        child: Center(
                                            child: Text(
                                          '${data[i]["member_id"]}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall,
                                        )),
                                      ),
                                      // email
                                      TableCell(
                                        child: Center(
                                          child: Text(
                                            '${data[i]["email"]}',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall,
                                          ),
                                        ),
                                      ),
                                      //mobile
                                      TableCell(
                                        child: Center(
                                          child: Text(
                                            '${data[i]["mobile"]}',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall,
                                          ),
                                        ),
                                      ),
                                      TableCell(
                                          child: Center(
                                        child: Column(
                                          children: [
                                            const SizedBox(
                                              height: 8,
                                            ),
                                            IconButton(
                                                onPressed: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              UpdateRegisterationPage(
                                                                  currentID: data[
                                                                          i]
                                                                      ["id"])));
                                                },
                                                icon: const Icon(
                                                  Icons.edit_note,
                                                  color: Colors.blue,
                                                )),
                                            const SizedBox(
                                              height: 8,
                                            ),
                                          ],
                                        ),
                                      )),
                                    ]),
                            ]
                          ],
                        ),
                      ),
                    )
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
