import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:pdf_text/pdf_text.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: PDFTextExtractorApp(),
  ));
}

class PDFTextExtractorApp extends StatefulWidget {
  const PDFTextExtractorApp({super.key});

  @override
  State<PDFTextExtractorApp> createState() => _PDFTextExtractorAppState();
}

class _PDFTextExtractorAppState extends State<PDFTextExtractorApp> {
  String extractedText = 'No PDF selected yet.';

  Future<void> pickAndExtractText() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null && result.files.single.path != null) {
      File file = File(result.files.single.path!);

      try {
        PDFDoc doc = await PDFDoc.fromFile(file);
        String text = await doc.text;

        setState(() {
          extractedText = text.isEmpty
              ? 'No extractable text found in this PDF.'
              : text;
        });
      } catch (e) {
        setState(() {
          extractedText = 'Error reading PDF: $e';
        });
      }
    } else {
      setState(() {
        extractedText = 'No file picked.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('PDF Text Extractor')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: pickAndExtractText,
              child: const Text('Pick PDF & Extract Text'),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  extractedText,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
