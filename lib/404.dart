import 'package:flutter/material.dart';

class UnknownRouteWidget extends StatelessWidget {
  const UnknownRouteWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("404 Not found"),
      ),
    );
  }
}
