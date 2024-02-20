// //======== 서버 연결까지 시도 해본 코드 =====//
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:god/screens/platform.dart';
import 'package:god/screens/returnScore.dart';
// import 'package:path_provider/path_provider.dart';
// 서버로 제일 최근 녹화된 영상 업로드 하여 엔드포인트 처리 하기 위한 임포트
import 'package:http/http.dart' as http;
import 'dart:convert';

// 파일 넘버 저장을 위한 패키지
// import 'package:path/path.dart';

class StreamingScreen extends StatefulWidget {
  const StreamingScreen({super.key});

  @override
  _StreamingScreenState createState() => _StreamingScreenState();
}

class _StreamingScreenState extends State<StreamingScreen> {
  CameraController? _cameraController;
  Future<void>? _initializeControllerFuture;
  List<CameraDescription> cameras = [];
  int selectedCameraIndex = 0;

  int _countdownSeconds = 2;
  late Timer _countdownTimer;
  bool _isGifPlaying = false;
  bool _isRecording = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    cameras = await availableCameras();
    if (cameras.isNotEmpty) {
      _cameraController = CameraController(
        cameras[selectedCameraIndex],
        ResolutionPreset.medium,
      );
      _initializeControllerFuture = _cameraController!.initialize();
    } else {
      print('No available cameras found.');
    }
  }

  void _startCountdown() {
    setState(() {
      _countdownSeconds = 3;
    });
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdownSeconds > 0) {
        setState(() {
          _countdownSeconds--;
        });
      } else {
        _countdownTimer.cancel();
        // 카운트다운이 끝나면 녹화 시작과 GIF 재생을 시작합니다.
        startRecording(); // 녹화 시작
        resetGifPlayback(); // GIF 애니메이션을 처음부터 재생
      }
    });
  }

  // 약간의 딜레이를 주고 GIF 애니메이션을 다시 시작합니다.
  Key? _gifKey;

  void resetGifPlayback() {
    setState(() {
      _isGifPlaying = false;
    });

    Future.delayed(Duration(milliseconds: 10), () {
      setState(() {
        _gifKey = UniqueKey(); // 새로운 Key 생성
        _isGifPlaying = true;
      });
    });
  }

  // GIF 길이 42초만큼 재생되다가 자동으로 저장되게 설정
  void _startGifPlayback() {
    setState(() {
      _isGifPlaying = true; // 윤곽선 영상 자체가 시작을 안함
    });
    // GIF 애니메이션 재생 시간 (42초) 후에 자동으로 녹화를 저장
    Future.delayed(Duration(seconds: 42), () {
      setState(() {
        _isGifPlaying = false; // 이를 통해 애니메이션을 화면에서 제거하거나 숨깁니다.
      });
      // 멘토링17
      if (_isRecording) {
        stopRecording();
      } else {}
    });
  }

  // startRecording 사용 부분 체크, 멘토링17
  Future<void> startRecording() async {
    // 카메라 컨트롤러가 초기화되었고, 현재 녹화 중이 아닐 때 녹화를 시작합니다.

    if (_cameraController != null &&
        !_cameraController!.value.isRecordingVideo) {
      await _cameraController!.startVideoRecording();
      setState(() {
        _isRecording = true;
        _isGifPlaying = true; // GIF 재생을 시작합니다.
      });
      _startGifPlayback(); // GIF 재생 시간을 관리하고 녹화를 자동으로 멈춥니다.
    }
  }

  Future<void> stopRecording() async {
    final CameraController? cameraController = _cameraController;
    if (cameraController == null || !cameraController.value.isRecordingVideo) {
      return; // 녹화 중이 아니면 함수 종료
    }

    try {
      // 녹화 중지 및 파일 객체 얻기
      // 이 라인에서 임시 파일 비디오 파일 버퍼를 추출해서 받아서 서버로 전달
      XFile? videoFile = await cameraController.stopVideoRecording();

      // MethodChannel을 통해 네이티브 메소드 호출
      // Native Platform device path : Recording has ended. Saved file path: content://media/external/video/media/1000002425
      final String? savedFilePath =
          await NativeMethods.saveVideoToGallery(videoFile.path);

      if (savedFilePath != null) {
        print('Recording has ended. Saved file path: $savedFilePath');
        uploadFileToServer(context, videoFile.path);
      } else {
        print('Error saving video through native code');
      }
    } catch (e) {
      print("Error stopping recording: $e");
    } finally {
      setState(() {
        _isRecording = false;
        _isGifPlaying = false; // GIF 애니메이션 멈춤
      });
    }
  }

  // 결과 화면으로 전환하는 함수 포함 멘토링17 : 엔드포인트 새로 정의
  // upload.dart의 서버 통신 함수 활용
  Future<void> uploadFileToServer(BuildContext context, String filePath) async {
    // fileToUpload > filePath
    final uri = Uri.parse('http://192.168.219.100:8024/stream_and_evaluate');
    final request = http.MultipartRequest('POST', uri)
      // 멀터에서 파일 처리할 때 폼 데이터 & 버퍼 형식으로 보내기 (둘다 속도 비교 해보기)
      ..files.add(await http.MultipartFile.fromPath(
        'file',
        filePath, // .path를 지우고 파일 path만 넣어주기
      ));

    final response = await request.send();

    if (response.statusCode == 200) {
      final responseData = await http.Response.fromStream(response);
      final result = jsonDecode(responseData.body);
      print("Server response: $result");

      // 서버로부터 점수 받아서 처리
      double score = result['average_score'];
      print(score);
      // 결과 화면으로 전환
      if (mounted) {
        navigateToResultScreen(context, score);
      }
    } else {
      print('File upload failed: ${response.reasonPhrase}');
    }
  }

  // 결과 화면으로 전환하는 함수
  void navigateToResultScreen(BuildContext context, double score) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            returnScreen(score: score), // 여기서 ReturnScreen은 결과를 표시하는 화면의 위젯
      ),
    );
  }

  Widget buildStopRecordingButton() {
    return Positioned(
      bottom: 20,
      left: 0,
      right: 0,
      child: Center(
        child: ElevatedButton(
          onPressed: stopRecording,
          child: const Text('Stop Recording and Save'),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Evaluation'),
      ),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Stack(
              alignment: Alignment.center,
              children: <Widget>[
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: CameraPreview(
                      _cameraController!), // Display camera preview
                ),
                if (_isGifPlaying)
                  Positioned(
                    bottom: 0,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: FittedBox(
                        fit: BoxFit.cover,
                        child: Image.asset("assets/images/canny01.gif"),
                        key: _gifKey, // 여기에 Key 적용, 윤곽선 영상 처음부터 강제 재생하게 키 설정
                      ),
                    ),
                  ),
                if (_countdownSeconds > 0)
                  Positioned(
                    child: Text(
                      '$_countdownSeconds',
                      style: TextStyle(
                          fontSize: 200,
                          color: Colors.blue,
                          fontFamily: 'Honk'),
                    ),
                  ),
                // Text(_isRecording
                //     .toString()), // _isRecording True 값 되게 확인 필요 멘토링17
                if (_isRecording) buildStopRecordingButton(),
              ],
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              _startCountdown(); // 카운트 시작 함수 안에 윤곽선 영상 처음부터 재생 포함
            },
            heroTag: 'startCountdown',
            child: const Icon(Icons.video_call),
          ),
          SizedBox(height: 20),
          FloatingActionButton(
            onPressed: switchCamera,
            heroTag: 'switchCamera',
            child: const Icon(Icons.switch_camera),
          ),
        ],
      ),
    );
  }

  Future<void> switchCamera() async {
    if (cameras.length > 1) {
      selectedCameraIndex = (selectedCameraIndex + 1) % cameras.length;
      _cameraController = CameraController(
        cameras[selectedCameraIndex],
        ResolutionPreset.medium,
      );
      _initializeControllerFuture = _cameraController!.initialize().then((_) {
        setState(() {});
      });
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _countdownTimer.cancel();
    super.dispose();
  }
}
