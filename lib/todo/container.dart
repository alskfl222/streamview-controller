import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../provider/user.dart';
import '../provider/todo.dart';
import 'list.dart';
import 'input/container.dart';
import '../util/modal.dart';

class TodoList extends StatefulWidget {
  const TodoList({super.key});

  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  DateTime? _date;

  @override
  void didChangeDependencies() {
    final todoProvider = Provider.of<TodoProvider>(context);
    if (_date != todoProvider.date) {
      _fetchInitTodo();
    }
  }

  void _fetchInitTodo() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    TodoProvider todoProvider =
        Provider.of<TodoProvider>(context, listen: false);
    User? user = userProvider.user;
    if (user == null) {
      print('No user is signed in.');
      return;
    }
    final token = await user.getIdToken();

    final serverUrl = dotenv.env['SERVER_URL'];
    if (serverUrl == null) {
      print('SERVER_URL is not defined in env file.');
      return;
    }
    final String formattedDate =
        DateFormat('yyyy-MM-dd').format(todoProvider.date);
    final response = await http.get(
      Uri.parse('$serverUrl/controller/todo?date=$formattedDate'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      if (data['todos'] != null) {
        todoProvider.setTodos(data['todos']);
      }
      if (data['date'] != null) {
        String dateString = data['date'];
        DateFormat format = DateFormat('yyyy-MM-dd');
        DateTime newDate = format.parse(dateString);
        setState(() {
          _date = newDate;
        });
      }
      print('Data fetched successfully: ${response.body}');
    } else {
      print('Failed to fetch data. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    // TodoProvider todoProvider = Provider.of<TodoProvider>(context);
    // DateTime date = todoProvider.date;
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
                        _date != null
                            ? "${_date?.toLocal()}".split(' ')[0]
                            : "불러오는 중",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.calendar_today),
                      onPressed: _onPressChangeDate,
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

  void _onPressChangeDate() async {
    TodoProvider todoProvider =
        Provider.of<TodoProvider>(context, listen: false);
    DateTime date = todoProvider.date;
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: date,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (pickedDate != null && pickedDate != date) {
      print(pickedDate);
      todoProvider.changeDate(pickedDate);
    }
  }

  void _sendTodos() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    TodoProvider todoProvider =
        Provider.of<TodoProvider>(context, listen: false);
    User? user = userProvider.user;
    if (user == null) {
      print('No user is signed in.');
      return;
    }
    final token = await user.getIdToken();

    final todoData = todoProvider.todoData;
    print(todoData);

    final serverUrl = dotenv.env['SERVER_URL']!;
    if (serverUrl == null) {
      print('SERVER_URL is not defined in env file.');
      return;
    }
    final postResponse = await http.post(
      Uri.parse('$serverUrl/controller/todo'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(todoData),
    );

    if (postResponse.statusCode == 200) {
      print('Data posted successfully: ${postResponse.body}');
      showModal(context, 'Success', 'Data posted successfully.');
    } else {
      print('Failed to post data. Status code: ${postResponse.statusCode}');
      print('Response body: ${postResponse.body}');
      showModal(context, 'Error',
          'Failed to post data. Status code: ${postResponse.statusCode}');
    }
  }
}
