import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:supermoms/src/models/carton_item.dart';
import 'package:supermoms/src/providers/item_provider.dart';
import 'package:supermoms/src/Data/database_helper.dart'; // Import pour accéder à la DB

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;

    const MethodChannel('plugins.flutter.io/path_provider')
        .setMockMethodCallHandler((MethodCall methodCall) async {
      if (methodCall.method == 'getApplicationDocumentsDirectory') {
        return '.';
      }
      return null;
    });
  });

  group('ItemProvider - Tests complets & Cas limites', () {
    late ItemProvider provider;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      provider = ItemProvider();
      
      // NETTOYAGE ET PRÉPARATION DE LA DB POUR LE TEST
      final db = await DatabaseHelper.instance.database;
      await db.delete('carton_items');
      await db.delete('cartons');
      
      // Insérer un carton de test pour respecter la clé étrangère
      await db.insert('cartons', {
        'id': 'b1',
        'name': 'Carton Test',
        'room': 'Salon',
        'fragile': 0,
        'created_at': DateTime.now().toIso8601String(),
      });
      await db.insert('cartons', {
        'id': 'box_a',
        'name': 'Carton A',
        'room': 'Cuisine',
        'fragile': 0,
        'created_at': DateTime.now().toIso8601String(),
      });
      await db.insert('cartons', {
        'id': 'box_b',
        'name': 'Carton B',
        'room': 'Chambre',
        'fragile': 0,
        'created_at': DateTime.now().toIso8601String(),
      });
    });

    test('addItem : Doit ajouter un objet et être récupérable par cartonId', () async {
      final newItem = CartonItem(id: 'i1', cartonId: 'b1', name: 'Lampe');

      await provider.addItem(newItem); // Ajout du await

      final results = provider.getItemsByCartonId('b1');
      expect(results.length, 1);
      expect(results.first.name, 'Lampe');
    });

    test('updateItem : Doit modifier un objet existant', () async {
      final item = CartonItem(id: 'i1', cartonId: 'b1', name: 'Ancien Nom');
      await provider.addItem(item);

      await provider.updateItem(CartonItem(id: 'i1', cartonId: 'b1', name: 'Nouveau Nom'));

      expect(provider.allItems.firstWhere((i) => i.id == 'i1').name, 'Nouveau Nom');
    });

    test('removeItem : Doit supprimer un objet précis', () async {
      await provider.addItem(CartonItem(id: 'i1', cartonId: 'b1', name: 'Item 1'));

      await provider.removeItem('i1');

      expect(provider.allItems.where((i) => i.id == 'i1'), isEmpty);
    });

    test('removeAllItemsOfCarton : Doit vider un carton spécifique', () async {
      await provider.addItem(CartonItem(id: 'i1', cartonId: 'box_a', name: 'A1'));
      await provider.addItem(CartonItem(id: 'i2', cartonId: 'box_a', name: 'A2'));
      await provider.addItem(CartonItem(id: 'i3', cartonId: 'box_b', name: 'B1'));

      await provider.removeAllItemsOfCarton('box_a');

      expect(provider.allItems.where((i) => i.cartonId == 'box_a'), isEmpty);
      expect(provider.allItems.any((i) => i.cartonId == 'box_b'), isTrue);
    });

    group('Cas limites & Recherche', () {
      test('Recherche : Doit ignorer les accents et la casse (Normalisation)', () async {
        await provider.addItem(CartonItem(id: 'i1', cartonId: 'b1', name: 'Bébé'));

        final results = provider.searchItemsByCartonIdAndName(
            cartonId: 'b1',
            query: 'bebe'
        );

        expect(results.length, 1);
        expect(results.first.name, 'Bébé');
      });

      test('ID Inexistant : getItemsByCartonId doit retourner une liste vide', () {
        final results = provider.getItemsByCartonId('ghost_box');
        expect(results, isEmpty);
      });

      test('Suppression ID fantôme : ne doit pas planter', () async {
        await provider.addItem(CartonItem(id: 'i1', cartonId: 'b1', name: 'Item'));

        await provider.removeItem('ghost_id');

        expect(provider.allItems.length, 1);
      });
    });
  });
}
