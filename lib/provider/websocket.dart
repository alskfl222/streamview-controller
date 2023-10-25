import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/user.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'current.dart';

class WebSocketProvider with ChangeNotifier {
  late WebSocketChannel _channel;
  late BuildContext _context;
  bool isWebSocketError = false;
  String errorMessage = '';

  WebSocketProvider(WebSocketChannel channel, BuildContext context) {
    _channel = channel;
    _context = context;
    _initWebSocket(_context);
  }

  void _initWebSocket(BuildContext context) {
    final CurrentDataProvider currentDataProvider =
        Provider.of<CurrentDataProvider>(context, listen: false);
    sendMessage({"type": "init"});
    _channel.stream.listen(
      (data) {
        Map<String, dynamic> decoded = jsonDecode(data);
        if (decoded["type"] == 'current') {
          currentDataProvider.setCurrentDisplay(decoded['option']['select']);
          currentDataProvider
              .setSelectedDate(DateTime.parse(decoded['option']['date']));
          currentDataProvider.setSelectedGame(decoded['option']['game']);
        }
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

  void sendMessage(Map<String, dynamic> data) {
    UserProvider userProvider =
        Provider.of<UserProvider>(_context, listen: false);
    String jsonMessage = jsonEncode({
      'sender': {
        'type': 'controller',
        'user': userProvider.user != null ? userProvider.user!.email : '',
      },
      'time': DateTime.now().toIso8601String(),
      ...data,
    });

    _channel.sink.add(jsonMessage);
  }

  @override
  void dispose() {
    _channel.sink.close();
    super.dispose();
  }
}
