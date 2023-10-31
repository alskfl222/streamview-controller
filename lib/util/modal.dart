import 'package:flutter/material.dart';

void showModal(BuildContext context, String title, String content) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return WillPopScope(
        onWillPop: () async {
          if (title == 'Success') {
            Navigator.of(context).popUntil((route) => route.isFirst);
            return true;
          }
          return true;
        },
        child: AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
                if (title == 'Success') {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                }
              },
            ),
          ],
        ),
      );
    },
  );
}
