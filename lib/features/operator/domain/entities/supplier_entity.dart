enum SupplierStatus { active, inactive, suspended }

extension SupplierStatusX on SupplierStatus {
  String get label => switch (this) {
    SupplierStatus.active => 'Activo',
    SupplierStatus.inactive => 'Inactivo',
    SupplierStatus.suspended => 'Suspendido',
  };
}

class SupplierEntity {
  final String id;
  final String name;
  final String contactName;
  final String email;
  final String phone;
  final SupplierStatus status;
  final double complianceScore;
  final int totalOrders;
  final int completedOrders;
  final List<String> categories;
  final String? address;

  const SupplierEntity({
    required this.id,
    required this.name,
    required this.contactName,
    required this.email,
    required this.phone,
    required this.status,
    required this.complianceScore,
    required this.totalOrders,
    required this.completedOrders,
    required this.categories,
    this.address,
  });

  double get completionRate =>
      totalOrders > 0 ? completedOrders / totalOrders * 100 : 0;

  String get initials {
    final parts = name.trim().split(' ');
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return '${parts.first[0]}${parts[1][0]}'.toUpperCase();
  }
}
