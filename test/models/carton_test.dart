import 'package:flutter_test/flutter_test.dart';
import 'package:supermoms/src/models/carton.dart';
import 'package:supermoms/src/models/room.dart';

void main() {
  final now = DateTime.now();

  test('Carton copyWith updates fields', () {
    final carton = Carton(
      id: 'box-1',
      name: 'Cuisine 1',
      room: Room.cuisine,
      fragile: true,
      items: const [],
      createdAt: now,
    );

    final updated = carton.copyWith(name: 'Cuisine 2');

    expect(updated.id, 'box-1');
    expect(updated.name, 'Cuisine 2');
    expect(updated.room, Room.cuisine);
    expect(updated.fragile, true);
    expect(updated.items, isEmpty);
    expect(updated.createdAt, now);
  });

  test('Carton equality works', () {
    final carton1 = Carton(
      id: '1',
      name: 'Box',
      room: Room.salon,
      fragile: false,
      items: const [],
      createdAt: now,
    );
    final carton2 = Carton(
      id: '1',
      name: 'Box',
      room: Room.salon,
      fragile: false,
      items: const [],
      createdAt: now,
    );

    expect(carton1, equals(carton2));
  });
}
