import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart' hide LinearGradient;

// --- CORE & ASSETS ---
import 'package:sistema_proveedores_client/core/assets.dart';

// --- WIDGETS ---
import 'package:sistema_proveedores_client/presentation/auth/widgets/custom_tab_bar.dart';
import 'package:sistema_proveedores_client/presentation/auth/widgets/home_tab_view.dart';
import 'package:sistema_proveedores_client/presentation/auth/widgets/side_menu.dart';

class ClientDashboard extends StatefulWidget {
  const ClientDashboard({super.key});

  @override
  State<ClientDashboard> createState() => _ClientDashboardState();
}

class _ClientDashboardState extends State<ClientDashboard>
    with TickerProviderStateMixin {
  // --- Constantes de Configuración (Clean Code) ---
  static const double _sidebarWidth = 288.0;
  static const double _menuButtonOffset = 216.0;
  static const Duration _animDuration = Duration(milliseconds: 200);

  // Colores de contraste (Sugerencia: Blanco para resaltar tarjetas)
  static const Color _lightBgColor = Color(0xFFF7F9FC);

  // --- Controladores de Animación ---
  late final AnimationController _sidebarAnimController;
  late final Animation<double> _sidebarAnim;
  SMIBool? _isMenuOpenInput;

  // --- Estado de Navegación ---
  int _selectedTabIndex = 0;

  // Física de resorte para el efecto elástico premium
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

  // --- Lógica de Rive (Menú) ---
  void _onMenuIconInit(Artboard artboard) {
    final controller =
        StateMachineController.fromArtboard(artboard, "State Machine");
    if (controller != null) {
      artboard.addController(controller);
      _isMenuOpenInput = controller.findInput<bool>("isOpen") as SMIBool;
      _isMenuOpenInput?.value = true;
    }
  }

  // --- Lógica de Interfaz ---
  void _toggleMenu() {
    if (_isMenuOpenInput == null) return;

    if (_isMenuOpenInput!.value) {
      _sidebarAnimController
          .animateWith(SpringSimulation(_springDesc, 0, 1, 0));
    } else {
      _sidebarAnimController.reverse();
    }

    _isMenuOpenInput!.change(!_isMenuOpenInput!.value);
    HapticFeedback.mediumImpact();

    // Ajuste dinámico de iconos de barra de estado según visibilidad del menú
    SystemChrome.setSystemUIOverlayStyle(_isMenuOpenInput!.value
        ? SystemUiOverlayStyle.dark
        : SystemUiOverlayStyle.light);
  }

  void _onTabChanged(int index) => setState(() => _selectedTabIndex = index);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: _lightBgColor, // CAMBIO: Fondo claro para contraste
      body: Stack(
        children: [
          // 1. CAPA: SIDEBAR (Se oculta/muestra por la izquierda)
          _buildSidebarLayer(),

          // 2. CAPA: CUERPO PRINCIPAL (Con transformación 3D y Glassmorphism)
          _buildMainBodyLayer(),

          // 3. CAPA: BOTÓN DE MENÚ (Superior)
          _buildMenuButtonLayer(),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  // --- COMPONENTES MODULARIZADOS (SOLID: Responsabilidad Única) ---

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
              ..setEntry(3, 2, 0.001)
              ..rotateY(rotation)
              ..setTranslationRaw(translation, 0, 0),
            child: child,
          );
        },
        child: FadeTransition(
          opacity: _sidebarAnim,
          child: const SideMenu(),
        ),
      ),
    );
  }

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
                    ignoring: _sidebarAnim.value > 0.5,
                    child: child,
                  ),
                ),
              ),
            ),
          );
        },
        child: Stack(
          children: [
            // A. Fondo Animado Rive (Formas sutiles sobre blanco)
            const RiveAnimation.asset(
              RiveAssets.shapes,
              fit: BoxFit.cover,
            ),

            // B. Capa de Desenfoque (Efecto Glassmorphism Claro)
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
                child: Container(
                  color: Colors.white.withValues(alpha: 0.45),
                ),
              ),
            ),

            // C. Contenido reactivo
            IndexedStack(
              index: _selectedTabIndex,
              children: [
                const HomeTabView(), // Fondo transparente por dentro
                _buildPlaceholderTab("Directorio de Proveedores"),
                _buildPlaceholderTab("Seguimiento de Órdenes"),
                _buildPlaceholderTab("Centro de Notificaciones"),
                _buildPlaceholderTab("Configuración de Perfil"),
              ],
            ),
          ],
        ),
      ),
    );
  }

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
        offset: Offset(0, _sidebarAnim.value * 300),
        child: child,
      ),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 24),
        child: CustomTabBar(onTabChange: _onTabChanged),
      ),
    );
  }

  Widget _buildPlaceholderTab(String title) {
    return Center(
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.black87, // CAMBIO: Texto oscuro para fondo claro
          fontSize: 22,
          fontWeight: FontWeight.bold,
          fontFamily: "Poppins",
        ),
      ),
    );
  }
}
