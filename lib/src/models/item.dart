class Item {
  const Item({
    required this.id,
    required this.boxId,
    required this.name,
    this.description,
    this.photo,
  });

  final String id;
  final String boxId;
  final String name;
  final String? description;
  final String? photo;

  Item copyWith({
    String? id,
    String? boxId,
    String? name,
    String? description,
    String? photo,
  }) =>
      Item(
        id: id ?? this.id,
        boxId: boxId ?? this.boxId,
        name: name ?? this.name,
        description: description ?? this.description,
        photo: photo ?? this.photo,
      );

  @override
  String toString() => 'Item(id: $id, boxId: $boxId, name: $name)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Item &&
          other.id == id &&
          other.boxId == boxId &&
          other.name == name &&
          other.description == description &&
          other.photo == photo;

  @override
  int get hashCode => Object.hash(id, boxId, name, description, photo);
}
