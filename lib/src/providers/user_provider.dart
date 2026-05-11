import 'package:flutter/material.dart';
import 'package:supermoms/src/Data/user_dao.dart';
import 'package:supermoms/src/models/user_model.dart';

class UserProvider extends ChangeNotifier {
  final UserDao _dao = UserDao();
  List<UserModel> _users = [];

  List<UserModel> get users => _users;

  Future<void> loadUsers() async {
    _users = await _dao.getAllUsers();
    notifyListeners();
  }

  bool isEmailUnique(String email) {
    return !_users.any((u) => u.email.toLowerCase() == email.toLowerCase());
  }

  Future<bool> addUser(UserModel user) async {
    if (!isEmailUnique(user.email)) return false;

    await _dao.insertUser(user);
    await loadUsers();
    return true;
  }

  Future<void> updateUser(UserModel user) async {
    await _dao.updateUser(user);
    await loadUsers();
    notifyListeners();
  }

  Future<void> resetPassword(UserModel user) async {
    final updatedUser = user.copyWith(password: '');
    await updateUser(updatedUser);
  }

  Future<void> deleteUser(UserModel user) async {
    if (user.id != null) {
      await _dao.deleteUser(user.id!);
      await loadUsers();
    }
  }
}
