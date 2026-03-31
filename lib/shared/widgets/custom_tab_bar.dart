import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart' hide LinearGradient;

// --- IMPORTACIONES CORREGIDAS PARA TU PROYECTO ---
import 'package:sistema_proveedores_client/core/models/tab_item.dart';
import 'package:sistema_proveedores_client/core/theme.dart';
import 'package:sistema_proveedores_client/core/assets.dart' as app_assets;

class CustomTabBar extends StatefulWidget {
  // ignore: use_super_parameters
  const CustomTabBar({Key? key, required this.onTabChange}) : super(key: key);

  final Function(int tabIndex) onTabChange;

  @override
  State<CustomTabBar> createState() => _CustomTabBarState();
}

class _CustomTabBarState extends State<CustomTabBar> {
  // Usamos la lista estática definida en tu modelo TabItem
  final List<TabItem> _icons = TabItem.tabItemsList;

  int _selectedTab = 0;

  void _onRiveIconInit(Artboard artboard, int index) {
    final controller = StateMachineController.fromArtboard(
        artboard, _icons[index].stateMachine);
    if (controller != null) {
      artboard.addController(controller);
      // Vinculamos el input "active" de la State Machine de Rive
      _icons[index].status = controller.findInput<bool>("active") as SMIBool;
    }
  }

  void onTabPress(int index) {
    if (_selectedTab != index) {
      setState(() {
        _selectedTab = index;
      });
      widget.onTabChange(index);

      // Disparamos la animación de Rive
      _icons[index].status?.change(true);
      Future.delayed(const Duration(seconds: 1), () {
        _icons[index].status?.change(false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.fromLTRB(24, 0, 24, 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          // ignore: deprecated_member_use
          color: RiveAppTheme.background2.withOpacity(0.8),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              // ignore: deprecated_member_use
              color: RiveAppTheme.background2.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 20),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(_icons.length, (index) {
            final icon = _icons[index];
            return GestureDetector(
              onTap: () => onTabPress(index),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Indicador superior animado
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.only(bottom: 2),
                    height: 4,
                    width: _selectedTab == index ? 20 : 0,
                    decoration: BoxDecoration(
                      color: RiveAppTheme.accentColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  // Icono de Rive
                  SizedBox(
                    height: 36,
                    width: 36,
                    child: Opacity(
                      opacity: _selectedTab == index ? 1 : 0.5,
                      child: RiveAnimation.asset(
                        app_assets
                            .RiveAssets.icons, // Usando tu clase assets.dart
                        artboard: icon.artboard,
                        onInit: (artboard) => _onRiveIconInit(artboard, index),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
