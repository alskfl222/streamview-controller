import 'package:flutter/material.dart';

class MaplestoryActivityWidget extends StatefulWidget {
  final Map<String, dynamic> selected;
  final ValueChanged<Map<String, dynamic>> onChanged;
  final TextEditingController textController;

  const MaplestoryActivityWidget({
    required this.selected,
    required this.onChanged,
    required this.textController,
    Key? key,
  }) : super(key: key);

  @override
  _MaplestoryActivityWidgetState createState() =>
      _MaplestoryActivityWidgetState();
}

class _MaplestoryActivityWidgetState extends State<MaplestoryActivityWidget> {
  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> activity = widget.selected['activity'] ?? {};
    String? activityName = activity['name'];
    String? characterName = activity['character'];

    return Flexible(
      child: Row(
        children: [
          // 첫 번째 DropdownButton 구성
          DropdownButton<String>(
            value: activityName,
            items: ['사냥', '보스', '기타']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _updateActivity('name', newValue); // activity의 'name'을 업데이트합니다.
              });
            },
            hint: const Text("활동 선택"),
          ),

          // 두 번째 DropdownButton에 대한 변경
          if (activity.isNotEmpty) // activity가 비어있지 않다면 Dropdown을 표시합니다.
            DropdownButton<String>(
              value: characterName,
              items:
                  ['a', 'b', 'c'].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _updateActivity(
                      'character', newValue); // 선택된 character를 업데이트합니다.
                });
              },
              hint: const Text("캐릭터 선택"),
            ),
          // '기타'가 선택되었을 때만 TextField를 표시
          if (activityName == '기타')
            Container(
              width: 160,
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: TextField(
                controller: widget.textController,
                onChanged: (newValue) {
                  // TextField가 변경될 때마다 상태를 업데이트합니다.
                  _updateActivity('description', newValue);
                },
                decoration: const InputDecoration(
                  labelText: "설명 입력",
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _updateActivity(String key, dynamic value) {
    Map<String, dynamic> newActivity =
        Map<String, dynamic>.from(widget.selected['activity'] ?? {})
          ..[key] = value;

    widget.onChanged({...widget.selected, 'activity': newActivity});
  }
}
