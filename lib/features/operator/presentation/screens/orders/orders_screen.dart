import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/theme/theme_controller.dart';
import '../../../data/datasources/operator_mock_datasource.dart';
import '../../../domain/entities/order_entity.dart';
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

  @override
  void initState() {
    super.initState();
    _allOrders = _ds.getOrders();
    _filter = widget.initialFilter;
  }

  List<OrderEntity> get _filtered => _filter == null
      ? _allOrders
      : _allOrders.where((o) => o.status == _filter).toList();

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeController>().isDark;
    final bgColor = isDark ? AppColors.darkBg : AppColors.lightBg;
    final textSecondary = isDark
        ? AppColors.darkTextSecondary
        : AppColors.lightTextSecondary;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Órdenes',
          style: GoogleFonts.poppins(fontSize: 17, fontWeight: FontWeight.w700),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: IconButton(
              icon: const Icon(Icons.search_rounded),
              onPressed: () {},
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // ── Filter chips ─────────────────────────────────────────────────
          Container(
            height: 48,
            color: isDark ? AppColors.darkCard : AppColors.lightCard,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                  onTap: () => setState(() => _filter = OrderStatus.pending),
                  color: AppColors.statusPending,
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: 'En progreso',
                  isSelected: _filter == OrderStatus.inProgress,
                  onTap: () => setState(() => _filter = OrderStatus.inProgress),
                  color: AppColors.statusInProgress,
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: 'Completado',
                  isSelected: _filter == OrderStatus.completed,
                  onTap: () => setState(() => _filter = OrderStatus.completed),
                  color: AppColors.statusCompleted,
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: 'Atrasado',
                  isSelected: _filter == OrderStatus.delayed,
                  onTap: () => setState(() => _filter = OrderStatus.delayed),
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
                    itemBuilder: (_, i) => OrderListItem(
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
        ],
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
