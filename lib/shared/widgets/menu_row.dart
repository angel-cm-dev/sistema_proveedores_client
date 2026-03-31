import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:rive/rive.dart';

// --- CORE & MODELS ---
import 'package:sistema_proveedores_client/core/models/menu_item.dart';
import 'package:sistema_proveedores_client/core/assets.dart';

class MenuRow extends StatelessWidget {
  const MenuRow({
    super.key, // Usando super parameters (Dart 3+)
    required this.menu,
    this.selectedMenu = "Home",
    this.onMenuPress,
  });

  final MenuItemModel menu;
  final String selectedMenu;
  final VoidCallback? onMenuPress; // Cambiado a VoidCallback para mejor tipado

  /// Inicializa la animación de Rive
  void _onMenuIconInit(Artboard artboard) {
    final controller = StateMachineController.fromArtboard(
        artboard, menu.riveIcon.stateMachine);
    if (controller != null) {
      artboard.addController(controller);
      menu.riveIcon.status = controller.findInput<bool>("active") as SMIBool?;
    }
  }

  /// Lógica al presionar: Dispara animación y Redireccionamiento
  void onMenuPressed() {
    // Si la pestaña ya está seleccionada, no hacemos nada (Optimización)
    if (selectedMenu == menu.title) return;

    // 1. DISPARAR REDIRECCIÓN: Ejecuta la función que viene del SideMenu
    // Esto es lo que mandará al Dashboard a la pestaña 0, 1, 2, etc.
    if (onMenuPress != null) {
      onMenuPress!();
    }

    // 2. ANIMACIÓN VISUAL: Activa el trigger de Rive
    menu.riveIcon.status?.change(true);
    Future.delayed(const Duration(seconds: 1), () {
      menu.riveIcon.status?.change(false);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Variable para saber si este item es el activo
    final bool isActive = selectedMenu == menu.title;

    return Stack(
      children: [
        // --- DISEÑO: Fondo azul de selección ---
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: isActive ? 288 - 16 : 0,
          height: 56,
          curve: const Cubic(0.2, 0.8, 0.2, 1),
          decoration: BoxDecoration(
            color: const Color(0xFF6792FF),
            borderRadius: BorderRadius.circular(
                15), // Un poco más redondeado para el look premium
          ),
        ),

        // --- INTERACCIÓN: Botón invisible encima ---
        CupertinoButton(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          pressedOpacity: 0.7, // Feedback al presionar
          onPressed: onMenuPressed,
          child: Row(
            children: [
              // Icono animado
              SizedBox(
                width: 32,
                height: 32,
                child: Opacity(
                  opacity: isActive ? 1 : 0.6,
                  child: RiveAnimation.asset(
                    RiveAssets.icons,
                    artboard: menu.riveIcon.artboard,
                    onInit: _onMenuIconInit,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              // Texto del Menú
              Text(
                menu.title,
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: "Inter",
                    fontWeight: isActive ? FontWeight.bold : FontWeight.w600,
                    fontSize: 17),
              )
            ],
          ),
        ),
      ],
    );
  }
}
