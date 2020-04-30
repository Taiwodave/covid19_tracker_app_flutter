import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:async';

class WebViewTest extends StatefulWidget {
  final String value;
  final String value1;

  WebViewTest({Key key, this.value, this.value1}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _WebViewTestState();
  }
}


JavascriptChannel snackbarJavascriptChannel(BuildContext context) {
  return JavascriptChannel(
    name: 'Toaster',
    onMessageReceived: (JavascriptMessage message) {
      Scaffold.of(context).showSnackBar(
        SnackBar(content: Text(message.message)),
      );
    },
  );
}




class _WebViewTestState extends State<WebViewTest> {
  //
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

   String filePath = 'files/test.html';

  //String filePath = 'file:///android_asset/test.html';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${widget.value1}')),
      body: Builder(
        builder: (BuildContext context) {
          return WebView(
            initialUrl: '${widget.value}',
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (WebViewController webViewController) {
              _controller.complete(webViewController);
            },
            javascriptChannels: <JavascriptChannel>[
              snackbarJavascriptChannel(context),
            ].toSet(),


          );
        },
      ),
    );
  }
}