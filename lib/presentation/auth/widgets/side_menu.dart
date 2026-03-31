import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Para conectar con tu Auth
import 'package:rive/rive.dart';

// --- IMPORTACIONES CORREGIDAS (Rutas de tu proyecto) ---
import 'package:sistema_proveedores_client/core/auth_provider.dart';
import 'package:sistema_proveedores_client/core/models/menu_item.dart';
import 'package:sistema_proveedores_client/core/theme.dart';
import 'package:sistema_proveedores_client/core/assets.dart';
import 'menu_row.dart'; // Ruta relativa al estar en la misma carpeta

class SideMenu extends StatefulWidget {
  const SideMenu({Key? key}) : super(key: key);

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  // Cargamos los datos desde el modelo MenuItemModel que corregimos
  final List<MenuItemModel> _browseMenuIcons = MenuItemModel.menuItems;
  final List<MenuItemModel> _historyMenuIcons = MenuItemModel.menuItems2;

  // Asumimos que el toggle de tema es el primer ítem de la lista 3
  final List<MenuItemModel> _themeMenuIcon = MenuItemModel.menuItems3;

  String _selectedMenu = MenuItemModel.menuItems[0].title;
  bool _isDarkMode = false;

  /// Inicializa la animación de Rive para el switch de modo oscuro
  void onThemeRiveIconInit(Artboard artboard) {
    final controller = StateMachineController.fromArtboard(
        artboard, _themeMenuIcon[0].riveIcon.stateMachine);
    if (controller != null) {
      artboard.addController(controller);
      _themeMenuIcon[0].riveIcon.status =
          controller.findInput<bool>("active") as SMIBool;
    }
  }

  void onMenuPress(MenuItemModel menu) {
    setState(() {
      _selectedMenu = menu.title;
    });
    // Aquí podrías agregar la navegación real si fuera necesario
  }

  void onThemeToggle(bool value) {
    setState(() {
      _isDarkMode = value;
    });
    _themeMenuIcon[0].riveIcon.status?.change(value);
  }

  @override
  Widget build(BuildContext context) {
    // Obtenemos la información real del usuario logueado
    final auth = context.watch<AuthProvider>();
    final user = auth.user;

    return Container(
      padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top,
          bottom: MediaQuery.of(context).padding.bottom),
      constraints: const BoxConstraints(maxWidth: 288),
      decoration: BoxDecoration(
        color: RiveAppTheme.background2,
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // CABECERA: Información Real del Usuario
          Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white.withOpacity(0.2),
                  foregroundColor: Colors.white,
                  child: const Icon(Icons.person_outline),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user?.name ?? "Angel Castañeda",
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Inter"),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        auth.isPremium ? "Premium Client" : "Free Client",
                        style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 13,
                            fontFamily: "Inter"),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),

          // SECCIONES DE MENÚ (Desplazables)
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  MenuButtonSection(
                      title: "BROWSE",
                      selectedMenu: _selectedMenu,
                      menuIcons: _browseMenuIcons,
                      onMenuPress: onMenuPress),
                  MenuButtonSection(
                      title: "HISTORY",
                      selectedMenu: _selectedMenu,
                      menuIcons: _historyMenuIcons,
                      onMenuPress: onMenuPress),
                ],
              ),
            ),
          ),

          // FOOTER: Modo Oscuro
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(children: [
              SizedBox(
                width: 32,
                height: 32,
                child: Opacity(
                  opacity: 0.6,
                  child: RiveAnimation.asset(
                    RiveAssets.icons, // Usando tu clase centralizada
                    artboard: _themeMenuIcon[0].riveIcon.artboard,
                    onInit: onThemeRiveIconInit,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  _themeMenuIcon[0].title,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontFamily: "Inter",
                      fontWeight: FontWeight.w600),
                ),
              ),
              CupertinoSwitch(value: _isDarkMode, onChanged: onThemeToggle),
            ]),
          )
        ],
      ),
    );
  }
}

class MenuButtonSection extends StatelessWidget {
  const MenuButtonSection(
      {Key? key,
      required this.title,
      required this.menuIcons,
      this.selectedMenu = "Home",
      this.onMenuPress})
      : super(key: key);

  final String title;
  final String selectedMenu;
  final List<MenuItemModel> menuIcons;
  final Function(MenuItemModel menu)? onMenuPress;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding:
              const EdgeInsets.only(left: 24, right: 24, top: 40, bottom: 8),
          child: Text(
            title,
            style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 15,
                fontFamily: "Inter",
                fontWeight: FontWeight.w600),
          ),
        ),
        Container(
          margin: const EdgeInsets.all(8),
          child: Column(
            children: [
              for (var menu in menuIcons) ...[
                Divider(
                    color: Colors.white.withOpacity(0.1),
                    thickness: 1,
                    height: 1,
                    indent: 16,
                    endIndent: 16),
                MenuRow(
                  menu: menu,
                  selectedMenu: selectedMenu,
                  onMenuPress: () => onMenuPress?.call(menu),
                ),
              ]
            ],
          ),
        ),
      ],
    );
  }
}
