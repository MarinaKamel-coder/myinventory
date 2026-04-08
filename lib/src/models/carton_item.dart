class CartonItem {
  const CartonItem({
    required this.id,
    required this.cartonId,
    required this.name,
    this.description,
    this.photo,
  });

  final String id;
  final String cartonId;
  final String name;
  final String? description;
  final String? photo;

  CartonItem copyWith({
    String? id,
    String? cartonId,
    String? name,
    String? description,
    String? photo,
  }) =>
      CartonItem(
        id: id ?? this.id,
        cartonId: cartonId ?? this.cartonId,
        name: name ?? this.name,
        description: description ?? this.description,
        photo: photo ?? this.photo,
      );

  @override
  String toString() => 'CartonItem(id: $id, cartonId: $cartonId, name: $name)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CartonItem &&
          other.id == id &&
          other.cartonId == cartonId &&
          other.name == name &&
          other.description == description &&
          other.photo == photo;

  @override
  int get hashCode => Object.hash(id, cartonId, name, description, photo);
}
