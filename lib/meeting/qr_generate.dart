
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:barcode_widget/barcode_widget.dart';


import '../main.dart';

class Member {
  final int id;
  final String name;
  Member( {
    required this.id,
    required this.name,
  });
}

class QRGeneratePage extends StatefulWidget {
  final String? meetingid;
  final String? meetingdate;
  final String? meetingtype;
  const QRGeneratePage({Key? key,
    required this.meetingid,
    required this.meetingdate,
    required this.meetingtype,
  }) : super(key: key);
  @override
  State<QRGeneratePage> createState() => _QRGeneratePageState();
}


class _QRGeneratePageState extends State<QRGeneratePage> {
  TextEditingController controller = TextEditingController();
  var qrstr = ""; var rqmeetingdate = "";
  String meetingname ="";
  String meetingid ="";
  String meetingtypez ="";
  String meetingdatez ="";
  @override
  void initState() {
    qrstr = widget.meetingid!;
    meetingtypez=widget.meetingtype!;
    meetingdatez =widget.meetingdate!;

    super.initState();
  }
  final TextEditingController textEditingController = TextEditingController();


  @override
  Widget build(BuildContext context) {


    return MyScaffold(
      route:"/qr_generate_page",
      body: Column(
        children: [

          const SizedBox(height: 60,),
          BarcodeWidget(
            data: qrstr,
            barcode: Barcode.qrCode(),
            color: Colors.green,
            height: 250,
            width: 250,
          ),
          const SizedBox(height: 20,),
          ElevatedButton(onPressed: () {
         /*   Navigator.push(context, MaterialPageRoute(
                builder: (context) => SaveBtnBuilder(qrstr: qrstr,)));
*/
            printDoc(qrstr);
          }, child: const Text("Print QR")),

       //  SaveBtnBuilder(qrstr: qrstr),

        ],
      ),

    );
  }
  Future<void> printDoc(qrstr) async {
    final doc = pw.Document();
    doc.addPage(pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return buildPrintableData(qrstr);
        }));
    await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => doc.save());
  }

  pw.Widget buildPrintableData(qrstr) {
    return pw.Padding(
        padding: const pw.EdgeInsets.all(25.00),
        child: pw.Center(
            child: pw.Column(children: [
              pw.SizedBox(height: 30),
              pw.BarcodeWidget(
                data: qrstr,
                barcode: Barcode.qrCode(),
                // color: Colors.green,
                height: 250,
                width: 250,
              ),
            ])));
  }
 }

