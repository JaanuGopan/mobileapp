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
    apiKey: 'AIzaSyA6k6N2YIXz4-iSYmsancSkdtByRSXCeyU',
    appId: '1:279127760308:web:52e9bb9bfa6e4f379966e1',
    messagingSenderId: '279127760308',
    projectId: 'smartgarden-2582e',
    authDomain: 'smartgarden-2582e.firebaseapp.com',
    storageBucket: 'smartgarden-2582e.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBoXK6tNFduj_GlTK-78hSqQ-oTBB-2Wv0',
    appId: '1:279127760308:android:37243008caec7ef69966e1',
    messagingSenderId: '279127760308',
    projectId: 'smartgarden-2582e',
    storageBucket: 'smartgarden-2582e.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBN3zQgAvbqv9EPBwSodvtTNzJOfZqQqEI',
    appId: '1:279127760308:ios:079ae71fb815e67c9966e1',
    messagingSenderId: '279127760308',
    projectId: 'smartgarden-2582e',
    storageBucket: 'smartgarden-2582e.appspot.com',
    iosBundleId: 'com.example.smartgarden',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBN3zQgAvbqv9EPBwSodvtTNzJOfZqQqEI',
    appId: '1:279127760308:ios:b80a16b8ca2f96249966e1',
    messagingSenderId: '279127760308',
    projectId: 'smartgarden-2582e',
    storageBucket: 'smartgarden-2582e.appspot.com',
    iosBundleId: 'com.example.app',
  );
}
