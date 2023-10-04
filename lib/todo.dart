import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'user.dart';

class TodoList extends StatefulWidget {
  const TodoList({super.key});

  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  final List<String> _todos = [];
  final TextEditingController _textController = TextEditingController();

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
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: const InputDecoration(labelText: '할 일 추가'),
                    onSubmitted: _handleSubmitted,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    _handleSubmitted(_textController.text);
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: ReorderableListView(
              onReorder: _onReorder,
              children: _todos.map((todo) {
                return ListTile(
                  key: ValueKey(todo),
                  title: Text(todo),
                  trailing: const Icon(Icons.menu),
                );
              }).toList(),
            ),
          ),
          ElevatedButton(
            onPressed: _sendToServer,
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  void _handleSubmitted(String text) {
    if (text.isNotEmpty) {
      setState(() {
        _todos.add(text);
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
    print("Sending data to server: $_todos");
    // API 호출 코드 추가 예정
  }
}
