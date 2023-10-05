import 'package:flutter/material.dart';
import 'container.dart';
import 'item.dart';

class TodoListWidget extends StatelessWidget {
  final List<TodoItem> todos;
  final Function(int oldIndex, int newIndex) onReorder;

  const TodoListWidget(
      {super.key, required this.todos, required this.onReorder});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ReorderableListView(
        buildDefaultDragHandles: false,
        onReorder: onReorder,
        children: todos.map((todo) {
          int index = todos.indexOf(todo);
          return TodoItemWidget(
              key: ValueKey(todo.id), todo: todo, index: index);
        }).toList(),
      ),
    );
  }
}
