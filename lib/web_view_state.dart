import 'package:Magnetic.am/value.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_pro/webview_flutter.dart';

class WebViewState extends ChangeNotifier {
  WebViewController? _controller;
  double _progress = 0;
  late String initUri;
  bool useForcedOpenLinkInDefaultWebView = false;

  WebViewController? get controller => _controller;

  set controller(WebViewController? value) => _controller = value;

  double get progress => _progress;

  set progress(double value) {
    _progress = value;
    notifyListeners();
  }

  Future<bool> canGoBack() async {
    if (controllerInitialized) {
      return _controller!.canGoBack();
    }
    return false;
  }

  Future<void> goBack() async {
    if (await canGoBack()) {
      await _controller!.goBack();
      var currentUrl = await _controller!.currentUrl();
      if (currentUrl != null && currentUrl.contains(url)) {
        useForcedOpenLinkInDefaultWebView = false;
      }
    }
  }

  void reload() async {
    if (controllerInitialized) {
      _controller!.reload();
    }
  }

  void loadUri(Uri uri) async {
    while (await Future<bool>.delayed(Duration(seconds: 1), () {
      if (controllerInitialized) {
        _controller!.loadUrl(uri.toString());
        return false;
      } else {
        return true;
      }
    }));
  }

  bool get controllerInitialized => _controller != null;
}
