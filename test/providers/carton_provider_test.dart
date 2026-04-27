import 'package:flutter_test/flutter_test.dart';
import 'package:supermoms/src/models/carton.dart';
import 'package:supermoms/src/models/room.dart';
import 'package:supermoms/src/providers/carton_provider.dart';

void main() {
  group('CartonProvider - addBox & Cas Limites', () {
    late CartonProvider provider;

    setUp(() {
      provider = CartonProvider();
    });

    test('addCarton : Doit ajouter un carton et augmenter le total', () {
      final initialCount = provider.totalCartons;
      final newBox = Carton(
        id: 'new-box',
        name: 'Bureau',
        room: Room.bureau,
        fragile: false,
        items: const [],
        createdAt: DateTime.now(),
      );

      provider.addCarton(newBox);

      expect(provider.totalCartons, initialCount + 1);
      expect(provider.cartons.any((c) => c.id == 'new-box'), isTrue);
    });

    test('updateCarton : Doit modifier un carton existant', () {
      final original = provider.cartons.first;
      final updated = original.copyWith(name: 'Nouveau Nom', room: Room.cuisine);

      provider.updateCarton(updated);

      final result = provider.cartons.firstWhere((c) => c.id == original.id);
      expect(result.name, 'Nouveau Nom');
    });

    group('Cas Limites', () {
      test('updateCarton : Ne doit rien faire si l\'ID n\'existe pas', () {
        final initialList = List.from(provider.cartons);
        final ghostBox = Carton(
          id: 'ghost',
          name: 'Fantôme',
          room: Room.autre,
          fragile: false,
          items: const [],
          createdAt: DateTime.now(),
        );

        provider.updateCarton(ghostBox);

        expect(provider.cartons.length, initialList.length);
        expect(provider.cartons.any((c) => c.id == 'ghost'), isFalse);
      });

      test('removeCarton : Ne doit pas planter avec un ID inexistant', () {
        final initialCount = provider.totalCartons;

        // On tente de supprimer un truc qui n'existe pas
        provider.removeCarton('non-existent-id');

        expect(provider.totalCartons, initialCount);
      });

      test('fragileCount : Doit calculer correctement le nombre de cartons fragiles', () {
        final initialFragile = provider.fragileCount;

        provider.addCarton(Carton(
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
