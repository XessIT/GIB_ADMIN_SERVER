import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../addImageView.dart';
import '../gib_achivements/gib_achivements_view_photos.dart';
import '../main.dart';

class superAdmin extends StatefulWidget {
  const superAdmin({Key? key}) : super(key: key);

  @override
  State<superAdmin> createState() => _superAdminState();
}

class _superAdminState extends State<superAdmin> {
  final _formKey = GlobalKey<FormState>();
  List<Map<String, dynamic>> data = [];

  Future<void> getMembers() async {
    try {
      final url =
          Uri.parse('http://mybudgetbook.in/GIBADMINAPI/superadmin.php');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        print('Response body: ${response.body}');

        List<dynamic> responseData = json.decode(response.body);
        print('Decoded data: $responseData');

        if (responseData is List && responseData.isNotEmpty) {
          setState(() {
            data =
                responseData.map((e) => Map<String, dynamic>.from(e)).toList();
            print("Members: $data");
          });
        } else {
          print('Empty or invalid response data.');
        }
      } else {
        print('Error fetching members: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  void _showConfirmationDialog(String memberId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm Access"),
          content: Text("Do you want to Give or Remove access?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _handleAccessAction(memberId, 'update'); // Give Access
              },
              child: Text("Give Access"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _handleAccessAction(memberId, 'remove'); // Remove Access
              },
              child: Text("Remove Access"),
            ),
          ],
        );
      },
    );
  }

  void _handleAccessAction(String memberId, String action) async {
    try {
      final url =
          Uri.parse('http://mybudgetbook.in/GIBADMINAPI/superadmin.php');
      final response = await http.put(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'member_id': memberId,
          'action': action,
        }),
      );

      if (response.statusCode == 200) {
        print('Admin access updated successfully.');
      } else {
        print('Failed to update admin access: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  @override
  void initState() {
    super.initState();
    getMembers();
  }

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      route: '/superAdmin',
      body: Form(
        key: _formKey,
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 50),
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Table(
                          border: TableBorder.all(),
                          defaultColumnWidth: const FixedColumnWidth(150),
                          columnWidths: const <int, TableColumnWidth>{
                            0: FixedColumnWidth(100),
                            1: FixedColumnWidth(200),
                            2: FixedColumnWidth(200),
                            4: FixedColumnWidth(230),
                            5: FixedColumnWidth(200),
                          },
                          defaultVerticalAlignment:
                              TableCellVerticalAlignment.middle,
                          children: [
                            TableRow(
                              children: [
                                TableCell(
                                  child: Center(
                                    child: Text(
                                      "S.No",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineMedium,
                                    ),
                                  ),
                                ),
                                TableCell(
                                  child: Center(
                                    child: Text(
                                      "Name",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineMedium,
                                    ),
                                  ),
                                ),
                                TableCell(
                                  child: Center(
                                    child: Text(
                                      "Mobile",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineMedium,
                                    ),
                                  ),
                                ),
                                TableCell(
                                  child: Center(
                                    child: Text(
                                      "Member ID",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineMedium,
                                    ),
                                  ),
                                ),
                                TableCell(
                                  child: Center(
                                    child: Text(
                                      "Company Name",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineMedium,
                                    ),
                                  ),
                                ),
                                TableCell(
                                  child: Center(
                                    child: Text(
                                      "Role",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineMedium,
                                    ),
                                  ),
                                ),
                                TableCell(
                                  child: Center(
                                    child: Text(
                                      "Admin Access",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineMedium,
                                    ),
                                  ),
                                ),
                                TableCell(
                                  child: Center(
                                    child: Text(
                                      "Action",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineMedium,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            for (var index = 0; index < data.length; index++)
                              TableRow(
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                ),
                                children: [
                                  TableCell(
                                    child: Center(child: Text("${index + 1}")),
                                  ),
                                  TableCell(
                                    child: Center(
                                      child: Text(
                                        '${data[index]['first_name'] ?? ''} ${data[index]['last_name'] ?? ''}',
                                      ),
                                    ),
                                  ),
                                  TableCell(
                                    child: Center(
                                      child: Text(data[index]['mobile'] ?? ''),
                                    ),
                                  ),
                                  TableCell(
                                    child: Center(
                                      child:
                                          Text(data[index]['member_id'] ?? ''),
                                    ),
                                  ),
                                  TableCell(
                                    child: Center(
                                      child: Text(
                                          data[index]['company_name'] ?? ''),
                                    ),
                                  ),
                                  TableCell(
                                    child: Center(
                                      child: Text(data[index]['role'] ?? ''),
                                    ),
                                  ),
                                  TableCell(
                                    child: Center(
                                      child: Text(
                                          data[index]['admin_access'] ?? ''),
                                    ),
                                  ),
                                  TableCell(
                                    child: Center(
                                      child: TextButton(
                                        onPressed: () {
                                          _showConfirmationDialog(
                                              data[index]['member_id'] ?? '');
                                        },
                                        child: Text("Access"),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
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
