import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:vireo/models/dream_model.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final path = join(await getDatabasesPath(), 'dreams.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE dreams (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        desc TEXT,
        date TEXT,
        progress REAL,
        steps TEXT
      )
    ''');
  }

  Future<List<Dream>> getDreams() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('dreams');
    return maps.map((map) => Dream.fromMap(map)).toList();
  }

  Future<void> insertDream(Dream dream) async {
    final db = await database;
    await db.insert('dreams', dream.toMap());
  }

  Future<void> deleteDream(int id) async {
    final db = await database;
    await db.delete('dreams', where: 'id = ?', whereArgs: [id]);
  }
  Future<void> updateDream(Dream dream) async {
    final db = await database;
    await db.update(
      'dreams',
      dream.toMap(),
      where: 'id = ?',
      whereArgs: [dream.id],
    );
  }

  Future<void> deleteAll() async {
    final db = await database;
    await db.delete('dreams');
  }
}
