import 'package:flutter/material.dart';
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
          GestureDetector(
            onTap: () {
              setState(() {
                _isOptionsVisible = !_isOptionsVisible;
              });
            },
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Text(_currentDisplay ?? "화면 없음"),
            ),
          ),
          if (_isOptionsVisible)
            Options(
              currentDisplay: _currentDisplay,
              onCurrentChange: _onCurrentChange,
              onDateSelected: _onDateSelected,
              onGameSelected: _onGameSelected,
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
}
