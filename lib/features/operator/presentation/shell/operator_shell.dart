import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/theme/theme_controller.dart';
import '../screens/calendar/calendar_screen.dart';
import '../screens/home/operator_home_screen.dart';
import '../screens/orders/orders_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/suppliers/suppliers_screen.dart';

class OperatorShell extends StatefulWidget {
  const OperatorShell({super.key});

  @override
  State<OperatorShell> createState() => _OperatorShellState();
}

class _OperatorShellState extends State<OperatorShell> {
  int _currentIndex = 0;

  static const _screens = [
    OperatorHomeScreen(),
    CalendarScreen(),
    OrdersScreen(),
    SuppliersScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeController>().isDark;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: borderColor, width: 1)),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (i) => setState(() => _currentIndex = i),
          items: [
            BottomNavigationBarItem(
              icon: _NavIcon(
                icon: Icons.home_outlined,
                isSelected: _currentIndex == 0,
              ),
              activeIcon: _NavIcon(icon: Icons.home_rounded, isSelected: true),
              label: 'Inicio',
            ),
            BottomNavigationBarItem(
              icon: _NavIcon(
                icon: Icons.calendar_month_outlined,
                isSelected: _currentIndex == 1,
              ),
              activeIcon: _NavIcon(
                icon: Icons.calendar_month_rounded,
                isSelected: true,
              ),
              label: 'Calendario',
            ),
            BottomNavigationBarItem(
              icon: _NavIcon(
                icon: Icons.receipt_long_outlined,
                isSelected: _currentIndex == 2,
              ),
              activeIcon: _NavIcon(
                icon: Icons.receipt_long_rounded,
                isSelected: true,
              ),
              label: 'Órdenes',
            ),
            BottomNavigationBarItem(
              icon: _NavIcon(
                icon: Icons.store_outlined,
                isSelected: _currentIndex == 3,
              ),
              activeIcon: _NavIcon(icon: Icons.store_rounded, isSelected: true),
              label: 'Proveedores',
            ),
            BottomNavigationBarItem(
              icon: _NavIcon(
                icon: Icons.person_outline_rounded,
                isSelected: _currentIndex == 4,
              ),
              activeIcon: _NavIcon(
                icon: Icons.person_rounded,
                isSelected: true,
              ),
              label: 'Perfil',
            ),
          ],
          selectedLabelStyle: GoogleFonts.inter(
            fontSize: 11,
            fontWeight: FontWeight.w700,
          ),
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
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: isSelected
            ? AppColors.primary.withValues(alpha: 0.12)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Icon(icon, size: 22),
    );
  }
}
