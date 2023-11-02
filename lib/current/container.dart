import 'dart:convert';
import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:streamview_controller/provider/user.dart';
import 'package:streamview_controller/provider/current.dart';
import 'package:streamview_controller/util/constant.dart';
import 'options.dart';

class CurrentWidget extends StatefulWidget {
  const CurrentWidget({super.key});

  @override
  _CurrentWidgetState createState() => _CurrentWidgetState();
}

class _CurrentWidgetState extends State<CurrentWidget> {
  @override
  void initState() {
    fetchInitialData();
  }

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
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentData = Provider.of<CurrentDataProvider>(context);
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue, width: 2),
                  borderRadius: BorderRadius.circular(8.0),
                  color: MaterialStateColor.resolveWith((states) {
                    if (states.contains(MaterialState.hovered)) {
                      return Colors.blue;
                    }
                    if (states.contains(MaterialState.pressed) ||
                        states.contains(MaterialState.selected)) {
                      return Colors.red;
                    }
                    return Colors.transparent;
                  })),
              child: GestureDetector(
                onTap: _showOptionsModal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      currentData.currentDisplay != null
                          ? translated[currentData.currentDisplay]!
                          : "없음",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (currentData.currentDisplay == "todo")
                      Text(
                        DateFormat('y년 M월 d일').format(currentData.selectedDate),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    if (currentData.currentDisplay == "game")
                      Text(
                        currentData.selectedGame ?? "그냥 게임",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.visibility),
            onPressed: _launchViewer,
          )
        ],
      ),
    );
  }

  void _showOptionsModal() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Options(),
        );
      },
    );
  }

  Future<void> _launchViewer() async {
    final UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    final uid = userProvider.user!.uid;
    html.window.open('/view?uid=$uid', '_blank', 'popup');
  }
}
