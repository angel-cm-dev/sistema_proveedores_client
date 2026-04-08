import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart' hide LinearGradient;
import 'package:provider/provider.dart';

import 'package:sistema_proveedores_client/core/assets.dart';
import 'package:sistema_proveedores_client/features/auth/providers/auth_provider.dart';
import 'package:sistema_proveedores_client/shared/widgets/custom_tab_bar.dart';
import 'package:sistema_proveedores_client/shared/widgets/side_menu.dart';

import 'package:sistema_proveedores_client/features/suppliers/widgets/home_tab_view.dart';
import 'package:sistema_proveedores_client/features/suppliers/widgets/supplier_search_tab_view.dart';
import 'package:sistema_proveedores_client/features/orders/widgets/order_history_tab_view.dart';
import 'package:sistema_proveedores_client/features/notifications/widgets/notification_list_tab_view.dart';
import 'package:sistema_proveedores_client/features/profile/widgets/profile_tab_view.dart';

class ClientDashboard extends StatefulWidget {
  const ClientDashboard({super.key});

  @override
  State<ClientDashboard> createState() => _ClientDashboardState();
}

class _ClientDashboardState extends State<ClientDashboard>
    with TickerProviderStateMixin {
  static const double _sidebarWidth = 288.0;
  static const double _menuButtonOffset = 220.0;

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
    )..addListener(() {
        if (_isMenuOpenInput != null) {
          bool isMenuOpen = _sidebarAnimController.value > 0.5;
          // FIX DEFINITIVO: Tu archivo Rive requiere TRUE para Hamburguesa y FALSE para X.
          bool targetRiveValue = !isMenuOpen;

          if (_isMenuOpenInput!.value != targetRiveValue) {
            _isMenuOpenInput!.value = targetRiveValue;
          }
        }
      });

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

  void _onMenuIconInit(Artboard artboard) {
    final controller =
        StateMachineController.fromArtboard(artboard, "State Machine");
    if (controller != null) {
      artboard.addController(controller);
      _isMenuOpenInput = controller.findInput<bool>("isOpen") as SMIBool?;
      // Como empieza cerrado, forzamos TRUE (que en tu archivo es Hamburguesa)
      _isMenuOpenInput?.value = true;
    }
  }

  void _toggleMenu() {
    if (_sidebarAnimController.isAnimating) return;
    if (_sidebarAnimController.isDismissed) {
      _sidebarAnimController.forward();
    } else {
      _sidebarAnimController.reverse();
    }
    HapticFeedback.mediumImpact();
  }

  void _handleTabChange(int index) {
    if (_selectedTabIndex == index) {
      if (!_sidebarAnimController.isDismissed) _sidebarAnimController.reverse();
      return;
    }

    setState(() => _selectedTabIndex = index);

    if (!_sidebarAnimController.isDismissed) {
      _sidebarAnimController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final String userDisplayName = context.select<AuthProvider, String>(
        (auth) => auth.user?.fullName ?? "Invitado");

    return Scaffold(
      extendBody: true,
      backgroundColor: const Color(0xFF17203A),
      body: Stack(
        children: [
          _buildSidebarLayer(),
          _buildMainBodyLayer(userDisplayName),
          _buildMenuButtonLayer(),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildSidebarLayer() {
    return AnimatedBuilder(
      animation: _sidebarAnim,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(_sidebarWidth * (_sidebarAnim.value - 1), 0),
          child: child,
        );
      },
      child: SideMenu(
        currentIndex: _selectedTabIndex,
        onTabSelected: _handleTabChange,
      ),
    );
  }

  Widget _buildMainBodyLayer(String userName) {
    return AnimatedBuilder(
      animation: _sidebarAnim,
      builder: (context, child) {
        final double scale = 1 - (_sidebarAnim.value * 0.12);
        final double translation = _sidebarAnim.value * 265;
        final double rotation = (_sidebarAnim.value * 30) * math.pi / 180;

        return Transform.translate(
          offset: Offset(translation, 0),
          child: Transform.scale(
            scale: scale,
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
        color: const Color(0xFFF7F9FC),
        child: Stack(
          children: [
            const RiveAnimation.asset(RiveAssets.shapes, fit: BoxFit.cover),
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
                child: Container(color: Colors.white.withValues(alpha: 0.4)),
              ),
            ),
            Positioned.fill(
              child: IndexedStack(
                index: _selectedTabIndex,
                children: [
                  HomeTabView(userName: userName),
                  const SupplierSearchTabView(),
                  const OrderHistoryTabView(),
                  const NotificationListTabView(),
                  const ProfileTabView(),
                ],
              ),
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
            width: 48,
            height: 48,
            margin: const EdgeInsets.only(left: 16, top: 12),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                    color: Colors.black26, blurRadius: 10, offset: Offset(0, 5))
              ],
            ),
            child: RiveAnimation.asset(RiveAssets.menuButton,
                onInit: _onMenuIconInit),
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
        child: CustomTabBar(
          selectedIndex: _selectedTabIndex,
          onTabChange: _handleTabChange,
        ),
      ),
    );
  }
}
