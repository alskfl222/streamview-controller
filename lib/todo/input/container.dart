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
  DateTime selectedDate = DateTime.now();
  String? _selectedTaskType;
  String? _selectedGame;
  String? _selectedActivity;
  String? _selectedCharacter;
  String? plannedStartTime;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            children: [
              DropdownButton<String>(
                value: _selectedTaskType,
                items: ['게임', '다른 할 일']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedTaskType = newValue;
                    _selectedGame = null;
                    _selectedActivity = null;
                  });
                },
                hint: const Text("할 일 종류 선택"),
              ),
              if (_selectedTaskType == '게임') ...[
                const SizedBox(
                  width: 16,
                ),
                DropdownButton<String>(
                  value: _selectedGame,
                  items: ['메이플스토리', '다른 게임']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedGame = newValue;
                      _selectedActivity = null;
                    });
                  },
                  hint: const Text("게임 종류 선택"),
                ),
              ],
              if (_selectedGame == '메이플스토리') ...[
                const SizedBox(
                  width: 16,
                ),
                DropdownButton<String>(
                  value: _selectedActivity,
                  items: ['사냥', '보스', '기타']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedActivity = newValue;
                    });
                  },
                  hint: const Text("메이플 활동 선택"),
                ),
                DropdownButton<String>(
                  value: _selectedCharacter,
                  items: ['a', 'b', 'c']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedCharacter = newValue;
                    });
                  },
                  hint: const Text("캐릭터 선택"),
                ),
                if (_selectedActivity == '기타')
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
      plannedStartTime = DateTime(
        now.year,
        now.month,
        now.day,
        selectedTime.hour,
        selectedTime.minute,
      ).toIso8601String();
    }
  }

  void _resetInputState() {
    _selectedTaskType = null;
    _selectedGame = null;
    _selectedActivity = null;
    _selectedCharacter = null;
    _textController.clear();
    plannedStartTime = null;
  }

  void _handleAddTodo() {
    TodoProvider todoProvider =
        Provider.of<TodoProvider>(context, listen: false);
    if (_selectedTaskType != null) {
      final todoItem = TodoItem(
        id: DateTime.now().toIso8601String(),
        taskType: _selectedTaskType!,
        game: _selectedGame ?? "",
        activity: _selectedActivity ?? "",
        character: _selectedCharacter ?? "",
        description: _textController.text,
        addedTime: DateTime.now().toIso8601String(),
        plannedStartTime: plannedStartTime,
      );
      todoProvider.addTodo(todoItem);
      _resetInputState();
    }
  }
}
