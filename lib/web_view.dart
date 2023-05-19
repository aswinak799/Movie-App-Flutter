import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
// import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;

class MovieDetails extends StatefulWidget {
  const MovieDetails({super.key, required this.url});
  final String url;

  @override
  State<MovieDetails> createState() => _MovieDetailsState();
}

class _MovieDetailsState extends State<MovieDetails> {
  @override
  void initState() {
    // TODO: implement initState
    url = widget.url;

    super.initState();
  }

  InAppWebViewController? _webViewController;
  late String url;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Movie Details")),
      body: SafeArea(
        child: InAppWebView(
          initialUrlRequest: URLRequest(url: Uri.parse(url)),
          initialOptions: InAppWebViewGroupOptions(
            crossPlatform: InAppWebViewOptions(
              javaScriptEnabled: true,
            ),
          ),
          onWebViewCreated: (InAppWebViewController controller) {
            _webViewController = controller;
          },
        ),
      ),
    );
  }
}
