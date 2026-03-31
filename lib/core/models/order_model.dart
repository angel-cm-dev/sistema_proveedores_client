import 'package:flutter/material.dart';

/// Define los estados posibles de una orden según la lógica de negocio.
enum OrderStatus { procesando, enCamino, entregado }

class OrderModel {
  final String id;
  final String producto;
  final String proveedor;
  final int cantidad;
  final double total;
  final String fecha;
  final OrderStatus estado;

  OrderModel({
    required this.id,
    required this.producto,
    required this.proveedor,
    required this.cantidad,
    required this.total,
    required this.fecha,
    required this.estado,
  });

  /// Retorna el color representativo según el estado de la orden.
  /// Centralizar esto aquí cumple con el principio de responsabilidad única.
  Color get statusColor {
    switch (estado) {
      case OrderStatus.entregado:
        return Colors.green;
      case OrderStatus.enCamino:
        return Colors.blue;
      case OrderStatus.procesando:
        return Colors.orange;
    }
  }

  /// Retorna la etiqueta legible para la interfaz de usuario.
  String get estadoLabel {
    switch (estado) {
      case OrderStatus.entregado:
        return "Entregado";
      case OrderStatus.enCamino:
        return "En Camino";
      case OrderStatus.procesando:
        return "Procesando";
    }
  }

  // Senior Tip: En el futuro, aquí podrías agregar un método fromJson
  // para mapear la respuesta de tu API en Laravel automáticamente.
}
