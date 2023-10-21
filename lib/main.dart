import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'firebase_options.dart';
import 'provider/websocket.dart';
import 'provider/user.dart';
import 'provider/current.dart';
import 'provider/todo.dart';
import 'homepage.dart';
import 'login.dart';
import 'viewer/container.dart';
import 'server_error.dart';

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
        ChangeNotifierProvider(
            create: (context) => WebSocketProvider(
                  WebSocketChannel.connect(
                    Uri.parse(dotenv.env['WEBSOCKET_URL']!),
                  ),
                  context,
                )),
        ChangeNotifierProvider(create: (context) => TodoProvider(context)),
      ],
      child: const StreamviewController(),
    ),
  );
}

class StreamviewController extends StatefulWidget {
  const StreamviewController({super.key});

  @override
  StreamviewControllerState createState() => StreamviewControllerState();
}

class StreamviewControllerState extends State<StreamviewController> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'StreamView Controller',
      initialRoute: '/login',
      routes: {
        '/login': (context) => const Login(),
        '/': (context) => const MyHomePage(),
        '/viewer': (context) => const ViewerPage(),
      },
    );
  }
}
