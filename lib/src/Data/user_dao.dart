import 'package:supermoms/src/Data/database_helper.dart';
import 'package:supermoms/src/models/user_model.dart';

class UserDao {
  Future<List<UserModel>> getAllUsers() async {
    final db = await DatabaseHelper.instance.database;
    final result = await db.query('users');
    return result.map((e) => UserModel.fromMap(e)).toList();
  }

  Future<void> insertUser(UserModel user) async {
    final db = await DatabaseHelper.instance.database;
    await db.insert('users', user.toMap());
  }

  Future<void> updateUser(UserModel user) async {
    final db = await DatabaseHelper.instance.database;
    await db.update(
      'users',
      user.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  Future<void> deleteUser(int id) async {
    final db = await DatabaseHelper.instance.database;
    await db.delete(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
