import 'package:god/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:god/view/auth/login.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/homeBackground.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 130,
                ),
                const Text(
                  'G.O.D : \n Go dance up',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color.fromARGB(255, 83, 83, 83),
                    fontSize: 80,
                    fontWeight: FontWeight.bold,
                    height: 1.0,
                    fontFamily: 'Honk',
                  ),
                ),
                const SizedBox(
                  height: 180,
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: const Color(0xff656366),
                    border: Border.all(color: Colors.black),
                  ),
                  child: const Text(
                    'Click the button below to play!',
                    style: TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontSize: 18,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                IconButton(
                  icon: const Icon(
                    Icons.play_arrow,
                    color: Color.fromARGB(255, 255, 230, 0),
                  ),
                  iconSize: 80,
                  onPressed: () {
                    // 플레이 버튼을 누를 때 로그인 화면으로 이동
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginPage(),
                      ),
                    ).then((result) {
                      // 로그인 화면에서 로그인 성공 시 result가 true로 반환됨
                      if (result == true) {
                        // 업로드 화면으로 이동
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HomeScreen(),
                          ),
                        );
                      }
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
