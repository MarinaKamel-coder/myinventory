class CartonItem {
  factory CartonItem.fromMap(Map<String, dynamic> map) => CartonItem(
    id: map['id'] as String,
    cartonId: map['cartonId'] as String,
    name: map['name'] as String,
    description: map['description'] as String?,
    photo: map['photo'] as String?,
    quantity: map['quantity'] as int? ?? 1,
  );
  const CartonItem({
    required this.id,
    required this.cartonId,
    required this.name,
    this.description,
    this.photo,
    this.quantity = 1,
  });

  final String id;
  final String cartonId;
  final String name;
  final String? description;
  final String? photo;
  final int quantity;

  CartonItem copyWith({
    String? id,
    String? cartonId,
    String? name,
    String? description,
    String? photo,
    int? quantity,
  }) => CartonItem(
    id: id ?? this.id,
    cartonId: cartonId ?? this.cartonId,
    name: name ?? this.name,
    description: description ?? this.description,
    photo: photo ?? this.photo,
    quantity: quantity ?? this.quantity,
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
          other.photo == photo &&
          other.quantity == quantity;

  @override
  int get hashCode =>
      Object.hash(id, cartonId, name, description, photo, quantity);

  Map<String, dynamic> toMap() => {
    'id': id,
    'cartonId': cartonId,
    'name': name,
    'description': description,
    'photo': photo,
    'quantity': quantity,
  };
}

extension CartonItemSqlMapping on CartonItem {
  Map<String, dynamic> toMap() => {
    'id': id,
    'cartonId': cartonId,
    'name': name,
    'description': description,
    'photo': photo,
    'quantity': quantity,
  };

  static CartonItem fromMap(Map<String, dynamic> map) {
    return CartonItem(
      id: map['id'] as String,
      cartonId: map['cartonId'] as String,
      name: map['name'] as String,
      description: map['description'] as String?,
      photo: map['photo'] as String?,
      quantity: map['quantity'] as int? ?? 1,
    );
  }
}
