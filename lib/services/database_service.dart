import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/item_model.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final String dbPath = await getDatabasesPath();
    final String path = join(dbPath, 'track_bloom.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE items(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            type TEXT NOT NULL,
            date TEXT NOT NULL,
            isCompleted INTEGER NOT NULL
          )
        ''');
      },
    );
  }

  Future<int> insertItem(ItemModel item) async {
    final db = await database;
    return db.insert('items', item.toMap());
  }

  Future<List<ItemModel>> getTodayItems(DateTime date) async {
    final db = await database;
    final String today = date.toIso8601String().substring(0, 10);
    final List<Map<String, dynamic>> maps = await db.query(
      'items',
      where: 'date LIKE ?',
      whereArgs: ['$today%'],
      orderBy: 'id DESC',
    );
    return maps.map((map) => ItemModel.fromMap(map)).toList();
  }

  Future<int> updateItem(ItemModel item) async {
    final db = await database;
    return db.update(
      'items',
      item.toMap(),
      where: 'id = ?',
      whereArgs: [item.id],
    );
  }

  Future<int> deleteItem(int id) async {
    final db = await database;
    return db.delete('items', where: 'id = ?', whereArgs: [id]);
  }
}
