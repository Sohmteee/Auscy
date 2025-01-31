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
    apiKey: 'AIzaSyAsx79nvW9rcroDLwosyYlgzKYY_4nGucA',
    appId: '1:312946413238:web:341722de801daa64016017',
    messagingSenderId: '312946413238',
    projectId: 'auscy-2621e',
    authDomain: 'auscy-2621e.firebaseapp.com',
    storageBucket: 'auscy-2621e.appspot.com',
    measurementId: 'G-TFCDJ1RD11',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA3RCNsnJGGPDqWQmnIZSCSfJ18cdaDrT8',
    appId: '1:577474389957:android:0cb17610f232c360d64dac',
    messagingSenderId: '577474389957',
    projectId: 'auscy-99955',
    storageBucket: 'auscy-99955.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDKCJMgAurUGRXF2Y2SbtJDb7srnkYxFGU',
    appId: '1:312946413238:ios:23f416e158bcaf0d016017',
    messagingSenderId: '312946413238',
    projectId: 'auscy-2621e',
    storageBucket: 'auscy-2621e.appspot.com',
    iosClientId:
        '312946413238-v9b277aa67dp703ki90pl0f0kd73ghk3.apps.googleusercontent.com',
    iosBundleId: 'com.sohmtee.auscy',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDKCJMgAurUGRXF2Y2SbtJDb7srnkYxFGU',
    appId: '1:312946413238:ios:23f416e158bcaf0d016017',
    messagingSenderId: '312946413238',
    projectId: 'auscy-2621e',
    storageBucket: 'auscy-2621e.appspot.com',
    iosClientId:
        '312946413238-v9b277aa67dp703ki90pl0f0kd73ghk3.apps.googleusercontent.com',
    iosBundleId: 'com.sohmtee.auscy',
  );
}