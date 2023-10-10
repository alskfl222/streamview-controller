import 'package:flutter/material.dart';

class CurrentButton extends StatelessWidget {
  final String option;
  final VoidCallback onPressed;
  final EdgeInsetsGeometry padding;

  const CurrentButton({
    super.key,
    required this.option,
    required this.onPressed,
    this.padding = const EdgeInsets.all(12.0),
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(padding),
      ),
      child: Text(option),
    );
  }
}
