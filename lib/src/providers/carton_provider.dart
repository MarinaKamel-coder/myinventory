import 'package:flutter/material.dart';
import 'package:supermoms/src/Data/data.dart';
import 'package:supermoms/src/models/carton.dart';
import 'package:supermoms/src/models/carton_item.dart';

class CartonProvider extends ChangeNotifier {
  // Initialisation avec les données de test
  final List<Carton> _cartons = List<Carton>.from(MockData.boxes);

  // Getter pour accéder à la liste
  List<Carton> get cartons => _cartons;

  // Ajouter un nouveau carton
  void addCarton(Carton newCarton) {
    _cartons.insert(0, newCarton);
    notifyListeners();
  }

  // Ajouter un objet dans un carton spécifique
  void addItemToCarton(String cartonId, CartonItem item) {
    final index = _cartons.indexWhere((c) => c.id == cartonId);
    if (index != -1) {
      _cartons[index].items.add(item);
      notifyListeners();
    }
  }

  // Supprimer un carton
  void removeCarton(String cartonId) {
    _cartons.removeWhere((c) => c.id == cartonId);
    notifyListeners();
  }
}
