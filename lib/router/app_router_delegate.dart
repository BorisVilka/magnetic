import 'package:Magnetic.am/home_screen.dart';
import 'package:Magnetic.am/web_view_state.dart';
import 'package:flutter/material.dart';

import 'app_route_path.dart';

class AppRouterDelegate extends RouterDelegate<AppRoutePath>
    with ChangeNotifier {
  AppRoutePath _currentConfiguration = AppRoutePath.home();

  final WebViewState state;

  AppRouterDelegate(this.state) {
    state.initUri = _currentConfiguration.uri.toString();
  }

  @override
  AppRoutePath get currentConfiguration => _currentConfiguration;

  @override
  Future<void> setNewRoutePath(AppRoutePath configuration) async {
    _currentConfiguration = configuration;
    state.initUri = configuration.uri.toString();
    state.loadUri(configuration.uri);
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      pages: [MaterialPage(child: HomeScreen())],
      onPopPage: (Route route, dynamic result) {
        return false;
      },
    );
  }

  @override
  Future<bool> popRoute() async {
    if (state.controllerInitialized) {
      if (await state.canGoBack()) {
        await state.goBack();
        return Future.value(true);
      }
    }
    return Future.value(false);
  }
}
