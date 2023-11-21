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

    Color borderColor = todo.getItemColor();
    // 현재 진행 중인 할일에 대한 스타일
    final currentTodoStyle = TextStyle(
      color: isCurrent ? Colors.blue : Colors.black,
      fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
    );

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: borderColor, width: 2.0), // 외곽선 설정
        borderRadius: BorderRadius.circular(8.0), // 모서리 둥글게 설정
      ),
      margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: ListTileTheme(
        contentPadding: EdgeInsets.zero,
        child: ExpansionTile(
          tilePadding: const EdgeInsets.all(16.0),
          backgroundColor: isCurrent ? Colors.blue.shade50 : Colors.white,
          title: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "종류: ${todo.type}",
                style: currentTodoStyle,
              ),
              Text(
                "${todo.type}: ${todo.kind}",
                style: currentTodoStyle,
              ),
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.copy),
                onPressed: () => _onPressedCopy(context, todo),
              ),
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
      ),
    );
  }

  List<Widget> _buildDetails(TodoItem todo) {
    // 세부사항을 구성하는 위젯 리스트를 생성합니다.
    List<Widget> details = [];

    // 'activity' 정보 추가
    if (todo.activity != null) {
      details.add(ListTile(title: Text('Activity: ${todo.activity}')));
    }
    // 'addedTime' 정보 추가
    if (todo.addedTime.isNotEmpty) {
      details.add(ListTile(title: Text('Added Time: ${todo.addedTime}')));
    }

    // 'plannedStartTime', 'actualStartTime', 'endTime' 정보 추가
    if (todo.plannedStartTime != null) {
      details.add(ListTile(
          title: Text('Planned Start Time: ${todo.plannedStartTime}')));
    }
    if (todo.actualStartTime != null) {
      details.add(
          ListTile(title: Text('Actual Start Time: ${todo.actualStartTime}')));
    }
    if (todo.endTime != null) {
      details.add(ListTile(title: Text('End Time: ${todo.endTime}')));
    }
    return details;
  }

  void _onPressedCopy(BuildContext context, TodoItem todo) {
    final todoProvider = Provider.of<TodoProvider>(context, listen: false);
    todoProvider.copyTodo(todo);

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return const Dialog(child: TodoInputWidget());
        }).then((_) {
      todoProvider.resetCopyTodo(); // 입력 완료 후 모드 종료
    });
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
