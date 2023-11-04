import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '/provider/todo.dart';
import '/util/dummy.dart';

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
  late List<TodoItem> _todos;

  @override
  void initState() {
    super.initState();
    _viewerId = const Uuid().v4();
    final websocketUrl = '${dotenv.env['WEBSOCKET_URL']}/current/$_viewerId';
    _channel = WebSocketChannel.connect(Uri.parse(websocketUrl!));
    _channel.stream.listen(
      (message) {
        print(message);
      },
      onDone: () {

      },
      onError: (error) {
        print(error);
      },
    );
    _loadDummyData();
  }

  void _loadDummyData() {
    // 여기에서 더미 데이터를 할일 목록에 할당합니다.
    _todos = dummyTodos; // 더미 데이터 할당
  }

  @override
  Widget build(BuildContext context) {
    // 화면의 너비를 구합니다.
    double screenWidth = MediaQuery.of(context).size.width;

    // 화면의 너비가 600픽셀 이상인지 여부에 따라 최대 너비를 결정합니다.
    double listViewMaxWidth = screenWidth > 600 ? 600 : screenWidth;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0), // 좌우 1rem (16픽셀) 패딩
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: listViewMaxWidth),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0), // 위아래 패딩 추가
                  child: Text(widget.date), // 날짜 표시
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: _todos.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          leading: const Icon(Icons.check_circle_outline),
                          title: Text('${_todos[index].type}: ${_todos[index].kind}'),
                          subtitle: Text(_todos[index].activity?['description'] ?? 'No description'),
                          trailing: Text(_todos[index].addedTime),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
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
