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
    apiKey: 'AIzaSyAkJKmMuGSxzW918NhIFfgXBFWTdplM17w',
    appId: '1:150804825010:web:6332bf0dee53bd3f8ddaab',
    messagingSenderId: '150804825010',
    projectId: 'data-21302',
    authDomain: 'data-21302.firebaseapp.com',
    storageBucket: 'data-21302.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB0CPHYftbrB-ohsREm3MzHFS6RAdObH3A',
    appId: '1:150804825010:android:5e5d504262a28c638ddaab',
    messagingSenderId: '150804825010',
    projectId: 'data-21302',
    storageBucket: 'data-21302.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCzumUbHT-P6g15Vp8anH-fDM4y1OGp6EA',
    appId: '1:150804825010:ios:433241b13c9aa05e8ddaab',
    messagingSenderId: '150804825010',
    projectId: 'data-21302',
    storageBucket: 'data-21302.firebasestorage.app',
    iosBundleId: 'com.example.imcSecured',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCzumUbHT-P6g15Vp8anH-fDM4y1OGp6EA',
    appId: '1:150804825010:ios:433241b13c9aa05e8ddaab',
    messagingSenderId: '150804825010',
    projectId: 'data-21302',
    storageBucket: 'data-21302.firebasestorage.app',
    iosBundleId: 'com.example.imcSecured',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAkJKmMuGSxzW918NhIFfgXBFWTdplM17w',
    appId: '1:150804825010:web:268f10c09bbe0ac78ddaab',
    messagingSenderId: '150804825010',
    projectId: 'data-21302',
    authDomain: 'data-21302.firebaseapp.com',
    storageBucket: 'data-21302.firebasestorage.app',
  );
}
