import 'dart:io';
import 'package:favourite_places/models/place.dart';
import 'package:riverpod/riverpod.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';

Future<Database> _getDatabase() async {
  final dbPath = await sql.getDatabasesPath();
  final db = await sql.openDatabase(
    path.join(dbPath, 'places.db'),
    onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE user_places(id TEXT PRIMARY KEY,title TEXT,image TEXT)');
    },
    version: 1,
  );
  return db;
}

class UserplaceNotifier extends StateNotifier<List<Place>> {
  UserplaceNotifier() : super(const []);
 Future<void> loadplaces() async {
    final db = await _getDatabase();
    final data = await db.query('user_places');
    final placess=data.map(
      (row) => Place(
        title: row['title'] as String,
        image: File(row['image'] as String),
      ),
    ).toList();
    state=placess;
  }

  void addplace(String titlee, File imag) async {
    final appDir = await syspaths.getApplicationDocumentsDirectory();
    final filename = path.basename(imag.path);
    final copiedimage = await imag.copy('${appDir.path}/$filename');
    final newplace = Place(title: titlee, image: copiedimage);
    final db = await _getDatabase();
    db.insert('user_places', {
      'id': newplace.id,
      'text': newplace.title,
      'image': newplace.image.path,
    });
    state = [newplace, ...state];
  }
}

final userPlacesProvider =
    StateNotifierProvider<UserplaceNotifier, List<Place>>(
  (ref) => UserplaceNotifier(),
);
