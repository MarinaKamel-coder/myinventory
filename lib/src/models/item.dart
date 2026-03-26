class Item {
  const Item({
    required this.id,
    required this.name,
    this.description,
    this.photo,
  });

  final String id;
  final String name;
  final String? description;
  final String? photo;

  @override
  String toString() => 'Item(id: $id, name: $name)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Item &&
          other.id == id &&
          other.name == name &&
          other.description == description &&
          other.photo == photo;

  @override
  int get hashCode => Object.hash(id, name, description, photo);
}
