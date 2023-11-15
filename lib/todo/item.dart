import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/todo.dart';
import './input/container.dart';

class TodoItemWidget extends StatelessWidget {
  final TodoItem todo;
  final int index;

  static const double itemHeight = 100.0;

  const TodoItemWidget({super.key, required this.todo, required this.index});

  @override
  Widget build(BuildContext context) {
    final todoProvider = Provider.of<TodoProvider>(context, listen: false);
    bool isCurrent = todoProvider.isCurrentTodo(todo);

    return ListTileTheme(
      contentPadding: EdgeInsets.zero,
      child: ExpansionTile(
        tilePadding: const EdgeInsets.all(16.0),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8.0),
            Text("종류: ${todo.type}"),
            Text("${todo.type}: ${todo.kind}"),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => _onPressedEdit(context, todo),
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => _onPressedDelete(context, todo),
            ),
          ],
        ),
        children: _buildDetails(todo), // 세부사항을 표시하는 위젯 리스트
      ),
    );
  }

  List<Widget> _buildDetails(TodoItem todo) {
    // 세부사항을 구성하는 위젯 리스트를 생성합니다.
    List<Widget> details = [];
    // 예시: 할일의 세부사항을 추가합니다.
    // 예를 들어, todo.activity와 같은 추가 정보를 여기에 포함시킬 수 있습니다.
    if (todo.activity != null) {
      details.add(ListTile(title: Text('Activity: ${todo.activity}')));
    }
    return details;
  }

  void _onPressedEdit(BuildContext context, TodoItem todo) {
    final todoProvider = Provider.of<TodoProvider>(context, listen: false);
    todoProvider.enterEditMode(todo);

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return const Dialog(child: TodoInputWidget());
        }).then((_) {
      todoProvider.exitEditMode();
    });
  }

  void _onPressedDelete(BuildContext context, TodoItem todo) {
    Provider.of<TodoProvider>(context, listen: false).deleteTodo(todo.id);
  }
}
