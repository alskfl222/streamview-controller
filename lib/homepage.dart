import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'todo/container.dart';
import 'provider/user.dart';
import 'current/container.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedTabIndex = 0;
  final List<Widget> _tabs = [const CurrentTab(), const TodoList()];

  Future<void> fetchInitialData() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    User? user = userProvider.user;

    if (user != null) {
      final token = await user.getIdToken();

      final response = await http.get(
        Uri.parse('http://localhost:5005/controller'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        print('Server response: ${response.body}');
      } else {
        print('Failed to fetch initial data. Status code: ${response.statusCode}');
      }
    } else {
      print('No user is signed in.');
    }
  }

  @override
  void initState() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    if (userProvider.status != Status.authenticated) {
      SchedulerBinding.instance!.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, '/login');
      });
    }
    fetchInitialData();
  }

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
            const Text("StreamView Controller"),
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
              await userProvider.signOut();
              if (!context.mounted) {
                return;
              }
              Navigator.pushNamed(context, '/login');
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
