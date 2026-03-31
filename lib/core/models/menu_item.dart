import 'package:flutter/material.dart';
import 'package:sistema_proveedores_client/core/models/tab_item.dart';

/// Modelo para los ítems del Menú Lateral (Drawer/SideMenu).
/// Senior Tip: Mantenemos la inmutabilidad y la consistencia con TabItem.
class MenuItemModel {
  final String title;
  final TabItem riveIcon;
  final UniqueKey id;

  MenuItemModel({
    required this.title,
    required this.riveIcon,
  }) : id = UniqueKey();

  // --- SECCIÓN: EXPLORAR (Discovery) ---
  static final List<MenuItemModel> menuItems = [
    MenuItemModel(
      title: "Inicio",
      riveIcon: TabItem(
        title: "Inicio",
        artboard: "HOME",
        stateMachine: "HOME_interactivity",
      ),
    ),
    MenuItemModel(
      title: "Proveedores",
      riveIcon: TabItem(
        title: "Proveedores",
        artboard: "SEARCH",
        stateMachine: "SEARCH_Interactivity",
      ),
    ),
    MenuItemModel(
      title: "Favoritos",
      riveIcon: TabItem(
        title: "Favoritos",
        artboard: "LIKE/STAR",
        stateMachine: "STAR_Interactivity",
      ),
    ),
    MenuItemModel(
      title: "Ayuda",
      riveIcon: TabItem(
        title: "Ayuda",
        artboard: "CHAT",
        stateMachine: "CHAT_Interactivity",
      ),
    ),
  ];

  // --- SECCIÓN: HISTORIAL (Operational) ---
  static final List<MenuItemModel> menuItems2 = [
    MenuItemModel(
      title: "Mis Evaluaciones",
      riveIcon: TabItem(
        title: "Mis Evaluaciones",
        artboard: "CHAT",
        stateMachine: "CHAT_Interactivity",
      ),
    ),
    MenuItemModel(
      title: "Historial Pagos",
      riveIcon: TabItem(
        title: "Historial Pagos",
        artboard: "TIMER",
        stateMachine: "TIMER_Interactivity",
      ),
    ),
  ];

  // --- SECCIÓN: CONFIGURACIÓN ---
  static final List<MenuItemModel> menuItems3 = [
    MenuItemModel(
      title: "Modo Oscuro",
      riveIcon: TabItem(
        title: "Modo Oscuro",
        artboard: "SETTINGS",
        stateMachine: "SETTINGS_Interactivity",
      ),
    ),
  ];
}
