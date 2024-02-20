// play.dart
import 'package:flutter/material.dart';
import 'package:god/screens/streaming.dart';
import 'package:god/screens/upload.dart';

class PlayScreen extends StatelessWidget {
  const PlayScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Play'),
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/loginBackground.jpg'), // 경로 수정
                fit: BoxFit.cover, // 배경 이미지가 전체를 채우도록 조정
              ),
            ),
          ),
          Center(
            // Center 위젯을 사용하여 버튼들을 화면 중앙에 배치
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const UploadScreen()),
                    );
                  },
                  child: const Text('Upload Mode'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const StreamingScreen()),
                    );
                  },
                  child: const Text('Stream Mode'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const StreamingScreen()),
                    );
                  },
                  child: const Text('Avator Mode'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// 내꺼
// // play.dart
// import 'package:flutter/material.dart';
// import 'package:god/screens/streaming.dart';
// import 'package:god/screens/upload.dart';

// class PlayScreen extends StatelessWidget {
//   const PlayScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Play'),
//       ),
//       body: Stack(
//         children: [
//           Container(
//             decoration: const BoxDecoration(
//               image: DecorationImage(
//                 image: AssetImage('assets/images/loginBackground.jpg'), // 경로 수정
//                 fit: BoxFit.cover, // 배경 이미지가 전체를 채우도록 조정
//               ),
//             ),
//           ),
//           Center(
//             // Center 위젯을 사용하여 버튼들을 화면 중앙에 배치
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 ElevatedButton(
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) => const UploadScreen()),
//                     );
//                   },
//                   child: const Text('Upload Mode'),
//                 ),
//                 const SizedBox(height: 20),
//                 ElevatedButton(
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) => const StreamingScreen()),
//                     );
//                   },
//                   child: const Text('Stream Mode'),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
