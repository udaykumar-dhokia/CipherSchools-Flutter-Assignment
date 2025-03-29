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
    apiKey: 'AIzaSyCJMOu__Vx9nc4Kc-w1tyIFpJOigjq39w8',
    appId: '1:1044292579348:web:09d22842a94b74e5457701',
    messagingSenderId: '1044292579348',
    projectId: 'cipherx-expense-tracker',
    authDomain: 'cipherx-expense-tracker.firebaseapp.com',
    storageBucket: 'cipherx-expense-tracker.firebasestorage.app',
    measurementId: 'G-RG5E0T0WYN',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAzfrEUMEghCqOmC0Flggphie7NtFM7-W0',
    appId: '1:1044292579348:android:1fa7f299b31055f3457701',
    messagingSenderId: '1044292579348',
    projectId: 'cipherx-expense-tracker',
    storageBucket: 'cipherx-expense-tracker.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAW9rAQ1Rvw2qKTS8yHxM5jbdE5tt5U9fI',
    appId: '1:1044292579348:ios:dca40ae19e8444cd457701',
    messagingSenderId: '1044292579348',
    projectId: 'cipherx-expense-tracker',
    storageBucket: 'cipherx-expense-tracker.firebasestorage.app',
    iosBundleId: 'com.example.cipherxExpenseTracker',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAW9rAQ1Rvw2qKTS8yHxM5jbdE5tt5U9fI',
    appId: '1:1044292579348:ios:dca40ae19e8444cd457701',
    messagingSenderId: '1044292579348',
    projectId: 'cipherx-expense-tracker',
    storageBucket: 'cipherx-expense-tracker.firebasestorage.app',
    iosBundleId: 'com.example.cipherxExpenseTracker',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCJMOu__Vx9nc4Kc-w1tyIFpJOigjq39w8',
    appId: '1:1044292579348:web:62739d35791598c7457701',
    messagingSenderId: '1044292579348',
    projectId: 'cipherx-expense-tracker',
    authDomain: 'cipherx-expense-tracker.firebaseapp.com',
    storageBucket: 'cipherx-expense-tracker.firebasestorage.app',
    measurementId: 'G-8GEBMP36EW',
  );
}
