import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import '../models/mahasiswa_model.dart'; // Pastikan model sudah dibuat

class BiodataForm extends StatefulWidget {
  final Mahasiswa? initialData; // Gunakan model Mahasiswa
  const BiodataForm({super.key, this.initialData});

  @override
  State<BiodataForm> createState() => _BiodataFormState();
}

class _BiodataFormState extends State<BiodataForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _npmController = TextEditingController();
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _visiController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Isi form jika ada data awal (edit mode)
    if (widget.initialData != null) {
      _npmController.text = widget.initialData!.npm;
      _namaController.text = widget.initialData!.nama;
      _visiController.text = widget.initialData!.visi;
    }
  }

  @override
  void dispose() {
    _npmController.dispose();
    _namaController.dispose();
    _visiController.dispose();
    super.dispose();
  }

  Future<void> _simpanData() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final databaseRef = FirebaseDatabase.instance.ref('mahasiswa');
      final mahasiswa = Mahasiswa(
        npm: _npmController.text.trim(),
        nama: _namaController.text.trim(),
        visi: _visiController.text.trim(),
      );

      await databaseRef.child(mahasiswa.npm).set(mahasiswa.toMap());

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data berhasil disimpan!')),
      );

      // Clear form setelah simpan
      if (widget.initialData == null) {
        _npmController.clear();
        _namaController.clear();
        _visiController.clear();
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.initialData == null ? 'Tambah Data' : 'Edit Data'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _npmController,
                  decoration: const InputDecoration(
                    labelText: 'NPM',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      value!.isEmpty ? 'NPM tidak boleh kosong' : null,
                  enabled: widget.initialData == null, // Disable jika edit
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _namaController,
                  decoration: const InputDecoration(
                    labelText: 'Nama Lengkap',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      value!.isEmpty ? 'Nama tidak boleh kosong' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _visiController,
                  decoration: const InputDecoration(
                    labelText: 'Visi 5 Tahun',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                  validator: (value) =>
                      value!.isEmpty ? 'Visi tidak boleh kosong' : null,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _isLoading ? null : _simpanData,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : const Text('SIMPAN'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}