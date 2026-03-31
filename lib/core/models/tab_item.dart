import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

/// Representa un ítem de navegación en la barra inferior.
/// Senior Tip: Usamos 'final' para garantizar la inmutabilidad del modelo.
class TabItem {
  final String title;
  final String artboard;
  final String stateMachine;
  final UniqueKey id;

  /// El input de la máquina de estados de Rive (SMIBool).
  /// Se inicializa externamente cuando el Artboard se carga.
  SMIBool? status;

  TabItem({
    required this.title,
    required this.artboard,
    required this.stateMachine,
  }) : id = UniqueKey();

  /// Sincronización con las Entidades de tu Diagrama ER:
  /// 1. Inicio -> Categorías
  /// 2. Buscar -> Productos/Marketplace
  /// 3. Historial -> VentasProveedor (Órdenes)
  /// 4. Alertas -> Notificaciones del Sistema
  /// 5. Perfil -> Usuarios (Mi Cuenta)
  static List<TabItem> tabItemsList = [
    TabItem(
      title: "Inicio",
      artboard: "CHAT", // Icono de burbujas para interacción inicial
      stateMachine: "CHAT_Interactivity",
    ),
    TabItem(
      title: "Explorar",
      artboard: "SEARCH", // Lupa para búsqueda de productos
      stateMachine: "SEARCH_Interactivity",
    ),
    TabItem(
      title: "Órdenes",
      artboard: "TIMER", // Reloj para historial de pedidos/ventas
      stateMachine: "TIMER_Interactivity",
    ),
    TabItem(
      title: "Alertas",
      artboard: "BELL", // Campana para notificaciones
      stateMachine: "BELL_Interactivity",
    ),
    TabItem(
      title: "Perfil",
      artboard: "USER", // Usuario para gestión de cuenta
      stateMachine: "USER_Interactivity",
    ),
  ];
}
