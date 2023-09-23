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
    apiKey: 'AIzaSyCX3MFROooLtHbcjXwVAK0z7iBHQGmRK04',
    appId: '1:803642138589:web:bd9cdbfbce91c2124f2034',
    messagingSenderId: '803642138589',
    projectId: 'stream-fb',
    authDomain: 'stream-fb.firebaseapp.com',
    storageBucket: 'stream-fb.appspot.com',
    measurementId: 'G-G09F404P1R',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC1Nj0FBqQBv_wxbetSWUdQ3LWuCOGTvLo',
    appId: '1:803642138589:android:ebdbdc52f55042d34f2034',
    messagingSenderId: '803642138589',
    projectId: 'stream-fb',
    storageBucket: 'stream-fb.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBOhyqm_VK6Cek7Ve-Itd-fDX0p4zPTReY',
    appId: '1:803642138589:ios:e9ea6871e403a9314f2034',
    messagingSenderId: '803642138589',
    projectId: 'stream-fb',
    storageBucket: 'stream-fb.appspot.com',
    iosBundleId: 'com.example.streamviewController',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBOhyqm_VK6Cek7Ve-Itd-fDX0p4zPTReY',
    appId: '1:803642138589:ios:8d5cbe06b97ad17f4f2034',
    messagingSenderId: '803642138589',
    projectId: 'stream-fb',
    storageBucket: 'stream-fb.appspot.com',
    iosBundleId: 'com.example.streamviewController.RunnerTests',
  );
}
