import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart' hide LinearGradient;

// --- IMPORTACIONES DEL PROYECTO ---
import 'package:sistema_proveedores_client/core/models/tab_item.dart';
import 'package:sistema_proveedores_client/core/theme.dart';
import 'package:sistema_proveedores_client/core/assets.dart' as app_assets;

class CustomTabBar extends StatefulWidget {
  final Function(int tabIndex) onTabChange;
  final int
      selectedIndex; // Parámetro para recibir el índice actual desde el padre

  const CustomTabBar({
    super.key,
    required this.onTabChange,
    this.selectedIndex = 0, // Valor por defecto
  });

  @override
  State<CustomTabBar> createState() => _CustomTabBarState();
}

class _CustomTabBarState extends State<CustomTabBar> {
  // Lista de iconos Rive para la barra inferior
  final List<TabItem> _icons = TabItem.tabItemsList;

  // Estado interno de la selección
  late int _selectedTab;

  @override
  void initState() {
    super.initState();
    // Inicializamos el estado interno con el valor que manda el padre
    _selectedTab = widget.selectedIndex;
  }

  // --- LA MAGIA DE LA SINCRONIZACIÓN ---
  // Este método se ejecuta si el widget padre (ClientDashboard) cambia sus parámetros.
  // Es crucial para que la barra se mueva si tocamos el SideMenu.
  @override
  void didUpdateWidget(covariant CustomTabBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedIndex != oldWidget.selectedIndex) {
      setState(() {
        _selectedTab = widget.selectedIndex;
      });
      // Animamos el nuevo icono seleccionado
      _triggerRiveAnimation(_selectedTab);
    }
  }

  void _onRiveIconInit(Artboard artboard, int index) {
    final controller = StateMachineController.fromArtboard(
        artboard, _icons[index].stateMachine);
    if (controller != null) {
      artboard.addController(controller);
      // Vinculamos el input "active"
      _icons[index].status = controller.findInput<bool>("active") as SMIBool;
    }
  }

  void _triggerRiveAnimation(int index) {
    _icons[index].status?.change(true);
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        _icons[index].status?.change(false);
      }
    });
  }

  void onTabPress(int index) {
    if (_selectedTab != index) {
      setState(() {
        _selectedTab = index;
      });
      // Avisamos al padre (Dashboard) del cambio
      widget.onTabChange(index);
      // Disparamos la animación del icono clickeado
      _triggerRiveAnimation(index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.fromLTRB(24, 0, 24, 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: RiveAppTheme.background2
              .withValues(alpha: 0.8), // Updated to withValues
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: RiveAppTheme.background2
                  .withValues(alpha: 0.3), // Updated to withValues
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
                  // Indicador superior (La línea azul)
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeInOut, // Curva suave añadida
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
                    child: AnimatedOpacity(
                      // Usar AnimatedOpacity mejora la transición
                      duration: const Duration(milliseconds: 200),
                      opacity: _selectedTab == index ? 1.0 : 0.5,
                      child: RiveAnimation.asset(
                        app_assets.RiveAssets.icons,
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
