import 'dart:ui';
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
  final List<MenuItemModel> _exploreMenu = MenuItemModel.menuItems;
  final List<MenuItemModel> _historyMenu = MenuItemModel.menuItems2;
  final List<MenuItemModel> _themeMenu = MenuItemModel.menuItems3;

  late String _selectedMenu;
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _determineInitialSelection();
  }

  /// Determina qué item del menú debe estar resaltado según el índice del Dashboard
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

  void onThemeToggle(bool value) {
    setState(() => _isDarkMode = value);
    _themeMenu[0].riveIcon.status?.change(value);
    HapticFeedback.mediumImpact();
  }

  void onMenuPress(MenuItemModel menu, int index) {
    if (_selectedMenu == menu.title) {
      Navigator.pop(context);
      return;
    }
    setState(() => _selectedMenu = menu.title);
    HapticFeedback.lightImpact();

    if (widget.onTabSelected != null) widget.onTabSelected!(index);

    // Pequeño delay para cerrar el drawer y que se aprecie la animación del item
    Future.delayed(const Duration(milliseconds: 150), () {
      if (mounted && Navigator.canPop(context)) Navigator.pop(context);
    });
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
            // Header con foto y nombre completo (Optimizado)
            _buildProfileHeader(context),

            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    _buildMenuSection(
                        title: "EXPLORAR", items: _exploreMenu, startIndex: 0),
                    _buildMenuSection(
                        title: "HISTORIAL",
                        items: _historyMenu,
                        startIndex: _exploreMenu.length),
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

  // ==========================================
  // HEADER DE PERFIL (VERSIÓN FINAL PULIDA)
  // ==========================================
  Widget _buildProfileHeader(BuildContext context) {
    // Rendimiento Senior: Solo escuchamos cambios en fullName y suscripción
    final userData = context.select<AuthProvider, (String, String)>((auth) => (
          auth.user?.fullName ?? "Angel Castañeda",
          auth.user?.suscripcionTipo ?? "Free"
        ));

    return Padding(
      // Padding derecho de 80px para dar aire al botón de cerrar "X" del dashboard
      padding: const EdgeInsets.fromLTRB(24, 20, 80, 10),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(1.5),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
            ),
            child: const CircleAvatar(
              radius: 18,
              backgroundColor: Colors.white10,
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
                  userData.$1, // Angel Castañeda
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.2,
                  ),
                ),
                Text(
                  "Cliente ${userData.$2}",
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.4),
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
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
              color: Colors.white.withValues(alpha: 0.3),
              fontSize: 11,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.1,
            ),
          ),
        ),
        ...items.asMap().entries.map((entry) {
          final int index = entry.key + startIndex;
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
                menu: entry.value,
                selectedMenu: _selectedMenu,
                onMenuPress: () => onMenuPress(entry.value, index),
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
              width: 28,
              height: 28,
              child: Opacity(
                opacity: 0.6,
                child: RiveAnimation.asset(
                  RiveAssets.icons,
                  artboard: _themeMenu[0].riveIcon.artboard,
                  onInit: onThemeRiveIconInit,
                ),
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                "Modo Oscuro",
                style: TextStyle(
                    color: Colors.white70,
                    fontSize: 15,
                    fontWeight: FontWeight.w600),
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
