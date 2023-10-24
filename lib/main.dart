import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'firebase_options.dart';
import 'provider/page.dart';
import 'provider/user.dart';
import 'provider/current.dart';
import 'provider/todo.dart';
import 'route/router_delegate.dart';
import 'route/route_info_parser.dart';

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
        ChangeNotifierProvider(create: (context) => PageProvider()),
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => CurrentDataProvider()),
        ChangeNotifierProvider(create: (context) => TodoProvider()),
        ChangeNotifierProxyProvider<PageProvider, StreamViewRouterDelegate>(
          create: (context) => StreamViewRouterDelegate(
              notifier: Provider.of<PageProvider>(context, listen: false)),
          update: (context, pageNotifier, previous) =>
              StreamViewRouterDelegate(notifier: pageNotifier),
        ),
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

class StreamViewControllerState extends State<StreamViewController> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: "StreamView Controller",
      routeInformationParser: StreamViewRouterInformationParser(),
      routerDelegate:
          Provider.of<StreamViewRouterDelegate>(context, listen: false),
    );
  }
}
