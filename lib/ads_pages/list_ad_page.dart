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
                child: Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Center(
                        child: Container(
                          child: PaginatedDataTable(
                            header: Text('Ad\'s'),
                            columnSpacing: 50,
                            columns: [
                              DataColumn(
                                  label: Text(
                                'S.No.',
                                style:
                                    Theme.of(context).textTheme.headlineSmall,
                              )),
                              DataColumn(
                                  label: Text(
                                'Member Name',
                                style:
                                    Theme.of(context).textTheme.headlineSmall,
                              )),
                              DataColumn(
                                  label: Text(
                                'Member Type',
                                style:
                                    Theme.of(context).textTheme.headlineSmall,
                              )),
                              DataColumn(
                                  label: Text(
                                'From Date',
                                style:
                                    Theme.of(context).textTheme.headlineSmall,
                              )),
                              DataColumn(
                                  label: Text(
                                'To Date',
                                style:
                                    Theme.of(context).textTheme.headlineSmall,
                              )),
                              DataColumn(
                                  label: Text(
                                'Price',
                                style:
                                    Theme.of(context).textTheme.headlineSmall,
                              )),
                              DataColumn(
                                  label: Text(
                                'Action',
                                style:
                                    Theme.of(context).textTheme.headlineSmall,
                              )),
                            ],
                            source: _MyTableDataSource(
                                getPaginatedData(), context), // Pass context
                            rowsPerPage: _rowsPerPage,
                            onPageChanged: (int newPage) {
                              setState(() {
                                _currentPage = newPage;
                              });
                            },
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

class _MyTableDataSource extends DataTableSource {
  final List<Map<String, dynamic>> data;
  final BuildContext context;
  int _index = 0; // Add index field

  _MyTableDataSource(this.data, this.context);

  @override
  DataRow? getRow(int index) {
    if (index >= data.length) {
      return null;
    }
    final item = data[index];
    _index++; // Increment index for each row
    return DataRow(
      cells: [
        DataCell(Text(
          _index.toString(),
          style: Theme.of(context).textTheme.bodySmall,
        )), // Add serial number cell
        DataCell(Text(item['member_name'].toString(),
            style: Theme.of(context).textTheme.bodySmall)),
        DataCell(Text(item['member_type'] ?? '',
            style: Theme.of(context).textTheme.bodySmall)),
        DataCell(Text(item['from_date'] ?? '',
            style: Theme.of(context).textTheme.bodySmall)),
        DataCell(Text(item['to_date'] ?? '',
            style: Theme.of(context).textTheme.bodySmall)),
        DataCell(Text(item['price'] ?? '',
            style: Theme.of(context).textTheme.bodySmall)),
        DataCell(
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddImageView(
                    membername: item['member_name'],
                    memberId: item['id'],
                  ),
                ),
              );
            },
            child: Text('View'),
          ),
        ),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false; // Implement isRowCountApproximate

  @override
  int get rowCount => data.length; // Implement rowCount

  @override
  int get selectedRowCount => 0; // Implement selectedRowCount
}
