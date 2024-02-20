// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBlM0VRfIdcswVbJKOrTBr1vbLFHJlyGQ4',
    appId: '1:820999029161:web:01629838647d03ab0dc4b8',
    messagingSenderId: '820999029161',
    projectId: 'go-dance-up-4d67b',
    authDomain: 'go-dance-up-4d67b.firebaseapp.com',
    storageBucket: 'go-dance-up-4d67b.appspot.com',
    measurementId: 'G-STERZKW61R',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAdkh7h4LAnznmMlLCzxHXYSlWuYN3Ij6U',
    appId: '1:820999029161:android:911639c6f64dd37d0dc4b8',
    messagingSenderId: '820999029161',
    projectId: 'go-dance-up-4d67b',
    storageBucket: 'go-dance-up-4d67b.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAPgMXvdhoVE1pQAL7ndvLjCgIGBDjZrns',
    appId: '1:820999029161:ios:339b8b8647e67ba30dc4b8',
    messagingSenderId: '820999029161',
    projectId: 'go-dance-up-4d67b',
    storageBucket: 'go-dance-up-4d67b.appspot.com',
    iosBundleId: 'com.example.app',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAPgMXvdhoVE1pQAL7ndvLjCgIGBDjZrns',
    appId: '1:820999029161:ios:cc497fd6149a698d0dc4b8',
    messagingSenderId: '820999029161',
    projectId: 'go-dance-up-4d67b',
    storageBucket: 'go-dance-up-4d67b.appspot.com',
    iosBundleId: 'com.example.app.RunnerTests',
  );
}
