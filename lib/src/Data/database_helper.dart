import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:supermoms/src/models/carton.dart';
import 'package:supermoms/src/models/carton_item.dart';

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
      version: 3,
      onConfigure: (db) async {
        // Indispensable pour que le ON DELETE CASCADE fonctionne
        await db.execute('PRAGMA foreign_keys = ON');
      },
      onCreate: _createTables,
      onUpgrade: _onUpgrade,
    );
  }

  /// Création initiale des tables
  Future<void> _createTables(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        email TEXT UNIQUE NOT NULL,
        password TEXT NOT NULL,
        display_name TEXT,
        created_at TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE cartons (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        room TEXT NOT NULL,
        fragile INTEGER NOT NULL,
        created_at TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE carton_items (
        id TEXT PRIMARY KEY,
        cartonId TEXT NOT NULL,
        name TEXT NOT NULL,
        description TEXT,
        photo TEXT,
        quantity INTEGER DEFAULT 1,
        FOREIGN KEY (cartonId) REFERENCES cartons(id) ON DELETE CASCADE
      )
    ''');
  }

  /// Gestion des montées de version (Migrations)
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
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
      
      if (!(await _columnExists(db, 'carton_items', 'photo'))) {
        await db.execute('ALTER TABLE carton_items ADD COLUMN photo TEXT');
      }
    }

    if (oldVersion < 3) {
      if (!(await _columnExists(db, 'carton_items', 'quantity'))) {
        await db.execute('ALTER TABLE carton_items ADD COLUMN quantity INTEGER DEFAULT 1');
      }
    }
  }

  /// Vérifie si une colonne existe pour éviter les erreurs SQL lors des migrations
  Future<bool> _columnExists(Database db, String tableName, String columnName) async {
    var results = await db.rawQuery('PRAGMA table_info($tableName)');
    return results.any((row) => row['name'] == columnName);
  }

  // --- MÉTHODES CRUD (Exemples pour ton CartonProvider) ---

  /// Insère un carton et tous ses items de manière atomique (Transaction)
  Future<void> insertCarton(Carton carton) async {
    final db = await database;
    await db.transaction((txn) async {
      await txn.insert('cartons', carton.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
      for (var item in carton.items) {
        await txn.insert('carton_items', item.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
      }
    });
  }

  /// Récupère tous les cartons avec leurs items chargés
  Future<List<Carton>> getAllCartons() async {
    final db = await database;
    final List<Map<String, dynamic>> cartonMaps = await db.query('cartons', orderBy: 'created_at DESC');

    List<Carton> cartons = [];
    for (var map in cartonMaps) {
      final List<Map<String, dynamic>> itemMaps = await db.query(
        'carton_items',
        where: 'cartonId = ?',
        whereArgs: [map['id']],
      );
      
      final items = itemMaps.map((i) => CartonItem.fromMap(i)).toList();
      cartons.add(CartonSqlMapping.fromMap(map, items));
    }
    return cartons;
  }

  /// Supprime un carton (les items seront supprimés automatiquement grâce au CASCADE)
  Future<void> deleteCarton(String id) async {
    final db = await database;
    await db.delete('cartons', where: 'id = ?', whereArgs: [id]);
  }
}