import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/theme/theme_controller.dart';
import '../../../data/datasources/operator_mock_datasource.dart';
import '../../../domain/entities/order_entity.dart';
import '../../widgets/operator_side_drawer.dart';
import '../../widgets/order_list_item.dart';
import 'order_detail_screen.dart';

class OrdersScreen extends StatefulWidget {
  final OrderStatus? initialFilter;

  const OrdersScreen({super.key, this.initialFilter});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  final _ds = OperatorMockDataSource();
  late final List<OrderEntity> _allOrders;
  OrderStatus? _filter;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _allOrders = _ds.getOrders();
    _filter = widget.initialFilter;
  }

  List<OrderEntity> get _filtered {
    final byStatus = _filter == null
        ? _allOrders
        : _allOrders.where((o) => o.status == _filter).toList();

    if (_query.trim().isEmpty) {
      return byStatus;
    }

    final q = _query.trim().toLowerCase();
    return byStatus.where((o) {
      return o.id.toLowerCase().contains(q) ||
          o.supplierName.toLowerCase().contains(q) ||
          (o.description?.toLowerCase().contains(q) ?? false);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeController>().isDark;
    final bgColor = isDark ? AppColors.darkBg : AppColors.lightBg;
    final textPrimary = isDark ? AppColors.darkText : AppColors.lightText;
    final textSecondary = isDark
        ? AppColors.darkTextSecondary
        : AppColors.lightTextSecondary;
    final cardColor = isDark ? AppColors.darkCard : AppColors.lightCard;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    return Scaffold(
      drawer: const OperatorSideDrawer(selectedIndex: 2),
      backgroundColor: bgColor,
      body: Stack(
        children: [
          Positioned(
            top: -110,
            right: -70,
            child: _BackdropGlow(
              color: AppColors.primary.withValues(alpha: isDark ? 0.18 : 0.16),
              size: 240,
            ),
          ),
          Positioned(
            top: 220,
            left: -90,
            child: _BackdropGlow(
              color: AppColors.info.withValues(alpha: isDark ? 0.14 : 0.13),
              size: 210,
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(14, 14, 20, 10),
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
                            onPressed: () => Scaffold.of(context).openDrawer(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Órdenes',
                              style: GoogleFonts.poppins(
                                fontSize: 34,
                                fontWeight: FontWeight.w800,
                                color: textPrimary,
                              ),
                            ),
                            Text(
                              'Seguimiento de entregas y estado SLA',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                  child: Container(
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: borderColor),
                    ),
                    child: TextField(
                      onChanged: (v) => setState(() => _query = v),
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: textPrimary,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Buscar por código, proveedor o detalle',
                        hintStyle: GoogleFonts.inter(
                          color: textSecondary,
                          fontSize: 13,
                        ),
                        prefixIcon: Icon(
                          Icons.search_rounded,
                          color: textSecondary,
                          size: 20,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 14,
                        ),
                      ),
                    ),
                  ),
                ),

                // ── Filter chips ─────────────────────────────────────────────────
                Container(
                  height: 48,
                  color: cardColor,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    children: [
                      _FilterChip(
                        label: 'Todas',
                        isSelected: _filter == null,
                        onTap: () => setState(() => _filter = null),
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 8),
                      _FilterChip(
                        label: 'Pendiente',
                        isSelected: _filter == OrderStatus.pending,
                        onTap: () =>
                            setState(() => _filter = OrderStatus.pending),
                        color: AppColors.statusPending,
                      ),
                      const SizedBox(width: 8),
                      _FilterChip(
                        label: 'En progreso',
                        isSelected: _filter == OrderStatus.inProgress,
                        onTap: () =>
                            setState(() => _filter = OrderStatus.inProgress),
                        color: AppColors.statusInProgress,
                      ),
                      const SizedBox(width: 8),
                      _FilterChip(
                        label: 'Completado',
                        isSelected: _filter == OrderStatus.completed,
                        onTap: () =>
                            setState(() => _filter = OrderStatus.completed),
                        color: AppColors.statusCompleted,
                      ),
                      const SizedBox(width: 8),
                      _FilterChip(
                        label: 'Atrasado',
                        isSelected: _filter == OrderStatus.delayed,
                        onTap: () =>
                            setState(() => _filter = OrderStatus.delayed),
                        color: AppColors.statusDelayed,
                      ),
                    ],
                  ),
                ),

                // ── Count badge ───────────────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 14, 20, 8),
                  child: Row(
                    children: [
                      Text(
                        '${_filtered.length} órdenes',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

                // ── List ──────────────────────────────────────────────────────────
                Expanded(
                  child: _filtered.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.inbox_rounded,
                                size: 56,
                                color: textSecondary.withValues(alpha: 0.3),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Sin órdenes con este filtro',
                                style: GoogleFonts.inter(
                                  color: textSecondary,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                          physics: const BouncingScrollPhysics(),
                          itemCount: _filtered.length,
                          itemBuilder: (_, i) => TweenAnimationBuilder<double>(
                            tween: Tween(begin: 0, end: 1),
                            duration: Duration(milliseconds: 180 + (i * 45)),
                            curve: Curves.easeOut,
                            builder: (_, value, child) => Opacity(
                              opacity: value,
                              child: Transform.translate(
                                offset: Offset(0, 10 * (1 - value)),
                                child: child,
                              ),
                            ),
                            child: OrderListItem(
                              order: _filtered[i],
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      OrderDetailScreen(order: _filtered[i]),
                                ),
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

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final Color color;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 0),
        decoration: BoxDecoration(
          color: isSelected
              ? color.withValues(alpha: 0.15)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? color : color.withValues(alpha: 0.3),
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              color: isSelected ? color : color.withValues(alpha: 0.7),
            ),
          ),
        ),
      ),
    );
  }
}
