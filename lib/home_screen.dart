import 'dart:io';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:Magnetic.am/value.dart' as values;

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
    if(Platform.isAndroid) WebView.platform = AndroidWebView();
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
        onWillPop: () async{
          if(await _controller.canGoBack()){
            _controller.goBack();
            return true;
          } else{
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
                          )
                      ),

                      IconButton(
                          onPressed: (){
                            _controller.reload();
                          },
                          icon: Icon(
                            Icons.refresh,
                            color: Colors.black,
                            size: _w / 14,
                          )
                      )
                    ],
                  ),
                ],
              ),
            )),
    );
  }
}