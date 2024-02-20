// import 'dart:async';
// // import 'dart:io';
// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';
// // import 'package:path/path.dart' as path;
// // import 'package:path_provider/path_provider.dart';
// import 'package:http/http.dart' as http;

// class StreamingScreen extends StatefulWidget {
//   const StreamingScreen({Key? key}) : super(key: key);

//   @override
//   _StreamingScreenState createState() => _StreamingScreenState();
// }

// class _StreamingScreenState extends State<StreamingScreen> {
//   CameraController? _cameraController;
//   Future<void>? _initializeControllerFuture;
//   bool _isRecording = false; // _isRecording을 변경 가능한 변수로 만듭니다.

//   @override
//   void initState() {
//     super.initState();
//     _initializeCamera();
//   }

//   Future<void> _initializeCamera() async {
//     final cameras = await availableCameras();
//     if (cameras.isNotEmpty) {
//       // 사용 가능한 카메라가 있을 때 초기화 로직 실행
//       final firstCamera = cameras.first;
//       _cameraController = CameraController(
//         firstCamera,
//         ResolutionPreset.medium,
//       );
//       _initializeControllerFuture = _cameraController!.initialize();
//     } else {
//       // 사용 가능한 카메라가 없을 경우 사용자에게 알림
//       print('No available cameras found.');
//       // 에러 처리 또는 사용자에게 메시지 표시 등의 추가적인 조치를 취할 수 있습니다.
//     }
//   }

//   Future<void> _toggleRecording() async {
//     if (_isRecording) {
//       await _stopRecording();
//     } else {
//       await _startRecording();
//     }
//   }

//   Future<void> _startRecording() async {
//     await _initializeControllerFuture; // 카메라 컨트롤러가 초기화될 때까지 기다립니다.
//     try {
//       await _cameraController!.startVideoRecording();
//       setState(() {
//         _isRecording = true;
//       });
//     } catch (e) {
//       // 오류 처리
//       print(e);
//     }
//   }

//   Future<void> _stopRecording() async {
//     try {
//       final videoFile = await _cameraController!.stopVideoRecording();
//       final String filePath = videoFile.path;
//       setState(() {
//         _isRecording = false;
//       });
//       await _sendVideoToServer(filePath); // 녹화를 중지하고 파일을 서버로 업로드합니다.
//     } catch (e) {
//       // 오류 처리
//       print(e);
//     }
//   }

//   Future<void> _sendVideoToServer(String filePath) async {
//     var uri = Uri.parse('http://127.0.0.1:8023/upload_and_evaluate');
//     var request = http.MultipartRequest('POST', uri)
//       ..files.add(await http.MultipartFile.fromPath('file', filePath));
//     var response = await request.send();

//     if (response.statusCode == 200) {
//       print('Video uploaded successfully');
//       // 여기서 평가 결과를 받아 처리할 수 있습니다.
//     } else {
//       print('Video upload failed');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Video Recorder')),
//       body: FutureBuilder<void>(
//         future: _initializeControllerFuture,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.done) {
//             return CameraPreview(_cameraController!);
//           } else {
//             return const Center(child: CircularProgressIndicator());
//           }
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _toggleRecording,
//         child: Icon(_isRecording ? Icons.stop : Icons.videocam),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _cameraController?.dispose();
//     super.dispose();
//   }
// }



// // import 'dart:async';
// // import 'package:god/screens/video.dart';
// // import 'package:flutter/material.dart';
// // import 'package:camera/camera.dart';
// // import 'package:image_gallery_saver/image_gallery_saver.dart';
// // import 'package:video_player/video_player.dart';

// // class StreamingScreen extends StatefulWidget {
// //   const StreamingScreen({Key? key}) : super(key: key);

// //   @override
// //   _StreamingScreenState createState() => _StreamingScreenState();
// // }

// // class _StreamingScreenState extends State<StreamingScreen> {
// //   late CameraController _cameraController;
// //   // 추후 어디서 사용할지 확인 필요
// //   // late List<CameraDescription> _cameras;
// //   late VideoPlayerController _videoController;
// //   bool _isRecording = false;
// //   bool _isLoading = true;
// //   int _countdown = 5;

