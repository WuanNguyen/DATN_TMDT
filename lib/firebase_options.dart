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
    apiKey: 'AIzaSyAPEP56w1FyMaKbQjzk9cfGSF9uB9LVqPQ',
    appId: '1:619220227129:web:be133156a0b19a1a68e9e8',
    messagingSenderId: '619220227129',
    projectId: 'datn-sporthuviz-bf24e',
    authDomain: 'datn-sporthuviz-bf24e.firebaseapp.com',
    databaseURL: 'https://datn-sporthuviz-bf24e-default-rtdb.firebaseio.com',
    storageBucket: 'datn-sporthuviz-bf24e.appspot.com',
    measurementId: 'G-D9P3SXFTL9',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDqt9PdIhKDcwOaTdjBxoFr-NCUeMza4y8',
    appId: '1:619220227129:android:e3cf48065db6223c68e9e8',
    messagingSenderId: '619220227129',
    projectId: 'datn-sporthuviz-bf24e',
    databaseURL: 'https://datn-sporthuviz-bf24e-default-rtdb.firebaseio.com',
    storageBucket: 'datn-sporthuviz-bf24e.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDfSAptFQ7EZFEjpQf1ATKU4rbQlinGB4c',
    appId: '1:619220227129:ios:4d9f1dbaf38751b768e9e8',
    messagingSenderId: '619220227129',
    projectId: 'datn-sporthuviz-bf24e',
    databaseURL: 'https://datn-sporthuviz-bf24e-default-rtdb.firebaseio.com',
    storageBucket: 'datn-sporthuviz-bf24e.appspot.com',
    iosBundleId: 'com.example.doanTmdt',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDfSAptFQ7EZFEjpQf1ATKU4rbQlinGB4c',
    appId: '1:619220227129:ios:4d9f1dbaf38751b768e9e8',
    messagingSenderId: '619220227129',
    projectId: 'datn-sporthuviz-bf24e',
    databaseURL: 'https://datn-sporthuviz-bf24e-default-rtdb.firebaseio.com',
    storageBucket: 'datn-sporthuviz-bf24e.appspot.com',
    iosBundleId: 'com.example.doanTmdt',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAPEP56w1FyMaKbQjzk9cfGSF9uB9LVqPQ',
    appId: '1:619220227129:web:2ea2f278446b773468e9e8',
    messagingSenderId: '619220227129',
    projectId: 'datn-sporthuviz-bf24e',
    authDomain: 'datn-sporthuviz-bf24e.firebaseapp.com',
    databaseURL: 'https://datn-sporthuviz-bf24e-default-rtdb.firebaseio.com',
    storageBucket: 'datn-sporthuviz-bf24e.appspot.com',
    measurementId: 'G-WQE8WXMFJC',
  );
}