import 'package:flutter/material.dart';
import 'package:supermoms/src/Data/data.dart';
import 'package:supermoms/src/models/carton.dart';
import 'package:supermoms/src/models/carton_item.dart';

class CartonProvider extends ChangeNotifier {
  // On utilise une liste modifiable (on enlève le côté "final" si besoin)
  final List<Carton> _cartons = List<Carton>.from(MockData.boxes);

  List<Carton> get cartons => _cartons;

  void addItemToCarton(String cartonId, CartonItem newItem) {
    // 1. Trouver le carton (Correction du nom de variable ici)
    final index = _cartons.indexWhere((carton) => carton.id == cartonId);

    if (index != -1) {
      // 2. Créer une nouvelle liste d'items avec le nouveau
      final updatedItems = List<CartonItem>.from(_cartons[index].items)..add(newItem);

      // 3. Mettre à jour le carton dans la liste
      _cartons[index] = _cartons[index].copyWith(items: updatedItems);

      // 4. PREVENIR L'INTERFACE
      notifyListeners();
    }
  }
} // N'oublie pas de bien fermer la classe ici !