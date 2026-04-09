// ignore_for_file: avoid_escaping_inner_quotes

import 'package:supermoms/src/models/carton.dart';
import 'package:supermoms/src/models/carton_item.dart';
import 'package:supermoms/src/models/room.dart';

class MockData {
  static final List<Carton> boxes = [
    Carton(
      id: '85bb614a-41a9-42c6-8f92-3d7ce49ce0a0',
      name: 'Carton #1',
      room: Room.cuisine,
      fragile: true,
      createdAt: DateTime.now(),
      items: [
        const CartonItem(
          id: 'i1',
          cartonId: '85bb614a-41a9-42c6-8f92-3d7ce49ce0a0',
          name: 'Assiettes blanches',
          description: 'Service de table complet',
        ),
        const CartonItem(
          id: 'i2',
          cartonId: '85bb614a-41a9-42c6-8f92-3d7ce49ce0a0',
          name: 'Verres à vin',
          description: 'Cristal d\'Arques',
        ),
      ],
    ),
    Carton(
      id: 'box-salon-001',
      name: 'Carton #2',
      room: Room.salon,
      fragile: false,
      createdAt: DateTime.now(),
      items: [
        const CartonItem(
          id: 'i3',
          cartonId: 'box-salon-001',
          name: 'Coussins décoratifs',
          description: 'Bleus et gris',
        ),
      ],
    ),
  ];
}