import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:rive/rive.dart';

// --- IMPORTACIONES CORREGIDAS (Rutas reales de tu proyecto) ---
import 'package:sistema_proveedores_client/core/models/menu_item.dart';
import 'package:sistema_proveedores_client/core/assets.dart'; // Sin el 'as app_assets' para ser más directo

class MenuRow extends StatelessWidget {
  const MenuRow({
    Key? key,
    required this.menu,
    this.selectedMenu = "Home",
    this.onMenuPress,
  }) : super(key: key);

  final MenuItemModel menu;
  final String selectedMenu;
  final Function? onMenuPress;

  void _onMenuIconInit(Artboard artboard) {
    final controller = StateMachineController.fromArtboard(
        artboard, menu.riveIcon.stateMachine);
    if (controller != null) {
      artboard.addController(controller);
      menu.riveIcon.status = controller.findInput<bool>("active") as SMIBool;
    }
  }

  void onMenuPressed() {
    if (selectedMenu != menu.title) {
      onMenuPress?.call();
      menu.riveIcon.status?.change(true);
      Future.delayed(const Duration(seconds: 1), () {
        menu.riveIcon.status?.change(false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: selectedMenu == menu.title ? 288 - 16 : 0,
          height: 56,
          curve: const Cubic(0.2, 0.8, 0.2, 1),
          decoration: BoxDecoration(
            color: const Color(0xFF6792FF), // Azul de tu diseño
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        CupertinoButton(
          padding: const EdgeInsets.all(12),
          pressedOpacity: 1,
          onPressed: onMenuPressed,
          child: Row(
            children: [
              SizedBox(
                width: 32,
                height: 32,
                child: Opacity(
                  opacity: selectedMenu == menu.title ? 1 : 0.6,
                  child: RiveAnimation.asset(
                    RiveAssets
                        .icons, // CORRECCIÓN: Usando 'icons' en lugar de 'iconsRiv'
                    artboard: menu.riveIcon.artboard,
                    onInit: _onMenuIconInit,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Text(
                menu.title,
                style: const TextStyle(
                    color: Colors.white,
                    fontFamily: "Inter",
                    fontWeight: FontWeight.w600,
                    fontSize: 17),
              )
            ],
          ),
        ),
      ],
    );
  }
}
