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
    return Flexible(
      child: Row(
        children: [
          DropdownButton<String>(
            value: widget.selected['activity'] != null
                ? widget.selected['activity']['name']
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
                if (widget.selected['activity'] != null) {
                  widget.selected['activity']['name'] = newValue;
                } else {
                  widget.selected['activity'] = {
                    'name': newValue,
                  };
                }
                widget.onChanged(widget.selected);
              });
            },
            hint: const Text("활동 선택"),
          ),
          if (widget.selected['activity'] != null)
            DropdownButton<String>(
              value: widget.selected['activity'] != null
                  ? widget.selected['activity']['character']
                  : null,
              items:
                  ['a', 'b', 'c'].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  widget.selected['activity']['character'] = newValue;
                  widget.onChanged(widget.selected);
                });
              },
              hint: const Text("캐릭터 선택"),
            ),
          if (widget.selected['activity'] != null &&
              widget.selected['activity']['name'] == '기타')
            Container(
              width: 160,
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: TextField(
                controller: widget.textController,
                decoration: const InputDecoration(
                  labelText: "설명 입력",
                ),
              ),
            ),
        ],
      ),
    );
  }
}
