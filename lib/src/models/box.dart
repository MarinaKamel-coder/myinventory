class Box {
  /// Identifiant unique du carton (ex: UUID)
  final String id;
  final String name;

  const Box({required this.id, required this.name});

  Box copyWith({String? id, String? name}) {
    return Box(id: id ?? this.id, name: name ?? this.name);
  }

  /// Sérialisation en JSON (optionnel)
  Map<String, dynamic> toJson() => {'id': id, 'name': name};

  static Box fromJson(Map<String, dynamic> json) =>
      Box(id: json['id'] as String, name: json['name'] as String);

  @override
  String toString() => 'Box(id: $id, name: $name)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Box && other.id == id && other.name == name;

  @override
  int get hashCode => Object.hash(id, name);
}
