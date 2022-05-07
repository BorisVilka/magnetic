import 'dart:io';

import 'package:Magnetic.am/bottom_navigation_bar.dart';
import 'package:Magnetic.am/value.dart';
import 'package:Magnetic.am/web_view_state.dart';
import 'package:external_app_launcher/external_app_launcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_pro/webview_flutter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

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
    var state = context.watch<WebViewState>();
    return WillPopScope(
      onWillPop: () async {
        if (await state.canGoBack()) {
          await state.goBack();
          return true;
        } else {
          return false;
        }
      },
      child: Scaffold(
          body: SafeArea(
            child: WebView(
              javascriptMode: JavascriptMode.unrestricted,
              initialUrl: state.initUri,
              onWebViewCreated: (controller) {
                state.controller = controller;
              },
              onProgress: (initProgress) {
                state.progress = initProgress / 100;
              },
              navigationDelegate: (NavigationRequest request) {
                return navigationDelegateHandler(context, request, state);
              },
              javascriptChannels: <JavascriptChannel>{
                _toasterJavascriptChannel(context),
              },
            ),
          ),
          bottomNavigationBar: BottomNavBar()),
    );
  }

  Future<NavigationDecision> navigationDelegateHandler(BuildContext context,
      NavigationRequest request, WebViewState state) async {
    // Filtering internal requests for iOS
    if (Platform.isIOS && !request.isForMainFrame) {
      return NavigationDecision.navigate;
    }
    var uriString = request.url;
    var uri = Uri.tryParse(uriString);
    if (uri == null) {
      return NavigationDecision.navigate;
    }
    // html default schemas
    if (_isWebSchemas(uriString)) {
      launchUrl(uri);
      return NavigationDecision.prevent;
      // Schema for whatsapp links
    } else if (uriString.contains('viber:')) {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        await LaunchApp.openApp(
          androidPackageName: 'com.viber.voip',
          iosUrlScheme: uriString,
          appStoreLink: 'itms-apps://apps.apple.com/am/app/viber/id382617920',
        );
      }
      return NavigationDecision.prevent;
      // Open idram url schema
    } else if (uriString.contains('idramapp:')) {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        await LaunchApp.openApp(
          androidPackageName: 'am.imwallet.android',
          iosUrlScheme: uriString,
          appStoreLink:
              'itms-apps://apps.apple.com/am/app/idram-idbank/id558788989',
        );
      }
      return NavigationDecision.prevent;
    }
    if (url.contains(uri.host)) {
      state.useForcedOpenLinkInDefaultWebView = false;
    } else if (uriString.contains('https://banking.idram.am') ||
        uriString.contains('https://money.idram.am')) {
      return NavigationDecision.navigate;
    } else {
      if (uriString.contains('https://online.payx.am')) {
        state.useForcedOpenLinkInDefaultWebView = true;
      }
      LaunchMode mode;
      if (uriString.contains('http')) {
        // Needs for handle navigation payment systems
        if (state.useForcedOpenLinkInDefaultWebView) {
          return NavigationDecision.navigate;
        } else {
          mode = LaunchMode.externalApplication;
        }
      } else {
        mode = LaunchMode.externalNonBrowserApplication;
      }
      await launchUrl(uri, mode: mode);
      return NavigationDecision.prevent;
    }
    // navigation behaviour default
    return NavigationDecision.navigate;
  }

  bool _isWebSchemas(String url) {
    return url.contains('mailto:') || url.contains('tel:');
  }
}
