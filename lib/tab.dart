import 'package:flutter/material.dart';

class TabContent extends StatelessWidget {
  final Function(String, Map<String, dynamic>) sendMessage;
  final String tabName;

  const TabContent(
      {super.key, required this.sendMessage, required this.tabName});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 각 탭에 따른 버튼 및 로직 추가...
        ElevatedButton(
          onPressed: () => sendMessage(tabName, {"option": "Option 1"}),
          child: Container(
            width: 100,
            height: 100,
            child: Center(child: Text("Option 1")),
          ),
        ),
        SizedBox(height: 15),
        ElevatedButton(
          onPressed: () => sendMessage(tabName, {"option": "Option 2"}),
          child: Container(
            width: 100,
            height: 100,
            child: Center(child: Text("Option 2")),
          ),
        ),
        SizedBox(height: 15),
        ElevatedButton(
          onPressed: () => sendMessage(tabName, {"option": "Option 3"}),
          child: Container(
            width: 100,
            height: 100,
            child: Center(child: Text("Option 3")),
          ),
        ),
      ],
    );
  }
}
