import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// SOLUCIÓN: Este es el import que faltaba para corregir el error de HapticFeedback
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart';

// --- CORE & MODELS ---
import 'package:sistema_proveedores_client/core/auth_provider.dart';
import 'package:sistema_proveedores_client/core/models/menu_item.dart';
import 'package:sistema_proveedores_client/core/theme.dart';
import 'package:sistema_proveedores_client/core/assets.dart';

// --- WIDGETS ---
import 'menu_row.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({super.key});

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  final List<MenuItemModel> _exploreMenu = MenuItemModel.menuItems;
  final List<MenuItemModel> _historyMenu = MenuItemModel.menuItems2;
  final List<MenuItemModel> _themeMenu = MenuItemModel.menuItems3;

  late String _selectedMenu;
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _selectedMenu = _exploreMenu[0].title;
  }

  void onThemeRiveIconInit(Artboard artboard) {
    final controller = StateMachineController.fromArtboard(
        artboard, _themeMenu[0].riveIcon.stateMachine);

    if (controller != null) {
      artboard.addController(controller);
      _themeMenu[0].riveIcon.status =
          controller.findInput<bool>("active") as SMIBool;
    }
  }

  void onMenuPress(MenuItemModel menu) {
    if (_selectedMenu == menu.title) return;

    setState(() => _selectedMenu = menu.title);
    // Ahora funciona correctamente gracias al import de services.dart
    HapticFeedback.lightImpact();

    debugPrint("Navegando a: ${menu.title}");
  }

  void onThemeToggle(bool value) {
    setState(() => _isDarkMode = value);

    _themeMenu[0].riveIcon.status?.change(value);
    // Ahora funciona correctamente
    HapticFeedback.mediumImpact();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final user = auth.user;

    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top,
        bottom: MediaQuery.of(context).padding.bottom,
      ),
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
          _buildProfileHeader(user?.nombre, user?.suscripcionTipo),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  MenuButtonSection(
                    title: "EXPLORAR", // Traducido
                    selectedMenu: _selectedMenu,
                    menuIcons: _exploreMenu,
                    onMenuPress: onMenuPress,
                  ),
                  MenuButtonSection(
                    title: "HISTORIAL", // Traducido
                    selectedMenu: _selectedMenu,
                    menuIcons: _historyMenu,
                    onMenuPress: onMenuPress,
                  ),
                ],
              ),
            ),
          ),
          _buildDarkModeToggle(),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(String? nombre, String? suscripcion) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.white.withValues(alpha: 0.2),
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
                  nombre ?? "Usuario Invitado",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Cliente ${suscripcion ?? 'Free'}",
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.7),
                    fontSize: 14,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDarkModeToggle() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          SizedBox(
            width: 32,
            height: 32,
            child: Opacity(
              opacity: 0.6,
              child: RiveAnimation.asset(
                RiveAssets.icons,
                artboard: _themeMenu[0].riveIcon.artboard,
                onInit: onThemeRiveIconInit,
              ),
            ),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Text(
              "Modo Oscuro",
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          CupertinoSwitch(
            value: _isDarkMode,
            onChanged: onThemeToggle,
            activeColor: const Color(0xFF6792FF),
          ),
        ],
      ),
    );
  }
}

class MenuButtonSection extends StatelessWidget {
  const MenuButtonSection({
    super.key,
    required this.title,
    required this.menuIcons,
    required this.selectedMenu,
    this.onMenuPress,
  });

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
              const EdgeInsets.only(left: 24, right: 24, top: 32, bottom: 8),
          child: Text(
            title,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 14,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
            ),
          ),
        ),
        ...menuIcons.map((menu) => Column(
              children: [
                Divider(
                  color: Colors.white.withValues(alpha: 0.05),
                  thickness: 1,
                  height: 1,
                  indent: 24,
                  endIndent: 24,
                ),
                MenuRow(
                  menu: menu,
                  selectedMenu: selectedMenu,
                  onMenuPress: () => onMenuPress?.call(menu),
                ),
              ],
            )),
      ],
    );
  }
}
