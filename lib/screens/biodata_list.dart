import 'package:firebase_database/firebase_database.dart';

class BiodataList extends StatefulWidget {
  @override
  _BiodataListState createState() => _BiodataListState();
}

class _BiodataListState extends State<BiodataList> {
  final DatabaseReference _database = FirebaseDatabase.instance.ref(
    'mahasiswa',
  );
  List<Map<dynamic, dynamic>> _biodataList = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    _database.onValue.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data != null) {
        setState(() {
          _biodataList =
              data.entries.map((entry) {
                return {
                  'key': entry.key,
                  ...entry.value as Map<dynamic, dynamic>,
                };
              }).toList();
        });
      }
    });
  }
}
