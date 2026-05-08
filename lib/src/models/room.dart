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

  /// Convertit le texte SQLite en enum Room
  static Room fromSql(String value) {
    return Room.values.firstWhere(
      (r) => r.label == value,
      orElse: () => Room.autre,
    );
  }
}

extension RoomSqlMapping on Room {
  /// Convertit l'enum en texte pour SQLite
  String toSql() => label;
}
