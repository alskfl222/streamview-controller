import 'package:flutter/material.dart';
import 'tab.dart';

class MyHomePage extends StatelessWidget {
  final String title;
  final Function(String, Map<String, dynamic>) sendMessage;

  const MyHomePage({
    super.key,
    required this.title,
    required this.sendMessage,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(title),
          bottom: const TabBar(
            tabs: [
              Tab(text: "현재"),
              Tab(text: "변화"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            TabContent(sendMessage: sendMessage, tabName: "Tab 1"),
            TabContent(sendMessage: sendMessage, tabName: "Tab 2"),
          ],
        ),
      ),
    );
  }
}

