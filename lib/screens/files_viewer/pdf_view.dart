import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class AppPDFView extends StatefulWidget {
  const AppPDFView({Key key, this.url}) : super(key: key);
  final String url;
  @override
  _AppPDFViewState createState() => _AppPDFViewState();
}

class _AppPDFViewState extends State<AppPDFView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(), body: SfPdfViewer.network(widget.url));
  }
}
