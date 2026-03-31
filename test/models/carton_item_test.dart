import 'package:flutter_test/flutter_test.dart';
import 'package:supermoms/src/models/carton_item.dart';

void main() {
  test('CartonItem copyWith updates fields', () {
    const item = CartonItem(
      id: 'item-1',
      cartonId: 'box-1',
      name: 'Cafetière',
      description: 'Ancienne cafetière',
    );

    final updated = item.copyWith(name: 'Nouvelle Cafetière');

    expect(updated.id, 'item-1');
    expect(updated.cartonId, 'box-1');
    expect(updated.name, 'Nouvelle Cafetière');
    expect(updated.description, 'Ancienne cafetière');
  });

  test('CartonItem equality works', () {
    const item1 = CartonItem(id: '1', cartonId: 'b1', name: 'Objet');
    const item2 = CartonItem(id: '1', cartonId: 'b1', name: 'Objet');

    expect(item1, equals(item2));
  });
}
