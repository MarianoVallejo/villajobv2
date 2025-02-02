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
    apiKey: 'AIzaSyCY6qV8xzNXoA3dTbZ8khxAabT09ZOTACw',
    appId: '1:596426621751:web:dfef2b3a9218bcde8490b2',
    messagingSenderId: '596426621751',
    projectId: 'villajob-a63fa',
    authDomain: 'villajob-a63fa.firebaseapp.com',
    storageBucket: 'villajob-a63fa.appspot.com',
    measurementId: 'G-WWB1EY70R0',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCbFX5if6nMcMMs1-seu-7YJNrR1xai8lE',
    appId: '1:596426621751:android:a5759f84da0d05aa8490b2',
    messagingSenderId: '596426621751',
    projectId: 'villajob-a63fa',
    storageBucket: 'villajob-a63fa.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyClPX8-Ind0oPahZSxm-eskKBFmagWgLso',
    appId: '1:596426621751:ios:d900d5117f545cbc8490b2',
    messagingSenderId: '596426621751',
    projectId: 'villajob-a63fa',
    storageBucket: 'villajob-a63fa.appspot.com',
    iosClientId: '596426621751-irquv489vp9h3j8e7umq753rdc8odmsq.apps.googleusercontent.com',
    iosBundleId: 'com.example.villajob',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyClPX8-Ind0oPahZSxm-eskKBFmagWgLso',
    appId: '1:596426621751:ios:d900d5117f545cbc8490b2',
    messagingSenderId: '596426621751',
    projectId: 'villajob-a63fa',
    storageBucket: 'villajob-a63fa.appspot.com',
    iosClientId: '596426621751-irquv489vp9h3j8e7umq753rdc8odmsq.apps.googleusercontent.com',
    iosBundleId: 'com.example.villajob',
  );
}
