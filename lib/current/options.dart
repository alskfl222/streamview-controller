import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/websocket.dart';
import 'current_button.dart';

class Options extends StatefulWidget {
  const Options({
    super.key,
  });

  @override
  _OptionsState createState() => _OptionsState();
}

class _OptionsState extends State<Options> {
  final List<String> _mainGames = ['메이플스토리', 'DJMAX'];
  final List<String> _games = ['메이플스토리', 'DJMAX'];
  String? _selectedCurrent;
  DateTime _selectedDate = DateTime.now();
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
                  CurrentButton(option: "할일", onPressed: _onPressedTodo),
                  CurrentButton(option: "게임", onPressed: _onPressedGame),
                ],
              ),
            )),
        if (_selectedCurrent == "게임")
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
      _selectedCurrent = "할일";
    });
    _showDatePicker();
  }

  void _onPressedGame() {
    setState(() {
      _selectedCurrent = "게임";
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
    if (_selectedCurrent == "할일") {
      return true;
    }
    if (_selectedCurrent == "게임" &&
        (_mainGames.contains(_selectedGame) || _selectedGame != null)) {
      return true;
    }
    return false;
  }

  void _submitServer() {
    final WebSocketProvider webSocketProvider =
        Provider.of<WebSocketProvider>(context, listen: false);
    Map<String, dynamic> data = {
      'type': 'current',
      'option': {
        'select': _selectedCurrent,
        'date': _selectedDate.toIso8601String(),
        'game': _selectedGame,
      }
    };
    webSocketProvider.sendMessage(data);
    Navigator.pop(context);
  }
}
