import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart' hide LinearGradient;
import 'package:provider/provider.dart';

// --- CORE & ASSETS ---
import 'package:sistema_proveedores_client/core/assets.dart';
import 'package:sistema_proveedores_client/features/auth/providers/auth_provider.dart';

// --- SHARED WIDGETS ---
import 'package:sistema_proveedores_client/shared/widgets/custom_tab_bar.dart';
import 'package:sistema_proveedores_client/shared/widgets/side_menu.dart';

// --- FEATURE TABS ---
import 'package:sistema_proveedores_client/features/suppliers/widgets/home_tab_view.dart';
import 'package:sistema_proveedores_client/features/suppliers/widgets/supplier_search_tab_view.dart';
import 'package:sistema_proveedores_client/features/orders/widgets/order_history_tab_view.dart';
import 'package:sistema_proveedores_client/features/notifications/widgets/notification_list_tab_view.dart';
import 'package:sistema_proveedores_client/features/profile/widgets/profile_tab_view.dart';

/// [ClientDashboard] - Arquitectura 3D Inmersiva.
/// Controla la navegación principal y la animación del menú lateral.
class ClientDashboard extends StatefulWidget {
  const ClientDashboard({super.key});

  @override
  State<ClientDashboard> createState() => _ClientDashboardState();
}

