import 'package:flutter/material.dart';
import 'package:supermoms/src/models/carton_item.dart';

class ItemProvider extends ChangeNotifier {
  final List<CartonItem> _items = [];

  List<CartonItem> get allItems => _items;

  List<CartonItem> getItemsByCartonId(String cartonId) => 
      _items.where((item) => item.cartonId == cartonId).toList();

  void addItem(CartonItem item) {
    _items.add(item);
    notifyListeners();
  }

  void removeItem(String itemId) {
    _items.removeWhere((item) => item.id == itemId);
    notifyListeners();
  }

  void updateItem(CartonItem updatedItem) {
    final index = _items.indexWhere((item) => item.id == updatedItem.id);
    if (index != -1) {
      _items[index] = updatedItem;
      notifyListeners();
    }
  }

  void removeAllItemsOfCarton(String cartonId) {
    _items.removeWhere((item) => item.cartonId == cartonId);
    notifyListeners();
  }
}
