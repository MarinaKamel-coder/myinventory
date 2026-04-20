import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supermoms/src/models/carton_item.dart';

class ItemProvider extends ChangeNotifier {
  ItemProvider() {
    _loadItems();
  }

  static const String _storageKey = 'carton_items';
  final List<CartonItem> _items = [];

  List<CartonItem> get allItems => _items;

  List<CartonItem> getItemsByCartonId(String cartonId) => 
      _items.where((item) => item.cartonId == cartonId).toList();

  List<CartonItem> searchItemsByCartonIdAndName({
    required String cartonId,
    required String query,
  }) {
    final normalizedQuery = _normalizeSearchText(query);
    if (normalizedQuery.isEmpty) {
      return getItemsByCartonId(cartonId);
    }

    return _items.where((item) {
      if (item.cartonId != cartonId) return false;
      final normalizedName = _normalizeSearchText(item.name);
      return normalizedName.contains(normalizedQuery);
    }).toList();
  }

  void addItem(CartonItem item) {
    _items.add(item);
    _saveItems();
    notifyListeners();
  }

  void removeItem(String itemId) {
    _items.removeWhere((item) => item.id == itemId);
    _saveItems();
    notifyListeners();
  }

  void updateItem(CartonItem updatedItem) {
    final index = _items.indexWhere((item) => item.id == updatedItem.id);
    if (index != -1) {
      _items[index] = updatedItem;
      _saveItems();
      notifyListeners();
    }
  }

  void removeAllItemsOfCarton(String cartonId) {
    _items.removeWhere((item) => item.cartonId == cartonId);
    _saveItems();
    notifyListeners();
  }

  Future<void> _loadItems() async {
    final prefs = await SharedPreferences.getInstance();
    final rawItems = prefs.getString(_storageKey);
    if (rawItems == null || rawItems.isEmpty) return;

    final decoded = jsonDecode(rawItems);
    if (decoded is! List) return;

    _items
      ..clear()
      ..addAll(
        decoded
          .whereType<Map<Object?, Object?>>()
            .map((item) => CartonItem.fromMap(Map<String, dynamic>.from(item))),
      );
    notifyListeners();
  }

  Future<void> _saveItems() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(_items.map((item) => item.toMap()).toList());
    await prefs.setString(_storageKey, encoded);
  }

  String _normalizeSearchText(String raw) {
    final value = raw.trim().toLowerCase();
    return value
        .replaceAll(RegExp('[àáâãäå]'), 'a')
        .replaceAll(RegExp('[ç]'), 'c')
        .replaceAll(RegExp('[èéêë]'), 'e')
        .replaceAll(RegExp('[ìíîï]'), 'i')
        .replaceAll(RegExp('[ñ]'), 'n')
        .replaceAll(RegExp('[òóôõö]'), 'o')
        .replaceAll(RegExp('[ùúûü]'), 'u')
        .replaceAll(RegExp('[ýÿ]'), 'y');
  }
}
