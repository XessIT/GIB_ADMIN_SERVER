import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:http/http.dart'as http;
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../main.dart';

import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';


/// G2GReport

class G2GReport extends StatefulWidget {
  const G2GReport({Key? key}) : super(key: key);

  @override
  State<G2GReport> createState() => _G2GReportState();
}
class _G2GReportState extends State<G2GReport> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: MyScaffold(

        route: "/dasg2g_report_page",
        body: Container(

          color: Colors.white,
          child: Center(
            child: Column(

              children:  [
                const Align(
                  alignment: Alignment.center,
                  child: TabBar(
                    //  controller: _tabController,
                      isScrollable: true,
                      labelColor: Colors.green,
                      unselectedLabelColor: Colors.black,
                      tabs:[
                        Tab(text:("Over All"),),
                        Tab(text:("Member Wise"),),
                      ]),
                ),
                const SizedBox(height: 30,),
                Container(
                    height:1100,
                    child:const TabBarView(children: [
                      G2GOverallReportPage(),
                      G2GMemberWise(),
                    ])
                )
              ],
            ),
          ),
        ),

      ),
    );
  }
}



class G2GOverallReportPage extends StatefulWidget {
  const G2GOverallReportPage({Key? key}) : super(key: key);

  @override
  State<G2GOverallReportPage> createState() => _G2GOverallReportPageState();
}

class _G2GOverallReportPageState extends State<G2GOverallReportPage> {
  final _formKey = GlobalKey<FormState>();
  List<Map<String, dynamic>> business = [];
  List<Map<String, dynamic>> filteredBusiness = [];
  TextEditingController districtController = TextEditingController();
  TextEditingController chapterController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  DateTime? fromDate;
  DateTime? toDate;

  int currentPage = 0;
  final int rowsPerPage = 15;

  @override
  void initState() {
    super.initState();
   getBusinessSlip();
  }

