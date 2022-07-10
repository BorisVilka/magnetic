import 'dart:io';

import 'package:Magnetic.am/router/app_route_information_parser.dart';
import 'package:Magnetic.am/router/app_router_delegate.dart';
import 'package:Magnetic.am/web_view_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_pro/webview_flutter.dart';
import 'package:provider/provider.dart';
import 'package:wonderpush_flutter/wonderpush_flutter.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  runApp(const MyApp());
  WonderPush.subscribeToNotifications();
  WonderPush.addProperty("User id", '1');
}

class MyApp extends StatelessWidget {
  final String _title = 'Magnetic.am';

  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => WebViewState(),
        ),
        ChangeNotifierProxyProvider<WebViewState, AppRouterDelegate>(
            create: (BuildContext context) => AppRouterDelegate(
                  Provider.of<WebViewState>(context, listen: false),
                ),
            update: (BuildContext context, WebViewState state,
                AppRouterDelegate? delegate) {
              if (delegate == null) {
                return AppRouterDelegate(
                  Provider.of<WebViewState>(context, listen: false),
                );
              } else {
                return delegate;
              }
            }),
      ],
      child: Builder(
        builder: (BuildContext context) => MaterialApp.router(
          title: _title,
          routerDelegate: context.watch<AppRouterDelegate>(),
          routeInformationParser: AppRouteInformationParser(),
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
        ),
      ),
    );
  }
}
