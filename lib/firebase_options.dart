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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyCVQdBSzXli1WoeD9F6yVfmF8R2LBDVgm8',
    appId: '1:464096832516:web:505ba75a36ebb1f71d1951',
    messagingSenderId: '464096832516',
    projectId: 'presence-61332',
    authDomain: 'presence-61332.firebaseapp.com',
    storageBucket: 'presence-61332.appspot.com',
    measurementId: 'G-46SDEDJP9B',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCUJqkvN_yKIWO6joZEWZJm7j49kdyIcHo',
    appId: '1:464096832516:android:2c9c137c91bdf1e21d1951',
    messagingSenderId: '464096832516',
    projectId: 'presence-61332',
    storageBucket: 'presence-61332.appspot.com',
  );
}
