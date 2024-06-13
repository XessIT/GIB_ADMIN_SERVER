import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../addImageView.dart';
import '../gib_achivements/gib_achivements_view_photos.dart';
import '../main.dart';
import 'package:http/http.dart' as http;

class ListAds extends StatelessWidget {
  const ListAds({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: ListAdsPage(),
    );
  }
}

class ListAdsPage extends StatefulWidget {
  const ListAdsPage({Key? key}) : super(key: key);

  @override
  State<ListAdsPage> createState() => _ListAdsPageState();
}

class _ListAdsPageState extends State<ListAdsPage> {
  final _formKey = GlobalKey<FormState>();
  List<Map<String, dynamic>> data = [];
  int _rowsPerPage = 10;
  int _currentPage = 0;

  Future<void> getData() async {
    print('Attempting to fetch data...');
    try {
      final url =
      Uri.parse('http://mybudgetbook.in/GIBADMINAPI/ads.php?table=ads');
      print('Request URL: $url');
      final response = await http.get(url);
      print("ResponseStatus: ${response.statusCode}");
      print("Response: ${response.body}");
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print("ResponseData: $responseData");

        if (responseData is List) {
          final List<dynamic> itemGroups = responseData;
          if (itemGroups.isNotEmpty) {
            setState(() {
              data = itemGroups.cast<Map<String, dynamic>>();
              for (var item in data) {
                item['ads_image'] = sanitizeImageUrl(item["ads_image"]);
              }
            });
            print('Data: $data');
          } else {
            print('Empty data list.');
          }
        } else if (responseData is Map<String, dynamic>) {
          setState(() {
            data = [responseData];
            data[0]['ads_image'] = sanitizeImageUrl(responseData["ads_image"]);
          });
          print('Data: $data');
        } else {
          print('Unexpected response format.');
        }
      } else {
        print('Error: ${response.statusCode}');
      }
      print('HTTP request completed. Status code: ${response.statusCode}');
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  String sanitizeImageUrl(String? imageUrl) {
    if (imageUrl != null && imageUrl.isNotEmpty) {
      imageUrl = imageUrl.replaceAll('\\', '/').replaceAll(RegExp('^/'), '');
      imageUrl = 'http://mybudgetbook.in/GIBADMINAPI/$imageUrl';
      print('Sanitized Image URL: $imageUrl');
      return imageUrl;
    } else {
      print('Ads image URL is null or empty.');
      return '';
    }
  }

  List<Map<String, dynamic>> getPaginatedData() {
    final int startIndex = _currentPage * _rowsPerPage;
    final int endIndex = startIndex + _rowsPerPage;
    return data.sublist(
        startIndex, endIndex > data.length ? data.length : endIndex);
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      route: '/list_ads_page',
      body: Form(
        key: _formKey,
        child: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 50,
              ),
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            columnSpacing: 20,
                            columns: [
                              DataColumn(
                                label: Text(
                                  "Ad's",
                                  style: Theme
                                      .of(context)
                                      .textTheme
                                      .bodySmall,
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  "Member Name",
                                  style: Theme
                                      .of(context)
                                      .textTheme
                                      .bodySmall,
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  "Member Type",
                                  style: Theme
                                      .of(context)
                                      .textTheme
                                      .bodySmall,
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  "From Date",
                                  style: Theme
                                      .of(context)
                                      .textTheme
                                      .bodySmall,
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  "To Date",
                                  style: Theme
                                      .of(context)
                                      .textTheme
                                      .bodySmall,
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  "Price",
                                  style: Theme
                                      .of(context)
                                      .textTheme
                                      .bodySmall,
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  "Action",
                                  style: Theme
                                      .of(context)
                                      .textTheme
                                      .bodySmall,
                                ),
                              ),
                            ],
                            rows: [
                              for (var item in data)
                                DataRow(
                                  color: MaterialStateColor.resolveWith(
                                        (states) => Colors.grey[200]!,
                                  ),
                                  cells: [
                                    DataCell(
                                      Column(
                                        children: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      AddImageView(
                                                        membername: item['member_name'],
                                                        memberId: item['id'],
                                                      ),
                                                ),
                                              );
                                            },
                                            child: Text(
                                              "View",
                                              style: TextStyle(
                                                  color: Colors.green),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    DataCell(
                                      Center(
                                        child: Text(
                                            item['member_name'].toString(),
                                            style: Theme
                                                .of(context)
                                                .textTheme
                                                .bodySmall),
                                      ),
                                    ),
                                    DataCell(
                                      Center(
                                        child: Text(item['member_type'] ?? '',
                                            style: Theme
                                                .of(context)
                                                .textTheme
                                                .bodySmall),
                                      ),
                                    ),
                                    DataCell(
                                      Center(
                                        child: Text(
                                          DateFormat('dd/MM/yyyy').format(
                                            DateTime.parse(
                                                item['from_date'] ?? ''),
                                          ),
                                          style: Theme
                                              .of(context)
                                              .textTheme
                                              .bodySmall,
                                        ),
                                      ),
                                    ),
                                    DataCell(
                                      Center(
                                        child: Text(
                                          DateFormat('dd/MM/yyyy').format(
                                            DateTime.parse(
                                                item['to_date'] ?? ''),
                                          ),
                                          style: Theme
                                              .of(context)
                                              .textTheme
                                              .bodySmall,
                                        ),
                                      ),
                                    ),
                                    DataCell(
                                      Center(
                                        child: Text(
                                            item['price'] ?? '', style: Theme
                                            .of(context)
                                            .textTheme
                                            .bodySmall),
                                      ),
                                    ),
                                    DataCell(
                                      Center(
                                        child: IconButton(
                                          icon: const Icon(
                                              Icons.delete, color: Colors.red),
                                          onPressed: () {
                                            showDialog(
                                              context: context,
                                              builder: (ctx) =>
                                                  AlertDialog(
                                                    backgroundColor: Colors
                                                        .grey[800],
                                                    title: const Text('Delete',
                                                        style: TextStyle(
                                                            color: Colors
                                                                .white)),
                                                    content: const Text(
                                                        "Do you want to Delete the Subscription Details?",
                                                        style: TextStyle(
                                                            color: Colors
                                                                .white)),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () async {
                                                          delete(item["id"]);
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (
                                                                      context) => const ListAds()));
                                                          ScaffoldMessenger.of(
                                                              context)
                                                              .showSnackBar(
                                                              const SnackBar(
                                                                content: Text(
                                                                    "Successfully Deleted "),
                                                              ));
                                                        },
                                                        child: const Text(
                                                            'Yes'),
                                                      ),
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: const Text('No'),
                                                      )
                                                    ],
                                                  ),
                                            );
                                          },
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
              ),
            ],
          ),
        ),
      ),
    );
  }


  Future<void> delete(String getID) async {
    try {
      final url = Uri.parse(
          'http://mybudgetbook.in/GIBADMINAPI/ads.php?id=$getID');
      print('member_category_url :$url');
      final response = await http.delete(url);
      if (response.statusCode == 200) {
        print("Cat-status code :${response.statusCode}");
        print("Cat-response body :${response.body}");
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }
}
