import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/theme/theme_controller.dart';
import '../../../data/datasources/operator_mock_datasource.dart';
import '../../../domain/entities/incident_entity.dart';
import '../../../domain/entities/order_entity.dart';
import '../incidents/incident_form_screen.dart';
import '../suppliers/supplier_detail_screen.dart';

class OrderDetailScreen extends StatefulWidget {
  final OrderEntity order;

  const OrderDetailScreen({super.key, required this.order});

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  final _ds = OperatorMockDataSource();
  late OrderStatus _currentStatus;
  late List<IncidentEntity> _incidents;

  @override
  void initState() {
    super.initState();
    _currentStatus = widget.order.status;
    _incidents = _ds.getIncidentsForOrder(widget.order.id);
  }

  List<OrderStatus> get _validTransitions => switch (_currentStatus) {
    OrderStatus.pending => [OrderStatus.inProgress],
    OrderStatus.inProgress => [OrderStatus.completed, OrderStatus.delayed],
    OrderStatus.delayed => [OrderStatus.inProgress, OrderStatus.completed],
    OrderStatus.completed => [],
  };

  void _changeStatus(OrderStatus next) {
    setState(() => _currentStatus = next);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Estado actualizado a: ${next.label}',
          style: GoogleFonts.inter(fontWeight: FontWeight.w500),
        ),
        backgroundColor: _statusColor(next),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeController>().isDark;
    final bgColor = isDark ? AppColors.darkBg : AppColors.lightBg;
    final cardColor = isDark ? AppColors.darkCard : AppColors.lightCard;
    final textPrimary = isDark ? AppColors.darkText : AppColors.lightText;
    final textSecondary = isDark
        ? AppColors.darkTextSecondary
        : AppColors.lightTextSecondary;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final order = widget.order;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text(
          order.id,
          style: GoogleFonts.poppins(fontSize: 17, fontWeight: FontWeight.w700),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: TextButton.icon(
              onPressed: () =>
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => IncidentFormScreen(order: order),
                    ),
                  ).then(
                    (_) => setState(() {
                      _incidents = _ds.getIncidentsForOrder(order.id);
                    }),
                  ),
              icon: const Icon(
                Icons.bug_report_rounded,
                size: 18,
                color: AppColors.warning,
              ),
              label: Text(
                'Incidencia',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: AppColors.warning,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Status card ───────────────────────────────────────────────
            _SectionCard(
              isDark: isDark,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Estado actual',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: textSecondary,
                              ),
                            ),
                            const SizedBox(height: 6),
                            _StatusBadge(status: _currentStatus),
                          ],
                        ),
                      ),
                      if (order.isOverdue)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.error.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: AppColors.error.withValues(alpha: 0.4),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.warning_amber_rounded,
                                size: 14,
                                color: AppColors.error,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Vencida',
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  color: AppColors.error,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                  if (_validTransitions.isNotEmpty) ...[
                    const SizedBox(height: 14),
                    Text(
                      'Cambiar estado:',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: _validTransitions
                          .map(
                            (s) => _TransitionChip(
                              status: s,
                              onTap: () => _changeStatus(s),
                            ),
                          )
                          .toList(),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ── Order info ────────────────────────────────────────────────
            _SectionCard(
              isDark: isDark,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Información de la orden',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: textPrimary,
                    ),
                  ),
                  const SizedBox(height: 14),
                  _InfoRow(
                    label: 'Proveedor',
                    value: order.supplierName,
                    isDark: isDark,
                    trailing: TextButton(
                      onPressed: () {
                        final supplier = _ds.getSupplierById(order.supplierId);
                        if (supplier != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  SupplierDetailScreen(supplier: supplier),
                            ),
                          );
                        }
                      },
                      child: Text(
                        'Ver proveedor',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  _InfoRow(
                    label: 'Creada',
                    value: _formatDateTime(order.createdAt),
                    isDark: isDark,
                  ),
                  const SizedBox(height: 10),
                  _InfoRow(
                    label: 'Vencimiento',
                    value: _formatDateTime(order.dueDate),
                    isDark: isDark,
                    valueColor: order.isOverdue ? AppColors.error : null,
                  ),
                  if (order.description != null) ...[
                    const SizedBox(height: 10),
                    _InfoRow(
                      label: 'Descripción',
                      value: order.description!,
                      isDark: isDark,
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ── Timeline ──────────────────────────────────────────────────
            _SectionCard(
              isDark: isDark,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Historial de estados',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: textPrimary,
                    ),
                  ),
                  const SizedBox(height: 14),
                  _TimelineItem(
                    label: 'Orden creada',
                    time: _formatDateTime(order.createdAt),
                    isFirst: true,
                    isLast: _currentStatus == OrderStatus.pending,
                    color: AppColors.info,
                    isDark: isDark,
                  ),
                  if (_currentStatus == OrderStatus.inProgress ||
                      _currentStatus == OrderStatus.completed ||
                      _currentStatus == OrderStatus.delayed)
                    _TimelineItem(
                      label: 'En progreso',
                      time: 'Actualizado',
                      isFirst: false,
                      isLast: _currentStatus == OrderStatus.inProgress,
                      color: AppColors.statusInProgress,
                      isDark: isDark,
                    ),
                  if (_currentStatus == OrderStatus.delayed)
                    _TimelineItem(
                      label: 'Marcada como atrasada',
                      time: 'Actualizado',
                      isFirst: false,
                      isLast: true,
                      color: AppColors.statusDelayed,
                      isDark: isDark,
                    ),
                  if (_currentStatus == OrderStatus.completed)
                    _TimelineItem(
                      label: 'Completada',
                      time: _formatDateTime(order.dueDate),
                      isFirst: false,
                      isLast: true,
                      color: AppColors.statusCompleted,
                      isDark: isDark,
                    ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ── Incidents ─────────────────────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Incidencias vinculadas',
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: textPrimary,
                  ),
                ),
                Text(
                  '${_incidents.length}',
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            if (_incidents.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: borderColor),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.check_circle_outline_rounded,
                      size: 36,
                      color: AppColors.success.withValues(alpha: 0.7),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Sin incidencias registradas',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: textSecondary,
                      ),
                    ),
                  ],
                ),
              )
            else
              ...(_incidents.map(
                (inc) => _IncidentTile(incident: inc, isDark: isDark),
              )),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  String _formatDateTime(DateTime d) {
    return '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}  ${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';
  }

  Color _statusColor(OrderStatus s) => switch (s) {
    OrderStatus.pending => AppColors.statusPending,
    OrderStatus.inProgress => AppColors.statusInProgress,
    OrderStatus.completed => AppColors.statusCompleted,
    OrderStatus.delayed => AppColors.statusDelayed,
  };
}

