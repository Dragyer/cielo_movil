import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/observation.dart';

class DBHelper {
  static Future<Database> _openDB() async {
    return openDatabase(
      join(await getDatabasesPath(), 'observations.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE observations(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, date TEXT)',
        );
      },
      version: 1,
    );
  }

  static Future<int> insert(Observation obs) async {
    final db = await _openDB();
    return await db.insert('observations', obs.toMap());
  }

  static Future<List<Observation>> getAll() async {
    final db = await _openDB();
    final List<Map<String, dynamic>> maps = await db.query('observations');
    return List.generate(maps.length, (i) => Observation.fromMap(maps[i]));
  }

  static Future<int> update(Observation obs) async {
    final db = await _openDB();
    return await db.update(
      'observations',
      obs.toMap(),
      where: 'id = ?',
      whereArgs: [obs.id],
    );
  }

  static Future<int> delete(int id) async {
    final db = await _openDB();
    return await db.delete('observations', where: 'id = ?', whereArgs: [id]);
  }
}