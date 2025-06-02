import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class BiodataForm extends StatefulWidget {
  const BiodataForm({Key? key}) : super(key: key);

  @override
  _BiodataFormState createState() => _BiodataFormState();
}

class _BiodataFormState extends State<BiodataForm> {
  // Controller untuk input field
  final TextEditingController _npmController = TextEditingController();
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _visiController = TextEditingController();

  // Referensi ke Firebase Realtime Database
  final DatabaseReference _database = FirebaseDatabase.instance.ref(
    'mahasiswa',
  );

  // State untuk menangani loading
  bool _isLoading = false;

  // Fungsi untuk menyimpan data
  Future<void> _simpanData() async {
    // Validasi form
    if (_npmController.text.isEmpty ||
        _namaController.text.isEmpty ||
        _visiController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Semua field harus diisi!')));
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Simpan data ke Firebase
      await _database.child(_npmController.text).set({
        'npm': _npmController.text,
        'nama': _namaController.text,
        'visi': _visiController.text,
        'created_at': ServerValue.timestamp, // Tambahkan timestamp
      });

      // Tampilkan notifikasi sukses
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Data berhasil disimpan!')));

      // Reset form setelah simpan
      _npmController.clear();
      _namaController.clear();
      _visiController.clear();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    // Clean up controller
    _npmController.dispose();
    _namaController.dispose();
    _visiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Input Biodata Mahasiswa'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _npmController,
                decoration: const InputDecoration(
                  labelText: 'NPM',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.numbers),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _namaController,
                decoration: const InputDecoration(
                  labelText: 'Nama Lengkap',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _visiController,
                decoration: const InputDecoration(
                  labelText: 'Visi 5 Tahun',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.visibility),
                ),
                maxLines: 5,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isLoading ? null : _simpanData,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child:
                    _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                          'SIMPAN DATA',
                          style: TextStyle(fontSize: 18),
                        ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
