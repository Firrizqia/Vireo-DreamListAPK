import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:vireo/models/dream_model.dart';
import 'package:vireo/models/user_model.dart';
import 'package:vireo/models/diary_model.dart';

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

    // Hapus komentar berikut jika ingin me-reset database saat pengembangan:
    // await deleteDatabase(path);

    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    // Tabel Dreams
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

    // Tabel Users
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        username TEXT,
        email TEXT,
        age TEXT,
        gender TEXT,
        motto TEXT,
        profileImagePath TEXT
      )
    ''');

    // Tabel Diary
    await db.execute('''
      CREATE TABLE diary (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        judul TEXT,
        isi TEXT,
        tanggal TEXT,
        jam TEXT
      )
    ''');
  }

  // ============================================
  // DREAM OPERATIONS
  // ============================================
  Future<List<Dream>> getDreams() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('dreams');
    return maps.map((map) => Dream.fromMap(map)).toList();
  }

  Future<void> insertDream(Dream dream) async {
    final db = await database;
    await db.insert('dreams', dream.toMap());
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

  Future<void> deleteDream(int id) async {
    final db = await database;
    await db.delete('dreams', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> deleteAllDreams() async {
    final db = await database;
    await db.delete('dreams');
  }

  // ============================================
  // USER OPERATIONS
  // ============================================
  Future<int> insertUser(UserModel user) async {
    final db = await database;
    return await db.insert(
      'users',
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
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

  // ============================================
  // DIARY OPERATIONS
  // ============================================

  Future<int> insertDiary(DiaryModel diary) async {
    final db = await database;
    return await db.insert('diary', diary.toMap());
  }

  Future<List<DiaryModel>> getAllDiary() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'diary',
      orderBy: 'id DESC',
    );
    return maps.map((map) => DiaryModel.fromMap(map)).toList();
  }

  Future<void> deleteDiary(int id) async {
    final db = await database;
    await db.delete('diary', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> deleteAllDiary() async {
    final db = await database;
    await db.delete('diary');
  }

  Future<void> updateDiary(DiaryModel diary) async {
    final db = await database;
    await db.update(
      'diary',
      diary.toMap(),
      where: 'id = ?',
      whereArgs: [diary.id],
    );
  }
}
