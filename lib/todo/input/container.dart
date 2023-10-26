import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/todo.dart';

class TodoInputWidget extends StatefulWidget {
  const TodoInputWidget({super.key});

  @override
  _TodoInputWidgetState createState() => _TodoInputWidgetState();
}

class _TodoInputWidgetState extends State<TodoInputWidget> {
  final TextEditingController _textController = TextEditingController();
  final Map<String, dynamic> _initialTodo = {
    'type': null, // 게임, 다른 할일, ...
    'date': DateTime.now(),
    'kind': null, // 게임 종류 등 (메이플스토리 등)
    'activity': null, // (메이플스토리 내에서 할일)
    'plannedStartTime': null, // 할일 시작 예정 시간
    'actualStartTime': null, // 실제 할일 시작 시간
    'endTime': null, // 할일 마무리 시간
    'description': '', // 할일 전체적 설명
  };
  late Map<String, dynamic> _selected = _initialTodo;

  @override
  Widget build(BuildContext context) {
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
                  items: ['게임', '다른 할 일']
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
                  hint: const Text("할 일 종류 선택"),
                ),
                if (_selected['type'] == '게임') ...[
                  const SizedBox(
                    width: 16,
                  ),
                  DropdownButton<String>(
                    value: _selected['kind'],
                    items: ['메이플스토리', '다른 게임']
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
              ]),
            ],
          ),
          if (_selected['kind'] != '')
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Row(children: [
                if (_selected['kind'] == '메이플스토리') ...[
                  DropdownButton<String>(
                    value: _selected['activity'] != null
                        ? _selected['activity']['name']
                        : null,
                    items: ['사냥', '보스', '기타']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        if (_selected['activity'] != null) {
                          _selected['activity']['name'] = newValue;
                        } else {
                          _selected['activity'] = {
                            'name': newValue,
                          };
                        }
                      });
                    },
                    hint: const Text("활동 선택"),
                  ),
                  if (_selected['activity'] != null)
                    DropdownButton<String>(
                      value: _selected['activity'] != null
                          ? _selected['activity']['character']
                          : null,
                      items: ['a', 'b', 'c']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selected['activity']['character'] = newValue;
                        });
                      },
                      hint: const Text("캐릭터 선택"),
                    ),
                  if (_selected['activity'] != null &&
                      _selected['activity']['name'] == '기타')
                    SizedBox(
                      width: 200,
                      child: TextField(
                        controller: _textController,
                        decoration: const InputDecoration(
                          labelText: "설명 입력",
                        ),
                      ),
                    ),
                ],
              ]),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.access_time),
                    onPressed: _selectPlannedStartTime,
                  ),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      _handleAddTodo();
                    },
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

  void _resetInputState() {
    _selected = _initialTodo;
  }

  void _handleAddTodo() {
    TodoProvider todoProvider =
        Provider.of<TodoProvider>(context, listen: false);
    if (_selected['type'] != null) {
      final todoItem = TodoItem(
        id: DateTime.now().toIso8601String(),
        type: _selected['type'],
        kind: _selected['kind'],
        activity: _selected['activity'],
        addedTime: DateTime.now().toIso8601String(),
        plannedStartTime: _selected['plannedStartTime'],
        description: '',
      );
      todoProvider.addTodo(todoItem);
      _resetInputState();
    }
  }
}
