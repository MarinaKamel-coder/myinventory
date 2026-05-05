import 'package:flutter/material.dart';
import 'package:supermoms/src/models/carton.dart';
import 'package:supermoms/src/repositories/carton_repository.dart';

class CartonProvider extends ChangeNotifier {
  final CartonRepository _repository = CartonRepository();
  
  List<Carton> _cartons = [];
  String _searchQuery = '';

  String get searchQuery => _searchQuery;

  // Getter avec logique de recherche
  List<Carton> get cartons {
    if (_searchQuery.isEmpty) return _cartons;

    final query = _searchQuery.toLowerCase();

    return _cartons.where((carton) {
      bool nameMatches = carton.name.toLowerCase().contains(query);
      bool itemMatches = carton.items.any((item) => 
          item.name.toLowerCase().contains(query));
      return nameMatches || itemMatches;
    }).toList();
  }

  // --- MÉTHODES SQLite ---

  // Charger les données depuis la base
  Future<void> loadCartons() async {
    try {
      _cartons = await _repository.getAllCartons();
      notifyListeners();
    } catch (e) {
      debugPrint("Erreur CartonProvider.loadCartons: $e");
    }
  }

  // Ajouter un carton en base et en mémoire
  Future<void> addCarton(Carton newCarton) async {
    try {
      await _repository.insertCarton(newCarton);
      _cartons.insert(0, newCarton);
      notifyListeners();
    } catch (e) {
      debugPrint("Erreur CartonProvider.addCarton: $e");
    }
  }

  // Supprimer un carton
  Future<void> deleteCarton(String cartonId) async {
    try {
      await _repository.deleteCarton(cartonId);
      _cartons.removeWhere((c) => c.id == cartonId);
      notifyListeners();
    } catch (e) {
      debugPrint("Erreur CartonProvider.deleteCarton: $e");
    }
  }

  // Mettre à jour un carton
  Future<void> updateCarton(Carton updatedCarton) async {
    try {
      await _repository.updateCarton(updatedCarton);
      final index = _cartons.indexWhere((c) => c.id == updatedCarton.id);
      if (index != -1) {
        _cartons[index] = updatedCarton;
        notifyListeners();
      }
    } catch (e) {
      debugPrint("Erreur CartonProvider.updateCarton: $e");
    }
  }

  // --- RECHERCHE ---

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  // Stats
  int get totalCartons => _cartons.length;
  int get fragileCount => _cartons.where((c) => c.fragile).length;

  Carton? findById(String id) {
    try {
      return _cartons.firstWhere((carton) => carton.id == id);
    } catch (_) {
      return null;
    }
  }
}
