// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options_dev.dart';
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
    apiKey: 'AIzaSyDHzP3kNU2FkKEeEymYHS_wcyAkw2GNqTM',
    appId: '1:859865604977:web:624437c122b91fbfaf0cd0',
    messagingSenderId: '859865604977',
    projectId: 'futsallink-project',
    authDomain: 'futsallink-project.firebaseapp.com',
    storageBucket: 'futsallink-project.firebasestorage.app',
    measurementId: 'G-V4P447SL53',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDkUL3X_O2jjFYZvBeD-YTdwU9j_IcSxVA',
    appId: '1:859865604977:android:a2ccc7c7a73ecdaeaf0cd0',
    messagingSenderId: '859865604977',
    projectId: 'futsallink-project',
    storageBucket: 'futsallink-project.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyA6nKEguTopxZw1s3TY9SPxcuz-2YZZHoc',
    appId: '1:859865604977:ios:6185b9893cef83fdaf0cd0',
    messagingSenderId: '859865604977',
    projectId: 'futsallink-project',
    storageBucket: 'futsallink-project.firebasestorage.app',
    iosBundleId: 'com.futsallink.club.dev',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyA6nKEguTopxZw1s3TY9SPxcuz-2YZZHoc',
    appId: '1:859865604977:ios:ac56c5187ed6b877af0cd0',
    messagingSenderId: '859865604977',
    projectId: 'futsallink-project',
    storageBucket: 'futsallink-project.firebasestorage.app',
    iosBundleId: 'com.project.futsallinkClub',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDHzP3kNU2FkKEeEymYHS_wcyAkw2GNqTM',
    appId: '1:859865604977:web:13228c151ff37cd1af0cd0',
    messagingSenderId: '859865604977',
    projectId: 'futsallink-project',
    authDomain: 'futsallink-project.firebaseapp.com',
    storageBucket: 'futsallink-project.firebasestorage.app',
    measurementId: 'G-Z3SLFX1RG6',
  );
}
