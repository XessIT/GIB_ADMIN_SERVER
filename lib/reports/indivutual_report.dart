import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pdf/pdf.dart';
import '../main.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:http/http.dart'as http;
import 'dart:convert';
import '../main.dart';
import 'package:pdf/widgets.dart' as pw;

import 'package:printing/printing.dart';
import 'dart:typed_data';
import 'package:flutter/services.dart';

import 'business_report.dart';
import 'package:cached_network_image/cached_network_image.dart';

class TotalIndividual extends StatelessWidget {
  const TotalIndividual({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: TotalIndividualReport(),
    );
  }
}


class TotalIndividualReport extends StatefulWidget {
  const TotalIndividualReport({Key? key}) : super(key: key);

  @override
  State<TotalIndividualReport> createState() => _TotalIndividualReportState();
}

class _TotalIndividualReportState extends State<TotalIndividualReport> {
  final _formKey = GlobalKey<FormState>();
    List<Map<String, dynamic>> business = [];
    List<Map<String, dynamic>> filteredBusiness = [];
    TextEditingController memberID = TextEditingController();
    TextEditingController mobile = TextEditingController();
    TextEditingController name = TextEditingController();





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

        return  memberIDMatch && MobileMatch ;
      }).toList();
      showData = true; // Show data columns after applying filter

    });
  }
  bool showData = false; // Flag to show/hide data columns
  bool isSearchEnabled = false;



