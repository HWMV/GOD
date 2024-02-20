// login.dart

import 'package:god/screens/home.dart';
import 'package:god/service/auth.service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
// 사용자 정보를 저장하는 함수
  void saveUserInfo(String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('user_email', email);
  }
/*
// 앱 시작 시에 저장된 사용자 정보를 확인하여 자동 로그인
  void checkAutoLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userEmail = prefs.getString('user_email');

    if (userEmail != null && userEmail.isNotEmpty) {
      // 저장된 이메일 정보가 있으면 자동으로 로그인 처리
      // 로그인 후에는 HomeScreen으로 이동
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ),
      );
    }
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Login'),
        foregroundColor: Colors.white,
        backgroundColor: const Color(0xFF656366),
      ),
      body: Stack(
        children: [
          // 배경 이미지 추가
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/loginBackground.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 이메일 필드 박스
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white, // 흰색 배경
                    borderRadius: BorderRadius.circular(20), // 테두리 모서리 둥글게
                  ),
                  child: TextFormField(
                    controller: _emailController,
                    style: const TextStyle(color: Colors.black), // 텍스트 색상 변경
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: InputBorder.none, // 텍스트 필드의 기본 테두리 제거
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                // 비밀번호 필드 박스
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white, // 흰색 배경
                    borderRadius: BorderRadius.circular(20), // 테두리 모서리 둥글게
                  ),
                  child: TextFormField(
                    controller: _passwordController,
                    style: const TextStyle(color: Colors.black), // 텍스트 색상 변경
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      border: InputBorder.none, // 텍스트 필드의 기본 테두리 제거
                    ),
                    obscureText: true,
                  ),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () async {
                    bool loginSuccess = await loginWithEmailAndPassword(
                      _auth,
                      _emailController.text,
                      _passwordController.text,
                    );

                    if (loginSuccess) {
                      // 로그인 성공 시 사용자 정보를 저장
                      saveUserInfo(_emailController.text);

                      // 로그인 성공 시 HomeScreen으로 이동
                      // ignore: use_build_context_synchronously
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomeScreen(),
                        ),
                      );
                    } else {
                      // 로그인 실패 시 추가적인 처리
                      // 예: 에러 메시지 표시 등
                    }
                  },
                  child: const Text(
                    'Login',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/register');
                  },
                  child: const Text('Register'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
