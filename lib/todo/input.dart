import 'package:flutter/material.dart';
import 'container.dart';

class TodoInputWidget extends StatefulWidget {
  final Function(TodoItem) onAddTodo;

  const TodoInputWidget({super.key, required this.onAddTodo});

  @override
  _TodoInputWidgetState createState() => _TodoInputWidgetState();
}

class _TodoInputWidgetState extends State<TodoInputWidget> {
  final TextEditingController _textController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  String? _selectedType;
  String? _selectedCharacter;
  DateTime? plannedStartTime;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            children: [
              DropdownButton<String>(
                value: _selectedType,
                items: ['사냥', '보스', '기타']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedType = newValue;
                    _selectedCharacter = null; // 타입 변경 시 캐릭터 선택도 초기화
                  });
                },
                hint: const Text("종류 선택"),
              ),
              if (_selectedType == '사냥' || _selectedType == '보스')
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
                )
              else if (_selectedType == '기타')
                SizedBox(
                  width: 200,
                  child: TextField(
                    controller: _textController,
                    decoration: const InputDecoration(
                      labelText: "기타 내용을 입력하세요",
                    ),
                  ),
                ),
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
      );
    }
  }

  void _handleAddTodo() {
    if (_selectedType != null) {
      final todoItem = TodoItem(
        id: DateTime.now().toString(),
        type: _selectedType!,
        character: _selectedCharacter ?? "",
        description: _textController.text,
        addedTime: DateTime.now(),
        plannedStartTime: plannedStartTime,
      );
      setState(() {
        widget.onAddTodo(todoItem);
        plannedStartTime = null;
      });
      _textController.clear();
    }
  }
// ... (다른 메서드와 로직들도 이곳에 복사)
}
