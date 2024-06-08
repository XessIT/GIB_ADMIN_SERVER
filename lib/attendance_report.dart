import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:gibadmin/reports/business_report.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:printing/printing.dart';

import 'main.dart';

class OverallReportAtt extends StatefulWidget {
  const OverallReportAtt({super.key});

  @override
  State<OverallReportAtt> createState() => _OverallReportAttState();
}

class _OverallReportAttState extends State<OverallReportAtt> {
  final _formKey = GlobalKey<FormState>();
  List<Map<String, dynamic>> business = [];
  List<Map<String, dynamic>> filteredBusiness = [];
  TextEditingController districtController = TextEditingController();
  TextEditingController chapterController = TextEditingController();
  TextEditingController meeting_name = TextEditingController();
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
      final response = await http.get(Uri.parse('http://mybudgetbook.in/GIBAPI/attendance_overall_report.php'));
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

  void filterData() {
    setState(() {
      filteredBusiness = business.where((item) {
        final districtMatch = districtController.text.isEmpty || (item['meeting_type']?.toString().toLowerCase().contains(districtController.text.toLowerCase()) ?? false);
        final chapterMatch = chapterController.text.isEmpty || (item['member_type']?.toString().toLowerCase().contains(chapterController.text.toLowerCase()) ?? false);
        final date = DateTime.parse(item['meeting_date']).toLocal();
        final fromDateMatch = fromDate == null || date.isAfter(fromDate!) || date.isAtSameMomentAs(fromDate!);
        final toDateMatch = toDate == null || date.isBefore(toDate!) || date.isAtSameMomentAs(toDate!);
        return districtMatch && chapterMatch && fromDateMatch && toDateMatch;
      }).toList();
      currentPage = 0; // Reset to first page after filtering
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
      });
    }
  }

  Future<Uint8List> generatePDF(List<Map<String, dynamic>> data) async {
    final pdf = pw.Document(pageMode: PdfPageMode.fullscreen);

    int index = 0; // Start index at 1 for S.No

    final columnWidths = <int, pw.TableColumnWidth>{
      0: const pw.FixedColumnWidth(30),
      1: pw.FixedColumnWidth(85),
      2: pw.FixedColumnWidth(80),
      3: pw.FixedColumnWidth(90),
      4: pw.FixedColumnWidth(80),
      5: pw.FixedColumnWidth(75),
      6: pw.FixedColumnWidth(75),
      7: pw.FixedColumnWidth(80),

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
                      pw.Text('Attendance Report', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
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
                  'Member Type',
                  'Meeting Type',
                  'Team Name',
                  'Meeting Name',
                  'Place',
                  'Time',
                ],
                ...data.map((item) {
                  index++;
                  // Ensure all values are converted to strings before adding to the list
                  return [
                    '$index',
                    DateFormat('dd-MM-yyyy').format(DateTime.parse(item['createdOn'])),
                    item['member_type']?.toString() ?? '', // Convert to string or empty string
                    item['meeting_type']?.toString() ?? '',
                    item['team_name']?.toString() ?? '',
                    item['meeting_name']?.toString() ?? '',
                    item['place']?.toString() ?? '',
                    item['from_time']?.toString() ?? '',

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
    await Printing.sharePdf(bytes: pdfBytes, filename: 'Attendance_report_overall.pdf');
  }


  @override
  Widget build(BuildContext context) {
    int index = currentPage * rowsPerPage;

    return MyScaffold(
      route: '/attendance_report_page',
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
                                'Attendance Report',
                                style: TextStyle(
                                  fontSize:20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              IconButton(onPressed: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>OverallReportAtt()));
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
                                            controller: districtController,
                                            decoration: const InputDecoration(
                                              fillColor: Colors.white,
                                              filled: true,
                                              labelText: "Meeting Type",
                                              labelStyle: TextStyle(fontSize: 14),
                                            ),
                                            style: TextStyle(fontSize: 14),
                                          ),
                                          suggestionsCallback: (pattern) async {
                                            final suggestions = ['Network Meeting', 'Team Meeting', 'Training Meeting'];

                                            // Filter suggestions based on the input pattern
                                            return suggestions
                                                .where((item) => item.toLowerCase().startsWith(pattern.toLowerCase()))
                                                .toList();
                                          },
                                          itemBuilder: (context, suggestion) {
                                            return ListTile(
                                              title: Text(suggestion),
                                            );
                                          },
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return "* Required Meeting Type";
                                            } else {
                                              return null;
                                            }
                                          },
                                          onSuggestionSelected: (suggestion) {
                                            setState(() {
                                              districtController.text = suggestion;
                                              filterData(); // Filter data immediately
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
                                            controller: meeting_name,
                                            decoration: const InputDecoration(
                                              fillColor: Colors.white,
                                              filled: true,
                                              labelText: "Name",
                                              labelStyle: TextStyle(fontSize: 14),
                                            ),
                                            style: TextStyle(fontSize: 14),
                                          ),
                                          suggestionsCallback: (pattern) async {
                                            Set<String> uniqueNames = {}; // Set to keep track of unique names
                                            return business
                                                .where((item) =>
                                                (item['user_name']?.toString().toLowerCase() ?? '')
                                                    .startsWith(pattern.toLowerCase()))
                                                .map((item) => item['user_name'].toString())
                                                .where((name) => uniqueNames.add(name)) // Add name to set, returns true if added
                                                .toList();
                                          },

                                          itemBuilder: (context, suggestion) {
                                            return ListTile(
                                              title: Text(suggestion),
                                            );
                                          },

                                          onSuggestionSelected: (suggestion) async {
                                            setState(() {
                                              meeting_name.text = suggestion;
                                            });
                                          },
                                        ),
                                      ),
                                      /*SizedBox(
                                        width: 170, height: 35,
                                        child: TypeAheadFormField<String>(
                                          textFieldConfiguration: TextFieldConfiguration(
                                            controller: chapterController,
                                            decoration: const InputDecoration(
                                              fillColor: Colors.white,
                                              filled: true,
                                              labelText: "Member Type",
                                              labelStyle: TextStyle(fontSize: 14),
                                            ),
                                            style: TextStyle(fontSize: 14),
                                          ),
                                          suggestionsCallback: (pattern) async {
                                            final suggestions = ['Executive', 'Non-Executive'];

                                            // Filter suggestions based on the input pattern
                                            return suggestions
                                                .where((item) => item.toLowerCase().startsWith(pattern.toLowerCase()))
                                                .toList();
                                          },
                                          itemBuilder: (context, suggestion) {
                                            return ListTile(
                                              title: Text(suggestion),
                                            );
                                          },
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return "* Required Member Type";
                                            } else {
                                              return null;
                                            }
                                          },
                                          onSuggestionSelected: (suggestion) {
                                            setState(() {
                                              chapterController.text = suggestion;
                                              filterData(); // Filter data immediately
                                            });
                                          },
                                        ),
                                      ),*/
                                      SizedBox(width: 10,),
                                      SizedBox(
                                        width: 170, height: 35,
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
                                      SizedBox(width: 10,),
                                      SizedBox(
                                        width: 170, height: 35,
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
                                      SizedBox(width: 10,),
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
                          SizedBox(height: 15),
                         /* Row(
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
                          )*/
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
                              child: Column(
                                children: [
                                  DataTable(
                                    columnSpacing: 20,
                                    columns: const [
                                      DataColumn(label: Text('S.No')),
                                      DataColumn(label: Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text('Date'),
                                      )),
                                      DataColumn(label: Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text('Member Type'),
                                      )),
                                      DataColumn(label: Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text('Meeting Type'),
                                      )),DataColumn(label: Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text('Team Name'),
                                      )),
                                      DataColumn(label: Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text('Meeting Name'),
                                      )),
                                      DataColumn(label: Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text('Place'),
                                      )),
                                      DataColumn(label: Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text('Time'),
                                      )),
                                    ],
                                    rows: getCurrentPageData().map((meeting) {
                                      index++;
                                      return DataRow(cells: [
                                        DataCell(Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Center(child: Text('$index', style: const TextStyle(fontWeight: FontWeight.normal, color: Colors.black, fontSize: 14.0))),
                                        )),
                                        DataCell(
                                          Center(
                                            child: Text(
                                              DateFormat('dd-MM-yyyy').format(DateTime.parse(meeting['meeting_date'])),
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.normal,
                                                  color: Colors.black,
                                                  fontSize: 14.0
                                              ),
                                            ),
                                          ),
                                        ),
                                        DataCell(Center(child: Text('${meeting['member_type']}', style: const TextStyle(fontWeight: FontWeight.normal, color: Colors.black, fontSize: 14.0)))),
                                        DataCell(Center(child: Text('${meeting['meeting_type']}', style: const TextStyle(fontWeight: FontWeight.normal, color: Colors.black, fontSize: 14.0)))),
                                        DataCell(Center(child: Text('${meeting['team_name']}', style: const TextStyle(fontWeight: FontWeight.normal, color: Colors.black, fontSize: 14.0)))),
                                        DataCell(Center(child: Text('${meeting['meeting_name']}', style: const TextStyle(fontWeight: FontWeight.normal, color: Colors.black, fontSize: 14.0)))),
                                        DataCell(Center(child: Text('${meeting['place']}', style: const TextStyle(fontWeight: FontWeight.normal, color: Colors.black, fontSize: 14.0)))),
                                        DataCell(Center(child: Text('${meeting['from_time']} + ${meeting['to_time']}', style: const TextStyle(fontWeight: FontWeight.normal, color: Colors.black, fontSize: 14.0)))),


                                      ]);
                                    }).toList(),
                                  ),


                                ],
                              ),
                            ),
                          )
                              : Center(child: Text("No Records Found", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),)),
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
