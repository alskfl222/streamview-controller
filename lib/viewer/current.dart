import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class CurrentViewerWidget extends StatefulWidget {
  final String date;
  final String uid;

  const CurrentViewerWidget({
    Key? key,
    required this.date,
    required this.uid,
  }) : super(key: key);

  @override
  _CurrentViewerWidgetState createState() => _CurrentViewerWidgetState();
}

class _CurrentViewerWidgetState extends State<CurrentViewerWidget> {
  late WebSocketChannel _channel;
  late String _viewerId;

  @override
  void initState() {
    super.initState();
    _viewerId = const Uuid().v4();
    final websocketUrl = '${dotenv.env['WEBSOCKET_URL']}/current/$_viewerId';
    _channel = WebSocketChannel.connect(Uri.parse(websocketUrl!));
    _channel.stream.listen(
      (message) {
        print(message);
        if (message == 'ping') {
          _channel.sink.add('pong');
        }
      },
      onDone: () {

      },
      onError: (error) {
        print(error);
      },
    );
    _channel.sink.add(jsonEncode({
      "sender": "current",
      "type": "init",
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(widget.date),
          Text(widget.uid),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _channel.sink.close();
    super.dispose();
  }
}
