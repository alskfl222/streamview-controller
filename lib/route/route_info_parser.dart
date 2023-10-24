import 'package:flutter/material.dart';
import 'route.dart';

class StreamViewRouterInformationParser
    extends RouteInformationParser<StreamViewRoute> {
  @override
  Future<StreamViewRoute> parseRouteInformation(
      RouteInformation routeInformation) async {
    final uri = routeInformation.uri;

    if (uri.pathSegments.isEmpty) {
      return StreamViewRoute.landing();
    }

    if (uri.pathSegments.length == 1) {
      if (uri.pathSegments[0] == 'login') return StreamViewRoute.login();
      if (uri.pathSegments[0] == '404') return StreamViewRoute.unknown();
    }

    if (uri.pathSegments.length == 2) {
      if (uri.pathSegments[0] == 'viewer') {
        var uid = uri.pathSegments[1];
        return StreamViewRoute.viewer(uid);
      }
    }

    return StreamViewRoute.unknown();
  }

  @override
  RouteInformation? restoreRouteInformation(StreamViewRoute configuration) {
    if (configuration.isUnknown) {
      return RouteInformation(uri: Uri.parse('/404'));
    }
    if (configuration.isLanding) {
      return RouteInformation(uri: Uri.parse('/'));
    }
    if (configuration.isViewer) {
      return RouteInformation(uri: Uri.parse('/viewer/${configuration.uid}'));
    }
    return RouteInformation(uri: Uri.parse('/login'));
  }
}