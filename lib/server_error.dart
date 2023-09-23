import 'package:flutter/material.dart';

class ServerErrorPage extends StatelessWidget {
  final String errorMessage;

  const ServerErrorPage({Key? key, required this.errorMessage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("서버 오류"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 54.0,
            ),
            const SizedBox(height: 16.0),
            const Text(
              "서버 연결에 문제가 발생했습니다.",
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12.0),
            Text(
              errorMessage,
              style: const TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.w500,
                color: Colors.deepOrangeAccent,
              ),
            ),
            const SizedBox(height: 16.0),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  // 다시 메인 화면으로 돌아가기 또는 웹소켓 연결 재시도 로직 구현
                  Navigator.of(context).pop();
                },
                child: const Text("다시 시도"),
              ),
            ),
            const SizedBox(height: 12.0),
            TextButton(
              onPressed: () {
                // 도움말 페이지나 지원 센터로 이동하는 로직 구현
              },
              child: Text("도움말"),
            )
          ],
        ),
      ),
    );
  }
}