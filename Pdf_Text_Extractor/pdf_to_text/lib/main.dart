import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

void main() {
  runApp(MaterialApp(home: PdfTextExtractorPage()));
}

class PdfTextExtractorPage extends StatefulWidget {
  @override
  _PdfTextExtractorPageState createState() => _PdfTextExtractorPageState();
}

class _PdfTextExtractorPageState extends State<PdfTextExtractorPage> {
  String? extractedText;
  bool loading = false;

  Future<void> pickPdfAndExtractText() async {
    setState(() {
      loading = true;
      extractedText = null;
    });

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null && result.files.single.path != null) {
      final path = result.files.single.path!;
      final bytes = File(path).readAsBytesSync();

      PdfDocument document = PdfDocument(inputBytes: bytes);
      PdfTextExtractor extractor = PdfTextExtractor(document);
      String text = extractor.extractText();
      document.dispose();

      setState(() {
        extractedText = text;
        loading = false;
      });
    } else {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('PDF Text Extractor')),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: loading
            ? Center(child: CircularProgressIndicator())
            : extractedText != null
                ? SingleChildScrollView(child: Text(extractedText!))
                : Center(child: Text('Pick a PDF to extract text')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: pickPdfAndExtractText,
        tooltip: 'Pick PDF',
        child: Icon(Icons.picture_as_pdf),
      ),
    );
  }
}
