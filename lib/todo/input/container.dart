import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/todo.dart';
import 'maplestory.dart';

class TodoInputWidget extends StatefulWidget {
  const TodoInputWidget({super.key});

  @override
  _TodoInputWidgetState createState() => _TodoInputWidgetState();
}

class _TodoInputWidgetState extends State<TodoInputWidget> {
  final TextEditingController _activityController = TextEditingController();
  final Map<String, dynamic> _initialTodo = {
    'type': null, // 게임, 다른 할일, ...
    'date': DateTime.now(),
    'kind': null, // 게임 종류 등 (메이플스토리 등)
    'activity': null, // (메이플스토리 내에서 할일)
    'plannedStartTime': null, // 할일 시작 예정 시간
    'actualStartTime': null, // 실제 할일 시작 시간
    'endTime': null, // 할일 마무리 시간
  };
  late Map<String, dynamic> _selected = _initialTodo;
  List<String> _otherKinds = [];
  String _otherKind = '';

  @override
  void didChangeDependencies() {
    final todoProvider = Provider.of<TodoProvider>(context);
    if (todoProvider.isEditMode && todoProvider.editingTodo != null) {
      _selected = {
        ...todoProvider.editingTodo!.toMap(),
      };
    }
    if (_selected['type'] == '게임' &&
        !['메이플스토리', '다른 게임'].contains(_selected['kind'])) {
      setState(() {
        _otherKinds = [..._otherKinds, _selected['kind']];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final todoProvider = Provider.of<TodoProvider>(context);
    Map<String, Widget> activityWidgets = {
      "메이플스토리": MaplestoryActivityWidget(
        selected: _selected,
        onChanged: (newSelected) {
          setState(() {
            _selected = newSelected;
          });
        },
        textController: _activityController,
      ),
      "다른 게임": Flexible(
        child: TextField(
          decoration: const InputDecoration(
            labelText: '다른 게임 이름',
          ),
          onChanged: (value) {
            setState(() {
              _otherKind = value;
            });
          },
        ),
      ),
    };
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 2.0),
      ),
      child: Column(
        children: [
          Column(
            children: [
              Row(children: [
                DropdownButton<String>(
                  value: _selected['type'],
                  items: ['게임', '다른 할일']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selected = {
                        ..._initialTodo,
                        'type': newValue,
                      };
                    });
                  },
                  hint: const Text("할일 종류 선택"),
                ),
                if (_selected['type'] == '게임') ...[
                  const SizedBox(
                    width: 16,
                  ),
                  DropdownButton<String>(
                    value: _selected['kind'] != null &&
                            ['메이플스토리', ..._otherKinds, '다른 게임']
                                .contains(_selected['kind'])
                        ? _selected['kind']
                        : null,
                    items: ['메이플스토리', ..._otherKinds, '다른 게임']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selected = {
                          ..._initialTodo,
                          'type': _selected['type'],
                          'kind': newValue,
                        };
                      });
                    },
                    hint: const Text("게임 종류 선택"),
                  ),
                ],
                if (_selected['type'] == '다른 할일')
                  SizedBox(
                    width: 200,
                    child: TextField(
                      decoration: const InputDecoration(
                        hintText: '할일 입력',
                      ),
                      onChanged: (newValue) {
                        setState(() {
                          _selected['kind'] = newValue;
                        });
                      },
                    ),
                  ),
              ]),
            ],
          ),
          if (_selected['type'] == '다른 할일' && _selected['kind'] != null ||
              _selected['type'] == '게임' && _selected['kind'] != null)
            Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (_selected['type'] == '게임')
                    activityWidgets[_selected['kind']]!
                  else if (_selected['type'] == '다른 할일')
                    const SizedBox(
                      width: 100,
                    ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.access_time),
                        onPressed: _selectPlannedStartTime,
                      ),
                      ElevatedButton(
                        onPressed: _handleAddTodo,
                        child: Text(todoProvider.isEditMode ? "Update" : "Add"),
                      ),
                    ],
                  ),
                ]),
        ],
      ),
    );
  }

  void _selectPlannedStartTime() async {
    TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (selectedTime != null) {
      DateTime now = DateTime.now();
      _selected['plannedStartTime'] = DateTime(
        now.year,
        now.month,
        now.day,
        selectedTime.hour,
        selectedTime.minute,
      ).toIso8601String();
    }
  }

  void _handleAddTodo() {
    TodoProvider todoProvider =
        Provider.of<TodoProvider>(context, listen: false);
    if (_selected['type'] != null) {
      final todoItem = TodoItem(
        id: todoProvider.isEditMode
            ? _selected['id'] // 수정 모드인 경우 기존 ID를 사용
            : DateTime.now().toIso8601String(),
        // 추가 모드인 경우 새 ID 생성
        type: _selected['type'],
        kind: _selected['kind'] != "다른 게임" ? _selected['kind'] : _otherKind,
        activity: _selected['activity'],
        addedTime: DateTime.now().toIso8601String(),
        plannedStartTime: _selected['plannedStartTime'],
      );
      if (_selected['kind'] == "다른 게임") {
        setState(() {
          _otherKinds = [..._otherKinds, _otherKind];
          print(_otherKinds);
          print(['메이플스토리', ..._otherKinds, '다른 게임']);
        });
      }
      if (todoProvider.isEditMode) {
        todoProvider.updateTodo(todoItem);
      } else {
        todoProvider.addTodo(todoItem);
      }

      _resetInputState();
    }
  }

  void _resetInputState() {
    setState(() {
      _selected = _initialTodo;
      _activityController.clear();
    });
  }
}
