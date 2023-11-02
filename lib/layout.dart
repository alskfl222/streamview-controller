import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'provider/user.dart';

class Layout extends StatelessWidget {
  final Widget child;

  const Layout({Key? key, required this.child}) : super(key: key);

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
                context.go('/');
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('할일'),
              onTap: () {
                context.go('/todo');
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: child,
    );
  }
}
