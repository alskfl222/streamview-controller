import 'package:flutter/material.dart';

class ViewerPage extends StatelessWidget {
  final String? uid;

  const ViewerPage({Key? key, this.uid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text(uid ?? "no uid")),
    );
  }
}
