import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart' hide LinearGradient;

// Core
import 'package:sistema_proveedores_client/core/auth_provider.dart';
import 'package:sistema_proveedores_client/core/assets.dart';

// Widgets (RUTAS CORREGIDAS SEGÚN TU ESTRUCTURA REAL EN /auth/widgets/)
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
  // Controladores de Animación
  late AnimationController? _sidebarAnimController;
  late Animation<double> _sidebarAnim;
  SMIBool? _menuBtn;

  int _selectedTabIndex = 0;
  late Widget _currentTabBody;

  // Física de resorte para un efecto "Premium"
  final springDesc = const SpringDescription(
    mass: 0.1,
    stiffness: 40,
    damping: 5,
  );

  @override
  void initState() {
    super.initState();

    _currentTabBody = const HomeTabView();

    _sidebarAnimController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _sidebarAnim = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      parent: _sidebarAnimController!,
      curve: Curves.linear,
    ));
  }

  @override
  void dispose() {
    _sidebarAnimController?.dispose();
    super.dispose();
  }

  void _onMenuIconInit(Artboard artboard) {
    // Nombre interno de la máquina de estados en menu_button.riv
    final controller =
        StateMachineController.fromArtboard(artboard, "State Machine");
    if (controller != null) {
      artboard.addController(controller);
      _menuBtn = controller.findInput<bool>("isOpen") as SMIBool;
      _menuBtn?.value = true;
    }
  }

  void toggleMenu() {
    if (_menuBtn != null) {
      if (_menuBtn!.value) {
        final springAnim = SpringSimulation(springDesc, 0, 1, 0);
        _sidebarAnimController?.animateWith(springAnim);
      } else {
        _sidebarAnimController?.reverse();
      }
      _menuBtn!.change(!_menuBtn!.value);
    }

    HapticFeedback.mediumImpact();

    SystemChrome.setSystemUIOverlayStyle(_menuBtn?.value ?? true
        ? SystemUiOverlayStyle.dark
        : SystemUiOverlayStyle.light);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: const Color(0xFF17203A),
      body: Stack(
        children: [
          // 1. SIDEBAR (Capa trasera)
          RepaintBoundary(
            child: AnimatedBuilder(
              animation: _sidebarAnim,
              builder: (context, child) {
                return Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.001)
                    ..rotateY(((1 - _sidebarAnim.value) * -30) * math.pi / 180)
                    // CORRECCIÓN: Usamos translationValues para evitar el deprecado 'translate'
                    ..setTranslationRaw((1 - _sidebarAnim.value) * -300, 0, 0),
                  child: child,
                );
              },
              child: FadeTransition(
                opacity: _sidebarAnim,
                child: const SideMenu(),
              ),
            ),
          ),

          // 2. CUERPO PRINCIPAL (Con rotación 3D)
          RepaintBoundary(
            child: AnimatedBuilder(
              animation: _sidebarAnim,
              builder: (context, child) {
                return Transform.scale(
                  scale: 1 - (_sidebarAnim.value * 0.1),
                  child: Transform.translate(
                    offset: Offset(_sidebarAnim.value * 265, 0),
                    child: Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.identity()
                        ..setEntry(3, 2, 0.001)
                        ..rotateY((_sidebarAnim.value * 30) * math.pi / 180),
                      child: ClipRRect(
                        borderRadius:
                            BorderRadius.circular(_sidebarAnim.value * 30),
                        child: child,
                      ),
                    ),
                  ),
                );
              },
              child: Stack(
                children: [
                  const RiveAnimation.asset(
                    RiveAssets.shapes,
                    fit: BoxFit.cover,
                  ),
                  Positioned.fill(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                      child: const SizedBox(),
                    ),
                  ),
                  _currentTabBody,
                ],
              ),
            ),
          ),

          // 3. BOTÓN FLOTANTE
          SafeArea(
            child: AnimatedBuilder(
              animation: _sidebarAnim,
              builder: (context, child) {
                return Row(
                  children: [
                    SizedBox(width: _sidebarAnim.value * 216),
                    child!,
                  ],
                );
              },
              child: GestureDetector(
                onTap: toggleMenu,
                child: Container(
                  width: 44,
                  height: 44,
                  margin: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black12,
                          blurRadius: 5,
                          offset: Offset(0, 5))
                    ],
                  ),
                  child: RiveAnimation.asset(
                    RiveAssets.menuButton,
                    onInit: _onMenuIconInit,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: AnimatedBuilder(
        animation: _sidebarAnim,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, _sidebarAnim.value * 300),
            child: child,
          );
        },
        child: CustomTabBar(
          onTabChange: (index) {
            setState(() {
              _selectedTabIndex = index;
              switch (index) {
                case 0:
                  _currentTabBody = const HomeTabView();
                  break;
                default:
                  _currentTabBody = Center(
                    child: Text(
                      "Sección $index",
                      style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                    ),
                  );
              }
            });
          },
        ),
      ),
    );
  }
}
