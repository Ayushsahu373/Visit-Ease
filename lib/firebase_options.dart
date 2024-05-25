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
    apiKey: 'AIzaSyCSTUqxMaIuGpI_2SmQBhlazRl95ziGqAI',
    appId: '1:148637454651:web:c94f435db50357a89d271e',
    messagingSenderId: '148637454651',
    projectId: 'visit-ease',
    authDomain: 'visit-ease.firebaseapp.com',
    storageBucket: 'visit-ease.appspot.com',
    measurementId: 'G-VJNYZJB1Z2',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCXKp0ChSpkBDuvCr_OZX1A9vpT1yHawCg',
    appId: '1:148637454651:android:cbeeafae805529fe9d271e',
    messagingSenderId: '148637454651',
    projectId: 'visit-ease',
    storageBucket: 'visit-ease.appspot.com',
  );
}
