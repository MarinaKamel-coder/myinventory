import 'package:flutter_test/flutter_test.dart';
import 'package:supermoms/src/models/carton.dart';
import 'package:supermoms/src/models/room.dart';
import 'package:supermoms/src/providers/carton_provider.dart';

void main() {
  // Nécessaire car le Provider utilise des composants asynchrones liés aux plugins
  TestWidgetsFlutterBinding.ensureInitialized();

  group('CartonProvider - Tests asynchrones SQLite', () {
    late CartonProvider provider;

    setUp(() {
      provider = CartonProvider();
    });

    test('addCarton : Doit ajouter un carton et augmenter le total', () async {
      final initialCount = provider.totalCartons;
      final newBox = Carton(
        id: 'test-box',
        name: 'Bureau',
        room: Room.bureau,
        fragile: false,
        items: const [],
        createdAt: DateTime.now(),
      );

      await provider.addCarton(newBox);

      expect(provider.totalCartons, initialCount + 1);
      expect(provider.cartons.any((c) => c.id == 'test-box'), isTrue);
    });

    test('updateCarton : Doit modifier un carton existant', () async {
      // On ajoute d'abord un carton car la liste est vide au début
      final original = Carton(
        id: 'box-1',
        name: 'Ancien Nom',
        room: Room.salon,
        fragile: false,
        items: const [],
        createdAt: DateTime.now(),
      );
      await provider.addCarton(original);

      final updated = original.copyWith(name: 'Nouveau Nom', room: Room.cuisine);
      await provider.updateCarton(updated);

      final result = provider.cartons.firstWhere((c) => c.id == original.id);
      expect(result.name, 'Nouveau Nom');
    });

    group('Cas Limites', () {
      test('updateCarton : Ne doit rien faire si l\'ID n\'existe pas', () async {
        final initialList = List.from(provider.cartons);
        final ghostBox = Carton(
          id: 'ghost',
          name: 'Fantôme',
          room: Room.autre,
          fragile: false,
          items: const [],
          createdAt: DateTime.now(),
        );

        await provider.updateCarton(ghostBox);

        expect(provider.cartons.length, initialList.length);
        expect(provider.cartons.any((c) => c.id == 'ghost'), isFalse);
      });

      test('deleteCarton : Doit supprimer le carton existant', () async {
        final box = Carton(
          id: 'to-delete',
          name: 'Supprime-moi',
          room: Room.autre,
          fragile: false,
          items: const [],
          createdAt: DateTime.now(),
        );
        await provider.addCarton(box);
        final countBefore = provider.totalCartons;

        await provider.deleteCarton('to-delete');

        expect(provider.totalCartons, countBefore - 1);
        expect(provider.cartons.any((c) => c.id == 'to-delete'), isFalse);
      });

      test('deleteCarton : Ne doit pas planter avec un ID inexistant', () async {
        final initialCount = provider.totalCartons;
        await provider.deleteCarton('non-existent-id');
        expect(provider.totalCartons, initialCount);
      });

      test('fragileCount : Doit calculer correctement le nombre de cartons fragiles', () async {
        final initialFragile = provider.fragileCount;

        await provider.addCarton(Carton(
            id: 'f1',
            name: 'Vases',
            room: Room.salon,
            fragile: true,
            items: const [],
            createdAt: DateTime.now(),
        ));

        expect(provider.fragileCount, initialFragile + 1);
      });
    });
  });
}
