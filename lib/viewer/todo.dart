import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:provider/provider.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '/provider/todo.dart';
// import '/util/dummy.dart';

class TodoViewerWidget extends StatefulWidget {
  final String date;
  final String uid;

  const TodoViewerWidget({
    Key? key,
    required this.date,
    required this.uid,
  }) : super(key: key);

  @override
  _TodoViewerWidgetState createState() => _TodoViewerWidgetState();
}

class _TodoViewerWidgetState extends State<TodoViewerWidget> {
  late WebSocketChannel _channel;
  late String _viewerId;
  List<TodoItem> _todos = [];

  @override
  void initState() {
    super.initState();
    _viewerId = const Uuid().v4();
    final websocketUrl = '${dotenv.env['WEBSOCKET_URL']}/todo/$_viewerId';
    _channel = WebSocketChannel.connect(Uri.parse(websocketUrl!));
    _channel.stream.listen(
      (message) {
        try {
          dynamic data = jsonDecode(message);
          print('Received data: $data');
          if (data is Map && data['todos'] is List) {
            setState(() {
              _todos = (data['todos'] as List)
                  .map((todoData) => TodoItem.fromJson(todoData))
                  .toList();
            });
          }
        } catch (e) {
          print('Error parsing message: $e');
        }
      },
      onDone: () {},
      onError: (error) {
        print('Error on WebSocket: $error');
      },
    );
    _fetchInitTodos();
  }

  void _fetchInitTodos() {
    _channel.sink.add(jsonEncode({'date': widget.date, 'uid': widget.uid}));
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double listViewMaxWidth = screenWidth > 600 ? 600 : screenWidth;
    final todoProvider = Provider.of<TodoProvider>(context, listen: false);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        // 좌우 1rem (16픽셀) 패딩
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: listViewMaxWidth),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  // 위아래 패딩 추가
                  child: Text(widget.date), // 날짜 표시
                ),
                Expanded(
                  child: _todos.isEmpty
                      ? const Center(
                          child: Text('등록된 할일이 없습니다'),
                        )
                      : ListView.builder(
                          itemCount: _todos.length,
                          itemBuilder: (context, index) {
                            if (index < _todos.length) {
                              // 인덱스 검사를 합니다 (사실상 불필요, 예방적 로직)
                              TodoItem todo = _todos[index];
                              return Card(
                                child: ListTile(
                                  leading: todo.statusIcon,
                                  title: Text('${todo.type}: ${todo.kind}'),
                                  subtitle: Text(
                                      todo.activity?['description'] ??
                                          'No description'),
                                  trailing: Text(todo.displayStatus),
                                ),
                              );
                            } else {
                              return const Center(
                                child: Text('이걸 보면 안 되는데?'),
                              );
                            }
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
