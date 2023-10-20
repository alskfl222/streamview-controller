import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'user.dart';
import 'websocket.dart';

class TodoItem {
  final String id;
  final String description;
  final String taskType;
  final String? game;
  final String? activity;
  final String? character;
  final String addedTime;
  String? plannedStartTime;
  String? actualStartTime;

  TodoItem({
    required this.id,
    required this.description,
    required this.taskType,
    required this.addedTime,
    this.game,
    this.activity,
    this.character,
    this.plannedStartTime,
    this.actualStartTime,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'taskType': taskType,
      'game': game,
      'activity': activity,
      'character': character,
      'addedTime': addedTime,
      'plannedStartTime': plannedStartTime,
      'actualStartTime': actualStartTime,
    };
  }
}

class TodoProvider with ChangeNotifier {
  late BuildContext _context;
  DateTime _date = DateTime.now();
  final List<TodoItem> _todos = [];

  TodoProvider(BuildContext context) {
    _context = context;
  }

  DateTime get date => _date;

  List<TodoItem> get todos => _todos;

  void changeDate(DateTime newDate) {
    _date = newDate;
  }

  void addTodo(TodoItem todo) {
    _todos.add(todo);
    notifyListeners();
  }

  void onReorder(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    final item = _todos.removeAt(oldIndex);
    _todos.insert(newIndex, item);
    notifyListeners();
  }

  void sendTodos() {
    final websocketProvider =
        Provider.of<WebSocketProvider>(_context, listen: false);
    final userProvider = Provider.of<UserProvider>(_context, listen: false);
    print(userProvider.user?.email);
    print("Sending data to server: ${_todos[0]}");
    Map<String, dynamic> data = {
      'type': 'todo',
      'date': _date.toIso8601String(),
      'todos': _todos.map((todo) => todo.toJson()).toList(),
    };
    websocketProvider.sendMessage(data);
  }
}
