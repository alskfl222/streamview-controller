import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'options.dart';

class CurrentTab extends StatefulWidget {
  @override
  _CurrentTabState createState() => _CurrentTabState();
}

class _CurrentTabState extends State<CurrentTab> {
  bool _isOptionsVisible = false;
  String? _currentDisplay;
  DateTime _selectedDate = DateTime.now();
  String? _selectedGame;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Text(
                  _currentDisplay ?? "선택 없음",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  width: 12,
                ),
                Text(
                  DateFormat('y년 M월 d일').format(_selectedDate),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _isOptionsVisible = !_isOptionsVisible;
                });
              },
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(_currentDisplay ?? "화면 없음"),
                  ),
                ],
              ),
            ),
          ),
          if (_isOptionsVisible)
            Options(
              currentDisplay: _currentDisplay,
              onCurrentChange: _onCurrentChange,
              onDateSelected: _onDateSelected,
              onGameSelected: _onGameSelected,
              onCloseOptions: _onCloseOptions,
            ),
        ],
      ),
    );
  }

  void _onCurrentChange(String? selectCurrentDisplay) {
    setState(() {
      _currentDisplay = selectCurrentDisplay;
    });
  }

  void _onDateSelected(DateTime selectedDate) {
    setState(() {
      _selectedDate = selectedDate;
    });
  }

  void _onGameSelected(String? selectedGame) {
    setState(() {
      _selectedGame = selectedGame;
    });
  }

  void _onCloseOptions() {
    setState(() {
      _isOptionsVisible = false;
    });
  }
}
