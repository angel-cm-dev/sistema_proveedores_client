import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/theme/theme_controller.dart';
import '../../../../auth/presentation/controllers/auth_controller.dart';
import '../../../data/datasources/operator_mock_datasource.dart';
import '../../../domain/entities/kpi_entity.dart';
import '../../../domain/entities/order_entity.dart';
import '../../../domain/entities/supplier_entity.dart';
import '../../widgets/kpi_card.dart';
import '../../widgets/operator_side_drawer.dart';
import '../../widgets/order_list_item.dart';
import '../../widgets/quick_action_card.dart';
import '../../../../common/presentation/screens/global_search_screen.dart';
import '../../../../common/presentation/screens/notifications_screen.dart';
import '../incidents/incident_form_screen.dart';
import '../incidents/incidents_screen.dart';
import '../orders/order_detail_screen.dart';
import '../orders/orders_screen.dart';
import '../suppliers/supplier_detail_screen.dart';

class OperatorHomeScreen extends StatefulWidget {
  const OperatorHomeScreen({super.key});

  @override
  State<OperatorHomeScreen> createState() => _OperatorHomeScreenState();
}

class _OperatorHomeScreenState extends State<OperatorHomeScreen> {
  final _ds = OperatorMockDataSource();
  late final List<KpiEntity> _kpis;
  late final List<OrderEntity> _recentOrders;
  late final List<SupplierEntity> _featuredSuppliers;

  @override
  void initState() {
    super.initState();
    _kpis = _ds.getKpis();
    _recentOrders = _ds.getOrders().take(5).toList();
    _featuredSuppliers = _ds.getSuppliers()
      ..sort((a, b) => b.complianceScore.compareTo(a.complianceScore));
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
    final surfaceColor = isDark ? AppColors.darkCard : AppColors.lightCard;

    final hour = DateTime.now().hour;
    final greeting = hour < 12
        ? 'Buenos días'
        : hour < 18
        ? 'Buenas tardes'
        : 'Buenas noches';

    return Scaffold(
      drawer: const OperatorSideDrawer(selectedIndex: 0),
      backgroundColor: bgColor,
      body: Stack(
        children: [
          Positioned(
            top: -120,
            right: -60,
            child: _BackdropGlow(
              color: AppColors.primary.withValues(alpha: isDark ? 0.20 : 0.18),
              size: 250,
            ),
          ),
          Positioned(
            top: 190,
            left: -80,
            child: _BackdropGlow(
              color: AppColors.info.withValues(alpha: isDark ? 0.16 : 0.15),
              size: 220,
            ),
          ),
          SafeArea(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // ── Header ──────────────────────────────────────────────
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(14, 16, 20, 8),
                    child: Row(
                      children: [
                        Builder(
                          builder: (context) => Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: isDark
                                  ? Colors.white.withValues(alpha: 0.08)
                                  : Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.06),
                                  blurRadius: 10,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: IconButton(
                              icon: Icon(
                                Icons.menu_rounded,
                                color: isDark
                                    ? Colors.white
                                    : AppColors.lightText,
                              ),
                              onPressed: () =>
                                  Scaffold.of(context).openDrawer(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
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
                                  fontSize: 28,
                                  fontWeight: FontWeight.w800,
                                  color: textPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
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
                      ],
                    ),
                  ),
                ),

                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 14),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Panel de control de proveedor',
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              color: textSecondary,
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: surfaceColor,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isDark
                                  ? AppColors.darkBorder
                                  : AppColors.lightBorder,
                            ),
                          ),
                          child: IconButton(
                            icon: Icon(
                              Icons.search_rounded,
                              color: textSecondary,
                              size: 20,
                            ),
                            onPressed: () => showSearch(
                              context: context,
                              delegate: GlobalSearchDelegate(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // ── KPIs ───────────────────────────────────────────────
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

                SliverToBoxAdapter(child: SizedBox(height: 22)),

                // ── Featured suppliers ─────────────────────────────────
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                    child: Row(
                      children: [
                        Text(
                          'Proveedores clave',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: textPrimary,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '${_featuredSuppliers.take(4).length} activos',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 198,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      physics: const BouncingScrollPhysics(),
                      itemCount: _featuredSuppliers.take(4).length,
                      separatorBuilder: (_, index) => const SizedBox(width: 12),
                      itemBuilder: (_, i) {
                        final supplier = _featuredSuppliers[i];
                        return _SupplierHighlightCard(
                          supplier: supplier,
                          index: i,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  SupplierDetailScreen(supplier: supplier),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                SliverToBoxAdapter(child: SizedBox(height: 24)),

                // ── Quick Actions ──────────────────────────────────────
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

                // ── Recent Orders ───────────────────────────────────────
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
                            MaterialPageRoute(
                              builder: (_) => const OrdersScreen(),
                            ),
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
        ],
      ),
    );
  }
}

class _BackdropGlow extends StatelessWidget {
  final Color color;
  final double size;

  const _BackdropGlow({required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [color, Colors.transparent],
            stops: const [0.2, 1],
          ),
        ),
      ),
    );
  }
}

const _supplierGradients = [
  [Color(0xFF5F8DF8), Color(0xFF5C6BDA)],
  [Color(0xFFEE758F), Color(0xFFE96584)],
  [Color(0xFF4FB8F1), Color(0xFF4A7DE1)],
  [Color(0xFF7D73EA), Color(0xFF4B56B8)],
];

class _SupplierHighlightCard extends StatelessWidget {
  final SupplierEntity supplier;
  final int index;
  final VoidCallback onTap;

  const _SupplierHighlightCard({
    required this.supplier,
    required this.index,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final gradient = _supplierGradients[index % _supplierGradients.length];
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 230,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: gradient.first.withValues(alpha: 0.30),
              blurRadius: 18,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.24),
                borderRadius: BorderRadius.circular(11),
              ),
              child: const Icon(
                Icons.business_center_rounded,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              supplier.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w700,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              supplier.address ?? 'Ubicación no disponible',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.inter(color: Colors.white70, fontSize: 12),
            ),
            const Spacer(),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.22),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '${supplier.complianceScore.toStringAsFixed(0)}% SLA',
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const Spacer(),
                CircleAvatar(
                  radius: 16,
                  backgroundColor: Colors.white.withValues(alpha: 0.22),
                  child: const Icon(
                    Icons.chevron_right_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
