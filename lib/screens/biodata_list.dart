import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import '../models/mahasiswa_model.dart';
import 'biodata_form.dart';

class BiodataList extends StatefulWidget {
  const BiodataList({super.key});

  @override
  State<BiodataList> createState() => _BiodataListState();
}

class _BiodataListState extends State<BiodataList> {
  final DatabaseReference _database = FirebaseDatabase.instance.ref('mahasiswa');
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _showDeleteDialog(String npm) async {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogCtx) {
        return AlertDialog(
          title: const Text('Konfirmasi'),
          content: const Text('Apakah Anda yakin ingin menghapus data ini?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Batal'),
              onPressed: () => Navigator.of(dialogCtx).pop(),
            ),
            TextButton(
              child: const Text('Hapus', style: TextStyle(color: Colors.red)),
              onPressed: () async {
                Navigator.of(dialogCtx).pop();
                await _database.child(npm).remove();
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Data berhasil dihapus')),
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Mahasiswa'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (ctx) => const BiodataForm()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Cari Nama/NPM',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase();
                });
              },
            ),
          ),
          Expanded(
            child: StreamBuilder<DatabaseEvent>(
              stream: _database.onValue,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
                  return const Center(child: Text('Tidak ada data'));
                }
                final Map<dynamic, dynamic> data =
                    snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
                final List<Mahasiswa> biodataList = [];
                data.forEach((key, value) {
                  final nama = value['nama'] ?? '';
                  final visi = value['visi'] ?? '';
                  biodataList.add(Mahasiswa(npm: key, nama: nama, visi: visi));
                });
                return ListView.builder(
                  itemCount: biodataList.length,
                  itemBuilder: (context, index) {
                    final biodata = biodataList[index];
                    if (_searchQuery.isNotEmpty &&
                        !biodata.nama.toLowerCase().contains(_searchQuery) &&
                        !biodata.npm.contains(_searchQuery)) {
                      return const SizedBox.shrink();
                    }
                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 8.0,
                        vertical: 4.0,
                      ),
                      child: ListTile(
                        title: Text(biodata.nama),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('NPM: ${biodata.npm}'),
                            const SizedBox(height: 4),
                            Text(
                              'Visi: ${biodata.visi}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (ctx) => BiodataForm(
                                      initialData: biodata,
                                    ),
                                  ),
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _showDeleteDialog(biodata.npm),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}