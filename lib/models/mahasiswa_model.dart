class Mahasiswa {
  final String npm;
  final String nama;
  final String visi;

  Mahasiswa({
    required this.npm,
    required this.nama,
    required this.visi,
  });

  Map<String, dynamic> toMap() {
    return {
      'nama': nama,
      'visi': visi,
    };
  }
}