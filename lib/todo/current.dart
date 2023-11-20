import 'package:flutter/material.dart';
import 'package:streamview_controller/provider/todo.dart';

class CurrentTodoCard extends StatelessWidget {
  final TodoItem? todo;

  const CurrentTodoCard({Key? key, this.todo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80, // 카드의 높이를 100픽셀로 고정
      child: Card(
        color: todo == null || todo!.id == 'default'
            ? Colors.grey.shade300
            : Colors.blue.shade100,
        child: Center(
          child: ListTile(
            leading: todo == null || todo!.id == 'default'
                ? const Icon(Icons.hourglass_empty, color: Colors.grey)
                : todo!.statusIcon,
            title: Text(
              todo == null || todo!.id == 'default'
                  ? '할일이 없습니다'
                  : todo!.kind,
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
            trailing: todo != null && todo!.id != 'default'
                ? IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                // 편집 로직 구현
              },
            )
                : null,
            // ... 기타 세부사항 표시
          ),
        ),
      ),
    );
  }
}
