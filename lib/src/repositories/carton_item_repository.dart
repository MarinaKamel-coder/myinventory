import 'package:supermoms/src/data/database_helper.dart';
import 'package:supermoms/src/models/carton_item.dart';

class CartonItemRepository {
  final DatabaseHelper db = DatabaseHelper.instance;

  Future<List<CartonItem>> getItemsByCartonId(String cartonId) async {
    final database = await db.database;
    final result = await database.query(
      'carton_items',
      where: 'carton_id = ?',
      whereArgs: [cartonId],
    );
    return result.map((e) => CartonItemSqlMapping.fromMap(e)).toList();
  }

  Future<void> insertItem(CartonItem item) async {
    final database = await db.database;
    await database.insert('carton_items', item.toMap());
  }

  Future<void> deleteItem(String id) async {
    final database = await db.database;
    await database.delete('carton_items', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> updateItem(CartonItem item) async {
    final database = await db.database;
    await database.update(
      'carton_items',
      item.toMap(),
      where: 'id = ?',
      whereArgs: [item.id],
    );
  }
}
