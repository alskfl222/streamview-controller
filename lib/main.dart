import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'firebase_options.dart';
import 'user.dart';
import 'homepage.dart';
import 'login.dart';
import 'server_error.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await dotenv.load(fileName: ".env");
  runApp(
    ChangeNotifierProvider(
      create: (context) => UserProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  late WebSocketChannel _channel;
  bool _isWebSocketError = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _channel = WebSocketChannel.connect(
      Uri.parse(dotenv.env['WEBSOCKET_URL']!),
    );
    _sendMessage("init", {});

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

  void _sendMessage(String type, Map<String, dynamic> data) {
    var jsonMessage = jsonEncode({
      'sender': 'controller',
      'user': 'owner',
      'time': DateTime.now().toIso8601String(),
      'type': type,
      'data': data,
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
        home: Consumer<UserProvider>(
          builder: (context, user, child) {
            return user.status == Status.authenticated
                ? MyHomePage(
                    title: 'StreamView Controller',
                    sendMessage: _sendMessage,
                  )
                : const Login();
          },
        ));
  }

  @override
  void dispose() {
    _channel.sink.close();
    super.dispose();
  }
}
