import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'provider/user.dart';
import 'provider/current.dart';
import 'package:streamview_controller/main.dart';
import 'current/container.dart';
import 'todo/container.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  int _selectedTabIndex = 0;
  final List<Widget> _tabs = [const CurrentTab(), const TodoList()];

  Future<void> fetchInitialData() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final currentProvider =
        Provider.of<CurrentDataProvider>(context, listen: false);
    User? user = userProvider.user;
    final serverUrl = dotenv.env['SERVER_URL']!;
    if (serverUrl == null) {
      print('SERVER_URL is not defined in env file.');
      return;
    }
    if (user != null) {
      final token = await user.getIdToken();
      final response = await http.get(
        Uri.parse('$serverUrl/controller'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        print('Server response: ${response.body}');
        dynamic current = jsonDecode(response.body)["current"];
        currentProvider.setCurrentDisplay(current['display']);
        currentProvider.setSelectedDate(DateTime.tryParse(current['date'])!);
        currentProvider.setSelectedGame(current['game']);
      } else {
        print(
            'Failed to fetch initial data. Status code: ${response.statusCode}');
      }
    } else {
      print('No user is signed in.');
    }
  }

  @override
  void initState() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    if (userProvider.status != Status.authenticated) {
      context
          .read<StreamViewRouterDelegate>()
          .setNewRoutePath(StreamViewRoute.landing());
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
              context
                  .read<StreamViewRouterDelegate>()
                  .setNewRoutePath(StreamViewRoute.login());
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
