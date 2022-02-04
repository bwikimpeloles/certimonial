import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PDFviewer extends StatefulWidget {
  String url = "";

  PDFviewer({Key? key, required this.url}) : super(key: key);

  @override
  _PDFviewerState createState() => _PDFviewerState();
}

class _PDFviewerState extends State<PDFviewer> {
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PDF Viewer'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.share,
              color: Colors.white,
            ),
            onPressed: () {
              // function to share pdf
            },
          ),
        ],
      ),
      body: SfPdfViewer.network(
        widget.url,
        key: _pdfViewerKey,
      ),
    );
  }
}
