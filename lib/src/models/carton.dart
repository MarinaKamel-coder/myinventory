import 'package:supermoms/src/models/carton_item.dart';
import 'package:supermoms/src/models/room.dart';

class Carton {
  const Carton({
    required this.id,
    required this.name,
    required this.room,
    required this.fragile,
    required this.items,
    required this.createdAt,
  });

  final String id;
  final String name;
  final Room room;
  final bool fragile;
  final List<CartonItem> items;
  final DateTime createdAt;

  Carton copyWith({
    String? id,
    String? name,
    Room? room,
    bool? fragile,
    List<CartonItem>? items,
    DateTime? createdAt,
  }) =>
      Carton(
        id: id ?? this.id,
        name: name ?? this.name,
        room: room ?? this.room,
        fragile: fragile ?? this.fragile,
        items: items ?? this.items,
        createdAt: createdAt ?? this.createdAt,
      );

  @override
  String toString() =>
      'Carton(id: $id, name: $name, room: $room, fragile: $fragile, items: $items, createdAt: $createdAt)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Carton &&
          other.id == id &&
          other.name == name &&
          other.room == room &&
          other.fragile == fragile &&
          other.items == items &&
          other.createdAt == createdAt;

  @override
  int get hashCode => Object.hash(id, name, room, fragile, items, createdAt);
}


extension CartonSqlMapping on Carton {
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'room': room.label,
      'fragile': fragile ? 1 : 0,
      'created_at': createdAt.toIso8601String(),
    };
  }

static Carton fromMap(Map<String, dynamic> map, List<CartonItem> items) {
    return Carton(
      id: map['id'] as String,
      name: map['name'] as String,
      room: Room.values.firstWhere(
        (r) => r.label == (map['room'] as String),
      ),
      fragile: (map['fragile'] as int) == 1,
      items: items,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }
}
