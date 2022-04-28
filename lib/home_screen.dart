import 'dart:io';

import 'package:Magnetic.am/value.dart' as values;
import 'package:external_app_launcher/external_app_launcher.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_webview_pro/webview_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late WebViewController _controller;
  double progress = 0;

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
  }

  JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'Toaster',
        onMessageReceived: (JavascriptMessage message) {
          // ignore: deprecated_member_use
          Scaffold.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    double _w = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: () async {
        if (await _controller.canGoBack()) {
          _controller.goBack();
          return true;
        } else {
          return false;
        }
      },
      child: Scaffold(
          body: SafeArea(
            child: WebView(
              javascriptMode: JavascriptMode.unrestricted,
              initialUrl: values.url,
              onWebViewCreated: (controller) {
                _controller = controller;
              },
              onProgress: (initProgress) {
                setState(() {
                  progress = initProgress / 100;
                });
              },
              // Schemas handler
              navigationDelegate: (NavigationRequest request) async {
                // html default schemas
                if (_isWebSchemas(request.url)) {
                  launch(request.url);
                  return NavigationDecision.prevent;
                  // Schema for whatsapp links
                } else if (request.url.contains('https://wa.')) {
                  if (Platform.isIOS && await canLaunch(request.url)) {
                    // for iOS open link in default webview
                    return NavigationDecision.navigate;
                  } else {
                    // or open link via url handler
                    await launch(request.url);
                  }
                  return NavigationDecision.prevent;
                  // Open Viber url schema
                } else if (request.url.contains('viber:')) {
                  if (await canLaunch(request.url)) {
                    await launch(request.url);
                  } else {
                    await LaunchApp.openApp(
                      androidPackageName: 'com.viber.voip',
                      iosUrlScheme: request.url,
                      appStoreLink:
                          'itms-apps://apps.apple.com/am/app/viber/id382617920',
                    );
                  }
                  return NavigationDecision.prevent;
                  // Open idram url schema
                } else if (request.url.contains('idramapp:')) {
                  if (await canLaunch(request.url)) {
                    await launch(request.url);
                  } else {
                    await LaunchApp.openApp(
                      androidPackageName: 'am.imwallet.android',
                      iosUrlScheme: request.url,
                      appStoreLink:
                      'itms-apps://apps.apple.com/am/app/idram-idbank/id558788989',
                    );
                  }
                  return NavigationDecision.prevent;
                }
                // navigation behaviour default
                return NavigationDecision.navigate;
              },
              javascriptChannels: <JavascriptChannel>{
                _toasterJavascriptChannel(context),
              },
            ),
          ),
          bottomNavigationBar: Container(
            height: _w / 6.5,
            color: Colors.white,
            child: Column(
              children: [
                LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.white,
                  color: Colors.black,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                        onPressed: () {
                          _controller.goBack();
                        },
                        icon: Icon(
                          Icons.arrow_back,
                          color: Colors.black,
                          size: _w / 14,
                        )),
                    IconButton(
                        onPressed: () {
                          _controller.reload();
                        },
                        icon: Icon(
                          Icons.refresh,
                          color: Colors.black,
                          size: _w / 14,
                        ))
                  ],
                ),
              ],
            ),
          )),
    );
  }

  bool _isWebSchemas(String url) {
    return url.contains('mailto:') || url.contains('tel:');
  }
}
