
class UserModel {
  final int? id;
  final String email;
  final String password;
  final String? displayName;
  final String? photoUrl;
  final DateTime createdAt;

  UserModel({
    this.id,
    required this.email,
    required this.password,
    required this.createdAt,
    this.displayName,
    this.photoUrl,
  });

  /// Créer un UserModel depuis une Map SQLite
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as int?,
      email: map['email'] as String,
      password: map['password'] as String,
      displayName: map['display_name'] as String?,
      photoUrl: map['photoUrl'] as String?,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  /// Convertir en Map pour insertion/update SQLite
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'email': email,
      'password': password,
      'display_name': displayName,
      'photoUrl': photoUrl,
      'created_at': createdAt.toIso8601String(),
    };
  }

  /// Copier le modèle avec des champs modifiés
  UserModel copyWith({
    int? id,
    String? email,
    String? password,
    String? displayName,
    String? photoUrl,
    DateTime? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      password: password ?? this.password,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'UserModel(id: $id, email: $email, displayName: $displayName)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserModel && other.id == id && other.email == email;
  }

  @override
  int get hashCode => id.hashCode ^ email.hashCode;
}