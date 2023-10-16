import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'todo/container.dart';
import 'provider/user.dart';
import 'current/container.dart';

class MyHomePage extends StatefulWidget {
  final String title;

  const MyHomePage({
    super.key,
    required this.title,
  });

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedTabIndex = 0; // 현재 선택된 탭의 인덱스

  // 위젯 배열로 관리
  final List<Widget> _tabs = [const CurrentTab(), const TodoList()];

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    String userName = userProvider.user != null
        ? userProvider.user!.email!.split("@")[0]
        : '누군가';

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(widget.title),
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
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const SizedBox(
              height: 84,
              child: DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
                child: Text('메뉴'),
              ),
            ),
            ListTile(
              title: const Text('현재'),
              onTap: () {
                setState(() {
                  _selectedTabIndex = 0;
                });
                Navigator.pop(context); // 햄버거 메뉴 닫기
              },
            ),
            ListTile(
              title: const Text('할일'),
              onTap: () {
                setState(() {
                  _selectedTabIndex = 1;
                });
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: _tabs[_selectedTabIndex],
    );
  }
}
