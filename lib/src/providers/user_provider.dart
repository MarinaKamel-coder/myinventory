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

  Future<void> addUser(UserModel user) async {
    await _dao.insertUser(user);
    await loadUsers();
  }
}
