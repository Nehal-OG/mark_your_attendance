// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
        return windows;
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
    apiKey: 'AIzaSyCvpNJEGhnvF5gjLJQRxKs4NhNhrnUH2X0',
    appId: '1:1080501875654:web:806e3c9cd02927b130f8c7',
    messagingSenderId: '1080501875654',
    projectId: 'mark-your-attendance-e2e43',
    authDomain: 'mark-your-attendance-e2e43.firebaseapp.com',
    storageBucket: 'mark-your-attendance-e2e43.firebasestorage.app',
    measurementId: 'G-PN1ZFRRFZG',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDwcr4Sn1NgQKMvfJhk_nIXmx6GwDQoXaQ',
    appId: '1:1080501875654:android:5910e27f2716f96c30f8c7',
    messagingSenderId: '1080501875654',
    projectId: 'mark-your-attendance-e2e43',
    storageBucket: 'mark-your-attendance-e2e43.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCGYYPUkdsgyP3Fk9MnU2xoQH1exMHbEzE',
    appId: '1:1080501875654:ios:b1008e29c801618930f8c7',
    messagingSenderId: '1080501875654',
    projectId: 'mark-your-attendance-e2e43',
    storageBucket: 'mark-your-attendance-e2e43.firebasestorage.app',
    iosBundleId: 'com.example.markYourAttendance',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCGYYPUkdsgyP3Fk9MnU2xoQH1exMHbEzE',
    appId: '1:1080501875654:ios:b1008e29c801618930f8c7',
    messagingSenderId: '1080501875654',
    projectId: 'mark-your-attendance-e2e43',
    storageBucket: 'mark-your-attendance-e2e43.firebasestorage.app',
    iosBundleId: 'com.example.markYourAttendance',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCvpNJEGhnvF5gjLJQRxKs4NhNhrnUH2X0',
    appId: '1:1080501875654:web:a4be260492f0253c30f8c7',
    messagingSenderId: '1080501875654',
    projectId: 'mark-your-attendance-e2e43',
    authDomain: 'mark-your-attendance-e2e43.firebaseapp.com',
    storageBucket: 'mark-your-attendance-e2e43.firebasestorage.app',
    measurementId: 'G-2DNPHKVMZM',
  );
}
