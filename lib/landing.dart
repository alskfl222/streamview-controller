import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'provider/user.dart';
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

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

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
              context.go('/login');
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
                Navigator.pop(context);
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