// //   @override
// //   void initState() {
// //     super.initState();
// //     _initializeCamera();
// //     _initializeVideo();
// //   }

// //   Future<void> _initializeVideo() async {
// //     _videoController = VideoPlayerController.asset(
// //       '/Users/hyunwoo/Desktop/god/god/assets/video/canny_sample.mp4',
// //     );
// //     await _videoController.initialize();
// //     _videoController.setLooping(true);
// //   }

// //   // 추후에 _togleRecording 변수 정의 고려
// //   Future<void> _toggleRecording() async {
// //     if (_isRecording) {
// //       await _cameraController.stopVideoRecording();
// //       // 녹화된 영상 save path
// //       await ImageGallerySaver.saveFile(
// //           '/Users/hyunwoo/Desktop/god/inference/flutter_inference/streaming_record');
// //     } else {
// //       await _cameraController.startVideoRecording();
// //       // Start playing the video when recording starts
// //       _videoController.play();
// //     }
// //     _isRecording = !_isRecording;
// //     setState(() {});
// //   }

// //   @override
// //   void dispose() {
// //     _cameraController.dispose();
// //     _videoController.dispose();
// //     super.dispose();
// //   }

// //   _initializeCamera() async {
// //     final cameras = await availableCameras();
// //     final front = cameras.firstWhere(
// //         (camera) => camera.lensDirection == CameraLensDirection.front);
// //     _cameraController = CameraController(front, ResolutionPreset.max);
// //     _cameraController = CameraController(cameras[0], ResolutionPreset.medium);
// //     await _cameraController.initialize();
// //     setState(() => _isLoading = false);
// //   }

// //   _recordVideo() async {
// //     if (_isRecording) {
// //       // 'file' 변수에 할당할 파일이 저장되면 사용할 예정
// //       // final file = await _cameraController.stopVideoRecording();
// //       setState(() => _isRecording = false);
// //       final route = MaterialPageRoute(
// //         fullscreenDialog: true,
// //         builder: (_) => const VideoPage(
// //             // 이 부분 저장 시 파일명 겹치지 않게 수정 필요
// //             filePath:
// //                 '/Users/hyunwoo/Desktop/god/inference/flutter_inference/streaming_record'),
// //       );
// //       Navigator.push(context, route);
// //     } else {
// //       await _cameraController.prepareForVideoRecording();
// //       // Start the countdown before starting recording
// //       _startCountdown();
// //     }
// //   }

// //   void _startCountdown() {
// //     Timer.periodic(const Duration(seconds: 1), (timer) {
// //       if (_countdown > 0) {
// //         setState(() {
// //           _countdown--;
// //         });
// //       } else {
// //         timer.cancel();
// //         // Start recording after countdown ends
// //         _cameraController.startVideoRecording();
// //         _isRecording = true;
// //         // Start playing the video when recording starts
// //         _videoController.play();
// //       }
// //     });
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     if (_isLoading) {
// //       return Container(
// //         color: Colors.white,
// //         child: const Center(
// //           child: CircularProgressIndicator(),
// //         ),
// //       );
// //     } else {
// //       return Center(
// //         child: Stack(
// //           alignment: Alignment.bottomCenter,
// //           children: [
// //             CameraPreview(_cameraController),
// //             if (_isRecording)
// //               Positioned(
// //                 bottom: 10,
// //                 child: Text(
// //                   '$_countdown',
// //                   style: const TextStyle(
// //                     fontSize: 48,
// //                     color: Colors.white,
// //                     fontWeight: FontWeight.bold,
// //                   ),
// //                 ),
// //               ),
// //             if (_isRecording)
// //               Positioned.fill(
// //                 child: AspectRatio(
// //                   aspectRatio: _videoController.value.aspectRatio,
// //                   child: VideoPlayer(_videoController),
// //                 ),
// //               ),
// //             Padding(
// //               padding: const EdgeInsets.all(25),
// //               child: FloatingActionButton(
// //                 backgroundColor: Colors.red,
// //                 child: Icon(_isRecording ? Icons.stop : Icons.circle),
// //                 onPressed: () => _recordVideo(),
// //               ),
// //             ),
// //           ],
// //         ),
// //       );
// //     }
// //   }
// // }
