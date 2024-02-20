import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:async';

class PracticeScreen extends StatefulWidget {
  const PracticeScreen({Key? key}) : super(key: key);

  @override
  _PracticeScreenState createState() => _PracticeScreenState();
}

class _PracticeScreenState extends State<PracticeScreen> {
  late CameraController _cameraController;
  Future<void>? _initializeControllerFuture;
  List<CameraDescription> cameras = [];
  int selectedCameraIndex = 0;

  bool _isGifPlaying = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  // 카메라 초기화 메서드
  Future<void> _initializeCamera() async {
    cameras = await availableCameras();
    if (cameras.isNotEmpty) {
      _cameraController = CameraController(
        cameras[selectedCameraIndex],
        ResolutionPreset.medium,
      );
      _initializeControllerFuture = _cameraController.initialize();
      setState(() {});
    } else {
      print('No available cameras found.');
    }
  }

  // 카메라 화면을 빌드하는 메서드
  Widget _buildCameraPreview() {
    if (!_cameraController.value.isInitialized) {
      return Container();
    }
    return Center(
      child: AspectRatio(
        aspectRatio: _cameraController.value.aspectRatio,
        child: CameraPreview(_cameraController),
      ),
    );
  }

  Key? _gifKey;

  // GIF 재생 버튼을 누를 때 호출되는 메서드
  void _toggleGifPlayback() {
    setState(() {
      _isGifPlaying = !_isGifPlaying; // 재생/일시정지 토글
      _gifKey = UniqueKey();
    });

    // Start, Stop GifPlayback 설정해서 유니크 키 사용하면 컨트롤 가능
    //(영상 한바퀴 후 무작위 재생 방지)
    // GIF 애니메이션 재생 시간 (42초) 후에 자동으로 녹화를 저장
    Future.delayed(Duration(seconds: 42), () {
      setState(() {
        _isGifPlaying = false; // 이를 통해 애니메이션을 화면에서 제거하거나 숨깁니다.
      });
      // 멘토링17
    });
  }

  // 카메라 전환 버튼을 누를 때 호출되는 메서드
  Future<void> _switchCamera() async {
    if (cameras.length > 1) {
      selectedCameraIndex = (selectedCameraIndex + 1) % cameras.length;
      await _cameraController.dispose();
      _cameraController = CameraController(
        cameras[selectedCameraIndex],
        ResolutionPreset.medium,
      );
      _initializeControllerFuture = _cameraController.initialize();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('연습 모드'),
      ),
      body: Stack(
        children: <Widget>[
          // 실시간 웹캠 이미지 표시
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: CameraPreview(_cameraController), // Display camera preview
          ),
          // GIF 재생 오버레이
          if (_isGifPlaying)
            Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: Image.asset("assets/images/canny01.gif"),
                  key: _gifKey,
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(height: 16),
          FloatingActionButton(
            onPressed: _switchCamera, // 카메라 전환 버튼
            child: const Icon(Icons.playlist_add_sharp),
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            onPressed: _toggleGifPlayback, // GIF 재생/일시정지 버튼
            child: Icon(_isGifPlaying
                ? Icons.pause
                : Icons.play_arrow), // 상태에 따라 아이콘 변경
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            onPressed: _switchCamera, // 카메라 전환 버튼
            child: const Icon(Icons.switch_camera),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }
}

// import 'package:flutter/material.dart';
// import 'package:video_player/video_player.dart';
// import 'package:camera/camera.dart';

// class PracticeScreen extends StatefulWidget {
//   const PracticeScreen({Key? key}) : super(key: key);

//   @override
//   _PracticeScreenState createState() => _PracticeScreenState();
// }

// class _PracticeScreenState extends State<PracticeScreen> {
//   late CameraController _cameraController;
//   late VideoPlayerController _videoPlayerController;

//   bool _isPracticeMode = true;

//   @override
//   void initState() {
//     super.initState();
//     _initializeCamera();
//     _initializeVideoPlayer(); // 비디오 플레이어 초기화 추가
//   }

//   // 카메라 초기화 메서드
//   Future<void> _initializeCamera() async {
//     final cameras = await availableCameras();
//     _cameraController = CameraController(cameras[0], ResolutionPreset.medium);
//     await _cameraController.initialize();
//     if (mounted) {
//       setState(() {});
//     }
//   }

//   // 비디오 플레이어 초기화 메서드
//   Future<void> _initializeVideoPlayer() async {
//     _videoPlayerController = VideoPlayerController.asset(
//         '/Users/hyunwoo/Desktop/god/god/assets/video/origin_sample.mp4');
//     await _videoPlayerController.initialize();
//     if (mounted) {
//       setState(() {});
//     }
//   }

//   // 카메라 화면을 빌드하는 메서드
//   Widget _buildCameraPreview() {
//     if (!_cameraController.value.isInitialized) {
//       return Container();
//     }
//     return AspectRatio(
//       aspectRatio: _cameraController.value.aspectRatio,
//       child: CameraPreview(_cameraController),
//     );
//   }

//   // 비디오 플레이어를 빌드하는 메서드
//   Widget _buildVideoPlayer() {
//     if (!_videoPlayerController.value.isInitialized) {
//       return Container();
//     }
//     return AspectRatio(
//       aspectRatio: _videoPlayerController.value.aspectRatio,
//       child: VideoPlayer(_videoPlayerController),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Practice'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             _isPracticeMode ? _buildCameraPreview() : Container(),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 if (_isPracticeMode) {
//                   // 카메라 모드에서 사용자의 영상을 촬영하거나 다른 작업 수행
//                 } else {
//                   // 비디오 플레이어 모드에서 재생/일시정지 토글
//                   if (_videoPlayerController.value.isPlaying) {
//                     _videoPlayerController.pause();
//                   } else {
//                     _videoPlayerController.play();
//                   }
//                 }
//               },
//               child: Text(_isPracticeMode ? 'Start Recording' : 'Play/Pause'),
//             ),
//             const SizedBox(height: 20),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 ElevatedButton(
//                   onPressed: () {
//                     // 배속 조절 로직 추가
//                   },
//                   child: const Text('Adjust Speed'),
//                 ),
//                 const SizedBox(width: 20),
//                 ElevatedButton(
//                   onPressed: () {
//                     // 구간반복 설정 로직 추가
//                   },
//                   child: const Text('Set Loop Range'),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 20),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 ElevatedButton(
//                   onPressed: () {
//                     setState(() {
//                       _isPracticeMode = true;
//                     });
//                   },
//                   child: const Text('Practice Mode'),
//                 ),
//                 const SizedBox(width: 20),
//                 ElevatedButton(
//                   onPressed: () {
//                     setState(() {
//                       _isPracticeMode = false;
//                       //_initializeVideoPlayer(); // 비디오 플레이어 초기화
//                     });
//                   },
//                   child: const Text('Evaluation Mode'),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _cameraController.dispose();
//     _videoPlayerController.dispose();
//     super.dispose();
//   }
// }