// ── Supporting widgets ────────────────────────────────────────────────────────

class _SectionCard extends StatelessWidget {
  final Widget child;
  final bool isDark;

  const _SectionCard({required this.child, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: child,
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final OrderStatus status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final color = _color(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Text(
            status.label,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Color _color(OrderStatus s) => switch (s) {
    OrderStatus.pending => AppColors.statusPending,
    OrderStatus.inProgress => AppColors.statusInProgress,
    OrderStatus.completed => AppColors.statusCompleted,
    OrderStatus.delayed => AppColors.statusDelayed,
  };
}

class _TransitionChip extends StatelessWidget {
  final OrderStatus status;
  final VoidCallback onTap;

  const _TransitionChip({required this.status, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final color = _color(status);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withValues(alpha: 0.5)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.arrow_forward_rounded, size: 12, color: color),
            const SizedBox(width: 5),
            Text(
              status.label,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _color(OrderStatus s) => switch (s) {
    OrderStatus.pending => AppColors.statusPending,
    OrderStatus.inProgress => AppColors.statusInProgress,
    OrderStatus.completed => AppColors.statusCompleted,
    OrderStatus.delayed => AppColors.statusDelayed,
  };
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isDark;
  final Color? valueColor;
  final Widget? trailing;

  const _InfoRow({
    required this.label,
    required this.value,
    required this.isDark,
    this.valueColor,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final textSecondary = isDark
        ? AppColors.darkTextSecondary
        : AppColors.lightTextSecondary;
    final textPrimary = isDark ? AppColors.darkText : AppColors.lightText;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: GoogleFonts.inter(fontSize: 13, color: textSecondary),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: valueColor ?? textPrimary,
            ),
          ),
        ),
        trailing ?? const SizedBox.shrink(),
      ],
    );
  }
}

class _TimelineItem extends StatelessWidget {
  final String label;
  final String time;
  final bool isFirst;
  final bool isLast;
  final Color color;
  final bool isDark;

  const _TimelineItem({
    required this.label,
    required this.time,
    required this.isFirst,
    required this.isLast,
    required this.color,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final textPrimary = isDark ? AppColors.darkText : AppColors.lightText;
    final textSecondary = isDark
        ? AppColors.darkTextSecondary
        : AppColors.lightTextSecondary;
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 28,
            child: Column(
              children: [
                if (!isFirst)
                  Expanded(
                    child: Container(
                      width: 2,
                      color: isDark
                          ? AppColors.darkBorder
                          : AppColors.lightBorder,
                    ),
                  ),
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      color: isDark
                          ? AppColors.darkBorder
                          : AppColors.lightBorder,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    time,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _IncidentTile extends StatelessWidget {
  final IncidentEntity incident;
  final bool isDark;

  const _IncidentTile({required this.incident, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final cardColor = isDark ? AppColors.darkCard : AppColors.lightCard;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final textPrimary = isDark ? AppColors.darkText : AppColors.lightText;
    final textSecondary = isDark
        ? AppColors.darkTextSecondary
        : AppColors.lightTextSecondary;
    final priorityColor = _priorityColor(incident.priority);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 44,
            decoration: BoxDecoration(
              color: priorityColor,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        incident.title,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    _PriorityChip(priority: incident.priority),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  incident.status.label,
                  style: GoogleFonts.inter(fontSize: 12, color: textSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _priorityColor(IncidentPriority p) => switch (p) {
    IncidentPriority.low => AppColors.info,
    IncidentPriority.medium => AppColors.warning,
    IncidentPriority.high => AppColors.error,
    IncidentPriority.critical => const Color(0xFFB5179E),
  };
}

class _PriorityChip extends StatelessWidget {
  final IncidentPriority priority;

  const _PriorityChip({required this.priority});

  @override
  Widget build(BuildContext context) {
    final color = _color(priority);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        priority.label,
        style: GoogleFonts.inter(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }

  Color _color(IncidentPriority p) => switch (p) {
    IncidentPriority.low => AppColors.info,
    IncidentPriority.medium => AppColors.warning,
    IncidentPriority.high => AppColors.error,
    IncidentPriority.critical => const Color(0xFFB5179E),
  };
}
