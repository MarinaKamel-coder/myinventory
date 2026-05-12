import 'package:flutter/material.dart';
import 'package:supermoms/src/models/carton_item.dart';
import 'package:supermoms/src/repositories/carton_item_repository.dart';

class ItemProvider extends ChangeNotifier {
  final CartonItemRepository _repo = CartonItemRepository();
  
  // Liste des objets chargés en mémoire
  final List<CartonItem> _items = [];
  bool _isLoading = false;

  List<CartonItem> get allItems => _items;
  bool get isLoading => _isLoading;

  // Filtrer les objets par carton
  List<CartonItem> getItemsByCartonId(String cartonId) =>
    _items.where((item) => item.cartonId == cartonId).toList();

  // --- MÉTHODES SQLite ---

  Future<void> loadItems(String cartonId) async {
    _isLoading = true;
    notifyListeners();
    try {
      final itemsFromDb = await _repo.getItemsByCartonId(cartonId);
      // Mise à jour sélective pour éviter les doublons en mémoire
      _items.removeWhere((item) => item.cartonId == cartonId);
      _items.addAll(itemsFromDb);
    } catch (e) {
      debugPrint("Erreur lors du chargement des objets : $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addItem(CartonItem item) async {
    try {
      await _repo.insertItem(item);
      _items.add(item);
      notifyListeners();
    } catch (e) {
      debugPrint("Erreur lors de l'ajout de l'objet : $e");
      rethrow;
    }
  }

  Future<void> removeItem(String itemId) async {
    try {
      await _repo.deleteItem(itemId);
      _items.removeWhere((item) => item.id == itemId);
      notifyListeners();
    } catch (e) {
      debugPrint("Erreur lors de la suppression de l'objet : $e");
    }
  }

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

  /// Version optimisée : Utilise une seule commande SQL si ton repo le permet,
  /// sinon on garde la boucle mais on ne notifie qu'une seule fois à la fin.
  Future<void> removeAllItemsOfCarton(String cartonId) async {
    try {
      // Si ton repo a une méthode deleteByCartonId, utilise-la ici.
      // Sinon, on boucle, mais le ON DELETE CASCADE de la DB gère normalement déjà cela
      // lors de la suppression d'un carton.
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
    
    // On récupère d'abord les items du carton
    final cartonItems = getItemsByCartonId(cartonId);
    
    if (normalizedQuery.isEmpty) return cartonItems;

    return cartonItems.where((item) {
      final normalizedName = _normalizeSearchText(item.name);
      final normalizedDesc = _normalizeSearchText(item.description ?? "");
      return normalizedName.contains(normalizedQuery) || normalizedDesc.contains(normalizedQuery);
    }).toList();
  }

  /// Normalisation pour ignorer les accents et la casse
  String _normalizeSearchText(String raw) {
    return raw
        .trim()
        .toLowerCase()
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