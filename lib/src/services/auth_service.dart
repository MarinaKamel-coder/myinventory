// lib/services/auth_service.dart

import 'package:shared_preferences/shared_preferences.dart';
import 'package:supermoms/src/data/database_helper.dart';
import 'package:supermoms/src/models/user_model.dart';
import 'package:supermoms/src/utils/hash_utils.dart';

class AuthService {
  static const _userIdKey = 'logged_user_id';

  // INSCRIPTION
  Future<UserModel?> register(String email, String password, String name) async {
    final db = await DatabaseHelper.instance.database;

    // Vérifie si l'email existe déjà
    final existing = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );
    if (existing.isNotEmpty) throw Exception('Email déjà utilisé');

    final now = DateTime.now();
    final hashedPassword = hashPassword(password);

    final id = await db.insert('users', {
      'email': email,
      'password': hashedPassword,
      'display_name': name,
      'created_at': now.toIso8601String(),
    });

    await _saveSession(id);

    return UserModel(
      id: id,
      email: email,
      password: hashedPassword,
      displayName: name,
      createdAt: now,
    );
  }

  // CONNEXION
  Future<UserModel?> signIn(String email, String password) async {
    final db = await DatabaseHelper.instance.database;

    final result = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, hashPassword(password)],
    );

    if (result.isEmpty) throw Exception('Email ou mot de passe incorrect');

    final user = UserModel.fromMap(result.first);

    if (user.id == null) throw Exception('Erreur: utilisateur sans ID');
    await _saveSession(user.id!);

    return user;
  }

  // DÉCONNEXION
  Future<void> signOut() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userIdKey);
  }

  // SUPPRESSION DE COMPTE
  Future<void> deleteAccount(int userId) async {
    final db = await DatabaseHelper.instance.database;
    await db.delete(
      'users',
      where: 'id = ?',
      whereArgs: [userId],
    );
    await signOut();
  }

  // Vérifie si une session existe au démarrage
  Future<UserModel?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt(_userIdKey);
    if (userId == null) return null;

    final db = await DatabaseHelper.instance.database;
    final result = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [userId],
    );

    if (result.isEmpty) return null;
    return UserModel.fromMap(result.first);
  }

  // Sauvegarde la session locale
  Future<void> _saveSession(int userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_userIdKey, userId);
  }
}
