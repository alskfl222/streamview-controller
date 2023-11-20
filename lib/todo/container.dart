import 'dart:convert';
import 'dart:html' as html;
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

class TodoWidget extends StatefulWidget {
  const TodoWidget({super.key});

  @override
  _TodoWidgetState createState() => _TodoWidgetState();
}

class _TodoWidgetState extends State<TodoWidget> {
  DateTime? _date;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
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
      return;
    }
    final token = await user.getIdToken();

    final serverUrl = dotenv.env['SERVER_URL'];
    if (serverUrl == null) {
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
                    IconButton(
                      icon: const Icon(Icons.visibility),
                      onPressed: _launchViewer,
                    ),
                  ],
                ),
                Row(
                  children: [
                    OutlinedButton(
                        onPressed: _showAddTodoModal,
                        child: const Text('할일 추가'))
                  ],
                )
              ],
            ),
          ),
          const TodoListWidget(),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: _sendTodos,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue, // 버튼 배경 색상
              foregroundColor: Colors.white, // 텍스트 색상
              padding: const EdgeInsets.symmetric(vertical: 15), // 버튼 내부 패딩
            ),
            child: const Text("할일 전송"),
          ),
        ),
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
      todoProvider.changeDate(pickedDate);
    }
  }

  Future<void> _launchViewer() async {
    final UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    TodoProvider todoProvider =
        Provider.of<TodoProvider>(context, listen: false);
    final uid = userProvider.user!.uid;
    final formattedDate = DateFormat('yyyy-MM-dd').format(todoProvider.date);
    html.window
        .open('/viewer/todo?date=$formattedDate&uid=$uid', '_blank', 'popup');
  }

  void _showAddTodoModal() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const Dialog(
          child: TodoInputWidget(),
        );
      },
    );
  }

  void _sendTodos() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    TodoProvider todoProvider =
        Provider.of<TodoProvider>(context, listen: false);
    User? user = userProvider.user;
    if (user == null) {
      return;
    }
    final token = await user.getIdToken();

    final todoData = todoProvider.todoData;

    final serverUrl = dotenv.env['SERVER_URL']!;
    if (serverUrl == null) {
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
