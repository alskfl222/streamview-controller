import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/todo.dart';
import 'item.dart';

class TodoListWidget extends StatefulWidget {
  const TodoListWidget({super.key});

  @override
  _TodoListWidgetState createState() => _TodoListWidgetState();
}

class _TodoListWidgetState extends State<TodoListWidget> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToCurrentTodo());
  }

  void _scrollToCurrentTodo() {
    final todoProvider = Provider.of<TodoProvider>(context, listen: false);
    if (todoProvider.todos.isNotEmpty) {
      int currentIndex = todoProvider.getCurrentTodoIndex();
      if (currentIndex != -1) {
        double position = currentIndex * TodoItemWidget.itemHeight;
        _scrollController.animateTo(
          position,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final todoProvider = Provider.of<TodoProvider>(context);
    return Expanded(
      child: ListView.builder(
        controller: _scrollController,
        itemCount: todoProvider.todos.length,
        itemBuilder: (context, index) {
          final todo = todoProvider.todos[index];
          return TodoItemWidget(todo: todo, index: index);
        },
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
