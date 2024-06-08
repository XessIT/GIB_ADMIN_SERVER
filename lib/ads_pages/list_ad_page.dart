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
                child: Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Container(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Table(
                            border: TableBorder.all(),
                            defaultColumnWidth: const FixedColumnWidth(150),
                            columnWidths: const <int, TableColumnWidth>{
                              0: FixedColumnWidth(150),
                              1: FixedColumnWidth(200),
                              2: FixedColumnWidth(240),
                              5: FixedColumnWidth(180),
                            },
                            defaultVerticalAlignment:
                                TableCellVerticalAlignment.middle,
                            children: [
                              TableRow(
                                children: [
                                  TableCell(
                                    child: Center(
                                      child: Text(
                                        "Ad's",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineMedium,
                                      ),
                                    ),
                                  ),
                                  TableCell(
                                    child: Center(
                                      child: Text(
                                        "Member Name",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineMedium,
                                      ),
                                    ),
                                  ),
                                  TableCell(
                                    child: Center(
                                      child: Text(
                                        "Member Type",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineMedium,
                                      ),
                                    ),
                                  ),
                                  TableCell(
                                    child: Center(
                                      child: Text(
                                        "From Date",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineMedium,
                                      ),
                                    ),
                                  ),
                                  TableCell(
                                    child: Center(
                                      child: Text(
                                        "To Date",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineMedium,
                                      ),
                                    ),
                                  ),
                                  TableCell(
                                    child: Center(
                                      child: Text(
                                        "Price",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineMedium,
                                      ),
                                    ),
                                  ),
                                  TableCell(
                                    child: Center(
                                      child: Column(
                                        children: [
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            "Action",
                                            style: Theme.of(context)
                                                .textTheme
                                                .headlineMedium,
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              for (var item in data)
                                TableRow(
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                  ),
                                  children: [
                                    TableCell(
                                      child: Center(
                                        child: Column(
                                          children: [
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            SizedBox(
                                                height: 50,
                                                width: 100,
                                                child: TextButton(
                                                  onPressed: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              AddImageView(
                                                                membername: item[
                                                                    'member_name'],
                                                                memberId:
                                                                    item['id'],
                                                              )),
                                                    );
                                                  },
                                                  child: Text(
                                                    "View",
                                                    style: TextStyle(
                                                        color: Colors.green),
                                                  ),
                                                )),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    TableCell(
                                      child: Center(
                                        child: Text(
                                            item['member_name'].toString()),
                                      ),
                                    ),
                                    TableCell(
                                      child: Center(
                                        child: Text(item['member_type'] ?? ''),
                                      ),
                                    ),
                                    TableCell(
                                      child: Center(
                                        child: Text(
                                          DateFormat('dd/MM/yyyy').format(
                                              DateTime.parse(
                                                  item['from_date'] ?? '')),
                                        ),
                                      ),
                                    ),
                                    TableCell(
                                      child: Center(
                                        child: Text(
                                          DateFormat('dd/MM/yyyy').format(
                                              DateTime.parse(
                                                  item['to_date'] ?? '')),
                                        ),
                                      ),
                                    ),
                                    TableCell(
                                      child: Center(
                                        child: Text(item['price'] ?? ''),
                                      ),
                                    ),
                                    TableCell(
                                      child: Center(
                                        child: IconButton(
                                          onPressed: () {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              _showDialog(context);
                                            }
                                          },
                                          icon: const Icon(Icons.delete),
                                          color: Colors.redAccent,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
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
      ),
    );
  }
}

void _showDialog(BuildContext context) {
  showDialog<void>(
    context: context,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        backgroundColor: Colors.black,
        title: Text(
          'Delete',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        content: Text('Are you sure do you want to delete this?',
            style: Theme.of(context).textTheme.headlineMedium),
        actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                child: Text(
                  'cancel',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                },
              ),
              TextButton(
                child: Text(
                  'delete',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                onPressed: () {
                  // Handle delete action
                },
              ),
            ],
          ),
        ],
      );
    },
  );
}
