import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'firebase_options.dart';
import 'provider/user.dart';
import 'provider/current.dart';
import 'provider/todo.dart';
import 'route/router.dart';


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

class StreamViewControllerState extends State<StreamViewController> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: "StreamView Controller",
      routerConfig: routerConfig,
    );
  }
}