  Future<void> getBusinessSlip() async {
    try {
      final response = await http.get(Uri.parse('http://mybudgetbook.in/GIBADMINAPI/g2g_report.php'));
      if (response.statusCode == 200) {
        setState(() {
          business = List<Map<String, dynamic>>.from(json.decode(response.body));
          filteredBusiness = business; // Initialize filteredBusiness with all data
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void filterData() {
    setState(() {
      filteredBusiness = business.where((item) {
        final districtMatch = districtController.text.isEmpty || (item['district']?.toString().toLowerCase().contains(districtController.text.toLowerCase()) ?? false);
        final chapterMatch = chapterController.text.isEmpty || (item['chapter']?.toString().toLowerCase().contains(chapterController.text.toLowerCase()) ?? false);
        final date = DateTime.parse(item['date']).toLocal();
        final fromDateMatch = fromDate == null || date.isAfter(fromDate!) || date.isAtSameMomentAs(fromDate!);
        final toDateMatch = toDate == null || date.isBefore(toDate!) || date.isAtSameMomentAs(toDate!);
        return districtMatch && chapterMatch && fromDateMatch && toDateMatch;
      }).toList();
    });
  }

  Future<void> _selectFromDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: fromDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != fromDate)
      setState(() {
        fromDate = picked;
      });
  }

  Future<void> _selectToDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: toDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != toDate)
      setState(() {
        toDate = picked;
      });
  }

  List<Map<String, dynamic>> getCurrentPageData() {
    final start = currentPage * rowsPerPage;
    final end = start + rowsPerPage;
    return filteredBusiness.sublist(start, end > filteredBusiness.length ? filteredBusiness.length : end);
  }

  void nextPage() {
    setState(() {
      if (currentPage < (filteredBusiness.length / rowsPerPage).ceil() - 1) {
        currentPage++;
      }
    });
  }

  void previousPage() {
    setState(() {
      if (currentPage > 0) {
        currentPage--;
      }
    });
  }

  Future<Uint8List> generatePDF(List<Map<String, dynamic>> data) async {
    final pdf = pw.Document(pageMode: PdfPageMode.fullscreen);

    int index = 0; // Start index at 1 for S.No

    final columnWidths = <int, pw.TableColumnWidth>{
      0: pw.FixedColumnWidth(30),
      1: pw.FixedColumnWidth(85),
      2: pw.FixedColumnWidth(80),
      3: pw.FixedColumnWidth(90),
      4: pw.FixedColumnWidth(80),
      5: pw.FixedColumnWidth(75),
      6: pw.FixedColumnWidth(75),
      7: pw.FixedColumnWidth(80),
      8: pw.FixedColumnWidth(90),
      9: pw.FixedColumnWidth(80),
      10: pw.FixedColumnWidth(80),
      11: pw.FixedColumnWidth(90),
      12: pw.FixedColumnWidth(80),
    };

    final imageData = await rootBundle.load('assets/logo.png');
    final imageBytes = imageData.buffer.asUint8List();


    pdf.addPage(
      pw.MultiPage(

        header: (pw.Context context) {
          return pw.Container(
              alignment: pw.Alignment.center,
              padding: pw.EdgeInsets.all(10),
              child: pw.Column(
                children: [
                  pw.Row(
                    children: [
                      pw.Text('G2G Report', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
                      pw.Spacer(),
                      pw.Image(pw.MemoryImage(imageBytes), width: 50, height: 50)

                    ],

                  ),

                  pw.Divider(),
                ],

              )

          );
        },
        build: (pw.Context context) {
          return [
            pw.Table.fromTextArray(
              columnWidths: columnWidths,
              cellStyle: pw.TextStyle(fontSize: 5),
              headerStyle: pw.TextStyle(fontSize: 5), // Set text size to 12
              data: <List<String>>[
                <String>[
                  'SNo',
                  'Date',
                  'Member Name',
                  'Member Mobile\n Number',
                  'Member Company',
                  'From Time',
                  'To Time',
                  'Met\n Member Name',
                  'Met\nMobile Number',
                  'Met\n Company ',
                  'District',
                  'Chapter',
                  'Location',
                ],
                ...data.map((item) {
                  index++;
                  // Ensure all values are converted to strings before adding to the list
                  return [
                    '$index',
                    DateFormat('dd-MM-yyyy').format(DateTime.parse(item['date'])),
                    item['first_name']?.toString() ?? '', // Convert to string or empty string
                    item['mobile']?.toString() ?? '',
                    item['company_name']?.toString() ?? '',
                    item['from_time']?.toString() ?? '',
                    item['to_time']?.toString() ?? '',
                    item['met_name']?.toString() ?? '',
                    item['met_number']?.toString() ?? '',
                    item['met_company_name']?.toString() ?? '',
                    item['district']?.toString() ?? '',
                    item['chapter']?.toString() ?? '',
                    item['location']?.toString() ?? '',
                  ];
                }).toList(),
              ],
            ),
          ];
        },
      ),
    );

    return pdf.save();
  }

  void downloadPdf() async {
    final pdfBytes = await generatePDF(filteredBusiness);
    await Printing.sharePdf(bytes: pdfBytes, filename: 'G2G_report.pdf');
  }

  @override
  Widget build(BuildContext context) {
    int index = currentPage * rowsPerPage;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Form(
        key: _formKey,
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(0.0),
                child: Container(
                  padding: const EdgeInsets.all(3.0),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Icon(Icons.report),
                            SizedBox(width: 10),
                            Text(
                              'G2G Report',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/dasg2g_report_page');
                              },
                              icon: Icon(Icons.refresh),
                            ),
                          ],
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Wrap(
                              children: [
                                Row(
                                  children: [
                                    SizedBox(width: 10),
                                    SizedBox(
                                      width: 170,
                                      height: 35,
                                      child: TypeAheadFormField<String>(
                                        textFieldConfiguration: TextFieldConfiguration(
                                          controller: districtController,
                                          decoration: const InputDecoration(
                                            fillColor: Colors.white,
                                            filled: true,
                                            labelText: "District",
                                            labelStyle: TextStyle(fontSize: 14),
                                          ),
                                          style: TextStyle(fontSize: 14),
                                        ),
                                        suggestionsCallback: (pattern) async {
                                          return business
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
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return "* Required District";
                                          } else {
                                            return null;
                                          }
                                        },
                                        onSuggestionSelected: (suggestion) async {
                                          setState(() {
                                            districtController.text = suggestion;
                                          });
                                        },
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    SizedBox(
                                      width: 170,
                                      height: 35,
                                      child: TypeAheadFormField<String>(
                                        textFieldConfiguration: TextFieldConfiguration(
                                          controller: chapterController,
                                          decoration: const InputDecoration(
                                            fillColor: Colors.white,
                                            filled: true,
                                            labelText: "Chapter",
                                            labelStyle: TextStyle(fontSize: 14),
                                          ),
                                          style: TextStyle(fontSize: 14),
                                        ),
                                        suggestionsCallback: (pattern) async {
                                          return business
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
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return "* Required Chapter";
                                          } else {
                                            return null;
                                          }
                                        },
                                        onSuggestionSelected: (suggestion) async {
                                          setState(() {
                                            chapterController.text = suggestion;
                                          });
                                        },
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    SizedBox(
                                      width: 170,
                                      height: 35,
                                      child: GestureDetector(
                                        onTap: () => _selectFromDate(context),
                                        child: AbsorbPointer(
                                          child: TextFormField(
                                            decoration: InputDecoration(
                                              fillColor: Colors.white,
                                              filled: true,
                                              labelText: 'From Date',
                                              labelStyle: TextStyle(fontSize: 14),
                                            ),
                                            controller: TextEditingController(
                                              text: fromDate != null ? DateFormat('dd-MM-yyyy').format(fromDate!) : '',
                                            ),
                                            style: TextStyle(fontSize: 14),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    SizedBox(
                                      width: 170,
                                      height: 35,
                                      child: GestureDetector(
                                        onTap: () => _selectToDate(context),
                                        child: AbsorbPointer(
                                          child: TextFormField(
                                            decoration: InputDecoration(
                                              fillColor: Colors.white,
                                              filled: true,
                                              labelText: 'To Date',
                                              labelStyle: TextStyle(fontSize: 14),
                                            ),
                                            controller: TextEditingController(
                                              text: toDate != null ? DateFormat('dd-MM-yyyy').format(toDate!) : '',
                                            ),
                                            style: TextStyle(fontSize: 14),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Card(
                                      child: IconButton(
                                        icon: Icon(Icons.search),
                                        onPressed: () {
                                          filterData();
                                        },
                                      ),
                                    ),
                                    SizedBox(width: 10,),


                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 15,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Card(
                              child: IconButton(
                                  icon: Icon(Icons.picture_as_pdf),
                                  onPressed: () =>
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => PdfViewScreen(
                                            data: filteredBusiness,
                                            generatePDF: generatePDF,
                                          ),
                                        ),
                                      )
                              ),
                            ),
                            Card(
                              child: IconButton(
                                icon: Icon(Icons.download),
                                onPressed: downloadPdf,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(3.0),
                child: SingleChildScrollView(
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          const Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding: EdgeInsets.only(left: 5),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Details", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                          ),
                          filteredBusiness.isNotEmpty
                              ? Scrollbar(
                            thumbVisibility: true,
                            controller: _scrollController,

                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              controller: _scrollController,

                              child: SizedBox(
                                child: DataTable(
                                  columnSpacing: 20,
                                  columns: const [
                                    DataColumn(label: Text('S.No')),
                                    DataColumn(label: Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text('Date'),
                                    )),
                                    DataColumn(label: Text('Member Name')), /// 1
                                    DataColumn(label: Text('Member Mobile Number')),
                                    DataColumn(label: Text('Member Company')),
                                    DataColumn(label: Text('From Time')),
                                    DataColumn(label: Text('To Time')),
                                    DataColumn(label: Text('Met Member Name')),
                                    DataColumn(label: Text('Met Mobile Number')),
                                    DataColumn(label: Text('Met Company Name')),
                                    DataColumn(label: Text('District')),
                                    DataColumn(label: Text('Chapter')),
                                    DataColumn(label: Text('Location')), /// 11
                                    // Add more DataColumn widgets for other fields as needed
                                  ],
                                  rows: filteredBusiness.map((meeting) {
                                    index++;
                                    return DataRow(cells: [
                                      DataCell(Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Center(child: Text('$index', style: const TextStyle(fontWeight: FontWeight.normal, color: Colors.black, fontSize: 14.0))),
                                      )),
                                      DataCell(
                                        Center(
                                          child: Text(
                                            DateFormat('dd-MM-yyyy').format(DateTime.parse(meeting['date'])),
                                            style: const TextStyle(
                                                fontWeight: FontWeight.normal,
                                                color: Colors.black,
                                                fontSize: 14.0
                                            ),
                                          ),
                                        ),
                                      ),
                                      DataCell(Center(child: Text('${meeting['first_name']}', style: const TextStyle(fontWeight: FontWeight.normal, color: Colors.black, fontSize: 14.0)))),
                                      DataCell(Center(child: Text('${meeting['mobile']}', style: const TextStyle(fontWeight: FontWeight.normal, color: Colors.black, fontSize: 14.0)))),
                                      DataCell(Center(child: Text('${meeting['company_name']}', style: const TextStyle(fontWeight: FontWeight.normal, color: Colors.black, fontSize: 14.0)))),
                                      DataCell(Center(child: Text('${meeting['from_time']}', style: const TextStyle(fontWeight: FontWeight.normal, color: Colors.black, fontSize: 14.0)))),
                                      DataCell(Center(child: Text('${meeting['to_time']}', style: const TextStyle(fontWeight: FontWeight.normal, color: Colors.black, fontSize: 14.0)))),
                                      DataCell(Center(child: Text('${meeting['met_name']}', style: const TextStyle(fontWeight: FontWeight.normal, color: Colors.black, fontSize: 14.0)))),
                                      DataCell(Center(child: Text('${meeting['met_number']}', style: const TextStyle(fontWeight: FontWeight.normal, color: Colors.black, fontSize: 14.0)))),
                                      DataCell(Center(child: Text('${meeting['met_company_name']}', style: const TextStyle(fontWeight: FontWeight.normal, color: Colors.black, fontSize: 14.0)))),
                                      DataCell(Center(child: Text('${meeting['district']}', style: const TextStyle(fontWeight: FontWeight.normal, color: Colors.black, fontSize: 14.0)))),
                                      DataCell(Center(child: Text('${meeting['chapter']}', style: const TextStyle(fontWeight: FontWeight.normal, color: Colors.black, fontSize: 14.0)))),
                                      DataCell(Center(child: Text('${meeting['location']}', style: const TextStyle(fontWeight: FontWeight.normal, color: Colors.black, fontSize: 14.0)))),
                                      // Add more DataCell widgets for other fields as needed
                                    ]);
                                  }).toList(),
                                ),
                              ),
                            ),
                          )
                              : Center(child: Text('No Records Found')),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: previousPage,
                    disabledColor: Colors.grey,
                    color: currentPage > 0 ? Colors.black : Colors.grey,
                  ),
                  Text('Page ${currentPage + 1} of ${(filteredBusiness.length / rowsPerPage).ceil()}'),
                  IconButton(
                    icon: Icon(Icons.arrow_forward),
                    onPressed: nextPage,
                    disabledColor: Colors.grey,
                    color: currentPage < (filteredBusiness.length / rowsPerPage).ceil() - 1 ? Colors.black : Colors.grey,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}




class G2GMemberWise extends StatefulWidget {
  const G2GMemberWise({Key? key}) : super(key: key);

  @override
  _G2GMemberWiseState createState() => _G2GMemberWiseState();
}

class _G2GMemberWiseState extends State<G2GMemberWise> {
  final _formKey = GlobalKey<FormState>();
  List<Map<String, dynamic>> business = [];
  List<Map<String, dynamic>> filteredBusiness = [];
  TextEditingController nameController = TextEditingController();
  TextEditingController districtController = TextEditingController();
  TextEditingController chapterController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  DateTime? fromDate;
  DateTime? toDate;
  int currentPage = 0;
  final int rowsPerPage = 15;

  @override
  void initState() {
    super.initState();
    getBusinessSlip();
  }

  Future<void> getBusinessSlip() async {
    try {
      final response = await http.get(Uri.parse('http://mybudgetbook.in/GIBADMINAPI/g2g_report.php'));
      if (response.statusCode == 200) {
        setState(() {
          business = List<Map<String, dynamic>>.from(json.decode(response.body));
          filteredBusiness = business; // Initialize filteredBusiness with all data
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void filterData() {
    setState(() {
      filteredBusiness = business.where((item) {
        final nameMatch = nameController.text.isEmpty ||
            (item['first_name']?.toString().toLowerCase().contains(nameController.text.toLowerCase()) ?? false) ||
            (item['mobile']?.toString().toLowerCase().contains(nameController.text.toLowerCase()) ?? false);
        final districtMatch = districtController.text.isEmpty ||
            (item['district']?.toString().toLowerCase().contains(districtController.text.toLowerCase()) ?? false);
        final chapterMatch = chapterController.text.isEmpty ||
            (item['chapter']?.toString().toLowerCase().contains(chapterController.text.toLowerCase()) ?? false);
        final date = DateTime.parse(item['date']).toLocal();
        final fromDateMatch = fromDate == null || date.isAfter(fromDate!) || date.isAtSameMomentAs(fromDate!);
        final toDateMatch = toDate == null || date.isBefore(toDate!) || date.isAtSameMomentAs(toDate!);
        return nameMatch && districtMatch && chapterMatch && fromDateMatch && toDateMatch;
      }).toList();
    });
  }


  List<Map<String, dynamic>> getCurrentPageData() {
    final start = currentPage * rowsPerPage;
    final end = start + rowsPerPage;
    return filteredBusiness.sublist(start, end > filteredBusiness.length ? filteredBusiness.length : end);
  }

  void nextPage() {
    setState(() {
      if (currentPage < (filteredBusiness.length / rowsPerPage).ceil() - 1) {
        currentPage++;
      }
    });
  }

  void previousPage() {
    setState(() {
      if (currentPage > 0) {
        currentPage--;
      }
    });
  }


  Future<void> _selectFromDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: fromDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != fromDate) {
      setState(() {
        fromDate = picked;
    //    filterData(); // Trigger filterData on date change
      });
    }
  }

  Future<void> _selectToDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: toDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != toDate) {
      setState(() {
        toDate = picked;
     //   filterData(); // Trigger filterData on date change
      });
    }
  }

  Future<Uint8List> generatePDF(List<Map<String, dynamic>> data) async {
    final pdf = pw.Document(pageMode: PdfPageMode.fullscreen);

    int index = 0; // Start index at 1 for S.No

    final columnWidths = <int, pw.TableColumnWidth>{
      0: pw.FixedColumnWidth(30),
      1: pw.FixedColumnWidth(85),
      2: pw.FixedColumnWidth(80),
      3: pw.FixedColumnWidth(90),
      4: pw.FixedColumnWidth(80),
      5: pw.FixedColumnWidth(75),
      6: pw.FixedColumnWidth(75),
      7: pw.FixedColumnWidth(80),
      8: pw.FixedColumnWidth(90),
      9: pw.FixedColumnWidth(80),
      10: pw.FixedColumnWidth(80),
      11: pw.FixedColumnWidth(90),
      12: pw.FixedColumnWidth(80),
    };

    final imageData = await rootBundle.load('assets/logo.png');
    final imageBytes = imageData.buffer.asUint8List();


    pdf.addPage(
      pw.MultiPage(

        header: (pw.Context context) {
          return pw.Container(
              alignment: pw.Alignment.center,
              padding: pw.EdgeInsets.all(10),
              child: pw.Column(
                children: [
                  pw.Row(
                    children: [
                      pw.Text('G2G Report', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
                      pw.Spacer(),
                      pw.Image(pw.MemoryImage(imageBytes), width: 50, height: 50)

                    ],

                  ),

                  pw.Divider(),
                ],

              )

          );
        },
        build: (pw.Context context) {
          return [
            pw.Table.fromTextArray(
              columnWidths: columnWidths,
              cellStyle: pw.TextStyle(fontSize: 5),
              headerStyle: pw.TextStyle(fontSize: 5), // Set text size to 12
              data: <List<String>>[
                <String>[
                  'SNo',
                  'Date',
                  'Member Name',
                  'Member Mobile\n Number',
                  'Member Company',
                  'From Time',
                  'To Time',
                  'Met\n Member Name',
                  'Met\nMobile Number',
                  'Met\n Company ',
                  'District',
                  'Chapter',
                  'Location',
                ],
                ...data.map((item) {
                  index++;
                  // Ensure all values are converted to strings before adding to the list
                  return [
                    '$index',
                    DateFormat('dd-MM-yyyy').format(DateTime.parse(item['date'])),
                    item['first_name']?.toString() ?? '', // Convert to string or empty string
                    item['mobile']?.toString() ?? '',
                    item['company_name']?.toString() ?? '',
                    item['from_time']?.toString() ?? '',
                    item['to_time']?.toString() ?? '',
                    item['met_name']?.toString() ?? '',
                    item['met_number']?.toString() ?? '',
                    item['met_company_name']?.toString() ?? '',
                    item['district']?.toString() ?? '',
                    item['chapter']?.toString() ?? '',
                    item['location']?.toString() ?? '',
                  ];
                }).toList(),
              ],
            ),
          ];
        },
      ),
    );

    return pdf.save();
  }

  void downloadPdf() async {
    final pdfBytes = await generatePDF(filteredBusiness);
    await Printing.sharePdf(bytes: pdfBytes, filename: 'G2G_report.pdf');
  }

  @override
  Widget build(BuildContext context) {
    int index = currentPage * rowsPerPage;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Form(
        key: _formKey,
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(0.0),
                child: Container(
                  padding: const EdgeInsets.all(3.0),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Icon(Icons.report),
                            SizedBox(width: 10),
                            Text(
                              'G2G Report',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/dasg2g_report_page');
                              },
                              icon: Icon(Icons.refresh),
                            ),
                          ],
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Wrap(
                              children: [
                                Row(
                                  children: [
                                    SizedBox(width: 10),
                                    SizedBox(
                                      width: 170,
                                      height: 35,
                                      child: TypeAheadFormField<String>(
                                        textFieldConfiguration: TextFieldConfiguration(
                                          controller: nameController,
                                          decoration: const InputDecoration(
                                            fillColor: Colors.white,
                                            filled: true,
                                            labelText: "Name or Mobile",
                                            labelStyle: TextStyle(fontSize: 14),
                                          ),
                                          style: TextStyle(fontSize: 14),
                                        ),
                                        suggestionsCallback: (pattern) async {
                                          if (pattern.isEmpty) {
                                            return []; // Return an empty list if the pattern is empty
                                          } else {
                                            return business.where((item) =>
                                            (item['first_name']?.toString().toLowerCase().contains(pattern.toLowerCase()) ?? false) ||
                                                (item['mobile']?.toString().toLowerCase().contains(pattern.toLowerCase()) ?? false)
                                               /* (item['met_name']?.toString().toLowerCase().contains(pattern.toLowerCase()) ?? false) ||
                                                (item['met_number']?.toString().toLowerCase().contains(pattern.toLowerCase()) ?? false)*/
                                            ).map((item) => "${item['first_name']}")
                                                .toList();
                                          }
                                        },
                                        itemBuilder: (context, suggestion) {
                                          return ListTile(
                                            title: Text(suggestion, style: TextStyle(fontSize: 12)),
                                          );
                                        },
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return "* Required Name or Mobile";
                                          } else {
                                            return null;
                                          }
                                        },
                                        onSuggestionSelected: (suggestion) async {
                                          setState(() {
                                            nameController.text = suggestion;
                                          });
                                        },
                                      ),
                                    ),
                                    SizedBox(width: 10),

                                    SizedBox(
                                      width: 170,
                                      height: 35,
                                      child: TypeAheadFormField<String>(
                                        textFieldConfiguration: TextFieldConfiguration(
                                          controller: districtController,
                                          decoration: const InputDecoration(
                                            fillColor: Colors.white,
                                            filled: true,
                                            labelText: "District",
                                            labelStyle: TextStyle(fontSize: 14),
                                          ),
                                          style: TextStyle(fontSize: 14),
                                          //onChanged: (value) => filterData(), // Trigger filterData on change
                                        ),
                                        suggestionsCallback: (pattern) async {
                                          return business
                                              .where((item) =>
                                          (item['district']?.toString().toLowerCase().startsWith(pattern.toLowerCase()) ?? false))
                                              .map((item) => item['district'].toString())
                                              .toList();
                                        },
                                        itemBuilder: (context, suggestion) {
                                          return ListTile(
                                            title: Text(suggestion),
                                          );
                                        },
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return "* Required District";
                                          } else {
                                            return null;
                                          }
                                        },
                                        onSuggestionSelected: (suggestion) async {
                                          setState(() {
                                            districtController.text = suggestion;
                                        //    filterData(); // Trigger filterData on suggestion selection
                                          });
                                        },
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    SizedBox(
                                      width: 170,
                                      height: 35,
                                      child: TypeAheadFormField<String>(
                                        textFieldConfiguration: TextFieldConfiguration(
                                          controller: chapterController,
                                          decoration: const InputDecoration(
                                            fillColor: Colors.white,
                                            filled: true,
                                            labelText: "Chapter",
                                            labelStyle: TextStyle(fontSize: 14),
                                          ),
                                          style: TextStyle(fontSize: 14),
                                        //  onChanged: (value) => filterData(), // Trigger filterData on change
                                        ),
                                        suggestionsCallback: (pattern) async {
                                          return business
                                              .where((item) =>
                                          (item['chapter']?.toString().toLowerCase().startsWith(pattern.toLowerCase()) ?? false))
                                              .map((item) => item['chapter'].toString())
                                              .toList();
                                        },
                                        itemBuilder: (context, suggestion) {
                                          return ListTile(
                                            title: Text(suggestion),
                                          );
                                        },
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return "* Required Chapter";
                                          } else {
                                            return null;
                                          }
                                        },
                                        onSuggestionSelected: (suggestion) async {
                                          setState(() {
                                            chapterController.text = suggestion;
                                      //      filterData(); // Trigger filterData on suggestion selection
                                          });
                                        },
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    SizedBox(
                                      width: 170,
                                      height: 35,
                                      child: GestureDetector(
                                        onTap: () => _selectFromDate(context),
                                        child: AbsorbPointer(
                                          child: TextFormField(
                                            decoration: InputDecoration(
                                              fillColor: Colors.white,
                                              filled: true,
                                              labelText: 'From Date',
                                              labelStyle: TextStyle(fontSize: 14),
                                            ),
                                            controller: TextEditingController(
                                              text: fromDate != null ? DateFormat('dd-MM-yyyy').format(fromDate!) : '',
                                            ),
                                            style: TextStyle(fontSize: 14),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    SizedBox(
                                      width: 170,
                                      height: 35,
                                      child: GestureDetector(
                                        onTap: () => _selectToDate(context),
                                        child: AbsorbPointer(
                                          child: TextFormField(
                                            decoration: InputDecoration(
                                              fillColor: Colors.white,
                                              filled: true,
                                              labelText: 'To Date',
                                              labelStyle: TextStyle(fontSize: 14),
                                            ),
                                            controller: TextEditingController(
                                              text: toDate != null ? DateFormat('dd-MM-yyyy').format(toDate!) : '',
                                            ),
                                            style: TextStyle(fontSize: 14),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Card(
                                      child: IconButton(
                                        icon: Icon(Icons.search),
                                        onPressed: () {
                                          filterData();
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Card(
                              child: IconButton(
                                  icon: Icon(Icons.picture_as_pdf),
                                  onPressed: () =>
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => PdfViewScreen(
                                            data: filteredBusiness,
                                            generatePDF: generatePDF,
                                          ),
                                        ),
                                      )
                              ),
                            ),
                            Card(
                              child: IconButton(
                                icon: Icon(Icons.download),
                                onPressed: downloadPdf,
                              ),
                            ),
                          ],
                        )

                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(3.0),
                child: SingleChildScrollView(
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          const Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding: EdgeInsets.only(left: 5),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Details", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                          ),
                          filteredBusiness.isNotEmpty
                              ? Scrollbar(
                            thumbVisibility: true,
                            controller: _scrollController,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              controller: _scrollController,
                              child: SizedBox(
                                child: DataTable(
                                  columnSpacing: 20,
                                  columns: const [
                                    DataColumn(label: Text('S.No')),
                                    DataColumn(label: Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text('Date'),
                                    )),
                                    DataColumn(label: Text('Member Name')),
                                    DataColumn(label: Text('Member Mobile Number')),
                                    DataColumn(label: Text('Member Company')),
                                    DataColumn(label: Text('From Time')),
                                    DataColumn(label: Text('To Time')),
                                    DataColumn(label: Text('Met Member Name')),
                                    DataColumn(label: Text('Met Mobile Number')),
                                    DataColumn(label: Text('Met Company Name')),
                                    DataColumn(label: Text('District')),
                                    DataColumn(label: Text('Chapter')),
                                    DataColumn(label: Text('Location')),
                                  ],
                                  rows: filteredBusiness.map((meeting) {
                                    index++;
                                    return DataRow(cells: [
                                      DataCell(Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Center(child: Text('$index', style: const TextStyle(fontWeight: FontWeight.normal, color: Colors.black, fontSize: 14.0))),
                                      )),
                                      DataCell(
                                        Center(
                                          child: Text(
                                            DateFormat('dd-MM-yyyy').format(DateTime.parse(meeting['date'])),
                                            style: const TextStyle(
                                                fontWeight: FontWeight.normal,
                                                color: Colors.black,
                                                fontSize: 14.0
                                            ),
                                          ),
                                        ),
                                      ),
                                      DataCell(Center(child: Text('${meeting['first_name']}', style: const TextStyle(fontWeight: FontWeight.normal, color: Colors.black, fontSize: 14.0)))),
                                      DataCell(Center(child: Text('${meeting['mobile']}', style: const TextStyle(fontWeight: FontWeight.normal, color: Colors.black, fontSize: 14.0)))),
                                      DataCell(Center(child: Text('${meeting['company_name']}', style: const TextStyle(fontWeight: FontWeight.normal, color: Colors.black, fontSize: 14.0)))),
                                      DataCell(Center(child: Text('${meeting['from_time']}', style: const TextStyle(fontWeight: FontWeight.normal, color: Colors.black, fontSize: 14.0)))),
                                      DataCell(Center(child: Text('${meeting['to_time']}', style: const TextStyle(fontWeight: FontWeight.normal, color: Colors.black, fontSize: 14.0)))),
                                      DataCell(Center(child: Text('${meeting['met_name']}', style: const TextStyle(fontWeight: FontWeight.normal, color: Colors.black, fontSize: 14.0)))),
                                      DataCell(Center(child: Text('${meeting['met_number']}', style: const TextStyle(fontWeight: FontWeight.normal, color: Colors.black, fontSize: 14.0)))),
                                      DataCell(Center(child: Text('${meeting['met_company_name']}', style: const TextStyle(fontWeight: FontWeight.normal, color: Colors.black, fontSize: 14.0)))),
                                      DataCell(Center(child: Text('${meeting['district']}', style: const TextStyle(fontWeight: FontWeight.normal, color: Colors.black, fontSize: 14.0)))),
                                      DataCell(Center(child: Text('${meeting['chapter']}', style: const TextStyle(fontWeight: FontWeight.normal, color: Colors.black, fontSize: 14.0)))),
                                      DataCell(Center(child: Text('${meeting['location']}', style: const TextStyle(fontWeight: FontWeight.normal, color: Colors.black, fontSize: 14.0)))),
                                    ]);
                                  }).toList(),
                                ),
                              ),
                            ),
                          )
                              : Center(child: Text('No Records Found')),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: previousPage,
                    disabledColor: Colors.grey,
                    color: currentPage > 0 ? Colors.black : Colors.grey,
                  ),
                  Text('Page ${currentPage + 1} of ${(filteredBusiness.length / rowsPerPage).ceil()}'),
                  IconButton(
                    icon: Icon(Icons.arrow_forward),
                    onPressed: nextPage,
                    disabledColor: Colors.grey,
                    color: currentPage < (filteredBusiness.length / rowsPerPage).ceil() - 1 ? Colors.black : Colors.grey,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class PdfViewScreen extends StatelessWidget {
  final List<Map<String, dynamic>> data;
  final Future<Uint8List> Function(List<Map<String, dynamic>>) generatePDF;

  PdfViewScreen({required this.data, required this.generatePDF});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PDF View'),
      ),
      body: PdfPreview(
        build: (format) => generatePDF(data),
      ),
    );
  }
}







