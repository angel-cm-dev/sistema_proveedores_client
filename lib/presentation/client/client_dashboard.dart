import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart' hide LinearGradient;

// --- 1. CORE & ASSETS ---
import 'package:sistema_proveedores_client/core/assets.dart';

// --- 2. SHARED WIDGETS (Componentes Globales de UI) ---
import 'package:sistema_proveedores_client/shared/widgets/custom_tab_bar.dart';
import 'package:sistema_proveedores_client/shared/widgets/side_menu.dart';

// --- 3. FEATURE WIDGETS (Lógica de Negocio por Dominio) ---
import 'package:sistema_proveedores_client/features/suppliers/widgets/home_tab_view.dart';
import 'package:sistema_proveedores_client/features/suppliers/widgets/supplier_search_tab_view.dart';
import 'package:sistema_proveedores_client/features/orders/widgets/order_history_tab_view.dart';
import 'package:sistema_proveedores_client/features/notifications/widgets/notification_list_tab_view.dart';
import 'package:sistema_proveedores_client/features/profile/widgets/profile_tab_view.dart';

/// [ClientDashboard] actúa como el Shell (caparazón) de la aplicación para clientes.
/// Implementa una arquitectura de capas (Stack) para manejar transformaciones 3D.
class ClientDashboard extends StatefulWidget {
  const ClientDashboard({super.key});

  @override
  State<ClientDashboard> createState() => _ClientDashboardState();
}

