import 'package:flutter/material.dart';

class myPageScreen extends StatelessWidget {
  const myPageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('myPage'),
      ),
      body: const Center(
        child: Text('myPage'),
      ),
    );
  }
}
