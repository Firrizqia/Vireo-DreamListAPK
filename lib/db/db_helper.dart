import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:vireo/models/dream_model.dart';
import 'package:vireo/models/user_model.dart';

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

    //un-komen jika ingin menghapus database lama
    //await deleteDatabase(path);

    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    //Dreams Table
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

    //Users Table
    await db.execute('''
    CREATE TABLE users (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT,
      username TEXT,
      email TEXT,
      age TEXT,
      gender TEXT,
      profileImagePath TEXT
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

  // Users Table Operations
  Future<int> insertUser(UserModel user) async {
  final db = await database;
  return await db.insert('users', user.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
}

Future<UserModel?> getUser() async {
  final db = await database;
  final List<Map<String, dynamic>> maps = await db.query('users', limit: 1);
  if (maps.isNotEmpty) {
    return UserModel.fromMap(maps.first);
  }
  return null;
}

Future<int> updateUser(UserModel user) async {
  final db = await database;
  return await db.update(
    'users',
    user.toMap(),
    where: 'id = ?',
    whereArgs: [user.id],
  );
}

Future<void> deleteUser(int id) async {
  final db = await database;
  await db.delete('users', where: 'id = ?', whereArgs: [id]);
}
}
