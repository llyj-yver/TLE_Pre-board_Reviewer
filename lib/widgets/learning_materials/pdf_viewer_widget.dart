import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';

class PDFViewerWidget extends StatefulWidget {
  final String pdfPath; // Can be asset path or file path
  final bool isAsset;   // true if pdfPath is from assets

  const PDFViewerWidget({
    super.key,
    required this.pdfPath,
    this.isAsset = true,
  });

  @override
  State<PDFViewerWidget> createState() => _PDFViewerWidgetState();
}

class _PDFViewerWidgetState extends State<PDFViewerWidget> {
  late PdfControllerPinch _pdfController;

  @override
  void initState() {
    super.initState();

    _pdfController = PdfControllerPinch(
      document: widget.isAsset
          ? PdfDocument.openAsset(widget.pdfPath)
          : PdfDocument.openFile(widget.pdfPath),
    );
  }

  @override
  void dispose() {
    _pdfController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF Viewer'),
      ),
      body: PdfViewPinch(
        controller: _pdfController,
        scrollDirection: Axis.vertical,
      ),
    );
  }
}
