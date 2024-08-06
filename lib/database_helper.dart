import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._();
  static Database? _database;

  DatabaseHelper._();

  factory DatabaseHelper() {
    return _instance;
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'airplanes.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE airplanes (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            type TEXT,
            passengers INTEGER,
            speed INTEGER,
            range INTEGER
          )
        ''');
      },
    );
  }

  Future<int> insertAirplane(Map<String, dynamic> row) async {
    Database db = await database;
    return await db.insert('airplanes', row);
  }

  Future<List<Map<String, dynamic>>> getAirplanes() async {
    Database db = await database;
    return await db.query('airplanes');
  }

  Future<int> updateAirplane(Map<String, dynamic> row) async {
    Database db = await database;
    int id = row['id'];
    return await db.update('airplanes', row, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteAirplane(int id) async {
    Database db = await database;
    return await db.delete('airplanes', where: 'id = ?', whereArgs: [id]);
  }
}
