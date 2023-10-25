import 'package:flutter/material.dart';
import 'user.dart';

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
  DateTime _date = DateTime.now();
  final List<TodoItem> _todos = [];

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

  }
}
