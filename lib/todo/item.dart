import 'package:flutter/material.dart';
import 'container.dart';

class TodoItemWidget extends StatelessWidget {
  final TodoItem todo;
  final int index;

  const TodoItemWidget({super.key, required this.todo, required this.index});

  @override
  Widget build(BuildContext context) {
    return ReorderableDelayedDragStartListener(
      index: index,
      child: ListTileTheme(
        contentPadding: EdgeInsets.zero,
        child: ExpansionTile(
          tilePadding: const EdgeInsets.all(16.0),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8.0),
              Text("종류: ${todo.type}"),
              if (todo.type == "사냥" || todo.type == "보스")
                Text("캐릭터: ${todo.character}"),
              if (todo.type == "기타") Text("기타: ${todo.description}"),
            ],
          ),
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
                title: Text('Planned Start Time: ${todo.plannedStartTime}'),
              ),
            if (todo.actualStartTime != null)
              ListTile(
                title: Text('Actual Start Time: ${todo.actualStartTime}'),
              ),
          ],
        ),
      ),
    );
  }
}
