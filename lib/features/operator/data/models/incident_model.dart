import '../../domain/entities/incident_entity.dart';

/// Data model for [IncidentEntity] with JSON serialization.
class IncidentModel extends IncidentEntity {
  const IncidentModel({
    required super.id,
    required super.orderId,
    required super.orderCode,
    required super.supplierName,
    required super.title,
    required super.description,
    required super.status,
    required super.priority,
    required super.createdAt,
    required super.reportedBy,
    required super.timeline,
    super.resolvedAt,
  });

  factory IncidentModel.fromJson(Map<String, dynamic> json) {
    return IncidentModel(
      id: json['id'] as String,
      orderId: json['order_id'] as String,
      orderCode: json['order_code'] as String,
      supplierName: json['supplier_name'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      status: _parseStatus(json['status'] as String),
      priority: _parsePriority(json['priority'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
      reportedBy: json['reported_by'] as String,
      resolvedAt: json['resolved_at'] != null
          ? DateTime.parse(json['resolved_at'] as String)
          : null,
      timeline: (json['timeline'] as List<dynamic>?)
              ?.map((e) => IncidentEventModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'order_id': orderId,
    'order_code': orderCode,
    'supplier_name': supplierName,
    'title': title,
    'description': description,
    'status': status.name,
    'priority': priority.name,
    'created_at': createdAt.toIso8601String(),
    'reported_by': reportedBy,
    'resolved_at': resolvedAt?.toIso8601String(),
    'timeline': timeline.map((e) => {
      'description': e.description,
      'timestamp': e.timestamp.toIso8601String(),
      'author': e.author,
    }).toList(),
  };

  static IncidentStatus _parseStatus(String value) => switch (value) {
    'inProgress' || 'in_progress' => IncidentStatus.inProgress,
    'resolved' => IncidentStatus.resolved,
    'closed' => IncidentStatus.closed,
    _ => IncidentStatus.open,
  };

  static IncidentPriority _parsePriority(String value) => switch (value) {
    'medium' => IncidentPriority.medium,
    'high' => IncidentPriority.high,
    'critical' => IncidentPriority.critical,
    _ => IncidentPriority.low,
  };
}

class IncidentEventModel extends IncidentEvent {
  const IncidentEventModel({
    required super.description,
    required super.timestamp,
    required super.author,
  });

  factory IncidentEventModel.fromJson(Map<String, dynamic> json) {
    return IncidentEventModel(
      description: json['description'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      author: json['author'] as String,
    );
  }
}
