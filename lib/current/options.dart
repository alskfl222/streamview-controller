import 'package:flutter/material.dart';

class Options extends StatefulWidget {
  final String? currentDisplay;
  final Function(String?) onCurrentChange;
  final Function(DateTime) onDateSelected;
  final Function(String?) onGameSelected;
  final Function() onCloseOptions;

  const Options({
    super.key,
    required this.currentDisplay,
    required this.onCurrentChange,
    required this.onDateSelected,
    required this.onGameSelected,
    required this.onCloseOptions,
  });

  @override
  _OptionsState createState() => _OptionsState();
}

class _OptionsState extends State<Options> {
  String? _selectedCurrent;
  DateTime _selectedDate = DateTime.now();
  String? _selectedGame;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _selectedCurrent = "할일";
                    });
                    _showDatePicker();
                  },
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                        const EdgeInsets.all(12.0)),
                  ),
                  child: Text("할일"),
                ),
                Text("게임")
              ],
            )),
        if (_checkValidation()) ...[
          const SizedBox(height: 12),
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              // 확인 로직
              widget.onCurrentChange(_selectedCurrent);
              widget.onDateSelected(_selectedDate);
              widget.onCloseOptions();
            },
          ),
        ]
      ],
    );
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

  bool _checkValidation() {
    if (_selectedCurrent == "할일") {
      return true;
    }
    return false;
  }
}

// } else if (widget.currentDisplay == "게임") {
// return DropdownButton<String>(
// value: _selectedGame,
// items: ['메이플스토리', 'DJMAX']
//     .map<DropdownMenuItem<String>>((String value) {
// return DropdownMenuItem<String>(
// value: value,
// child: Text(value),
// );
// }).toList(),
// onChanged: (String? newValue) {
// setState(() {
// _selectedGame = newValue;
// });
// widget.onGameSelected(_selectedGame);
// },
// );
// } else {
// return const SizedBox.shrink();
// }
// )
