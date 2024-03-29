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
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDzCPm8sy76XFce1IMOgZrxkBC29FyvXh0',
    appId: '1:218595973435:web:a75c605b6965450e9abf1e',
    messagingSenderId: '218595973435',
    projectId: 'clubzey',
    authDomain: 'clubzey.firebaseapp.com',
    storageBucket: 'clubzey.appspot.com',
    measurementId: 'G-CV67SJ3K0C',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCfjii9eDRHzywVyvyJFoLS10MrcQBcH2I',
    appId: '1:218595973435:android:c5b9cdaf8e5754219abf1e',
    messagingSenderId: '218595973435',
    projectId: 'clubzey',
    storageBucket: 'clubzey.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB7HZuvtTxegBrsQaARSkuy8w1nCyoKcO4',
    appId: '1:218595973435:ios:19884fe9fe6c8f9c9abf1e',
    messagingSenderId: '218595973435',
    projectId: 'clubzey',
    storageBucket: 'clubzey.appspot.com',
    iosClientId: '218595973435-ja6shfmq4smhreg7th4sephv7fvp4914.apps.googleusercontent.com',
    iosBundleId: 'aerobola.clubzey',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyB7HZuvtTxegBrsQaARSkuy8w1nCyoKcO4',
    appId: '1:218595973435:ios:19884fe9fe6c8f9c9abf1e',
    messagingSenderId: '218595973435',
    projectId: 'clubzey',
    storageBucket: 'clubzey.appspot.com',
    iosClientId: '218595973435-ja6shfmq4smhreg7th4sephv7fvp4914.apps.googleusercontent.com',
    iosBundleId: 'aerobola.clubzey',
  );
}
