import 'package:flutter/material.dart';
import 'package:supermoms/src/models/carton_item.dart';
import 'package:supermoms/src/repositories/carton_item_repository.dart';

class ItemProvider extends ChangeNotifier {
  final CartonItemRepository _repo = CartonItemRepository();
  
  // Liste des objets chargés en mémoire
  final List<CartonItem> _items = [];

  List<CartonItem> get allItems => _items;

  // Filtrer les objets par carton
  List<CartonItem> getItemsByCartonId(String cartonId) =>
    _items.where((item) => item.cartonId == cartonId).toList();

  // --- MÉTHODES SQLite ---

  // Charger les objets d'un carton spécifique depuis la base de données
  Future<void> loadItems(String cartonId) async {
    try {
      final itemsFromDb = await _repo.getItemsByCartonId(cartonId);
      // On met à jour la mémoire pour ce carton spécifique
      _items.removeWhere((item) => item.cartonId == cartonId);
      _items.addAll(itemsFromDb);
      notifyListeners();
    } catch (e) {
      debugPrint("Erreur lors du chargement des objets : $e");
    }
  }

  // Ajouter un objet (SQLite + Mémoire)
  Future<void> addItem(CartonItem item) async {
    try {
      await _repo.insertItem(item);
      _items.add(item);
      notifyListeners();
    } catch (e) {
      debugPrint("Erreur lors de l'ajout de l'objet : $e");
    }
  }

  // Supprimer un objet (SQLite + Mémoire)
  Future<void> removeItem(String itemId) async {
    try {
      await _repo.deleteItem(itemId);
      _items.removeWhere((item) => item.id == itemId);
      notifyListeners();
    } catch (e) {
      debugPrint("Erreur lors de la suppression de l'objet : $e");
    }
  }

  // Mettre à jour un objet (SQLite + Mémoire)
  Future<void> updateItem(CartonItem updatedItem) async {
    try {
      await _repo.updateItem(updatedItem);
      final index = _items.indexWhere((item) => item.id == updatedItem.id);
      if (index != -1) {
        _items[index] = updatedItem;
        notifyListeners();
      }
    } catch (e) {
      debugPrint("Erreur lors de la mise à jour : $e");
    }
  }

  // Supprimer tous les objets d'un carton
  Future<void> removeAllItemsOfCarton(String cartonId) async {
    try {
      final itemsToDelete = _items.where((i) => i.cartonId == cartonId).toList();
      for (final item in itemsToDelete) {
        await _repo.deleteItem(item.id);
      }
      _items.removeWhere((item) => item.cartonId == cartonId);
      notifyListeners();
    } catch (e) {
      debugPrint("Erreur lors de la suppression groupée : $e");
    }
  }

  // --- RECHERCHE ---

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
