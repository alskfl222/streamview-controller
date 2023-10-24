import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:streamview_controller/viewer/container.dart';
import 'firebase_options.dart';
import 'provider/user.dart';
import 'provider/current.dart';
import 'provider/todo.dart';
import 'landing.dart';
import 'login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await dotenv.load(fileName: "env");
  usePathUrlStrategy();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => StreamViewRouterDelegate()),
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => CurrentDataProvider()),
        ChangeNotifierProvider(create: (context) => TodoProvider()),
      ],
      child: const StreamViewController(),
    ),
  );
}

class StreamViewController extends StatefulWidget {
  const StreamViewController({super.key});

  @override
  StreamViewControllerState createState() => StreamViewControllerState();
}

class StreamViewRoute {
  final bool isLogin;
  final String? uid;
  final bool isUnknown;

  StreamViewRoute.landing()
      : isLogin = false,
        uid = null,
        isUnknown = false;

  StreamViewRoute.login()
      : isLogin = true,
        uid = null,
        isUnknown = false;

  StreamViewRoute.viewer(this.uid)
      : isLogin = false,
        isUnknown = false;

  StreamViewRoute.unknown()
      : isLogin = false,
        uid = null,
        isUnknown = true;
}

class StreamViewRouterDelegate extends RouterDelegate<StreamViewRoute>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<StreamViewRoute> {
  @override
  final GlobalKey<NavigatorState> navigatorKey;
  StreamViewRoute _currentPath = StreamViewRoute.login();

  StreamViewRouterDelegate() : navigatorKey = GlobalKey<NavigatorState>();

  @override
  StreamViewRoute get currentConfiguration => _currentPath;

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: [
        const MaterialPage(child: Login()),
        if (_currentPath.isLogin) const MaterialPage(child: LandingPage()),
        if (_currentPath.uid != null)
          MaterialPage(child: ViewerPage(uid: _currentPath.uid!)),
        if (_currentPath.isUnknown)
          const MaterialPage(child: UnknownRoutePage())
      ],
      onPopPage: (route, result) => route.didPop(result),
    );
  }

  @override
  Future<void> setNewRoutePath(StreamViewRoute configuration) async {
    _currentPath = configuration;
    notifyListeners();
  }
}

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

    // Handle unknown routes
    return StreamViewRoute.unknown();
  }

  @override
  RouteInformation? restoreRouteInformation(StreamViewRoute configuration) {
    if (configuration.isUnknown) {
      return RouteInformation(uri: Uri.parse('/404'));
    }
    if (configuration.isLogin) return RouteInformation(uri: Uri.parse('/'));
    if (configuration.uid != null) {
      return RouteInformation(uri: Uri.parse('/viewer/${configuration.uid}'));
    }
    return RouteInformation(uri: Uri.parse('/login'));
  }
}

class StreamViewControllerState extends State<StreamViewController> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: "StreamView Controller",
      routeInformationParser: StreamViewRouterInformationParser(),
      routerDelegate: StreamViewRouterDelegate(),
    );
  }
}

class UnknownRoutePage extends StatelessWidget {
  const UnknownRoutePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("404 Not found"),
      ),
    );
  }
}
