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
    apiKey: 'AIzaSyCqawPYoMxXLQRUO2Sx85EsfKJpuKm1prA',
    appId: '1:596232969609:web:97956622359111ea01d558',
    messagingSenderId: '596232969609',
    projectId: 'storyconnect-9c7dd',
    authDomain: 'storyconnect-9c7dd.firebaseapp.com',
    storageBucket: 'storyconnect-9c7dd.appspot.com',
    measurementId: 'G-LVPW4WQL22',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBm8UTRpQ5Y3F0IXK_T3vcRkbJTU7rsrq4',
    appId: '1:596232969609:android:b5c25deaf38f329501d558',
    messagingSenderId: '596232969609',
    projectId: 'storyconnect-9c7dd',
    storageBucket: 'storyconnect-9c7dd.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC0UUz4v1pzQHt2eBebliGoOc9EneJ2T6o',
    appId: '1:596232969609:ios:61d49fe26173539b01d558',
    messagingSenderId: '596232969609',
    projectId: 'storyconnect-9c7dd',
    storageBucket: 'storyconnect-9c7dd.appspot.com',
    iosClientId: '596232969609-p25gp9qhkasluasncjf4rmhn2fiu9dit.apps.googleusercontent.com',
    iosBundleId: 'com.example.storyconnect',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyC0UUz4v1pzQHt2eBebliGoOc9EneJ2T6o',
    appId: '1:596232969609:ios:efec8fba54ec9ab701d558',
    messagingSenderId: '596232969609',
    projectId: 'storyconnect-9c7dd',
    storageBucket: 'storyconnect-9c7dd.appspot.com',
    iosClientId: '596232969609-52ugrh0h1nhhmjgmnl0bmeif9fchqgva.apps.googleusercontent.com',
    iosBundleId: 'com.storyconnect.storyconnect',
  );
}
