import 'package:flutter/material.dart';

class Options extends StatefulWidget {
  final String? currentDisplay;
  final Function(String?) onCurrentChange;
  final Function(DateTime) onDateSelected;
  final Function(String?) onGameSelected;

  const Options({
    super.key,
    required this.currentDisplay,
    required this.onCurrentChange,
    required this.onDateSelected,
    required this.onGameSelected,
  });

  @override
  _OptionsState createState() => _OptionsState();
}

class _OptionsState extends State<Options> {
  String? _selectedCurrent;
  String? _selectedGame;
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Flexible(
      fit: FlexFit.loose,
      child: Row(
        children: [
          Text("할 일"),
          Text("게임")
        ],
      )
    // if (widget.currentDisplay == "할일") {
    //   return CalendarDatePicker(
    //     initialDate: DateTime.now(),
    //     firstDate: DateTime(DateTime.now().year - 1),
    //     lastDate: DateTime(DateTime.now().year + 1),
    //     onDateChanged: (date) {
    //       setState(() {
    //         _selectedDate = date;
    //       });
    //       widget.onDateSelected(_selectedDate);
    //     },
    //   );
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
    );
  }
}

