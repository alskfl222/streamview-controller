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

  factory TodoItem.fromJson(Map<String, dynamic> json) {
    return TodoItem(
      id: json['id'] as String,
      type: json['type'] as String,
      kind: json['kind'] as String,
      activity: _decodeMap(json['activity'] as Map<String, dynamic>?),
      addedTime: json['addedTime'] as String,
      plannedStartTime: json['plannedStartTime'] as String?,
      actualStartTime: json['actualStartTime'] as String?,
      endTime: json['endTime'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'kind': kind,
      'activity': activity != null ? _encodeMap(activity!) : null,
      'addedTime': addedTime,
      'plannedStartTime': plannedStartTime,
      'actualStartTime': actualStartTime,
      'endTime': endTime,
    };
  }

  Map<String, dynamic> _encodeMap(Map<String, String?> map) {
    final result = <String, dynamic>{};
    map.forEach((key, value) {
      result[key] = value ?? 'null'; // null 값을 'null' 문자열로 변환
    });
    return result;
  }

  static Map<String, String?>? _decodeMap(Map<String, dynamic>? json) {
    return json?.map((key, value) => MapEntry(key, value?.toString()));
  }
}

class TodoProvider with ChangeNotifier {
  bool _isEditMode = false;
  DateTime _date =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  List<TodoItem> _todos = [];
  TodoItem? _editingTodo;

  bool get isEditMode => _isEditMode;

  DateTime get date => _date;

  List<TodoItem> get todos => _todos;

  TodoItem? get editingTodo => _editingTodo;

  Map<String, dynamic> get todoData => {
        'date': _date.toIso8601String(),
        'todos': _todos.map((todo) => todo.toMap()).toList(),
      };

  void enterEditMode(TodoItem todoItem) {
    _isEditMode = true;
    _editingTodo = todoItem;
    notifyListeners();
  }

  void exitEditMode() {
    _isEditMode = false;
    _editingTodo = null;
    notifyListeners();
  }

  void setTodos(List<dynamic> todosJson) {
    _todos = todosJson.map((todoJson) => TodoItem.fromJson(todoJson)).toList();
    notifyListeners();
  }

  void changeDate(DateTime newDate) {
    _date = newDate;
    notifyListeners();
    print("changeDate");
  }

  void addTodo(TodoItem todo) {
    _todos.add(todo);
    notifyListeners();
  }

  void updateTodo(TodoItem updatedTodo) {
    int index = _todos.indexWhere((todo) => todo.id == updatedTodo.id);
    if (index != -1) {
      print("수정 인덱스: $index");
      _todos[index] = updatedTodo;
      notifyListeners();
    } else {
      print("기존 할일을 찾지 못함");
    }
    exitEditMode();
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
