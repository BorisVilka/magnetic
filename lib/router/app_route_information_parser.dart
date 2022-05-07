import 'package:flutter/material.dart';

import 'app_route_path.dart';

class AppRouteInformationParser extends RouteInformationParser<AppRoutePath> {
  @override
  Future<AppRoutePath> parseRouteInformation(
      RouteInformation routeInformation) async {
    if (routeInformation.location == null) {
      return AppRoutePath.home();
    }
    return AppRoutePath(routeInformation.location!);
  }
}