// Function to fetch image bytes from URL
  Future<Uint8List?> fetchImageBytes(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return response.bodyBytes;
      }
    } catch (e) {
      print('Failed to fetch image from $url: $e');
    }
    return null;
  }

  Future<Uint8List> generatePDF(List<Map<String, dynamic>> data) async {
    final pdf = pw.Document(pageMode: PdfPageMode.fullscreen);

    final imageData = await rootBundle.load('assets/logo.png');
    final imageBytes = imageData.buffer.asUint8List();

    final List<Map<String, dynamic>> dataWithImages = [];
    for (var meeting in data) {
      String imageUrl = 'http://mybudgetbook.in/GIBADMINAPI/${meeting['profile_image']}';
      Uint8List? profileImage = await fetchImageBytes(imageUrl);
      dataWithImages.add({...meeting, 'profile_image_bytes': profileImage});
    }

    pdf.addPage(
      pw.MultiPage(
        header: (pw.Context context) {
          return pw.Container(

            //alignment: pw.Alignment.start,

            padding: pw.EdgeInsets.all(10),
            child: pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.start,

              children: [
                pw.Row(
                  children: [
                    pw.Text('Individual Report', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
                    pw.Spacer(),
                    pw.Image(pw.MemoryImage(imageBytes), width: 50, height: 50),
                  ],
                ),
                pw.Divider(),
                pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.start,

                    children: [
                    pw.Container(
                      child: pw.Column(
                        mainAxisAlignment: pw.MainAxisAlignment.start,
                        children: [

                          if (dataWithImages.isNotEmpty && dataWithImages[0]['profile_image_bytes'] != null)
                            pw.ClipOval(
                              child: pw.Image(
                                pw.MemoryImage(dataWithImages[0]['profile_image_bytes']),
                                width: 80,
                                height: 100,
                              ),
                            ),                        ],
                      ),
                    ),
                  ]
                ),


                /// this place want to set a profileimage here
              ],
            ),
          );
        },
        build: (pw.Context context) {
          return dataWithImages.map((meeting) {
            Uint8List? profileImage = meeting['profile_image_bytes'];

            return pw.Column(
              children: [

                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Expanded(
                      child: pw.Table(
                        border: pw.TableBorder.all(),
                        columnWidths: {
                          0: pw.FlexColumnWidth(1),
                          1: pw.FlexColumnWidth(2),
                        },
                        children: [

                          pw.TableRow(children: [
                            pw.Text('Bio Details', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                            pw.Text(''),
                          ]),
                      /*    if (profileImage != null)
                            pw.TableRow(children: [
                              pw.Container(
                                child: pw.Image(pw.MemoryImage(profileImage), width: 100, height: 100),
                              ),

                            ]),*/

                          tableRow('Name', '${meeting['first_name']} ${meeting['last_name']}'),
                          tableRow('Mobile', '${meeting['mobile']}'),
                          tableRow('Email', '${meeting['email']}'),
                          tableRow('Date Of Birth', '${meeting['dob']}'),
                          tableRow('Education', '${meeting['education']}'),
                          tableRow('Gender', '${meeting['gender']}'),
                          tableRow('Member ID', '${meeting['member_id']}'),
                          tableRow('Member Type', '${meeting['member_type']}'),
                          tableRow('Place', '${meeting['place']}'),
                          tableRow('Blood Group', '${meeting['blood_group']}'),
                          tableRow('Admin Rights', '${meeting['admin_rights']}'),
                          tableRow('Pin', '${meeting['pin']}'),
                          tableRow('Reffer Mobile', '${meeting['referrer_mobile']}'),
                          tableRow('Reffer ID', '${meeting['referrer_id']}'),
                          tableRow('District', '${meeting['district']}'),
                          tableRow('Chapter', '${meeting['chapter']}'),
                          tableRow('Koottam', '${meeting['koottam']}'),
                          tableRow('Kovil', '${meeting['kovil']}'),

                        ],
                      ),
                    ),
                    pw.SizedBox(width: 10),
                    pw.Expanded(
                      child: pw.Table(
                        border: pw.TableBorder.all(),
                        columnWidths: {
                          0: pw.FlexColumnWidth(1),
                          1: pw.FlexColumnWidth(2),
                        },
                        children: [
                          pw.TableRow(
                            children: [
                              pw.Text('Details', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                              pw.Text(''),
                            ],
                          ),
                         /* if (profileImage != null)
                            pw.TableRow(children: [
                              pw.Container(
                                child: pw.Image(pw.MemoryImage(profileImage), width: 100, height: 100),
                              ),

                            ]),*/
                         tableRow('Native', '${meeting['native']}'),
                          tableRow('Company Name', '${meeting['company_name']}'),
                          tableRow('Company Address', '${meeting['company_address']}'),
                          tableRow('Business Type', '${meeting['business_type']}'),
                          tableRow('Business Keywords', '${meeting['business_keywords']}'),
                          tableRow('Business Year', '${meeting['b_year']}'),
                          tableRow('Website', '${meeting['website']}'),
                          tableRow('Marital Status', '${meeting['marital_status']}'),
                          tableRow('Spouse Name', '${meeting['s_name']}'),
                          tableRow('Wedding Anniversary Date', '${meeting['WAD']}'),
                          tableRow('Spouse Blood Group', '${meeting['s_blood']}'),
                          tableRow('Spouse Father Koottam', '${meeting['s_father_koottam']}'),
                          tableRow('Spouse Father Kovil', '${meeting['s_father_kovil']}'),
                        ],
                      ),
                    ),
                  ],
                )
              ],
            );
          }).toList();
        },
      ),
    );

    return pdf.save();
  }

  pw.TableRow tableRow(String label, String value) {
    return pw.TableRow(
      children: [
        pw.Padding(
          padding: pw.EdgeInsets.all(8),
          child: pw.Text(label, style: pw.TextStyle(fontSize: 10)),
        ),
        pw.Padding(
          padding: pw.EdgeInsets.all(8),
          child: pw.Text(value, style: pw.TextStyle(fontSize: 10)),
        ),
      ],
    );
  }

  void downloadPdf() async {
    final pdfBytes = await generatePDF(filteredBusiness);
    await Printing.sharePdf(bytes: pdfBytes, filename: 'Individual_report.pdf');
  }


  @override
  void initState() {
    super.initState();
    getBusinessSlip();

    memberID.addListener(_enableSearchIcon);
    mobile.addListener(_enableSearchIcon);
  }

  void _enableSearchIcon() {
    setState(() {
      isSearchEnabled = memberID.text.isNotEmpty || mobile.text.isNotEmpty;
    });
  }


  @override
  void dispose() {
    memberID.removeListener(_enableSearchIcon);
    mobile.removeListener(_enableSearchIcon);
    memberID.dispose();
    mobile.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    int index =0;

    return MyScaffold(
        route:"/total_individual_report",
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
                                  'Individual Report',
                                  style: TextStyle(
                                    fontSize:20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                IconButton(onPressed: (){
                                  Navigator.pushNamed(context, '/total_individual_report');
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
                                              if (pattern.isEmpty) {
                                                return []; // Return an empty list if the pattern is empty
                                              }
                                              else{
                                                return business.where((item) =>
                                                (item['member_id']?.toString().toLowerCase().startsWith(pattern.toLowerCase()) ?? false))
                                                    .map((item) => item['member_id'].toString())
                                                    .toList();
                                              }
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
                                              if (pattern.isEmpty) {
                                                return []; // Return an empty list if the pattern is empty
                                              }
                                              else {
                                                return business
                                                    .where((item) =>
                                                    (item['mobile']?.toString().toLowerCase() ?? '')
                                                        .startsWith(pattern.toLowerCase()))
                                                    .map((item) => item['mobile'].toString())
                                                    .toList();
                                              }
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
                                        Card(
                                          child: IconButton(
                                            icon: Icon(Icons.search),
                                            onPressed: isSearchEnabled ? () {
                                              filterData();
                                            } : null,
                                            color: isSearchEnabled ? Colors.blue : Colors.grey,
                                          ),
                                        ),                                      ],
                                    )
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
                ),
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: SingleChildScrollView(
                    child: Container(
                      width: double.infinity,
                      height: 1000,
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
                            showData && filteredBusiness.isNotEmpty
                                ? SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: SizedBox(
                                height: 30,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: DataTable(
                                            columns: const [

                                              DataColumn(label: Text('Bio Details')),
                                              DataColumn(label: Text('')),

                                            ],
                                            rows: filteredBusiness.map((meeting) {
                                              String imageUrl = 'http://mybudgetbook.in/GIBADMINAPI/${meeting['profile_image']}';
                                              index++;
                                              return DataRow(
                                                cells: [

                                                  DataCell(

                                                      Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: Container(
                                                          height: 180,
                                                          width: 180, // Ensure the width matches the height for a circle
                                                          clipBehavior: Clip.antiAlias, // Smooth clipping for better visuals
                                                          decoration: BoxDecoration(
                                                            shape: BoxShape.circle, // Set the shape to circle
                                                            image: DecorationImage(
                                                              image: CachedNetworkImageProvider(imageUrl),
                                                              fit: BoxFit.cover, // Cover the container with the image
                                                            ),
                                                          ),
                                                        ),

                                                      ),

                                                      Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: Text('Name'),
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: Text('Mobile'),
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: Text('Email'),
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: Text('Date Of Birth'),
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: Text('Education'),
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: Text('Gender'),
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: Text('Member ID'),
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: Text('Member Type'),
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: Text('Place'),
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: Text('Blood Group'),
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: Text('Admin Rights'),
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: Text('Pin'),
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: Text('Reffer Mobile'),
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: Text('Reffer ID'),
                                                      ),
                                                      // Add more fields as needed
                                                    ],
                                                  )),
                                                  DataCell(Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: Container(
                                                          height: 180,
                                                          width: 180, // Ensure the width matches the height for a circle

                                                        ),

                                                      ),

                                                      Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: Text('${meeting['first_name']} ${meeting['last_name']}'),
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: Text('${meeting['mobile']}'),
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: Text('${meeting['email']}'),
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: Text('${meeting['dob']}'),
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: Text('${meeting['education']}'),
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: Text('${meeting['gender']}'),
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: Text('${meeting['member_id']}'),
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: Text('${meeting['member_type']}'),
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: Text('${meeting['place']}'),
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: Text('${meeting['blood_group']}'),
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: Text('${meeting['admin_rights']}'),
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: Text('${meeting['pin']}'),
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: Text('${meeting['referrer_mobile']}'),
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: Text('${meeting['referrer_id']}'),
                                                      ),
                                                      // Add more fields as needed
                                                    ],
                                                  )),
                                                ],
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                        Expanded(
                                          child: DataTable(
                                            columns: const [
                                              DataColumn(label: Text('Details')),
                                              DataColumn(label: Text('')),
                                            ],
                                            rows: filteredBusiness.map((meeting) {
                                              index++;
                                              return DataRow(
                                                cells: [
                                                  DataCell(Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: Text('District'),
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: Text('Chapter'),
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: Text('Koottam'),
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: Text('Kovil'),
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: Text('Native'),
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: Text('Company Name'),
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: Text('Company Address'),
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: Text('Business Type'),
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: Text('Business Keywords'),
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: Text('Business Year'),
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: Text('Website'),
                                                      ),

                                                      Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: Text('Matrital Status'),
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: Text('Spouse Name'),
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: Text('Wedding Anniversary Date'),
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: Text('Spouse Blood Group'),
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: Text('Spouse Father Kootam'),
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: Text('Spouse Father Kovil'),
                                                      ),
                                                      // Add more fields as needed
                                                    ],
                                                  )),
                                                  DataCell(
                                                      Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Padding(
                                                        padding: const EdgeInsets.all(12.0),
                                                        child: Text('${meeting['district']}'),
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: Text('${meeting['chapter']}'),
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: Text('${meeting['koottam']}'),
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: Text('${meeting['kovil']}'),
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: Text('${meeting['native']}'),
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: Text('${meeting['company_name']}'),
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: Text('${meeting['company_address']}'),
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: Text('${meeting['business_type']}'),
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: Text('${meeting['business_keywords']}'),
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: Text('${meeting['b_year']}'),
                                                      )  ,
                                                      Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: Text('${meeting['website']}'),
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: Text('${meeting['marital_status']}'),
                                                      ), Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: Text('${meeting['s_name']}'),
                                                      ),Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: Text('${meeting['WAD']}'),
                                                      ),Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: Text('${meeting['s_blood']}'),
                                                      ),Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: Text('${meeting['s_father_koottam']}'),
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: Text('${meeting['s_father_kovil']}'),
                                                      ),
                                                      // Add more fields as needed
                                                    ],
                                                  )),
                                                ],
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                      ],
                                    ),

                              ),
                                ) : Center(child: Text(" No Records Found", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),)),

                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
    );
  }
}
