import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../provider/current.dart';
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
                      currentData.currentDisplay ?? "선택 없음",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (currentData.currentDisplay == "할일")
                      Text(
                        DateFormat('y년 M월 d일').format(currentData.selectedDate),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    if (currentData.currentDisplay == "게임")
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
    final fullUrl = Uri.base.resolveUri(Uri(path: '/viewer'));

    if (!await launchUrl(fullUrl)) {
      throw Exception('Could not launch $fullUrl');
    }
  }
}
