import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:streamview_controller/todo/list.dart';
import 'input.dart';
import '../user.dart';

class TodoItem {
  final String id;
  final String description;
  final String type; // '사냥', '보스', '기타'
  final String? character; // 'a', 'b', 'c' 또는 null (임시)
  final DateTime addedTime;
  DateTime? plannedStartTime;
  DateTime? actualStartTime;

  TodoItem({
    required this.id,
    required this.description,
    required this.type,
    required this.addedTime,
    this.character,
    this.plannedStartTime,
    this.actualStartTime,
  });
}

class TodoList extends StatefulWidget {
  const TodoList({super.key});

  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  final List<TodoItem> _todos = [];
  DateTime selectedDate = DateTime.now();

  // DateTime? plannedStartTime;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    var userProvider = Provider.of<UserProvider>(context, listen: false);
    if (userProvider.status != Status.authenticated) {
      Navigator.pushReplacementNamed(context, '/');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "${selectedDate.toLocal()}".split(' ')[0], // 현재 날짜를 표시
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.calendar_today),
                      onPressed: () async {
                        final DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: selectedDate,
                          firstDate: DateTime.now(),
                          lastDate:
                              DateTime.now().add(const Duration(days: 365)),
                        );
                        if (pickedDate != null && pickedDate != selectedDate) {
                          setState(() {
                            selectedDate = pickedDate;
                          });
                        }
                      },
                    ),
                  ],
                ),
                TodoInputWidget(onAddTodo: _addTodo)
              ],
            ),
          ),
          TodoListWidget(
            todos: _todos,
            onReorder: _onReorder,
          ),
          ElevatedButton(
            onPressed: _sendToServer,
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  void _addTodo(TodoItem item) {
    setState(() {
      _todos.add(item);
    });
  }

  void _onReorder(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    setState(() {
      final item = _todos.removeAt(oldIndex);
      _todos.insert(newIndex, item);
    });
  }

  void _sendToServer() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    print(userProvider.user?.email);
    // 서버로 데이터를 보내는 로직을 구현해야 합니다.
    // 현재는 단순히 콘솔에 출력만 하도록 했습니다.
    print("Sending data to server: $_todos");
  }
}
