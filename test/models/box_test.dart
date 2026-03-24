import 'package:flutter_test/flutter_test.dart';
import 'package:supermoms/src/models/box.dart';

void main() {
  test('Box toJson/fromJson roundtrip', () {
    const box = Box(id: 'box-1', name: 'Cuisine 1');

    final json = box.toJson();
    final decoded = Box.fromJson(json);

    expect(decoded, equals(box));
  });

  test('copyWith updates fields', () {
    const box = Box(id: 'box-1', name: 'Cuisine 1');

    final updated = box.copyWith(name: 'Cuisine 2');

    expect(updated.id, 'box-1');
    expect(updated.name, 'Cuisine 2');
  });
}
