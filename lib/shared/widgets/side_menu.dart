import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart';

// --- CORE & MODELS ---
import 'package:sistema_proveedores_client/core/models/menu_item.dart';
import 'package:sistema_proveedores_client/core/assets.dart';
import 'package:sistema_proveedores_client/core/theme.dart';

// --- FEATURES ---
import 'package:sistema_proveedores_client/features/auth/providers/auth_provider.dart';

// --- WIDGETS ---
import 'menu_row.dart';

class SideMenu extends StatefulWidget {
  final Function(int)? onTabSelected; // Callback para cambiar de pestaña
  final int currentIndex; // Pestaña activa actualmente

  const SideMenu({
    super.key,
    this.onTabSelected,
    this.currentIndex = 0,
  });

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  final List<MenuItemModel> _exploreMenu =
      MenuItemModel.menuItems; // Inicio, Proveedores
  final List<MenuItemModel> _historyMenu =
      MenuItemModel.menuItems2; // Órdenes, Notif, Perfil
  final List<MenuItemModel> _themeMenu = MenuItemModel.menuItems3;

  late String _selectedMenu;
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    // Determinamos qué texto debe estar resaltado al abrir el menú
    _determineInitialSelection();
  }

  void _determineInitialSelection() {
    if (widget.currentIndex < _exploreMenu.length) {
      _selectedMenu = _exploreMenu[widget.currentIndex].title;
    } else {
      int historyIndex = widget.currentIndex - _exploreMenu.length;
      if (historyIndex < _historyMenu.length) {
        _selectedMenu = _historyMenu[historyIndex].title;
      } else {
        _selectedMenu = _exploreMenu[0].title;
      }
    }
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

  /// Lógica de Navegación Centralizada
  void onMenuPress(MenuItemModel menu, int index) {
    if (_selectedMenu == menu.title) {
      Navigator.pop(context); // Solo cerramos si ya estamos ahí
      return;
    }

    setState(() => _selectedMenu = menu.title);

    // Feedback háptico premium
    HapticFeedback.lightImpact();

    // 1. Ejecutamos la navegación del Dashboard
    if (widget.onTabSelected != null) {
      widget.onTabSelected!(index);
    }

    // 2. Cerramos el drawer con una pequeña demora para que se vea la animación del botón
    Future.delayed(const Duration(milliseconds: 150), () {
      if (mounted && Navigator.canPop(context)) {
        Navigator.pop(context);
      }
    });
  }

  void onThemeToggle(bool value) {
    setState(() => _isDarkMode = value);
    _themeMenu[0].riveIcon.status?.change(value);
    HapticFeedback.mediumImpact();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final user = auth.user;

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
            _buildProfileHeader(user?.nombre, user?.suscripcionTipo),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    _buildMenuSection(
                      title: "EXPLORAR",
                      items: _exploreMenu,
                      startIndex: 0, // Inicio (0), Proveedores (1)
                    ),
                    _buildMenuSection(
                      title: "HISTORIAL",
                      items: _historyMenu,
                      startIndex: _exploreMenu
                          .length, // Órdenes (2), Notif (3), Perfil (4)
                    ),
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

  Widget _buildProfileHeader(String? nombre, String? suscripcion) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
            ),
            child: const CircleAvatar(
              radius: 22,
              backgroundImage: AssetImage(
                  'assets/samples/ui/rive_app/images/avatars/avatar_1.jpg'),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nombre ?? "Angel Castañeda",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Cliente ${suscripcion ?? 'Premium'}",
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.5),
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

  Widget _buildMenuSection(
      {required String title,
      required List<MenuItemModel> items,
      required int startIndex}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding:
              const EdgeInsets.only(left: 24, right: 24, top: 32, bottom: 8),
          child: Text(
            title,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.4),
              fontSize: 13,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.5,
            ),
          ),
        ),
        ...items.asMap().entries.map((entry) {
          int index = entry.key + startIndex;
          MenuItemModel menu = entry.value;
          return Column(
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
                selectedMenu: _selectedMenu,
                onMenuPress: () => onMenuPress(menu, index),
              ),
            ],
          );
        }),
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
                  color: Colors.white70,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            CupertinoSwitch(
              value: _isDarkMode,
              onChanged: onThemeToggle,
              activeTrackColor: const Color(0xFF6792FF),
            ),
          ],
        ),
      ),
    );
  }
}
