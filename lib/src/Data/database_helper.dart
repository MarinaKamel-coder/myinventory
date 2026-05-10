import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._internal();
  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = join(dir.path, "supermoms.db");

    return await openDatabase(
      path,
      version: 2,
      onCreate: _createTables,
      onUpgrade: _onUpgrade,
      //  Active les clés étrangères pour le ON DELETE CASCADE
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
    );
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
       CREATE TABLE IF NOT EXISTS users (
         id INTEGER PRIMARY KEY AUTOINCREMENT,
         email TEXT UNIQUE NOT NULL,
         password TEXT NOT NULL,
         display_name TEXT,
         created_at TEXT NOT NULL
      )
    ''');
    await db.execute(
      'ALTER TABLE carton_items ADD COLUMN photo TEXT'
    );
  }
}

  Future _createTables(Database db, int version) async {
    await db.execute('''
      CREATE TABLE rooms (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        label TEXT NOT NULL
      );
    ''');

    await db.execute('''
      CREATE TABLE cartons (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        room TEXT NOT NULL,
        fragile INTEGER NOT NULL,
        created_at TEXT NOT NULL
      );
    ''');

    await db.execute('''
      CREATE TABLE carton_items (
        id TEXT PRIMARY KEY,
        cartonId TEXT NOT NULL,
        name TEXT NOT NULL,
        description TEXT,
        photo TEXT,
        FOREIGN KEY (cartonId) REFERENCES cartons(id) ON DELETE CASCADE
      );
    ''');

    await db.execute('''
     CREATE TABLE IF NOT EXISTS users (
       id INTEGER PRIMARY KEY AUTOINCREMENT,
       email TEXT UNIQUE NOT NULL,
       password TEXT NOT NULL,
       display_name TEXT,
       created_at TEXT NOT NULL
    )
  ''');
  }
}
