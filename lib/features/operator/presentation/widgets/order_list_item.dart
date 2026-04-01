import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../domain/entities/order_entity.dart';

class OrderListItem extends StatelessWidget {
  final OrderEntity order;
  final VoidCallback? onTap;

  const OrderListItem({super.key, required this.order, this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? AppColors.darkCard : AppColors.lightCard;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor),
        ),
        child: Row(
          children: [
            // Status indicator bar
            Container(
              width: 4,
              height: 48,
              decoration: BoxDecoration(
                color: _statusColor(order.status),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        order.id,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                          color: isDark
                              ? AppColors.darkText
                              : AppColors.lightText,
                        ),
                      ),
                      const Spacer(),
                      _StatusChip(status: order.status),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    order.supplierName,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(
                        Icons.schedule_rounded,
                        size: 12,
                        color: order.isOverdue
                            ? AppColors.error
                            : (isDark
                                  ? AppColors.darkTextSecondary
                                  : AppColors.lightTextSecondary),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _formatDate(order.dueDate),
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: order.isOverdue
                              ? AppColors.error
                              : (isDark
                                    ? AppColors.darkTextSecondary
                                    : AppColors.lightTextSecondary),
                          fontWeight: order.isOverdue
                              ? FontWeight.w600
                              : FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.chevron_right_rounded,
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }

  Color _statusColor(OrderStatus s) => switch (s) {
    OrderStatus.pending => AppColors.statusPending,
    OrderStatus.inProgress => AppColors.statusInProgress,
    OrderStatus.completed => AppColors.statusCompleted,
    OrderStatus.delayed => AppColors.statusDelayed,
  };

  String _formatDate(DateTime d) {
    final now = DateTime.now();
    final diff = d.difference(now);
    if (diff.isNegative) {
      final hours = diff.abs().inHours;
      if (hours < 24) return 'Venció hace ${hours}h';
      return 'Venció hace ${diff.abs().inDays}d';
    }
    final hours = diff.inHours;
    if (hours < 24) return 'Vence en ${hours}h';
    return 'Vence en ${diff.inDays}d';
  }
}

class _StatusChip extends StatelessWidget {
  final OrderStatus status;

  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    final color = _color(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        status.label,
        style: GoogleFonts.inter(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: color,
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
