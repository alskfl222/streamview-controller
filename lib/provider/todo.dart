import 'dart:convert';

import 'package:flutter/material.dart';

class TodoItem {
  final String id;
  final String type;
  final String kind;
  Map<String, String?>? activity;
  final String addedTime;
  String? plannedStartTime;
  String? actualStartTime;
  String? endTime;

  TodoItem({
    required this.id,
    required this.type,
    required this.kind,
    this.activity,
    required this.addedTime,
    this.plannedStartTime,
    this.actualStartTime,
    this.endTime,
  });

  String toJson() {
    return jsonEncode({
      id: id,
      type: type,
      kind: kind,
      activity: jsonEncode(activity),
      addedTime: addedTime,
      plannedStartTime: plannedStartTime,
      actualStartTime: actualStartTime,
    });
  }
}

class TodoProvider with ChangeNotifier {
  DateTime _date =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  final List<TodoItem> _todos = [];

  DateTime get date => _date;

  List<TodoItem> get todos => _todos;

  void changeDate(DateTime newDate) {
    _date = newDate;
  }

  void addTodo(TodoItem todo) {
    _todos.add(todo);
    print(_todos);
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


}
