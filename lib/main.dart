import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/biodata_form.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Biodata Mahasiswa',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const BiodataForm(), // Gunakan form yang sudah dibuat
    );
  }
}
