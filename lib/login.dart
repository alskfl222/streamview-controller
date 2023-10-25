import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'provider/user.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscureText = true;
  String message = '';

  @override
  void initState() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    if (userProvider.status == Status.authenticated) {
      context.go('/');
    }
  }

  Future<void> _performLogin(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    String result = await userProvider.signIn(
        _emailController.text, _passwordController.text);
    setState(() {
      message = result;
    });
    if (result == '로그인 성공') {
      context.go('/');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("로그인"),
        ),
        body: Center(
            child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              SizedBox(
                  width: 360,
                  child: TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: "이메일",
                    ),
                  )),
              const SizedBox(height: 16),
              SizedBox(
                  width: 360,
                  child: TextField(
                    controller: _passwordController,
                    obscureText: _obscureText,
                    decoration: InputDecoration(
                      labelText: "비밀번호",
                      suffixIcon: IconButton(
                        // 추가한 부분
                        icon: Icon(
                          _obscureText
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                      ),
                    ),
                    onSubmitted: (value) => _performLogin(context),
                  )),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 회원 가입, 지금 필요 없음
                  // ElevatedButton(
                  //     onPressed: () async {
                  //       String result = await userProvider.signUp(
                  //           _emailController.text, _passwordController.text);
                  //       setState(() {
                  //         message = result;
                  //       });
                  //     },
                  //     child: const Padding(
                  //       padding: EdgeInsets.all(8),
                  //       child: Text('회원 가입',
                  //           style: TextStyle(
                  //             fontSize: 16,
                  //             fontWeight: FontWeight.bold,
                  //           )),
                  //     )),
                  // const SizedBox(width: 16),
                  ElevatedButton(
                      onPressed: () => _performLogin(context),
                      child: const Padding(
                        padding: EdgeInsets.all(8),
                        child: Text('로그인',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            )),
                      )),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                  width: 360,
                  child: Text(message,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.pinkAccent,
                      )))
            ],
          ),
        )));
  }
}
