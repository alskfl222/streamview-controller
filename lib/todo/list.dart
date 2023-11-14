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

    if (todoProvider.todos.isEmpty) {
      // 할일 리스트가 비어있을 때 표시할 위젯
      return const Expanded(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            '할일이 없습니다',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      );
    }

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
