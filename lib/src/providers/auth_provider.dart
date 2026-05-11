import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  UserModel? _currentUser;
  bool _isLoading = false;
  String? _error;

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _currentUser != null;

  AuthProvider() {
    _checkCurrentUser();
  }

  Future<void> _checkCurrentUser() async {
    _setLoading(true);
    try {
      _currentUser = await _authService.getCurrentUser();
    } catch (e) {
      _error = e.toString();
    }
    _setLoading(false);
  }

  Future<bool> signIn(String email, String password) async {
    _setLoading(true);
    _error = null;
    try {
      _currentUser = await _authService.signIn(email, password);
      _setLoading(false);
      return true;
    } catch (e) {
      _error = e.toString();
      _setLoading(false);
      return false;
    }
  }

  Future<bool> register(String email, String password, String name) async {
    _setLoading(true);
    _error = null;
    try {
      _currentUser = await _authService.register(email, password, name);
      _setLoading(false);
      return true;
    } catch (e) {
      _error = e.toString();
      _setLoading(false);
      return false;
    }
  }

  Future<void> signOut() async {
    await _authService.signOut();
    _currentUser = null;
    notifyListeners();
  }

  Future<void> deleteCurrentUser() async {
    if (_currentUser != null && _currentUser!.id != null) {
      await _authService.deleteAccount(_currentUser!.id!);
      _currentUser = null;
      notifyListeners();
    }
  }

  Future<void> updateCurrentUser(UserModel updatedUser) async {
    _currentUser = updatedUser;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
