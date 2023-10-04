import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'user.dart';

class TodoItem {
  final String id;
  final String description;
  final String type; // '사냥', '보스', '기타'
  final String? character; // 'a', 'b', 'c' 또는 null (임시)
  final DateTime addedTime;
  DateTime? plannedStartTime;
  DateTime? actualStartTime;

  TodoItem({
    required this.id,
    required this.description,
    required this.type,
    required this.addedTime,
    this.character,
    this.plannedStartTime,
    this.actualStartTime,
  });
}

class TodoList extends StatefulWidget {
  const TodoList({super.key});

  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  final List<TodoItem> _todos = [];
  final TextEditingController _textController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  String? _selectedType;
  String? _selectedCharacter;
  DateTime? plannedStartTime;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    var userProvider = Provider.of<UserProvider>(context, listen: false);
    if (userProvider.status != Status.authenticated) {
      Navigator.pushReplacementNamed(context, '/');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('할 일')),
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
                        "${selectedDate.toLocal()}".split(' ')[0], // 현재 날짜를 표시
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.calendar_today),
                      onPressed: () async {
                        final DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: selectedDate,
                          firstDate: DateTime.now(),
                          lastDate:
                              DateTime.now().add(const Duration(days: 365)),
                        );
                        if (pickedDate != null && pickedDate != selectedDate) {
                          setState(() {
                            selectedDate = pickedDate;
                          });
                        }
                      },
                    ),
                  ],
                ),
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
                          print(newValue);
                          _selectedType = newValue;
                          _selectedCharacter = null; // 타입 변경 시 캐릭터 선택도 초기화
                        });
                      },
                      hint: Text("종류 선택"),
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
                        hint: Text("캐릭터 선택"),
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
                        _handleSubmitted();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
              child: ReorderableListView(
            buildDefaultDragHandles: false,
            onReorder: _onReorder,
            children: _todos.map((todo) {
              return ReorderableDelayedDragStartListener(
                key: ValueKey(todo.id),
                index: _todos.indexOf(todo),
                child: ListTileTheme(
                  contentPadding: EdgeInsets.zero,
                  child: ExpansionTile(
                    tilePadding: const EdgeInsets.all(16.0),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8.0),
                        Text("종류: ${todo.type}"),
                        if (todo.type == "사냥" || todo.type == "보스")
                          Text("캐릭터: ${todo.character}"),
                        if (todo.type == "기타")
                          Text("기타: ${todo.description}"),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            // 수정 로직
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.check),
                          onPressed: () {
                            // 확인 로직
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            // 삭제 로직
                          },
                        ),
                      ],
                    ),
                    children: [
                      ListTile(
                        title: Text('Added Time: ${todo.addedTime}'),
                      ),
                      if (todo.plannedStartTime != null)
                        ListTile(
                          title: Text(
                              'Planned Start Time: ${todo.plannedStartTime}'),
                        ),
                      if (todo.actualStartTime != null)
                        ListTile(
                          title: Text(
                              'Actual Start Time: ${todo.actualStartTime}'),
                        ),
                    ],
                  ),
                ),
              );
            }).toList(),
          )),
          ElevatedButton(
            onPressed: _sendToServer,
            child: const Text("Save"),
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

  void _handleSubmitted() {
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
        _todos.add(todoItem);
        plannedStartTime = null;
      });
      _textController.clear();
    }
  }

  void _onReorder(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    setState(() {
      final item = _todos.removeAt(oldIndex);
      _todos.insert(newIndex, item);
    });
  }

  void _sendToServer() {
    // 서버로 데이터를 보내는 로직을 구현해야 합니다.
    // 현재는 단순히 콘솔에 출력만 하도록 했습니다.
    print("Sending data to server: $_todos");
  }
}
