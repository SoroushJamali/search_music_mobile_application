import 'dart:async';
import 'package:flutter/material.dart';

import 'package:webview_flutter/webview_flutter.dart';

class MyWebView extends StatelessWidget {
  String a;
  final Completer<WebViewController> _controller =
  Completer<WebViewController>();

  MyWebView(this.a);



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.all(40.0),
            child:Center(
            child:SizedBox(
          height: 500,
            width: 500,
            child:WebView(
          initialUrl: 'https://m.feelapp.website/music4.php?p='+a,
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController) {
            _controller.complete(webViewController);
          },
        )))));

  }

}