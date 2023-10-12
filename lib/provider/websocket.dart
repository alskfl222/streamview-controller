import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketProvider with ChangeNotifier {
  late WebSocketChannel _channel;
  bool isWebSocketError = false;
  String errorMessage = '';

  WebSocketProvider(WebSocketChannel channel) {
    _channel = channel;
    _initWebSocket();
  }

  void _initWebSocket() {
    _sendMessage({"type": "init"});

    _channel.stream.listen(
          (data) {
        // 데이터 처리 로직 (생략 가능)
        notifyListeners();
      },
      onError: (error) {
        isWebSocketError = true;
        errorMessage = error.toString();
        notifyListeners();
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

  void dispose() {
    _channel.sink.close();
    super.dispose();
  }
}