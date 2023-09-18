import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const title = 'WebSocket Demo';
    return const MaterialApp(
      title: title,
      home: MyHomePage(
        title: title,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
    required this.title,
  });

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _channel = WebSocketChannel.connect(
    Uri.parse(dotenv.env['WEBSOCKET_URL']!),
  );

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
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 버튼 3개를 추가
            ElevatedButton(
              onPressed: () => _sendMessage("option", {"value": "Option 1"}),
              child: Container(
                width: 100,
                height: 100,
                child: Center(child: Text("Option 1")),
              ),
            ),
            SizedBox(height: 15),
            ElevatedButton(
              onPressed: () => _sendMessage("option", {"value": "Option 2"}),
              child: Container(
                width: 100,
                height: 100,
                child: Center(child: Text("Option 2")),
              ),
            ),
            SizedBox(height: 15),
            ElevatedButton(
              onPressed: () => _sendMessage("option", {"value": "Option 3"}),
              child: Container(
                width: 100,
                height: 100,
                child: Center(child: Text("Option 3")),
              ),
            ),
            SizedBox(height: 24),
            StreamBuilder(
              stream: _channel.stream,
              builder: (context, snapshot) {
                return Text(snapshot.hasData ? '${snapshot.data}' : '');
              },
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _channel.sink.close();
    super.dispose();
  }
}