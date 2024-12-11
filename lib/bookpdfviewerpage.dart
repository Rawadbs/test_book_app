import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PDFViewPage extends StatelessWidget {
  final String pdfName;

  const PDFViewPage({super.key, required this.pdfName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF Viewer'),
      ),
      body: SfPdfViewer.asset(
        'assets/pdf/$pdfName', // تحميل PDF مباشرة من assets
      ),
    );
  }
}
