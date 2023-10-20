import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/todo.dart';
import 'item.dart';

class TodoListWidget extends StatelessWidget {
  const TodoListWidget(
      {super.key});

  @override
  Widget build(BuildContext context) {
    TodoProvider todoProvider = Provider.of<TodoProvider>(context);
    return Expanded(
      child: ReorderableListView(
        buildDefaultDragHandles: false,
        onReorder: todoProvider.onReorder,
        children: todoProvider.todos.map((todo) {
          int index = todoProvider.todos.indexOf(todo);
          return TodoItemWidget(
              key: ValueKey(todo.id), todo: todo, index: index);
        }).toList(),
      ),
    );
  }
}
