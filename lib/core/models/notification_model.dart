import 'package:flutter/material.dart';

enum NotificationType { pedido, promocion, sistema }

class NotificationModel {
  final String id;
  final String title;
  final String body;
  final DateTime timestamp;
  final NotificationType type;
  bool isRead;

  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.timestamp,
    required this.type,
    this.isRead = false,
  });

  // Helper para obtener el icono según el tipo
  IconData get icon {
    switch (type) {
      case NotificationType.pedido:
        return Icons.local_shipping_outlined;
      case NotificationType.promocion:
        return Icons.sell_outlined;
      case NotificationType.sistema:
        return Icons.info_outline;
    }
  }

  // Helper para el color del icono
  Color get color {
    switch (type) {
      case NotificationType.pedido:
        return Colors.blue;
      case NotificationType.promocion:
        return Colors.orange;
      case NotificationType.sistema:
        return Colors.teal;
    }
  }
}
