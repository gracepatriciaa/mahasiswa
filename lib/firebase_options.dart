import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
    apiKey: 'AIzaSyACGmUMqSTIVSOnsqTnS8EBtzeZ6PaNP94',
    appId: '1:671124957223:web:bec674ae78dea7a54b0602',
    messagingSenderId: '671124957223',
    projectId: 'biodatamahasiswa-8c9f2',
    authDomain: 'biodatamahasiswa-8c9f2.firebaseapp.com',
    databaseURL: 'https://biodatamahasiswa-8c9f2-default-rtdb.firebaseio.com',
    storageBucket: 'biodatamahasiswa-8c9f2.firebasestorage.app',
    measurementId: 'G-2WJLWVH52F',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCeAIRyxIgnnXUJCv-78EnJ7kmuyF95oRI',
    appId: '1:671124957223:android:c5bda4c9e44d5cb64b0602',
    messagingSenderId: '671124957223',
    projectId: 'biodatamahasiswa-8c9f2',
    databaseURL: 'https://biodatamahasiswa-8c9f2-default-rtdb.firebaseio.com',
    storageBucket: 'biodatamahasiswa-8c9f2.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD9iKYJ2oL_MZAl7U3VD8igGZ3o7kgOCcA',
    appId: '1:671124957223:ios:b96c90dce215550d4b0602',
    messagingSenderId: '671124957223',
    projectId: 'biodatamahasiswa-8c9f2',
    databaseURL: 'https://biodatamahasiswa-8c9f2-default-rtdb.firebaseio.com',
    storageBucket: 'biodatamahasiswa-8c9f2.firebasestorage.app',
    iosBundleId: 'com.example.mahasiswa',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyD9iKYJ2oL_MZAl7U3VD8igGZ3o7kgOCcA',
    appId: '1:671124957223:ios:b96c90dce215550d4b0602',
    messagingSenderId: '671124957223',
    projectId: 'biodatamahasiswa-8c9f2',
    databaseURL: 'https://biodatamahasiswa-8c9f2-default-rtdb.firebaseio.com',
    storageBucket: 'biodatamahasiswa-8c9f2.firebasestorage.app',
    iosBundleId: 'com.example.mahasiswa',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyACGmUMqSTIVSOnsqTnS8EBtzeZ6PaNP94',
    appId: '1:671124957223:web:6043b2ca9aacd99a4b0602',
    messagingSenderId: '671124957223',
    projectId: 'biodatamahasiswa-8c9f2',
    authDomain: 'biodatamahasiswa-8c9f2.firebaseapp.com',
    databaseURL: 'https://biodatamahasiswa-8c9f2-default-rtdb.firebaseio.com',
    storageBucket: 'biodatamahasiswa-8c9f2.firebasestorage.app',
    measurementId: 'G-RDHPRXL0V0',
  );

}