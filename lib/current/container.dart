import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'options.dart';

class CurrentTab extends StatefulWidget {
  @override
  _CurrentTabState createState() => _CurrentTabState();
}

class _CurrentTabState extends State<CurrentTab> {
  String? _currentDisplay;
  DateTime _selectedDate = DateTime.now();
  String? _selectedGame;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
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
                      _currentDisplay ?? "선택 없음",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (_currentDisplay == "할일")
                      Text(
                        DateFormat('y년 M월 d일').format(_selectedDate),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    if (_currentDisplay == "게임")
                      Text(
                        _selectedGame!,
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
          child: Options(
            currentDisplay: _currentDisplay,
            onCurrentChange: _onCurrentChange,
            onDateSelected: _onDateSelected,
            onGameSelected: _onGameSelected,
          ),
        );
      },
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
