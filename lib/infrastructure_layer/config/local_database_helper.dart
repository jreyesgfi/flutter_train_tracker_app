import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'configurations.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // General Config
    await db.execute(
      '''
      CREATE TABLE configurations (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        key TEXT UNIQUE,
        value TEXT
      )
      '''
    );

    // Liked Muscles Config
    await db.execute('''
    CREATE TABLE liked_muscles (
      muscleId TEXT PRIMARY KEY
    )
  ''');
  }

  Future<int> insertConfiguration(String key, String value) async {
    final db = await database;
    return await db.insert(
      'configurations',
      {'key': key, 'value': value},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Map<String, dynamic>?> getConfiguration(String key) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'configurations',
      where: 'key = ?',
      whereArgs: [key],
    );
    if (maps.isNotEmpty) {
      return maps.first;
    }
    return null;
  }

  Future<int> updateConfiguration(String key, String value) async {
    final db = await database;
    return await db.update(
      'configurations',
      {'value': value},
      where: 'key = ?',
      whereArgs: [key],
    );
  }

  Future<int> deleteConfiguration(String key) async {
    final db = await database;
    return await db.delete(
      'configurations',
      where: 'key = ?',
      whereArgs: [key],
    );
  }
}
