import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/theme_controller.dart';
import '../screens/dashboard/owner_dashboard_screen.dart';
import '../screens/performance/supplier_performance_screen.dart';
import '../screens/profile/owner_profile_screen.dart';
import '../screens/users/users_screen.dart';

class OwnerShell extends StatefulWidget {
  const OwnerShell({super.key});

  @override
  State<OwnerShell> createState() => _OwnerShellState();
}

class _OwnerShellState extends State<OwnerShell> {
  int _currentIndex = 0;

  static const _screens = [
    OwnerDashboardScreen(),
    SupplierPerformanceScreen(),
    UsersScreen(),
    OwnerProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeController>().isDark;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: borderColor, width: 1)),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (i) => setState(() => _currentIndex = i),
          items: [
            BottomNavigationBarItem(
              icon: _NavIcon(icon: Icons.dashboard_outlined, isSelected: _currentIndex == 0),
              activeIcon: _NavIcon(icon: Icons.dashboard_rounded, isSelected: true),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: _NavIcon(icon: Icons.leaderboard_outlined, isSelected: _currentIndex == 1),
              activeIcon: _NavIcon(icon: Icons.leaderboard_rounded, isSelected: true),
              label: 'Rendimiento',
            ),
            BottomNavigationBarItem(
              icon: _NavIcon(icon: Icons.people_outline_rounded, isSelected: _currentIndex == 2),
              activeIcon: _NavIcon(icon: Icons.people_rounded, isSelected: true),
              label: 'Usuarios',
            ),
            BottomNavigationBarItem(
              icon: _NavIcon(icon: Icons.person_outline_rounded, isSelected: _currentIndex == 3),
              activeIcon: _NavIcon(icon: Icons.person_rounded, isSelected: true),
              label: 'Perfil',
            ),
          ],
          selectedLabelStyle: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700),
          unselectedLabelStyle: GoogleFonts.inter(fontSize: 11),
          type: BottomNavigationBarType.fixed,
          elevation: 0,
        ),
      ),
    );
  }
}

class _NavIcon extends StatelessWidget {
  final IconData icon;
  final bool isSelected;

  const _NavIcon({required this.icon, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    if (!isSelected) return Icon(icon);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.secondary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon),
    );
  }
}
