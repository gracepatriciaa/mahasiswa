import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/biodata_list.dart'; // Pastikan hanya import ini

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Inisialisasi Firebase. Variabel 'firebaseApp' tidak perlu disimpan
  // jika tidak digunakan secara eksplisit setelah inisialisasi.
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Biodata Mahasiswa',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const BiodataList(), // Pastikan BiodataList adalah const
    );
  }
}
