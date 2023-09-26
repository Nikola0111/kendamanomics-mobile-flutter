import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TrickTutorial extends StatefulWidget {
  final String? trickTutorialUrl;
  const TrickTutorial({super.key, required this.trickTutorialUrl});

  @override
  State<TrickTutorial> createState() => _TrickTutorialState();
}

class _TrickTutorialState extends State<TrickTutorial> {
  WebViewController? _webviewController;

  @override
  void initState() {
    super.initState();
    _initializeWebviewController();
  }

  void _initializeWebviewController() {
    if (widget.trickTutorialUrl != null) {
      _webviewController = WebViewController()
        ..loadRequest(Uri.parse('${widget.trickTutorialUrl!}?autoplay=1&autohide=1&controls=1'));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_webviewController != null) {
      return WebViewWidget(controller: _webviewController!);
    }

    return const SizedBox.shrink();
  }
}
