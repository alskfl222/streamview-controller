import 'dart:convert';
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
import 'homepage.dart';
import 'login.dart';
import 'viewer.dart';
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
        ChangeNotifierProvider(create: (context) => WebSocketProvider(
          WebSocketChannel.connect(
            Uri.parse(dotenv.env['WEBSOCKET_URL']!),
          ),
        )),
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
  late WebSocketChannel _channel;
  bool _isWebSocketError = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _channel = WebSocketChannel.connect(
      Uri.parse(dotenv.env['WEBSOCKET_URL']!),
    );
    _sendMessage({"type": "init"});

    _channel.stream.listen(
      (data) {
        // 데이터 처리 로직 (생략 가능)
      },
      onError: (error) {
        setState(() {
          _isWebSocketError = true;
          _errorMessage = error.toString();
        });
      },
      onDone: () {
        // 웹소켓 연결 종료시 로직 (생략 가능)
      },
      cancelOnError: true,
    );
  }

  void _sendMessage(Map<String, dynamic> data) {
    var jsonMessage = jsonEncode({
      'sender': 'controller',
      'time': DateTime.now().toIso8601String(),
      ...data,
    });

    _channel.sink.add(jsonMessage);
  }

  @override
  Widget build(BuildContext context) {
    if (_isWebSocketError) {
      return MaterialApp(
        home: ServerErrorPage(
          errorMessage: _errorMessage,
        ),
      );
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'StreamView Controller',
      initialRoute: '/',
      routes: {
        '/': (context) => Consumer<UserProvider>(
              builder: (context, user, child) {
                return user.status == Status.authenticated
                    ? MyHomePage(
                        title: 'StreamView Controller',
                        sendMessage: _sendMessage,
                      )
                    : const Login();
              },
            ),
        '/viewer': (context) => const ViewerPage(),
      },
    );
  }

  @override
  void dispose() {
    _channel.sink.close();
    super.dispose();
  }
}
