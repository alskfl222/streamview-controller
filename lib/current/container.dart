import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:streamview_controller/provider/user.dart';
import 'package:streamview_controller/provider/current.dart';
import 'package:streamview_controller/util.dart';
import 'options.dart';

class CurrentTab extends StatefulWidget {
  const CurrentTab({super.key});

  @override
  _CurrentTabState createState() => _CurrentTabState();
}

class _CurrentTabState extends State<CurrentTab> {
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
                      currentData.currentDisplay != null ?
                          translated[currentData.currentDisplay]! : "없음",
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
                        currentData.selectedGame!,
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
    final UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
    final uid = userProvider.user!.uid;
    html.window.open('/view?uid=$uid', '_blank', 'popup');
  }
}
