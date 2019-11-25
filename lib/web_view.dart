import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MyWebView extends StatefulWidget {
  String url;
  MyWebView(this.url);
  @override
  _MyWebViewState createState() => _MyWebViewState(this.url);
}

class _MyWebViewState extends State<MyWebView> {
  String url;
  _MyWebViewState(this.url);
  @override
  Widget build(BuildContext context) {
    print('web');
    print(url);
    return Scaffold(
      appBar: AppBar(
        title: Text('News Buddy'),
      ),
      body: WebView(
        initialUrl: this.url,
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
