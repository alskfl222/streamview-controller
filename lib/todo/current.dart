import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:streamview_controller/provider/todo.dart';
import 'package:streamview_controller/todo/input/container.dart';

class CurrentTodoCard extends StatelessWidget {
  final TodoItem? todo;

  const CurrentTodoCard({Key? key, this.todo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 할일 상태에 따른 버튼을 생성합니다.

    List<Widget> buildActionButtons() {
      final todoProvider = Provider.of<TodoProvider>(context, listen: false);
      List<Widget> buttons = [];

      if (todo != null && todo!.id != 'default') {
        // 할일이 "시작" 상태인 경우
        if (todo!.actualStartTime == null && todo!.endTime == null) {
          buttons.add(
            IconButton(
              icon: const Icon(Icons.play_arrow),
              onPressed: () {
                // 시작 로직 구현
                todoProvider.startTodo(todo!.id);
              },
            ),
          );
        }

        // 할일이 진행 중인 경우 "완료" 버튼
        if (todo!.actualStartTime != null && todo!.endTime == null) {
          buttons.add(
            IconButton(
              icon: const Icon(Icons.check),
              onPressed: () {
                // 완료 로직 구현
                todoProvider.completeTodo(todo!.id);
              },
            ),
          );
        }

        // "수정" 버튼
        buttons.add(
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // 수정 로직 구현
              _onPressedEdit(context, todo!);
            },
          ),
        );
      }

      return buttons;
    }

    return SizedBox(
      height: 80, // 카드의 높이를 100픽셀로 고정
      child: Card(
        color: todo?.getItemColor() ?? Colors.grey.shade300,
        child: Center(
          child: ListTile(
            leading: todo == null || todo!.id == 'default'
                ? const Icon(Icons.hourglass_empty, color: Colors.grey)
                : todo!.statusIcon,
            title: Text(
              todo == null || todo!.id == 'default' ? '할일이 없습니다' : todo!.kind,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: todo == null || todo!.id == 'default'
                    ? Colors.grey.shade600
                    : Colors.black,
              ),
            ),
            subtitle: todo != null && todo!.id != 'default'
                ? Text(todo!.displayStatus)
                : null,
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: buildActionButtons(),
            ),
            // ... 기타 세부사항 표시
          ),
        ),
      ),
    );
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
}
