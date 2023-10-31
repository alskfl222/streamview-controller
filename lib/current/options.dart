import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../provider/user.dart';
import 'current_button.dart';
import '../util/modal.dart';

class Options extends StatefulWidget {
  const Options({super.key});

  @override
  _OptionsState createState() => _OptionsState();
}

class _OptionsState extends State<Options> {
  final List<String> _mainGames = ['메이플스토리', 'DJMAX'];
  final List<String> _games = ['메이플스토리', 'DJMAX'];
  String? _selectedCurrent;
  DateTime _selectedDate =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  String? _selectedGame;
  final TextEditingController _gameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Wrap(
                spacing: 12.0, // 버튼 간의 가로 간격
                runSpacing: 8.0, // 버튼 간의 세로 간격
                children: [
                  CurrentButton(option: "todo", onPressed: _onPressedTodo),
                  CurrentButton(option: "game", onPressed: _onPressedGame),
                ],
              ),
            )),
        if (_selectedCurrent == "game")
          Row(
            children: [
              Flexible(
                flex: 2,
                child: DropdownButton<String>(
                  value: _selectedGame,
                  items: _games.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedGame = newValue;
                    });
                  },
                ),
              ),
              const SizedBox(width: 12),
              Flexible(
                flex: 3,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: TextField(
                          controller: _gameController,
                          decoration: const InputDecoration(
                            hintText: "게임 이름 입력",
                          ),
                          onSubmitted: _onGameSubmitted),
                    ),
                    const SizedBox(width: 8.0), // 텍스트 필드와 버튼 사이의 간격
                    IconButton(
                      onPressed: () {
                        final String value = _gameController.text;
                        _onGameSubmitted(value);
                      },
                      icon: const Icon(Icons.add),
                    ),
                  ],
                ),
              )
            ],
          ),
        if (_checkValidation()) ...[
          const SizedBox(height: 12),
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _submitServer,
          ),
        ]
      ],
    );
  }

  void _onPressedTodo() {
    setState(() {
      _selectedCurrent = "todo";
    });
    _showDatePicker();
  }

  void _onPressedGame() {
    setState(() {
      _selectedCurrent = "game";
    });
  }

  void _showDatePicker() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(DateTime.now().year - 1),
      lastDate: DateTime(DateTime.now().year + 1),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  void _onGameSubmitted(String value) {
    setState(() {
      if (!_games.contains(value)) {
        _games.add(value);
      }
      _selectedGame = value;
    });
    _gameController.clear();
  }

  bool _checkValidation() {
    if (_selectedCurrent == "todo") {
      return true;
    }
    if (_selectedCurrent == "game" &&
        (_mainGames.contains(_selectedGame) || _selectedGame != null)) {
      return true;
    }
    return false;
  }

  void _submitServer() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    User? user = userProvider.user;
    if (user == null) {
      print('No user is signed in.');
      return;
    }
    final token = await user.getIdToken();

    final currentData = {
      'current': {
        'display': _selectedCurrent,
        'date': _selectedDate.toIso8601String(),
      },
    };

    final serverUrl = dotenv.env['SERVER_URL']!;
    if (serverUrl == null) {
      print('SERVER_URL is not defined in env file.');
      return;
    }
    final postResponse = await http.post(
      Uri.parse('$serverUrl/controller/current'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(currentData),
    );

    if (postResponse.statusCode == 200) {
      print('Data posted successfully: ${postResponse.body}');
      showModal(context, 'Success', 'Data posted successfully.');
    } else {
      print('Failed to post data. Status code: ${postResponse.statusCode}');
      showModal(context, 'Error', 'Failed to post data. Status code: ${postResponse.statusCode}');
    }
  }



}
