import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/user.dart';
import '../provider/todo.dart';
import 'list.dart';
import 'input/container.dart';

class TodoList extends StatefulWidget {
  const TodoList({super.key});

  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  @override
  Widget build(BuildContext context) {
    TodoProvider todoProvider =
        Provider.of<TodoProvider>(context, listen: false);
    DateTime date = todoProvider.date;
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "${date.toLocal()}".split(' ')[0],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.calendar_today),
                      onPressed: () async {
                        final DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: date,
                          firstDate: DateTime.now(),
                          lastDate:
                              DateTime.now().add(const Duration(days: 365)),
                        );
                        if (pickedDate != null && pickedDate != date) {
                          todoProvider.changeDate(pickedDate);
                        }
                      },
                    ),
                  ],
                ),
                const TodoInputWidget()
              ],
            ),
          ),
          const TodoListWidget(),
          ElevatedButton(
            onPressed: _sendTodos,
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  void _sendTodos() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    User? user = userProvider.user;
    if (user == null) {
      print('No user is signed in.');
      return;
    }
    final token = await user.getIdToken();

    final currentData = {
      'current': {
        'display': _selectedCurrent,
        'date': _selectedDate.toIso8601String(),
      },
    };

    TodoProvider todoProvider =
        Provider.of<TodoProvider>(context, listen: false);
  }
}
