import 'package:flutter/material.dart';

class CurrentDataProvider with ChangeNotifier {
  String? _currentDisplay;
  DateTime _selectedDate =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  String? _selectedGame;

  String? get currentDisplay => _currentDisplay;

  DateTime get selectedDate => _selectedDate;

  String? get selectedGame => _selectedGame;

  void setCurrentDisplay(String? display) {
    _currentDisplay = display;
    notifyListeners();
  }

  void setSelectedDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  void setSelectedGame(String? game) {
    _selectedGame = game;
    notifyListeners();
  }
}
