import 'package:flutter/material.dart';
import 'package:supermoms/src/models/carton.dart';
import 'package:supermoms/src/repositories/carton_repository.dart';

class CartonProvider extends ChangeNotifier {
  final CartonRepository _repository = CartonRepository();
  
  List<Carton> _cartons = [];
  String _searchQuery = '';
  bool _isLoading = false;

  // Getters
  List<Carton> get allCartonsRaw => _cartons;
  String get searchQuery => _searchQuery;
  bool get isLoading => _isLoading;

  /// Getter avec logique de recherche (filtre le nom du carton OU les objets)
  List<Carton> get cartons {
    if (_searchQuery.isEmpty) return _cartons;

    final query = _searchQuery.toLowerCase();

    return _cartons.where((carton) {
      final nameMatches = carton.name.toLowerCase().contains(query);
      final itemMatches = carton.items.any((item) => 
          item.name.toLowerCase().contains(query));
      
      return nameMatches || itemMatches;
    }).toList();
  }

  // --- MÉTHODES SQLite ---

  /// Charge les données depuis la base de données au démarrage
  Future<void> loadCartons() async {
    _setLoading(true);
    try {
      _cartons = await _repository.getAllCartons();
    } catch (e) {
      debugPrint("Erreur CartonProvider.loadCartons: $e");
    } finally {
      _setLoading(false);
    }
  }

  /// Ajoute un carton en base et met à jour la mémoire
  Future<void> addCarton(Carton newCarton) async {
    try {
      await _repository.insertCarton(newCarton);
      // On l'ajoute au début de la liste pour qu'il apparaisse en premier
      _cartons.insert(0, newCarton);
      notifyListeners();
    } catch (e) {
      debugPrint("Erreur CartonProvider.addCarton: $e");
      rethrow; // Permet à l'UI d'afficher une erreur si besoin
    }
  }

  /// Supprime un carton
  Future<void> deleteCarton(String cartonId) async {
    try {
      await _repository.deleteCarton(cartonId);
      _cartons.removeWhere((c) => c.id == cartonId);
      notifyListeners();
    } catch (e) {
      debugPrint("Erreur CartonProvider.deleteCarton: $e");
    }
  }

  /// Met à jour un carton (ex: après ajout d'un objet ou changement de pièce)
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

  void clearSearch() {
    _searchQuery = '';
    notifyListeners();
  }

  // --- STATISTIQUES & UTILITAIRES ---

  int get totalCartons => _cartons.length;
  
  int get fragileCount => _cartons.where((c) => c.fragile).length;

  /// Calcule le nombre total d'objets tous cartons confondus
  int get totalItemsCount {
    return _cartons.fold(0, (sum, carton) => sum + carton.items.length);
  }

  Carton? findById(String id) {
    try {
      return _cartons.firstWhere((carton) => carton.id == id);
    } catch (_) {
      return null;
    }
  }

  // Helper privé pour l'état de chargement
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}