import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart';

// --- CORE & MODELS ---
import 'package:sistema_proveedores_client/core/models/menu_item.dart';
import 'package:sistema_proveedores_client/core/assets.dart';
import 'package:sistema_proveedores_client/core/theme.dart';
import 'package:sistema_proveedores_client/features/auth/providers/auth_provider.dart';

// --- IMPORTANTE: Verifica que esta ruta coincida con la tuya ---
import 'package:sistema_proveedores_client/features/support/screens/help_support_screen.dart';

import 'menu_row.dart';

class SideMenu extends StatefulWidget {
  final Function(int)? onTabSelected;
  final int currentIndex;

  const SideMenu({
    super.key,
    this.onTabSelected,
    this.currentIndex = 0,
  });

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  late List<MenuItemModel> _mainNavMenu;
  late MenuItemModel _helpItem;
  late String _selectedMenu;
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _initializeSafeMenus();
    _determineInitialSelection();
  }

  // ==========================================
  // FIX DEFINITIVO: ESCUCHA ACTIVA AL DASHBOARD
  // ==========================================
  @override
  void didUpdateWidget(covariant SideMenu oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Si la barra inferior (a través del Dashboard) nos manda un nuevo índice:
    if (widget.currentIndex != oldWidget.currentIndex) {
      setState(() {
        _determineInitialSelection(); // Actualiza el botón azul (highlight)
      });
    }
  }

  void _initializeSafeMenus() {
    final list1 = MenuItemModel.menuItems;
    final list2 = MenuItemModel.menuItems2;

    final fallbackIcon = list1.isNotEmpty
        ? list1[0].riveIcon
        : MenuItemModel.menuItems[0].riveIcon;

    _mainNavMenu = [
      MenuItemModel(
          title: "Inicio",
          riveIcon: list1.isNotEmpty ? list1[0].riveIcon : fallbackIcon),
      MenuItemModel(
          title: "Directorio",
          riveIcon: list1.length > 1 ? list1[1].riveIcon : fallbackIcon),
      MenuItemModel(
          title: "Mis Órdenes",
          riveIcon: list2.isNotEmpty ? list2[0].riveIcon : fallbackIcon),
      MenuItemModel(
          title: "Notificaciones",
          riveIcon: list2.length > 1 ? list2[1].riveIcon : fallbackIcon),
      MenuItemModel(
          title: "Perfil",
          riveIcon: list2.length > 2 ? list2[2].riveIcon : fallbackIcon),
    ];

    _helpItem = MenuItemModel(
      title: "Ayuda y Soporte",
      riveIcon: fallbackIcon,
    );
  }

  void _determineInitialSelection() {
    if (widget.currentIndex < _mainNavMenu.length) {
      _selectedMenu = _mainNavMenu[widget.currentIndex].title;
    } else {
      _selectedMenu = "Inicio";
    }
  }

  void _handleNavigation(MenuItemModel menu, int? index) {
    setState(() => _selectedMenu = menu.title);
    HapticFeedback.lightImpact();

    if (index != null && index >= 0 && index < 5) {
      if (widget.onTabSelected != null) {
        widget.onTabSelected!(index);
      }
    } else if (menu.title == "Ayuda y Soporte") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HelpSupportScreen()),
      );
    }
    // NOTA: Eliminamos el Future.delayed con el Navigator.pop
    // porque el ClientDashboard ya se encarga de cerrar la animación 3D.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RiveAppTheme.background2,
      body: Container(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top,
          bottom: MediaQuery.of(context).padding.bottom,
        ),
        constraints: const BoxConstraints(maxWidth: 288),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileHeader(context),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    _buildMenuSection(
                        title: "EXPLORAR", items: _mainNavMenu, isTab: true),
                    _buildSupportSection(),
                  ],
                ),
              ),
            ),
            _buildDarkModeToggle(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    final userData = context.select<AuthProvider, (String, String)>((auth) => (
          auth.user?.fullName ?? "Angel Castañeda",
          auth.user?.suscripcionTipo ?? "Free"
        ));

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 80, 10),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 18,
            backgroundImage: AssetImage(
                'assets/samples/ui/rive_app/images/avatars/avatar_1.jpg'),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userData.$1,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      fontFamily: "Poppins"),
                ),
                Text("Cliente ${userData.$2}",
                    style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.4),
                        fontSize: 11))
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuSection(
      {required String title,
      required List<MenuItemModel> items,
      required bool isTab}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 24, top: 32, bottom: 8),
          child: Text(title,
              style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.3),
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.1)),
        ),
        ...items.asMap().entries.map((entry) {
          return MenuRow(
            menu: entry.value,
            selectedMenu: _selectedMenu,
            onMenuPress: () =>
                _handleNavigation(entry.value, isTab ? entry.key : null),
          );
        }),
      ],
    );
  }

  Widget _buildSupportSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 24, top: 32, bottom: 8),
          child: Text("SOPORTE",
              style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.3),
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.1)),
        ),
        MenuRow(
          menu: _helpItem,
          selectedMenu: _selectedMenu,
          onMenuPress: () => _handleNavigation(_helpItem, null),
        ),
      ],
    );
  }

  Widget _buildDarkModeToggle() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.1),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            const Icon(Icons.dark_mode_outlined,
                color: Colors.white60, size: 24),
            const SizedBox(width: 12),
            const Expanded(
                child: Text("Modo Oscuro",
                    style: TextStyle(
                        color: Colors.white70,
                        fontSize: 15,
                        fontWeight: FontWeight.w600))),
            CupertinoSwitch(
              value: _isDarkMode,
              onChanged: (v) => setState(() => _isDarkMode = v),
              activeTrackColor: const Color(0xFF6792FF),
            ),
          ],
        ),
      ),
    );
  }
}
