enum Room {
  salon('Salon', '🛋️'),
  cuisine('Cuisine', '🍳'),
  chambre('Chambre', '🛏️'),
  salleDeBain('Salle de bain', '🚿'),
  bureau('Bureau', '💼'),
  garage('Garage', '🚗'),
  cave('Cave', '📦'),
  autre('Autre', '📍');

  const Room(this.label, this.icon);

  final String label;
  final String icon;

  /// Convertit la valeur SQLite en enum Room
  /// Supporte à la fois le 'name' (technique) et le 'label' (affichage) pour la compatibilité
  static Room fromSql(String value) {
    return Room.values.firstWhere(
      (r) => r.name == value || r.label == value,
      orElse: () => Room.autre,
    );
  }
}

extension RoomSqlMapping on Room {
  /// Convertit l'enum en texte pour SQLite.
  /// On utilise .name pour la stabilité de la base de données.
  String toSql() => name;
}