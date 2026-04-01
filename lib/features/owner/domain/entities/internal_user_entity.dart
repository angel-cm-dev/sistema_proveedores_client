import '../../../auth/domain/entities/user_entity.dart';

enum InternalUserStatus { active, inactive }

extension InternalUserStatusX on InternalUserStatus {
  String get label => switch (this) {
    InternalUserStatus.active => 'Activo',
    InternalUserStatus.inactive => 'Inactivo',
  };
}

class InternalUserEntity {
  final String id;
  final String name;
  final String email;
  final UserRole role;
  final InternalUserStatus status;
  final DateTime createdAt;
  final DateTime? lastLogin;

  const InternalUserEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.status,
    required this.createdAt,
    this.lastLogin,
  });

  String get initials {
    final parts = name.trim().split(' ');
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return '${parts.first[0]}${parts[1][0]}'.toUpperCase();
  }
}
