import 'package:flutter/material.dart';
import 'package:supermoms/src/models/carton_item.dart';
import 'package:supermoms/src/repositories/carton_item_repository.dart';

class ItemProvider extends ChangeNotifier {
  final CartonItemRepository _repo = CartonItemRepository();

  final List<CartonItem> _items = [];

  List<CartonItem> get allItems => _items;
  
  List<CartonItem> getItemsByCartonId(String cartonId) =>
    _items.where((item) => item.cartonId == cartonId).toList();


  Future<void> loadItems(String cartonId) async {
    _items.clear();
    _items.addAll(await _repo.getItemsByCartonId(cartonId));
    notifyListeners();
  }
  

  void addItem(CartonItem item) async {
    await _repo.insertItem(item);
    _items.add(item);
    notifyListeners();
  }

  void removeItem(String itemId) async {
    await _repo.deleteItem(itemId);
    _items.removeWhere((item) => item.id == itemId);
    notifyListeners();
  }

  void updateItem(CartonItem updatedItem) async {
    await _repo.updateItem(updatedItem);
    final index = _items.indexWhere((item) => item.id == updatedItem.id);
    if (index != -1) {
      _items[index] = updatedItem;
      notifyListeners();
    }
  }

  void removeAllItemsOfCarton(String cartonId) async {
    final itemsToDelete = _items.where((i) => i.cartonId == cartonId).toList();
    for (final item in itemsToDelete) {
      await _repo.deleteItem(item.id);
    }
    _items.removeWhere((item) => item.cartonId == cartonId);
    notifyListeners();
  }
}
