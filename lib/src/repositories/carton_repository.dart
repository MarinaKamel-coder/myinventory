import 'package:supermoms/src/data/database_helper.dart';
import 'package:supermoms/src/models/carton.dart';
import 'package:supermoms/src/models/carton_item.dart';

class CartonRepository {
  final db = DatabaseHelper.instance;

  Future<List<Carton>> getAllCartons() async {
    final database = await db.database;

    final cartonRows = await database.query('cartons');

    List<Carton> cartons = [];

    for (final row in cartonRows) {
      final items = await database.query(
        'carton_items',
        where: 'carton_id = ?',
        whereArgs: [row['id']],
      );

      final itemList = items.map((e) => CartonItemSqlMapping.fromMap(e)).toList();

      cartons.add(CartonSqlMapping.fromMap(row, itemList));
    }

    return cartons;
  }
  //final String cartonId = DateTime.now().toString();
  Future<void> insertCarton(Carton carton) async {
    final database = await db.database;
    await database.insert('cartons', carton.toMap());
    for (final item in carton.items) {
  await database.insert('carton_items', item.toMap());
}
  }

  Future<void> deleteCarton(String id) async {
    final database = await db.database;
    await database.delete('carton_items', where: 'carton_id = ?', whereArgs: [id]);
    await database.delete('cartons', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> updateCarton(Carton carton) async {
    final database = await db.database;
    await database.update(
      'cartons',
      carton.toMap(),
      where: 'id = ?',
      whereArgs: [carton.id],
    );
  }
}
