import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
      activity: _decodeMap(json['activity'] as Map<String, String?>?),
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
    final result = <String, String>{};
    map.forEach((key, value) {
      result[key] = value ?? 'null'; // null 값을 'null' 문자열로 변환
    });
    return result;
  }

  static Map<String, String?>? _decodeMap(Map<String, String?>? json) {
    return json?.map((key, value) => MapEntry(key, value?.toString()));
  }

  Icon get statusIcon {
    if (actualStartTime != null && endTime == null) {
      // 실제 시작 시간은 있으나 끝나지 않았을 때
      return const Icon(Icons.play_arrow, color: Colors.green);
    } else if (endTime != null) {
      // 작업이 끝났을 때
      return const Icon(Icons.check_circle, color: Colors.blue);
    } else if (plannedStartTime != null) {
      // 예정된 작업
      return const Icon(Icons.schedule, color: Colors.orange);
    } else {
      // 등록만 된 경우
      return const Icon(Icons.circle, color: Colors.grey);
    }
  }

  String get displayStatus {
    final formatter = DateFormat('yyyy-MM-dd HH:mm');

    String? formatTime(String? time) {
      if (time != null) {
        try {
          final dateTime = DateTime.parse(time);
          return formatter.format(dateTime);
        } catch (e) {
          return null; // 유효하지 않은 시간 형식인 경우 null을 반환
        }
      }
      return null;
    }

    final formattedPlannedStartTime = formatTime(plannedStartTime);
    final formattedActualStartTime = formatTime(actualStartTime);
    final formattedEndTime = formatTime(endTime);
    final formattedAddedTime = formatTime(addedTime);

    if (formattedActualStartTime != null && formattedEndTime != null) {
      return "시작: $formattedActualStartTime\n끝: $formattedEndTime";
    } else if (formattedActualStartTime != null) {
      return "시작: $formattedActualStartTime";
    } else if (formattedPlannedStartTime != null) {
      return "예정: $formattedPlannedStartTime";
    } else {
      // `addedTime`은 'required' 이므로 변환 오류가 있으면 원래의 문자열을 반환합니다.
      return "등록: ${formattedAddedTime ?? addedTime}";
    }
  }
}

class TodoProvider with ChangeNotifier {
  bool _isEditMode = false;
  DateTime _date =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  List<TodoItem> _todos = [];
  TodoItem? _editingTodo;
  final List<String> _defaultGameKinds = ["메이플스토리"];
  final List<String> _addedGameKinds = [];

  bool get isEditMode => _isEditMode;

  DateTime get date => _date;

  List<TodoItem> get todos => _todos;

  TodoItem? get editingTodo => _editingTodo;

  List<String> get gameKinds =>
      List.from(_defaultGameKinds)..addAll(_addedGameKinds);

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
    _todos = todosJson.map((todoJson) {
      final todo = TodoItem.fromJson(todoJson);
      final kind = todo.kind;

      if (todo.type == '게임' &&
          !_defaultGameKinds.contains(kind) &&
          !_addedGameKinds.contains(kind)) {
        _addedGameKinds.add(kind);
      }

      return todo;
    }).toList();
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

  void deleteTodo(String todoId) {
    _todos.removeWhere((todo) => todo.id == todoId);
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

  void addGameKind(String newGameKind) {
    if (!_defaultGameKinds.contains(newGameKind) &&
        !_addedGameKinds.contains(newGameKind)) {
      _addedGameKinds.add(newGameKind);
      notifyListeners();
    }
  }
}
