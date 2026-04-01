enum IncidentStatus { open, inProgress, resolved, closed }

enum IncidentPriority { low, medium, high, critical }

extension IncidentStatusX on IncidentStatus {
  String get label => switch (this) {
    IncidentStatus.open => 'Abierta',
    IncidentStatus.inProgress => 'En atención',
    IncidentStatus.resolved => 'Resuelta',
    IncidentStatus.closed => 'Cerrada',
  };
}

extension IncidentPriorityX on IncidentPriority {
  String get label => switch (this) {
    IncidentPriority.low => 'Baja',
    IncidentPriority.medium => 'Media',
    IncidentPriority.high => 'Alta',
    IncidentPriority.critical => 'Crítica',
  };
}

class IncidentEntity {
  final String id;
  final String orderId;
  final String orderCode;
  final String supplierName;
  final String title;
  final String description;
  final IncidentStatus status;
  final IncidentPriority priority;
  final DateTime createdAt;
  final DateTime? resolvedAt;
  final String reportedBy;
  final List<IncidentEvent> timeline;

  const IncidentEntity({
    required this.id,
    required this.orderId,
    required this.orderCode,
    required this.supplierName,
    required this.title,
    required this.description,
    required this.status,
    required this.priority,
    required this.createdAt,
    required this.reportedBy,
    required this.timeline,
    this.resolvedAt,
  });

  bool get isOpen =>
      status == IncidentStatus.open || status == IncidentStatus.inProgress;
}

class IncidentEvent {
  final String description;
  final DateTime timestamp;
  final String author;

  const IncidentEvent({
    required this.description,
    required this.timestamp,
    required this.author,
  });
}
