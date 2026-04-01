enum UserRole { operator, owner }

class UserEntity {
  final String id;
  final String name;
  final String email;
  final UserRole role;

  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
  });

  String get displayRole => switch (role) {
    UserRole.operator => 'Operador',
    UserRole.owner => 'Propietario',
  };

  /// Initials for avatar display
  String get initials {
    final parts = name.trim().split(' ');
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }
}