class _ClientDashboardState extends State<ClientDashboard>
    with TickerProviderStateMixin {
  // ==========================================
  // CONFIGURACIÓN Y CONSTANTES DE DISEÑO
  // ==========================================
  static const double _sidebarWidth = 288.0;
  static const double _menuButtonOffset = 216.0;
  static const Duration _animDuration = Duration(milliseconds: 200);
  static const Color _lightBgColor = Color(0xFFF7F9FC); // Fondo claro premium

  // ==========================================
  // CONTROLADORES DE ANIMACIÓN Y ESTADO
  // ==========================================
  late final AnimationController _sidebarAnimController;
  late final Animation<double> _sidebarAnim;
  SMIBool? _isMenuOpenInput; // Control de estado para el icono Rive

  int _selectedTabIndex =
      0; // Índice que controla el IndexedStack/AnimatedSwitcher

  // Física de resorte para el efecto elástico premium (Senior UX)
  static const _springDesc = SpringDescription(
    mass: 0.1,
    stiffness: 40,
    damping: 5,
  );

  @override
  void initState() {
    super.initState();

    _sidebarAnimController = AnimationController(
      duration: _animDuration,
      vsync: this,
    );

    _sidebarAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _sidebarAnimController, curve: Curves.linear),
    );
  }

  @override
  void dispose() {
    _sidebarAnimController.dispose();
    super.dispose();
  }

  // ==========================================
  // LÓGICA DE INTERACCIÓN (RIVE & SISTEMA)
  // ==========================================

  /// Inicializa la máquina de estados del botón de menú
  void _onMenuIconInit(Artboard artboard) {
    final controller =
        StateMachineController.fromArtboard(artboard, "State Machine");
    if (controller != null) {
      artboard.addController(controller);
      _isMenuOpenInput = controller.findInput<bool>("isOpen") as SMIBool;
      _isMenuOpenInput?.value = true; // Sincronización inicial
    }
  }

  /// Gestiona la apertura/cierre del menú con transformaciones 3D y feedback táctil
  void _toggleMenu() {
    if (_isMenuOpenInput == null) return;

    if (_isMenuOpenInput!.value) {
      // Aplicamos simulación física para el rebote elástico
      _sidebarAnimController
          .animateWith(SpringSimulation(_springDesc, 0, 1, 0));
    } else {
      _sidebarAnimController.reverse();
    }

    _isMenuOpenInput!.change(!_isMenuOpenInput!.value);
    HapticFeedback.mediumImpact(); // Feedback profesional al interactuar

    // Cambia el brillo de la barra de estado según la visibilidad del menú
    SystemChrome.setSystemUIOverlayStyle(_isMenuOpenInput!.value
        ? SystemUiOverlayStyle.dark
        : SystemUiOverlayStyle.light);
  }

  void _onTabChanged(int index) => setState(() => _selectedTabIndex = index);

  // ==========================================
  // CONSTRUCCIÓN DEL ÁRBOL DE WIDGETS
  // ==========================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true, // Crucial para que el contenido pase por debajo
      backgroundColor: _lightBgColor,
      body: Stack(
        children: [
          _buildSidebarLayer(), // CAPA 1: Menú lateral (Z-Index Inferior)
          _buildMainBodyLayer(), // CAPA 2: Contenido 3D (Z-Index Medio)
          _buildMenuButtonLayer(), // CAPA 3: Botón de hamburguesa (Z-Index Superior)
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  // ==========================================
  // CAPAS MODULARIZADAS (Mantenibilidad)
  // ==========================================

  /// [CAPA 1] Renderiza el SideMenu con rotación y desplazamiento negativo
  Widget _buildSidebarLayer() {
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _sidebarAnim,
        builder: (context, child) {
          final double translation = (1 - _sidebarAnim.value) * -_sidebarWidth;
          final double rotation =
              ((1 - _sidebarAnim.value) * -30) * math.pi / 180;

          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001) // Perspectiva 3D
              ..rotateY(rotation)
              ..setTranslationRaw(translation, 0, 0),
            child: child,
          );
        },
        child: FadeTransition(
          opacity: _sidebarAnim,
          // --- REDIRECCIÓN INTEGRADA AQUÍ ---
          child: SideMenu(
            currentIndex: _selectedTabIndex,
            onTabSelected: (index) {
              if (_selectedTabIndex != index) {
                _onTabChanged(index); // Cambia la pestaña
              }
              _toggleMenu(); // Cierra el menú lateral con la animación elástica
            },
          ),
        ),
      ),
    );
  }

  /// [CAPA 2] Contenido Principal: Fondo Rive + Glassmorphism + Vistas de Pestañas
  Widget _buildMainBodyLayer() {
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _sidebarAnim,
        builder: (context, child) {
          final double scale = 1 - (_sidebarAnim.value * 0.1);
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
                  borderRadius: BorderRadius.circular(_sidebarAnim.value * 30),
                  child: IgnorePointer(
                    ignoring: _sidebarAnim.value >
                        0.5, // Bloquea toques si el menú está abierto
                    child: child,
                  ),
                ),
              ),
            ),
          );
        },
        child: Stack(
          children: [
            // A. Fondo Animado (Rive)
            const RiveAnimation.asset(RiveAssets.shapes, fit: BoxFit.cover),

            // B. Capa Glassmorphism (Desenfoque dinámico)
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
                child: Container(color: Colors.white.withValues(alpha: 0.45)),
              ),
            ),

            // C. TRANSICIÓN CORPORATIVA: AnimatedSwitcher
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              switchInCurve: Curves.easeInOutCubic,
              switchOutCurve: Curves.easeInOutCubic,
              transitionBuilder: (Widget child, Animation<double> animation) {
                return FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, 0.02),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  ),
                );
              },
              child: _getTabContent(_selectedTabIndex),
            ),
          ],
        ),
      ),
    );
  }

  /// [CAPA 3] Botón flotante para activar el SideMenu
  Widget _buildMenuButtonLayer() {
    return SafeArea(
      child: AnimatedBuilder(
        animation: _sidebarAnim,
        builder: (context, child) => Padding(
          padding:
              EdgeInsets.only(left: _sidebarAnim.value * _menuButtonOffset),
          child: child,
        ),
        child: GestureDetector(
          onTap: _toggleMenu,
          child: Container(
            width: 44,
            height: 44,
            margin: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                    color: Colors.black12, blurRadius: 8, offset: Offset(0, 5))
              ],
            ),
            child: RiveAnimation.asset(RiveAssets.menuButton,
                onInit: _onMenuIconInit),
          ),
        ),
      ),
    );
  }

  /// Barra inferior personalizada con animación de ocultamiento
  Widget _buildBottomNavigationBar() {
    return AnimatedBuilder(
      animation: _sidebarAnim,
      builder: (context, child) => Transform.translate(
        offset: Offset(0, _sidebarAnim.value * 300), // Se oculta al abrir
        child: child,
      ),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 24),
        child: CustomTabBar(onTabChange: _onTabChanged),
      ),
    );
  }

  // ==========================================
  // GESTOR DE VISTAS (Lógica de Pestañas)
  // ==========================================

  Widget _getTabContent(int index) {
    switch (index) {
      case 0:
        return const HomeTabView(key: ValueKey(0));
      case 1:
        return const SupplierSearchTabView(key: ValueKey(1));
      case 2:
        return const OrderHistoryTabView(key: ValueKey(2));
      case 3:
        return const NotificationListTabView(key: ValueKey(3));
      case 4:
        return const ProfileTabView(key: ValueKey(4));
      default:
        return const HomeTabView(key: ValueKey(0));
    }
  }
}
