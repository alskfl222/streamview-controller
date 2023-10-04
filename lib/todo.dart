import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'user.dart';

class TodoItem {
  final String id;
  final String task;
  final DateTime addedTime;
  DateTime? plannedStartTime;
  DateTime? actualStartTime;

  TodoItem({
    required this.id,
    required this.task,
    required this.addedTime,
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
  final TextEditingController _textController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  DateTime? plannedStartTime;

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
      appBar: AppBar(title: const Text('할 일')),
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
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.calendar_today),
                      onPressed: () async {
                        final DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: selectedDate,
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(Duration(days: 365)),
                        );
                        if (pickedDate != null && pickedDate != selectedDate)
                          setState(() {
                            selectedDate = pickedDate;
                          });
                      },
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _textController,
                        decoration: const InputDecoration(labelText: '할 일 추가'),
                        onSubmitted: _handleSubmitted,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.access_time),
                      onPressed: _selectPlannedStartTime,
                    ),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        _handleSubmitted(_textController.text);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
              child: ReorderableListView(
            buildDefaultDragHandles: false,
            onReorder: _onReorder,
            children: _todos.map((todo) {
              return ReorderableDelayedDragStartListener(
                key: ValueKey(todo.id),
                index: _todos.indexOf(todo),
                child: ListTileTheme(
                  contentPadding: EdgeInsets.zero,
                  child: ExpansionTile(
                    tilePadding: const EdgeInsets.all(16.0),
                    title: Text(todo.task),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            // 수정 로직
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.check),
                          onPressed: () {
                            // 확인 로직
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            // 삭제 로직
                          },
                        ),
                      ],
                    ),
                    children: [
                      ListTile(
                        title: Text('Added Time: ${todo.addedTime}'),
                      ),
                      if (todo.plannedStartTime != null)
                        ListTile(
                          title: Text(
                              'Planned Start Time: ${todo.plannedStartTime}'),
                        ),
                      if (todo.actualStartTime != null)
                        ListTile(
                          title: Text(
                              'Actual Start Time: ${todo.actualStartTime}'),
                        ),
                    ],
                  ),
                ),
              );
            }).toList(),
          )),
          ElevatedButton(
            onPressed: _sendToServer,
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  void _selectPlannedStartTime() async {
    TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (selectedTime != null) {
      DateTime now = DateTime.now();
      plannedStartTime = DateTime(
        now.year,
        now.month,
        now.day,
        selectedTime.hour,
        selectedTime.minute,
      );
    }
  }

  void _handleSubmitted(String text) {
    if (text.isNotEmpty) {
      final todoItem = TodoItem(
        id: DateTime.now().toString(),
        task: text,
        addedTime: DateTime.now(),
        plannedStartTime: plannedStartTime,
      );
      setState(() {
        _todos.add(todoItem);
        plannedStartTime = null;
      });
      _textController.clear();
    }
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
    // 서버로 데이터를 보내는 로직을 구현해야 합니다.
    // 현재는 단순히 콘솔에 출력만 하도록 했습니다.
    print("Sending data to server: $_todos");
  }
}
