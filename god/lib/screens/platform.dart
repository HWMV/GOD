// 네이티브 플랫폼을 쓰기 위한 함수 정의

import 'package:flutter/services.dart';

class NativeMethods {
  static const MethodChannel _channel =
      MethodChannel('com.example.app/media_store');

  static Future<String?> saveVideoToGallery(String videoPath) async {
    try {
      final String? filePath =
          await _channel.invokeMethod('saveVideo', {'videoPath': videoPath});
      return filePath;
    } on PlatformException catch (e) {
      print("Failed to save video: '${e.message}'.");
      return null;
    }
  }
}
