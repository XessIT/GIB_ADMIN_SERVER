import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:gibadmin/meeting/qr_generate.dart';
import 'package:http/http.dart'as http;
import 'package:printing/printing.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../main.dart';
import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:qr_flutter/qr_flutter.dart';




class QRCreations extends StatelessWidget {
  const QRCreations({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: QRCreationsPage(),
    );
  }
}
class QRCreationsPage extends StatefulWidget {
  const QRCreationsPage({Key? key}) : super(key: key);

  @override
  State<QRCreationsPage> createState() => _QRCreationsPageState();
}

class _QRCreationsPageState extends State<QRCreationsPage> {

  List<Map<String, dynamic>> meetings = [];

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    try {
      final response = await http.get(Uri.parse('http://mybudgetbook.in/GIBADMINAPI/create_meeting.php'));
      if (response.statusCode == 200) {
        setState(() {
          meetings = List<Map<String, dynamic>>.from(json.decode(response.body));
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
  Future<Uint8List> generatePdf() async {
    final pdf = pw.Document();

    for (final meeting in meetings) {
      final qrImageData = await QrPainter(
        data: meeting['id'].toString(),
        color: const Color(0xff000000),
        version: QrVersions.auto,
        errorCorrectionLevel: QrErrorCorrectLevel.L,
      ).toImageData(200);

      final qrImage = pw.MemoryImage(qrImageData!.buffer.asUint8List());

      pdf.addPage(
        pw.Page(
          build: (pw.Context context) {
            return pw.Center(
              child: pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                children: [
                  pw.Container(
                    padding: const pw.EdgeInsets.all(8.0),
                    child: pw.Image(
                      qrImage,
                      width: 200.0,
                      height: 200.0,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      );
    }

    return await pdf.save();
  }

  Future<void> updateQrStatus(String meetingId) async {
    try {
      final response = await http.put(
        Uri.parse('http://mybudgetbook.in/GIBADMINAPI/qr_status_update.php'),
        body: jsonEncode({'meeting_id': meetingId}),
      );
      if (response.statusCode == 200) {
        print('QR Status updated successfully');
      } else {
        throw Exception('Failed to update QR status');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
  @override
  Widget build(BuildContext context) {
    int index = 0;
    return MyScaffold(
      route: "/qr_creations_page",
      body: SingleChildScrollView(
        child: Form(
          child: Center(
            child: Column(
              children: [
                const SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: Container(
                    child:   Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: const Column(
                          children: [
                            Row(
                              children: [
                                Icon(Icons.report,),
                                SizedBox(width:10,),
                                Text(
                                  'UpComming Meeting',
                                  style: TextStyle(
                                    fontSize:20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.only(right: 15),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Wrap(
                                  //mainAxisAlignment: MainAxisAlignment.start,
                                  children: [

                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 15,)
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
                        color: Colors.blue.shade50,
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child:  Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            const Align (
                                alignment:Alignment.topLeft,
                                child: Padding(
                                  padding: EdgeInsets.only(left: 5),

                                  child:  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(" Details",style: TextStyle(fontSize:17,fontWeight: FontWeight.bold),),


                                    ],
                                  ),

                                )),
                            Scrollbar(
                              thumbVisibility: true,

                              child: SingleChildScrollView(
                                child: SizedBox(
                                  child: DataTable(
                                    columnSpacing:20,
                                    columns: const [
                                      DataColumn(label: Text('S.No')),
                                      DataColumn(label: Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text('Generate QR'),
                                      )),
                                      DataColumn(label: Text('Meeting Date')),
                                      DataColumn(label: Text('District')),
                                      DataColumn(label: Text('Chapter')),
                                      DataColumn(label: Text('Place')),
                                      DataColumn(label: Text('Team Name')),
                                      DataColumn(label: Text('Meeting Type')),
                                      DataColumn(label: Text('Member Type')),
                                      // Add more DataColumn widgets for other fields as needed
                                    ],

                                    rows: meetings.map((meeting) {
                                      index++;
                                      return DataRow(cells: [
                                        DataCell(Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Center(child: Text('$index',style: const TextStyle(fontWeight: FontWeight.normal, color: Colors.black, fontSize: 14.0))),
                                        )),
                                        DataCell(
                                          Center(
                                            child:
                                            meeting['qr_status'] == 'Generated' ?
                                            IconButton(
                                              onPressed: () {
                                                showDialog(
                                                  context: context,
                                                  builder: (BuildContext context) {
                                                    return AlertDialog(
                                                      title: Text('QR Code'),
                                                      content: SizedBox(
                                                        height: 300.0,
                                                        width: 150.0,
                                                        child: Column(
                                                          mainAxisSize: MainAxisSize.min,
                                                          children: [
                                                            QrImageView(
                                                              data: meeting['id'],
                                                              embeddedImageStyle: const QrEmbeddedImageStyle(
                                                                size: Size(40, 40),
                                                              ),
                                                            ),
                                                            SizedBox(height: 8.0),
                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                              children: [
                                                                IconButton(
                                                                  onPressed: () {
                                                                    generatePdf();
                                                                  },
                                                                  icon: Icon(Icons.print),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      actions: [
                                                        TextButton(
                                                          onPressed: () {
                                                            // Close the dialog
                                                            Navigator.of(context).pop();
                                                          },
                                                          child: Text('Close'),
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                                },
                                              icon: Icon(Icons.qr_code),
                                            ):
                                            TextButton(
                                              child: Text('Generate'),
                                              onPressed: () {
                                                showDialog(
                                                  context: context,
                                                  builder: (BuildContext context) {
                                                    return AlertDialog(
                                                      title: Text('Alert'),
                                                      content: Text('Do you want to generate QR code?'),
                                                      actions: <Widget>[
                                                        TextButton(
                                                          child: Text('No'),
                                                          onPressed: () {
                                                            Navigator.of(context).pop();
                                                          },
                                                        ),
                                                        TextButton(
                                                          child: Text('Yes'),
                                                          onPressed: () {
                                                            Navigator.of(context).pop(); // Close the first dialog
                                                            updateQrStatus(meeting['id']);

                                                            showDialog(
                                                              context: context,
                                                              builder: (BuildContext context) {
                                                                return AlertDialog(
                                                                  title: Text('QR Code'),
                                                                  content: SizedBox(
                                                                    height: 300.0,
                                                                    width: 150.0,
                                                                    child: Column(
                                                                      mainAxisSize: MainAxisSize.min,
                                                                      children: [
                                                                        QrImageView(
                                                                          data: meeting['id'],
                                                                          embeddedImageStyle: const QrEmbeddedImageStyle(
                                                                            size: Size(40, 40),
                                                                          ),
                                                                        ),
                                                                        SizedBox(height: 8.0),
                                                                        Row(
                                                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                          children: [
                                                                            IconButton(
                                                                              onPressed: () {
                                                                                generatePdf();
                                                                              },
                                                                              icon: Icon(Icons.print),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  actions: [
                                                                    TextButton(
                                                                      onPressed: () {
                                                                        // Close the dialog
                                                                        getData();
                                                                        Navigator.of(context).pop();
                                                                      },
                                                                      child: Text('Close'),
                                                                    ),
                                                                  ],
                                                                );
                                                              },
                                                            );                                                          },
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                              },
                                            )
                                          ),
                                        ),
                                        DataCell(Center(child: Text('${meeting['meeting_date']}',style: const TextStyle(fontWeight: FontWeight.normal, color: Colors.black, fontSize: 14.0)))),
                                        DataCell(Center(child: Text('${meeting['district']}',style: const TextStyle(fontWeight: FontWeight.normal, color: Colors.black, fontSize: 14.0)))),
                                        DataCell(Center(child: Text('${meeting['chapter']}',style: const TextStyle(fontWeight: FontWeight.normal, color: Colors.black, fontSize: 14.0)))),
                                        DataCell(Center(child: Text('${meeting['place']}',style: const TextStyle(fontWeight: FontWeight.normal, color: Colors.black, fontSize: 14.0)))),
                                        DataCell(Center(child: Text('${meeting['team_name']}',style: const TextStyle(fontWeight: FontWeight.normal, color: Colors.black, fontSize: 14.0)))),
                                        DataCell(Center(child: Text('${meeting['meeting_type']}',style: const TextStyle(fontWeight: FontWeight.normal, color: Colors.black, fontSize: 14.0)))),
                                        DataCell(Center(child: Text('${meeting['member_type']}',style: const TextStyle(fontWeight: FontWeight.normal, color: Colors.black, fontSize: 14.0)))),
                                        // Add more DataCell widgets for other fields as needed
                                      ]);
                                    }).toList(),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
