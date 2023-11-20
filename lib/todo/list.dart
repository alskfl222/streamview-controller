import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/todo.dart';
import 'item.dart';
import 'current.dart';

class TodoListWidget extends StatefulWidget {
  const TodoListWidget({super.key});

  @override
  _TodoListWidgetState createState() => _TodoListWidgetState();
}

class _TodoListWidgetState extends State<TodoListWidget> {
  @override
  Widget build(BuildContext context) {
    final todoProvider = Provider.of<TodoProvider>(context);
    final currentTodo = todoProvider.currentTodo;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (currentTodo != null) CurrentTodoCard(todo: currentTodo),
        Flexible(
          child: SizedBox(
            height: MediaQuery.of(context).size.height - 270,
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: todoProvider.todos.length,
              itemBuilder: (context, index) {
                final todo = todoProvider.todos[index];
                return TodoItemWidget(todo: todo, index: index);
              },
            ),
          ),
        )
      ],
    );
  }
}