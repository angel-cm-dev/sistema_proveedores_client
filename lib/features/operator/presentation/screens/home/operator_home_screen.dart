import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/theme/theme_controller.dart';
import '../../../../auth/presentation/controllers/auth_controller.dart';
import '../../../data/datasources/operator_mock_datasource.dart';
import '../../../domain/entities/kpi_entity.dart';
import '../../../domain/entities/order_entity.dart';
import '../../widgets/kpi_card.dart';
import '../../widgets/order_list_item.dart';
import '../../widgets/quick_action_card.dart';
import '../../../../common/presentation/screens/global_search_screen.dart';
import '../../../../common/presentation/screens/notifications_screen.dart';
import '../incidents/incident_form_screen.dart';
import '../incidents/incidents_screen.dart';
import '../orders/order_detail_screen.dart';
import '../orders/orders_screen.dart';

class OperatorHomeScreen extends StatefulWidget {
  const OperatorHomeScreen({super.key});

  @override
  State<OperatorHomeScreen> createState() => _OperatorHomeScreenState();
}

class _OperatorHomeScreenState extends State<OperatorHomeScreen> {
  final _ds = OperatorMockDataSource();
  late final List<KpiEntity> _kpis;
  late final List<OrderEntity> _recentOrders;

  @override
  void initState() {
    super.initState();
    _kpis = _ds.getKpis();
    _recentOrders = _ds.getOrders().take(5).toList();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.read<AuthController>();
    final themeCtrl = context.watch<ThemeController>();
    final isDark = themeCtrl.isDark;
    final user = auth.currentUser;

    final bgColor = isDark ? AppColors.darkBg : AppColors.lightBg;
    final textPrimary = isDark ? AppColors.darkText : AppColors.lightText;
    final textSecondary = isDark
        ? AppColors.darkTextSecondary
        : AppColors.lightTextSecondary;
    final cardColor = isDark ? AppColors.darkCard : AppColors.lightCard;

    final hour = DateTime.now().hour;
    final greeting = hour < 12
        ? 'Buenos días'
        : hour < 18
        ? 'Buenas tardes'
        : 'Buenas noches';

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // ── Header ────────────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                color: cardColor,
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '$greeting,',
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              color: textSecondary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            user?.name.split(' ').first ?? 'Operador',
                            style: GoogleFonts.poppins(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Search
                    IconButton(
                      icon: Icon(
                        Icons.search_rounded,
                        color: textSecondary,
                        size: 22,
                      ),
                      onPressed: () => showSearch(
                        context: context,
                        delegate: GlobalSearchDelegate(),
                      ),
                    ),
                    // Theme toggle
                    IconButton(
                      icon: Icon(
                        isDark
                            ? Icons.light_mode_rounded
                            : Icons.dark_mode_rounded,
                        color: textSecondary,
                        size: 22,
                      ),
                      onPressed: themeCtrl.toggle,
                    ),
                    // Notification bell with badge
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.notifications_none_rounded,
                            color: textSecondary,
                            size: 24,
                          ),
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const NotificationsScreen(),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: AppColors.error,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ],
                    ),
                    // Avatar
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: AppColors.primary.withValues(
                        alpha: 0.15,
                      ),
                      child: Text(
                        user?.initials ?? 'OP',
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SliverToBoxAdapter(child: SizedBox(height: 20)),

            // ── KPIs ─────────────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(left: 20, bottom: 12),
                child: Text(
                  'Resumen del día',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: textPrimary,
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 156,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  physics: const BouncingScrollPhysics(),
                  itemCount: _kpis.length,
                  separatorBuilder: (_, index) => const SizedBox(width: 12),
                  itemBuilder: (_, i) => KpiCard(kpi: _kpis[i]),
                ),
              ),
            ),

            SliverToBoxAdapter(child: SizedBox(height: 24)),

            // ── Quick Actions ─────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Acciones rápidas',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        QuickActionCard(
                          label: 'Nueva incidencia',
                          icon: Icons.bug_report_rounded,
                          color: AppColors.warning,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const IncidentFormScreen(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        QuickActionCard(
                          label: 'Ver incidencias',
                          icon: Icons.list_alt_rounded,
                          color: AppColors.info,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const IncidentsScreen(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        QuickActionCard(
                          label: 'Órdenes críticas',
                          icon: Icons.priority_high_rounded,
                          color: AppColors.error,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const OrdersScreen(
                                initialFilter: OrderStatus.delayed,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            SliverToBoxAdapter(child: SizedBox(height: 24)),

            // ── Recent Orders ─────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Órdenes recientes',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: textPrimary,
                      ),
                    ),
                    TextButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const OrdersScreen()),
                      ),
                      child: Text(
                        'Ver todas',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              sliver: SliverList.builder(
                itemCount: _recentOrders.length,
                itemBuilder: (_, i) => OrderListItem(
                  order: _recentOrders[i],
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          OrderDetailScreen(order: _recentOrders[i]),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
