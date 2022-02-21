import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class PdfView extends StatefulWidget {

  String path;

  @override
  _PdfViewState createState() => _PdfViewState();

  PdfView(this.path);
}

class _PdfViewState extends State<PdfView> {
  int? pages = 1;
  bool isReady = false;
  // late PDFViewController _pdfViewController;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PDFView(
        filePath: widget.path,
        enableSwipe: true,
        swipeHorizontal: true,
        autoSpacing: false,
        pageFling: false,
        onRender: (_pages) {
          setState(() {
            pages = _pages;
            isReady = true;
          });
        },
        onError: (error) {
          print(error.toString());
        },
        onPageError: (page, error) {
          print('$page: ${error.toString()}');
        },
        onViewCreated: (PDFViewController pdfViewController) {
          // _controller.complete(pdfViewController);
        },
        onPageChanged: (int? page, int? total) {
          print('page change: $page/$total');
        },
      ),
    );
  }
}
