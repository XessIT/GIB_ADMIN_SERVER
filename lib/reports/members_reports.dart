import 'package:flutter/material.dart';
import '../main.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:http/http.dart'as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'dart:typed_data';
import 'package:flutter/services.dart';

import 'business_report.dart';


class MembersReport extends StatelessWidget {
  const MembersReport({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: MembersReportPage(),
    );
  }
}


class MembersReportPage extends StatefulWidget {
  const MembersReportPage({Key? key}) : super(key: key);

  @override
  State<MembersReportPage> createState() => _MembersReportPageState();
}

class _MembersReportPageState extends State<MembersReportPage> {
  final _formKey = GlobalKey<FormState>();
  List<Map<String, dynamic>> business = [];
  List<Map<String, dynamic>> filteredBusiness = [];
  TextEditingController districtController = TextEditingController();
  TextEditingController chapterController = TextEditingController();
  TextEditingController memberID = TextEditingController();
  TextEditingController mobile = TextEditingController();
  TextEditingController Membertype = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<String> memberTypes = ['executive', 'non executive', 'Member', 'Guest'];


  int currentPage = 0;
  final int rowsPerPage = 15;
  DateTime? fromDate;
  DateTime? toDate;

  @override
  void initState() {
    super.initState();
    getBusinessSlip();
  }

