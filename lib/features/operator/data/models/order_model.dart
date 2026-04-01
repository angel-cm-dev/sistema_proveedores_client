import '../../domain/entities/order_entity.dart';

/// Data model for [OrderEntity] with JSON serialization.
class OrderModel extends OrderEntity {
  const OrderModel({
    required super.id,
    required super.supplierId,
    required super.supplierName,
    required super.status,
    required super.createdAt,
    required super.dueDate,
    super.description,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] as String,
      supplierId: json['supplier_id'] as String,
      supplierName: json['supplier_name'] as String,
      status: _parseStatus(json['status'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
      dueDate: DateTime.parse(json['due_date'] as String),
      description: json['description'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'supplier_id': supplierId,
    'supplier_name': supplierName,
    'status': status.name,
    'created_at': createdAt.toIso8601String(),
    'due_date': dueDate.toIso8601String(),
    'description': description,
  };

  static OrderStatus _parseStatus(String value) => switch (value) {
    'inProgress' || 'in_progress' => OrderStatus.inProgress,
    'completed' => OrderStatus.completed,
    'delayed' => OrderStatus.delayed,
    _ => OrderStatus.pending,
  };

  factory OrderModel.fromEntity(OrderEntity e) => OrderModel(
    id: e.id,
    supplierId: e.supplierId,
    supplierName: e.supplierName,
    status: e.status,
    createdAt: e.createdAt,
    dueDate: e.dueDate,
    description: e.description,
  );
}
