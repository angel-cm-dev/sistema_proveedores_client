import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/theme/theme_controller.dart';
import '../widgets/operator_side_drawer.dart';
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
    final navBg = isDark
        ? const Color(0xFF232D4A).withValues(alpha: 0.92)
        : const Color(0xFF25365E).withValues(alpha: 0.92);

    return Scaffold(
      drawer: OperatorSideDrawer(
        selectedIndex: _currentIndex,
        onNavigate: (i) => setState(() => _currentIndex = i),
      ),
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 18),
        child: Container(
          decoration: BoxDecoration(
            color: navBg,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.18),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavIcon(
                icon: _currentIndex == 0
                    ? Icons.home_rounded
                    : Icons.home_outlined,
                isSelected: _currentIndex == 0,
                onTap: () => setState(() => _currentIndex = 0),
              ),
              _NavIcon(
                icon: _currentIndex == 1
                    ? Icons.calendar_month_rounded
                    : Icons.calendar_month_outlined,
                isSelected: _currentIndex == 1,
                onTap: () => setState(() => _currentIndex = 1),
              ),
              _NavIcon(
                icon: _currentIndex == 2
                    ? Icons.receipt_long_rounded
                    : Icons.receipt_long_outlined,
                isSelected: _currentIndex == 2,
                onTap: () => setState(() => _currentIndex = 2),
              ),
              _NavIcon(
                icon: _currentIndex == 3
                    ? Icons.store_rounded
                    : Icons.store_outlined,
                isSelected: _currentIndex == 3,
                onTap: () => setState(() => _currentIndex = 3),
              ),
              _NavIcon(
                icon: _currentIndex == 4
                    ? Icons.person_rounded
                    : Icons.person_outline_rounded,
                isSelected: _currentIndex == 4,
                onTap: () => setState(() => _currentIndex = 4),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavIcon extends StatelessWidget {
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavIcon({
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        width: 56,
        height: 44,
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.22)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Icon(
          icon,
          size: 22,
          color: isSelected ? const Color(0xFF79B3FF) : Colors.white70,
        ),
      ),
    );
  }
}
