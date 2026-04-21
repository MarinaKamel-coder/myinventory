import 'package:flutter/material.dart';
import 'package:supermoms/src/models/carton.dart';
import 'package:supermoms/src/repositories/carton_repository.dart';


class CartonProvider extends ChangeNotifier {
  final CartonRepository _repo = CartonRepository();

  List<Carton> _cartons = [];
  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  Future<void> loadCartons() async {
    _cartons = await _repo.getAllCartons();
    notifyListeners();
  }

  List<Carton> get cartons {
    if (_searchQuery.isEmpty) return _cartons;

    final query = _searchQuery.toLowerCase();

    return _cartons.where((carton) {
      final nameMatches = carton.name.toLowerCase().contains(query);
      final itemMatches = carton.items.any(
        (item) => item.name.toLowerCase().contains(query),
      );
      return nameMatches || itemMatches;
    }).toList();
  }

  void addCarton(Carton carton) async {
    await _repo.insertCarton(carton);
    _cartons.insert(0, carton);
    notifyListeners();
  }

  void removeCarton(String id) async {
    await _repo.deleteCarton(id);
    _cartons.removeWhere((c) => c.id == id);
    notifyListeners();
  }

  void updateCarton(Carton carton) async {
    await _repo.updateCarton(carton);
    final index = _cartons.indexWhere((c) => c.id == carton.id);
    if (index != -1) {
      _cartons[index] = carton;
      notifyListeners();
    }
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }
}
