import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supermoms/src/models/carton_item.dart';
import 'package:supermoms/src/providers/item_provider.dart';

void main() {
  // Nécessaire pour simuler SharedPreferences dans les tests unitaires
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ItemProvider - Tests complets & Cas limites', () {
    late ItemProvider provider;

    setUp(() async {
      SharedPreferences.setMockInitialValues({}); // Reset du stockage avant chaque test
      provider = ItemProvider();
    });

    test('addItem : Doit ajouter un objet et être récupérable par cartonId', () {
      final newItem = CartonItem(id: 'i1', cartonId: 'b1', name: 'Lampe');

      provider.addItem(newItem);

      final results = provider.getItemsByCartonId('b1');
      expect(results.length, 1);
      expect(results.first.name, 'Lampe');
    });

    test('updateItem : Doit modifier un objet existant', () {
      final item = CartonItem(id: 'i1', cartonId: 'b1', name: 'Ancien Nom');
      provider.addItem(item);

      provider.updateItem(CartonItem(id: 'i1', cartonId: 'b1', name: 'Nouveau Nom'));

      expect(provider.allItems.first.name, 'Nouveau Nom');
    });

    test('removeItem : Doit supprimer un objet précis', () {
      provider.addItem(CartonItem(id: 'i1', cartonId: 'b1', name: 'Item 1'));

      provider.removeItem('i1');

      expect(provider.allItems, isEmpty);
    });

    test('removeAllItemsOfCarton : Doit vider un carton spécifique', () {
      provider.addItem(CartonItem(id: 'i1', cartonId: 'box_a', name: 'A1'));
      provider.addItem(CartonItem(id: 'i2', cartonId: 'box_a', name: 'A2'));
      provider.addItem(CartonItem(id: 'i3', cartonId: 'box_b', name: 'B1'));

      provider.removeAllItemsOfCarton('box_a');

      expect(provider.allItems.length, 1);
      expect(provider.allItems.first.cartonId, 'box_b');
    });

    group('Cas limites & Recherche', () {
      test('Recherche : Doit ignorer les accents et la casse (Normalisation)', () {
        provider.addItem(CartonItem(id: 'i1', cartonId: 'b1', name: 'Bébé'));

        final results = provider.searchItemsByCartonIdAndName(
            cartonId: 'b1',
            query: 'bebe' // Sans accent, minuscule
        );

        expect(results.length, 1);
        expect(results.first.name, 'Bébé');
      });

      test('ID Inexistant : getItemsByCartonId doit retourner une liste vide', () {
        final results = provider.getItemsByCartonId('ghost_box');
        expect(results, isEmpty);
      });

      test('Suppression ID fantôme : ne doit pas planter', () {
        provider.addItem(CartonItem(id: 'i1', cartonId: 'b1', name: 'Item'));

        provider.removeItem('ghost_id'); // ID qui n'existe pas

        expect(provider.allItems.length, 1); // Rien n'a bougé
      });
    });
  });
}