class _ClientDashboardState extends State<ClientDashboard>
    with TickerProviderStateMixin {
  // ==========================================
  // CONFIGURACIÓN DE UI & ANIMACIÓN
  // ==========================================
  static const double _sidebarWidth = 288.0;
  static const double _menuButtonOffset = 220.0;
  static const Duration _tabTransitionDuration = Duration(milliseconds: 400);

  late final AnimationController _sidebarAnimController;
  late final Animation<double> _sidebarAnim;
  SMIBool? _isMenuOpenInput;

  int _selectedTabIndex = 0;

  @override
  void initState() {
    super.initState();

    _sidebarAnimController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    // Curva de suavizado profesional
    _sidebarAnim = CurvedAnimation(
      parent: _sidebarAnimController,
      curve: Curves.easeInOutQuart,
    );
  }

  @override
  void dispose() {
    _sidebarAnimController.dispose();
    super.dispose();
  }

  // ==========================================
  // LÓGICA DE INTERACCIÓN (RIVE & FEEDBACK)
  // ==========================================

  void _onMenuIconInit(Artboard artboard) {
    final controller =
        StateMachineController.fromArtboard(artboard, "State Machine");
    if (controller != null) {
      artboard.addController(controller);
      _isMenuOpenInput = controller.findInput<bool>("isOpen") as SMIBool;
      _isMenuOpenInput?.value = true;
    }
  }

  void _toggleMenu() {
    if (_isMenuOpenInput == null) return;

    if (_isMenuOpenInput!.value) {
      // Física Premium: Rebote elástico al abrir
      _sidebarAnimController.animateWith(
        SpringSimulation(
          const SpringDescription(mass: 0.1, stiffness: 45, damping: 6),
          0,
          1,
          0,
        ),
      );
    } else {
      _sidebarAnimController.reverse();
    }

    _isMenuOpenInput!.change(!_isMenuOpenInput!.value);
    HapticFeedback.mediumImpact();
  }

  void _onTabChanged(int index) {
    if (_selectedTabIndex == index) return;
    setState(() => _selectedTabIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    // Rendimiento Senior: Selección reactiva del nombre
    final String userDisplayName = context.select<AuthProvider, String>((auth) {
      return auth.user?.fullName ?? "Invitado";
    });

    return Scaffold(
      extendBody: true,
      backgroundColor:
          const Color(0xFF17203A), // Color de fondo del menú lateral
      body: Stack(
        children: [
          // CAPA 1: SideMenu (Fondo)
          _buildSidebarLayer(),

          // CAPA 2: Contenido con Transformación 3D (Z-Index Medio)
          _buildMainBodyLayer(userDisplayName),

          // CAPA 3: Botón de Menú Rive (Z-Index Superior)
          _buildMenuButtonLayer(),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  // ==========================================
  // CONSTRUCCIÓN DE CAPAS (WIDGET BUILDERS)
  // ==========================================

  Widget _buildSidebarLayer() {
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _sidebarAnim,
        builder: (context, child) {
          final double translation = (1 - _sidebarAnim.value) * -_sidebarWidth;
          return Transform.translate(
            offset: Offset(translation, 0),
            child: child,
          );
        },
        child: SideMenu(
          currentIndex: _selectedTabIndex,
          onTabSelected: (index) {
            _onTabChanged(index);
            _toggleMenu();
          },
        ),
      ),
    );
  }

  Widget _buildMainBodyLayer(String userName) {
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _sidebarAnim,
        builder: (context, child) {
          final double scale = 1 - (_sidebarAnim.value * 0.12);
          final double translation = _sidebarAnim.value * 265;
          final double rotation = (_sidebarAnim.value * 30) * math.pi / 180;

          return Transform.scale(
            scale: scale,
            child: Transform.translate(
              offset: Offset(translation, 0),
              child: Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..rotateY(rotation),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(_sidebarAnim.value * 35),
                  child: IgnorePointer(
                    ignoring: _sidebarAnim.value > 0.5,
                    child: child,
                  ),
                ),
              ),
            ),
          );
        },
        child: Container(
          color: const Color(0xFFF7F9FC), // Color de fondo de la app
          child: Stack(
            children: [
              // Background Animado
              const RiveAnimation.asset(RiveAssets.shapes, fit: BoxFit.cover),

              // Glassmorphism Overlay
              Positioned.fill(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
                  child: Container(color: Colors.white.withValues(alpha: 0.45)),
                ),
              ),

              // Gestor de Pestañas
              AnimatedSwitcher(
                duration: _tabTransitionDuration,
                switchInCurve: Curves.easeOutQuart,
                switchOutCurve: Curves.easeInQuart,
                child: _getTabContent(_selectedTabIndex, userName),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuButtonLayer() {
    return SafeArea(
      child: AnimatedBuilder(
        animation: _sidebarAnim,
        builder: (context, child) => Padding(
          padding: EdgeInsets.only(
            left: _sidebarAnim.value * _menuButtonOffset,
          ),
          child: child,
        ),
        child: GestureDetector(
          onTap: _toggleMenu,
          child: Container(
            width: 50,
            height: 50,
            margin: const EdgeInsets.only(left: 16, top: 12),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                    color: Colors.black26, blurRadius: 10, offset: Offset(0, 5))
              ],
            ),
            child: RiveAnimation.asset(
              RiveAssets.menuButton,
              onInit: _onMenuIconInit,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return AnimatedBuilder(
      animation: _sidebarAnim,
      builder: (context, child) => Transform.translate(
        offset:
            Offset(0, _sidebarAnim.value * 200), // Se oculta al abrir el menú
        child: child,
      ),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 24),
        child: CustomTabBar(onTabChange: _onTabChanged),
      ),
    );
  }

  // ==========================================
  // GESTOR DE ESTADOS DE VISTA
  // ==========================================

  Widget _getTabContent(int index, String name) {
    // El uso de ValueKey es obligatorio para que AnimatedSwitcher detecte el cambio
    switch (index) {
      case 0:
        return HomeTabView(key: const ValueKey(0), userName: name);
      case 1:
        return const SupplierSearchTabView(key: ValueKey(1));
      case 2:
        return const OrderHistoryTabView(key: ValueKey(2));
      case 3:
        return const NotificationListTabView(key: ValueKey(3));
      case 4:
        return const ProfileTabView(key: ValueKey(4));
      default:
        return HomeTabView(userName: name);
    }
  }
}
