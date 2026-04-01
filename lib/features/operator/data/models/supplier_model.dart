import '../../domain/entities/supplier_entity.dart';

/// Data model for [SupplierEntity] with JSON serialization.
class SupplierModel extends SupplierEntity {
  const SupplierModel({
    required super.id,
    required super.name,
    required super.contactName,
    required super.email,
    required super.phone,
    required super.status,
    required super.complianceScore,
    required super.totalOrders,
    required super.completedOrders,
    required super.categories,
    super.address,
  });

  factory SupplierModel.fromJson(Map<String, dynamic> json) {
    return SupplierModel(
      id: json['id'] as String,
      name: json['name'] as String,
      contactName: json['contact_name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      status: _parseStatus(json['status'] as String),
      complianceScore: (json['compliance_score'] as num).toDouble(),
      totalOrders: json['total_orders'] as int,
      completedOrders: json['completed_orders'] as int,
      categories: (json['categories'] as List<dynamic>).cast<String>(),
      address: json['address'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'contact_name': contactName,
    'email': email,
    'phone': phone,
    'status': status.name,
    'compliance_score': complianceScore,
    'total_orders': totalOrders,
    'completed_orders': completedOrders,
    'categories': categories,
    'address': address,
  };

  static SupplierStatus _parseStatus(String value) => switch (value) {
    'inactive' => SupplierStatus.inactive,
    'suspended' => SupplierStatus.suspended,
    _ => SupplierStatus.active,
  };

  factory SupplierModel.fromEntity(SupplierEntity e) => SupplierModel(
    id: e.id,
    name: e.name,
    contactName: e.contactName,
    email: e.email,
    phone: e.phone,
    status: e.status,
    complianceScore: e.complianceScore,
    totalOrders: e.totalOrders,
    completedOrders: e.completedOrders,
    categories: e.categories,
    address: e.address,
  );
}
