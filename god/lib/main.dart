// 파이어베이스를 이용한 flutter 진입점
import 'package:god/screens/loading.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

//login ID: wanana042@gmail.com
//login Password: wanana042

void main() async {
  // Firebase 초기화
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'G.O.D: Go Dance Up',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: const LoadingScreen(),
    );
  }
}
