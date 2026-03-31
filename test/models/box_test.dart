import 'package:flutter_test/flutter_test.dart';
import 'package:supermoms/src/models/box.dart';
import 'package:supermoms/src/models/room.dart';

void main() {
  final now = DateTime.now();

  test('Box copyWith updates fields', () {
    final box = Box(
      id: 'box-1',
      name: 'Cuisine 1',
      room: Room.cuisine,
      fragile: true,
      items: const [],
      createdAt: now,
    );

    final updated = box.copyWith(name: 'Cuisine 2');

    expect(updated.id, 'box-1');
    expect(updated.name, 'Cuisine 2');
    expect(updated.room, Room.cuisine);
    expect(updated.fragile, true);
    expect(updated.items, isEmpty);
    expect(updated.createdAt, now);
  });

  test('Box equality works', () {
    final box1 = Box(
      id: '1',
      name: 'Box',
      room: Room.salon,
      fragile: false,
      items: const [],
      createdAt: now,
    );
    final box2 = Box(
      id: '1',
      name: 'Box',
      room: Room.salon,
      fragile: false,
      items: const [],
      createdAt: now,
    );

    expect(box1, equals(box2));
  });
}
