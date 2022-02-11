import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'thirdpage.dart';
class Try extends StatelessWidget {

  final String url2;
  const Try({Key? key, required this.url2}) : super(key: key);


  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Welcome to Flutter',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Open file'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            tooltip: 'Return to previous page',
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ThirdPage()));
            },
          ),


        ),
        body: Center(
          child: WebView(
            initialUrl:
            url2,
            javascriptMode: JavascriptMode.unrestricted,
          ),
        ),
      ),
    );
  }
}