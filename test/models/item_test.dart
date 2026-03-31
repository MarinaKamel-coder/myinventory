import 'package:flutter_test/flutter_test.dart';
import 'package:supermoms/src/models/item.dart';

void main() {
  test('Item copyWith updates fields', () {
    const item = Item(
      id: 'item-1',
      boxId: 'box-1',
      name: 'Cafetière',
      description: 'Ancienne cafetière',
    );

    final updated = item.copyWith(name: 'Nouvelle Cafetière');

    expect(updated.id, 'item-1');
    expect(updated.boxId, 'box-1');
    expect(updated.name, 'Nouvelle Cafetière');
    expect(updated.description, 'Ancienne cafetière');
  });

  test('Item equality works', () {
    const item1 = Item(id: '1', boxId: 'b1', name: 'Objet');
    const item2 = Item(id: '1', boxId: 'b1', name: 'Objet');

    expect(item1, equals(item2));
  });
}