  Future<void> getBusinessSlip() async {
    try {
      final response = await http.get(Uri.parse('http://mybudgetbook.in/GIBADMINAPI/registration_report.php'));
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
        final memberIDMatch = memberID.text.isEmpty ||
            (item['member_id']?.toString().toLowerCase().contains(memberID.text.toLowerCase()) ?? false);
        final MobileMatch = mobile.text.isEmpty ||
            (item['mobile']?.toString().toLowerCase().contains(mobile.text.toLowerCase()) ?? false);
        final MembertypeMatch = Membertype.text.isEmpty ||
            (item['type']?.toString().toLowerCase().contains(Membertype.text.toLowerCase()) ?? false);

        final districtMatch = districtController.text.isEmpty ||
            (item['district']?.toString().toLowerCase().contains(districtController.text.toLowerCase()) ?? false);
        final chapterMatch = chapterController.text.isEmpty ||
            (item['chapter']?.toString().toLowerCase().contains(chapterController.text.toLowerCase()) ?? false);

        return  memberIDMatch && MobileMatch && MembertypeMatch && districtMatch && chapterMatch;
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
                      pw.Text('Members Report', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
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
                  'Name',
                  'Member ID',
                  'Mobile',
                  'Company Name',
                  'Place',
                  'Type',
                  'District',
                  'Chapter',
                  'Reffer ID ',
                  'Reffer Mobile',
                ],
                ...data.map((item) {
                  index++;
                  // Ensure all values are converted to strings before adding to the list
                  return [
                    '$index',
                    item['first_name']?.toString() ?? '', // Convert to string or empty string
                    item['member_id']?.toString() ?? '',
                    item['mobile']?.toString() ?? '',
                    item['company_name']?.toString() ?? '',
                    item['place']?.toString() ?? '',
                    item['type']?.toString() ?? '',
                    item['district']?.toString() ?? '',
                    item['chapter']?.toString() ?? '',
                    item['referrer_id']?.toString() ?? '',
                    item['referrer_mobile']?.toString() ?? '',
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
    await Printing.sharePdf(bytes: pdfBytes, filename: 'Members_report.pdf');
  }


  @override
  Widget build(BuildContext context) {
    int index = currentPage * rowsPerPage;

    return MyScaffold(
        route: "/members_report_page",
        body: Form(
          key: _formKey,
          child: Center(
            child: Column(
              children: [
                const SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: Container(
                    child: Padding(
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
                                Icon(Icons.report,),
                                SizedBox(width:10,),
                                Text(
                                  'Members Report',
                                  style: TextStyle(
                                    fontSize:20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                IconButton(onPressed: (){
                                  Navigator.pushNamed(context, '/members_report_page');
                                }, icon: Icon(Icons.refresh)),
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
                                        SizedBox(width: 10,),
                                        SizedBox(
                                          width: 170, height: 35,
                                          child: TypeAheadFormField<String>(
                                            textFieldConfiguration: TextFieldConfiguration(
                                              controller: memberID,
                                              decoration: const InputDecoration(
                                                fillColor: Colors.white,
                                                filled: true,
                                                labelText: "Member ID",
                                                labelStyle: TextStyle(fontSize: 14),
                                              ),
                                              style: TextStyle(fontSize: 14),
                                            ),
                                            suggestionsCallback: (pattern) async {
                                              return business
                                                  .where((item) =>
                                                  (item['member_id']?.toString().toLowerCase() ?? '')
                                                      .startsWith(pattern.toLowerCase()))
                                                  .map((item) => item['member_id'].toString())
                                                  .toList();
                                            },
                                            itemBuilder: (context, suggestion) {
                                              return ListTile(
                                                title: Text(suggestion),
                                              );
                                            },
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return "* Required Member ID";
                                              } else {
                                                return null;
                                              }
                                            },
                                            onSuggestionSelected: (suggestion) async {
                                              setState(() {
                                                memberID.text = suggestion;
                                              });
                                            },
                                          ),
                                        ),
                                        SizedBox(width: 10,),
                                        SizedBox(
                                          width: 170, height: 35,
                                          child: TypeAheadFormField<String>(
                                            textFieldConfiguration: TextFieldConfiguration(
                                              controller: mobile ,
                                              decoration: const InputDecoration(
                                                fillColor: Colors.white,
                                                filled: true,
                                                labelText: "Mobile",
                                                labelStyle: TextStyle(fontSize: 14),
                                              ),
                                              style: TextStyle(fontSize: 14),
                                            ),
                                            suggestionsCallback: (pattern) async {
                                              return business
                                                  .where((item) =>
                                                  (item['mobile']?.toString().toLowerCase() ?? '')
                                                      .startsWith(pattern.toLowerCase()))
                                                  .map((item) => item['mobile'].toString())
                                                  .toList();
                                            },
                                            itemBuilder: (context, suggestion) {
                                              return ListTile(
                                                title: Text(suggestion),
                                              );
                                            },
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return "* Required Mobile";
                                              } else {
                                                return null;
                                              }
                                            },
                                            onSuggestionSelected: (suggestion) async {
                                              setState(() {
                                                mobile.text = suggestion;
                                              });
                                            },
                                          ),
                                        ),
                                        SizedBox(width: 10,),
                                        SizedBox(
                                          width: 170,
                                          height: 35,
                                          child: TypeAheadFormField<String>(
                                            textFieldConfiguration: TextFieldConfiguration(
                                              controller: Membertype,
                                              decoration: const InputDecoration(
                                                fillColor: Colors.white,
                                                filled: true,
                                                labelText: "Member type",
                                                labelStyle: TextStyle(fontSize: 14),
                                              ),
                                              style: TextStyle(fontSize: 14),
                                            ),
                                            suggestionsCallback: (pattern) async {
                                              return memberTypes.where((type) => type.toLowerCase().startsWith(pattern.toLowerCase())).toList();
                                            },
                                            itemBuilder: (context, suggestion) {
                                              return ListTile(
                                                title: Text(suggestion),
                                              );
                                            },
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return "* Required Membertype";
                                              } else {
                                                return null;
                                              }
                                            },
                                            onSuggestionSelected: (suggestion) {
                                              setState(() {
                                                Membertype.text = suggestion;
                                              });
                                            },
                                          ),
                                        ),
                                        SizedBox(width: 10,),
                                        SizedBox(
                                          width: 170, height: 35,
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
                                        SizedBox(width: 10,),
                                        SizedBox(
                                          width: 170, height: 35,
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

                                        Card(
                                          child: IconButton(
                                            icon: Icon(Icons.search),
                                            onPressed: () {
                                              filterData();
                                            },
                                          ),
                                        )
                                      ],
                                    )
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
                                    Text(" Details", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),),
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
                                      DataColumn(label: Text('S.No')),   ///1
                                      DataColumn(label: Text('Name')),///3
                                      DataColumn(label: Text('Member ID')),///4
                                      DataColumn(label: Text('Mobile')),/// 5
                                      DataColumn(label: Text('Company Name')),///6
                                      DataColumn(label: Text('Place')),///7
                                      DataColumn(label: Text('Type')), ///8
                                      DataColumn(label: Text('District')), ///9
                                      DataColumn(label: Text('Chapter')), ///9
                                      DataColumn(label: Text('Referrer ID')),///10
                                      DataColumn(label: Text('Referrer Mobile')),///10

                                      // Add more DataColumn widgets for other fields as needed
                                    ],
                                    rows: filteredBusiness.map((meeting) {
                                      index++;
                                      return DataRow(cells: [
                                        DataCell(Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Center(child: Text('$index', style: const TextStyle(fontWeight: FontWeight.normal, color: Colors.black, fontSize: 14.0))),
                                        )),  ///1
                                        DataCell(Center(child: Text('${meeting['first_name']} ${meeting['last_name']}', style: const TextStyle(fontWeight: FontWeight.normal, color: Colors.black, fontSize: 14.0)))), ///3
                                        DataCell(Center(child: Text('${meeting['member_id']}', style: const TextStyle(fontWeight: FontWeight.normal, color: Colors.black, fontSize: 14.0)))), ///4
                                        DataCell(Center(child: Text('${meeting['mobile']}', style: const TextStyle(fontWeight: FontWeight.normal, color: Colors.black, fontSize: 14.0)))), ///4
                                        DataCell(Center(child: Text('${meeting['company_name']}', style: const TextStyle(fontWeight: FontWeight.normal, color: Colors.black, fontSize: 14.0)))), ///5
                                        DataCell(Center(child: Text('${meeting['place']}', style: const TextStyle(fontWeight: FontWeight.normal, color: Colors.black, fontSize: 14.0)))), ///6
                                        DataCell(Center(child: Text('${meeting['type']}', style: const TextStyle(fontWeight: FontWeight.normal, color: Colors.black, fontSize: 14.0)))), ///6
                                        DataCell(Center(child: Text('${meeting['district']}', style: const TextStyle(fontWeight: FontWeight.normal, color: Colors.black, fontSize: 14.0)))), ///6
                                        DataCell(Center(child: Text('${meeting['chapter']}', style: const TextStyle(fontWeight: FontWeight.normal, color: Colors.black, fontSize: 14.0)))), ///6
                                        DataCell(Center(child: Text('${meeting['referrer_id']}', style: const TextStyle(fontWeight: FontWeight.normal, color: Colors.black, fontSize: 14.0)))), ///6
                                        DataCell(Center(child: Text('${meeting['referrer_mobile']}', style: const TextStyle(fontWeight: FontWeight.normal, color: Colors.black, fontSize: 14.0)))),  ///7
                                        // Add more DataCell widgets for other fields as needed
                                      ]);
                                    }).toList(),
                                  ),
                                ),
                              ),
                            ) : Center(child: Text("No Records Found", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),)),

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
        )
    );
  }
}


