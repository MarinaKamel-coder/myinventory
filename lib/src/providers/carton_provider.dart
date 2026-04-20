import 'package:flutter/material.dart';
import 'package:supermoms/src/Data/data.dart'; // Pour importer les données initiales
import 'package:supermoms/src/models/carton.dart';


class CartonProvider extends ChangeNotifier {
  // Liste privée pour encapsuler les données
  final List<Carton> _cartons = [...MockData.boxes];
  String _searchQuery = ''; // Variable pour stocker la requête de recherche actuelle


  // Getter pour lire tous les cartons depuis l'UI
  List<Carton> get cartons {
    if (_searchQuery.isEmpty) return _cartons;
    return _cartons
        .where((c) => c.name.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  // Méthode pour mettre à jour la recherche depuis le TextField
  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners(); //
  }

  // Getter pour le compteur total de cartons (utilisé dans les stats)
  int get totalCartons => _cartons.length;

  // Getter pour le nombre de cartons fragiles
  int get fragileCount => _cartons.where((c) => c.fragile).length;

  // --- MÉTHODES CRUD POUR LES CARTONS ---

  // 1. GET ALL CARTONS (Déjà couvert par le getter 'cartons', mais on peut aussi créer une méthode si besoin de filtrer plus tard)
  List<Carton> getAllCartons() => _cartons;

  // 2. AJOUTER UN CARTON
  void addCarton(Carton newCarton) {
    _cartons.insert(0, newCarton); // Ajoute au début pour qu'il soit en haut de liste
    notifyListeners(); // Crucial pour mettre à jour l'UI instantanément
  }

  // 3. SUPPRIMER UN CARTON
  void removeCarton(String cartonId) {
    _cartons.removeWhere((c) => c.id == cartonId);
    notifyListeners();
  }

  // 4. MODIFIER UN CARTON
  void updateCarton(Carton updatedCarton) {
    final index = _cartons.indexWhere((c) => c.id == updatedCarton.id);

    if (index != -1) {
      _cartons[index] = updatedCarton;
      notifyListeners();
    }
  }
}
