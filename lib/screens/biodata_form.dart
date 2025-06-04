import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import '../models/mahasiswa_model.dart';

class BiodataForm extends StatefulWidget {
  final Mahasiswa? initialData;

  const BiodataForm({super.key, this.initialData});

  @override
  State<BiodataForm> createState() => _BiodataFormState();
}

class _BiodataFormState extends State<BiodataForm> {
  final _formKey = GlobalKey<FormState>();
  final _npmController = TextEditingController();
  final _namaController = TextEditingController();
  final _visiController = TextEditingController();
  final DatabaseReference _database = FirebaseDatabase.instance.ref('mahasiswa');
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
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

  Future<void> _saveData() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final mahasiswa = Mahasiswa(
        npm: _npmController.text.trim(),
        nama: _namaController.text.trim(),
        visi: _visiController.text.trim(),
      );

      await _database.child(mahasiswa.npm).set(mahasiswa.toMap());

      if (!mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.initialData == null
              ? 'Data berhasil ditambahkan'
              : 'Data berhasil diupdate'),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.initialData == null ? 'Tambah Mahasiswa' : 'Edit Mahasiswa'),
        actions: [
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            )
          else
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: _saveData,
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _npmController,
                decoration: const InputDecoration(
                  labelText: 'NPM',
                  border: OutlineInputBorder(),
                ),
                enabled: widget.initialData == null,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'NPM tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _namaController,
                decoration: const InputDecoration(
                  labelText: 'Nama',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _visiController,
                decoration: const InputDecoration(
                  labelText: 'Visi',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Visi tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveData,
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : Text(widget.initialData == null ? 'Tambah' : 'Update'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}