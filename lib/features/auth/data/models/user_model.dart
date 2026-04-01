import '../../domain/entities/user_entity.dart';

/// Modelo de datos de usuario.
/// Convierte desde/hacia JSON de la API.
class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.name,
    required super.email,
    required super.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      role: _parseRole(json['role'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'role': role.name,
  };

  static UserRole _parseRole(String value) => switch (value) {
    'owner' => UserRole.owner,
    _ => UserRole.operator,
  };
}
