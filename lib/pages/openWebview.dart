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

class NavigationControls extends StatelessWidget {

  const NavigationControls(this._webViewControllerFuture);

  final Future<WebViewController> _webViewControllerFuture;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<WebViewController>(
      future: _webViewControllerFuture,
      builder:
          (BuildContext context, AsyncSnapshot<WebViewController> snapshot) {
        final bool webViewReady =
            snapshot.connectionState == ConnectionState.done;
        final WebViewController controller = snapshot.data;
        return Row(
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: !webViewReady
                  ? null
                  : () async {
                if (await controller.canGoBack()) {
                  controller.goBack();
                } else {
                  Scaffold.of(context).showSnackBar(
                    const SnackBar(content: Text("No back history item")),
                  );
                  return;
                }
              },
            ),
            IconButton(
              icon: const Icon(Icons.arrow_forward_ios),
              onPressed: !webViewReady
                  ? null
                  : () async {
                if (await controller.canGoForward()) {
                  controller.goForward();
                } else {
                  Scaffold.of(context).showSnackBar(
                    const SnackBar(
                        content: Text("No forward history item")),
                  );
                  return;
                }
              },
            ),
            IconButton(
              icon: const Icon(Icons.replay),
              onPressed: !webViewReady
                  ? null
                  : () {
                controller.reload();
              },
            ),

            IconButton(
              icon: const Icon(Icons.replay),
              onPressed: !webViewReady
                  ? null
                  : () async{
            _onShowUserAgent(controller, context);
            },
            )
          ],
        );
      },
    );
  }


  void _onShowUserAgent(
      WebViewController controller, BuildContext context) async {
    controller.evaluateJavascript(
        'Toaster.postMessage("User Agent: " + navigator.userAgent);');
  }
}