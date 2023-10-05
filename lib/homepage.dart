import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:streamview_controller/todo/container.dart';
import 'user.dart';
import 'current/container.dart';

class MyHomePage extends StatelessWidget {
  final String title;
  final Function(Map<String, dynamic>) sendMessage;

  const MyHomePage({
    super.key,
    required this.title,
    required this.sendMessage,
  });

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    String userName =
        userProvider.user != null ? userProvider.user!.email!.split("@")[0] : '누군가';
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Text(title),
              const SizedBox(width: 10),
              Text(
                userName,
                style: const TextStyle(
                  fontSize: 10,
                ),
              ),
            ],
          ),
          actions: [
            IconButton(
              onPressed: () async {
                userProvider.signOut();
              },
              icon: const Icon(Icons.logout),
            )
          ],
          bottom: const TabBar(
            tabs: [
              Tab(text: "현재"),
              Tab(text: "할 일"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            CurrentTab(),
            const TodoList(),
          ],
        ),
      ),
    );
  }
}
