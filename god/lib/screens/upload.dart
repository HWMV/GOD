import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'returnScore.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});

  @override
  _UploadScreenState createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  Future<void> uploadFile(BuildContext context) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();
      if (result != null) {
        File file = File(result.files.single.path!);
        var request = http.MultipartRequest('POST',
            Uri.parse('http://192.168.219.100:8024/upload_and_evaluate'));
        request.files.add(await http.MultipartFile.fromPath('file', file.path));

        var streamedResponse = await request.send();
        var response = await http.Response.fromStream(streamedResponse);

        if (response.statusCode == 200) {
          print('업로드 성공');
          final responseData = json.decode(response.body);
          double score = responseData['average_score'];

          if (mounted) {
            navigateToResultScreen(context, score);
          }
        } else {
          print('업로드 실패: ${response.statusCode}');
        }
      } else {
        print('파일 선택 취소');
      }
    } catch (e) {
      print('업로드 중 예외 발생: $e');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff656366),
        title: const Center(
          child: Text('Upload video',
              style: TextStyle(
                fontFamily: AutofillHints.addressCity,
                color: Color(0xffFFFFFF),
              )),
        ),
      ),
      body: Stack(
        children: [
          // 배경 이미지 추가
          Positioned.fill(
            child: Image.asset(
              'assets/images/uploadBackground.jpg', // 배경 이미지 경로
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    uploadFile(context);
                  },
                  child: const Text(
                    'Upload',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
