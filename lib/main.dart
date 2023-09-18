import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'homepage.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  late WebSocketChannel _channel;

  @override
  void initState() {
    super.initState();
    _channel = WebSocketChannel.connect(
      Uri.parse(dotenv.env['WEBSOCKET_URL']!),
    );
    _sendMessage("init", {});
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
    return MaterialApp(
      title: 'WebSocket Demo',
      home: MyHomePage(
        title: 'WebSocket Demo',
        sendMessage: _sendMessage,
      ),
    );
  }

  @override
  void dispose() {
    _channel.sink.close();
    super.dispose();
  }
}

