enum OrderStatus { pending, inProgress, completed, delayed }

extension OrderStatusX on OrderStatus {
  String get label => switch (this) {
    OrderStatus.pending => 'Pendiente',
    OrderStatus.inProgress => 'En progreso',
    OrderStatus.completed => 'Completado',
    OrderStatus.delayed => 'Atrasado',
  };
}

class OrderEntity {
  final String id;
  final String supplierId;
  final String supplierName;
  final OrderStatus status;
  final DateTime createdAt;
  final DateTime dueDate;
  final String? description;

  const OrderEntity({
    required this.id,
    required this.supplierId,
    required this.supplierName,
    required this.status,
    required this.createdAt,
    required this.dueDate,
    this.description,
  });

  bool get isOverdue =>
      status != OrderStatus.completed && DateTime.now().isAfter(dueDate);
}
