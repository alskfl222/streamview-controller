import 'package:flutter/material.dart';
import 'route.dart';
import '../provider/page.dart';
import '../login.dart';
import '../landing.dart';
import '../viewer/container.dart';
import '../404.dart';

class StreamViewRouterDelegate extends RouterDelegate<StreamViewRoute>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<StreamViewRoute> {
  @override
  final GlobalKey<NavigatorState> navigatorKey;
  final PageProvider notifier;

  StreamViewRouterDelegate({required this.notifier})
      : navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    print("build: ${notifier.pageName}");
    return Navigator(
      key: navigatorKey,
      pages: [
        if (notifier.pageName == PageName.login)
          const MaterialPage(child: Login()),
        if (notifier.pageName == PageName.landing)
          const MaterialPage(child: LandingPage()),
        if (notifier.pageName == PageName.viewer)
          MaterialPage(child: ViewerPage(uid: notifier.uid!)),
        if (notifier.isUnknown) const MaterialPage(child: UnknownRoutePage())
      ],
      onPopPage: (route, result) => route.didPop(result),
    );
  }

  @override
  StreamViewRoute? get currentConfiguration {
    if (notifier.isUnknown) {
      return StreamViewRoute.unknown();
    }

    if (notifier.pageName == PageName.login) {
      return StreamViewRoute.login();
    }
    if (notifier.pageName == PageName.landing) {
      return StreamViewRoute.landing();
    }

    if (notifier.pageName == PageName.viewer) {
      return StreamViewRoute.viewer(notifier.uid);
    }

    return StreamViewRoute.unknown();
  }

  @override
  Future<void> setNewRoutePath(StreamViewRoute configuration) async {
    print('setNewRoutePath: ${configuration.pageName}');
    if (configuration.isUnknown) {
      _updateRoute(page: null, isUnknown: true);
    }

    if (configuration.isLogin) {
      _updateRoute(page: PageName.login);
    }

    if (configuration.isLanding) {
      _updateRoute(page: PageName.landing);
    }

    if (configuration.isViewer) {
      _updateRoute(page: PageName.viewer, uid: configuration.uid);
    }
  }

  _updateRoute({PageName? page, bool isUnknown = false, String? uid}) {
    notifier.changePage(page: page, uid: uid, unknown: isUnknown);
  }
}
