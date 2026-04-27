import 'package:flutter/material.dart';
import 'package:supermoms/src/Data/data.dart';
import 'package:supermoms/src/models/carton.dart';

class CartonProvider extends ChangeNotifier {
  // Liste privée initialisée avec les données mockées
  final List<Carton> _cartons = [...MockData.boxes];
  String _searchQuery = '';

  String get searchQuery => _searchQuery;

  // Getter avec logique de filtrage
  List<Carton> get cartons {
    if (_searchQuery.isEmpty) return _cartons;

    final query = _searchQuery.toLowerCase();

    return _cartons.where((carton) {
      // Vérifie le nom du carton
      bool nameMatches = carton.name.toLowerCase().contains(query);
      
      // Vérifie si la pièce (room) correspond aussi 
      bool roomMatches = carton.room.label.toLowerCase().contains(query);

      return nameMatches || roomMatches;
    }).toList();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  // --- STATISTIQUES ---
  int get totalCartons => _cartons.length;
  int get fragileCount => _cartons.where((c) => c.fragile).length;

  // --- MÉTHODES CRUD ---

  // Ajouter un carton
  void addCarton(Carton newCarton) {
    _cartons.insert(0, newCarton);
    notifyListeners();
  }

  // Supprimer un carton 
  void deleteCarton(String cartonId) {
    _cartons.removeWhere((c) => c.id == cartonId);
    notifyListeners();
  }

  // Modifier un carton 
  void updateCarton(String id, String newName, bool isFragile) {
    final index = _cartons.indexWhere((c) => c.id == id);

    if (index != -1) {
      // On crée une copie du carton avec les nouvelles valeurs
      _cartons[index] = _cartons[index].copyWith(
        name: newName,
        fragile: isFragile,
      );
      notifyListeners();
    }
  }

  // Version alternative si on reçoit un objet complet
  void updateCartonFull(Carton updatedCarton) {
    final index = _cartons.indexWhere((c) => c.id == updatedCarton.id);
    if (index != -1) {
      _cartons[index] = updatedCarton;
      notifyListeners();
    }
  }
}