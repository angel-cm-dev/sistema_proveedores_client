import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';

/// Reusable date range filter chip that opens a date range picker.
class DateRangeFilter extends StatelessWidget {
  final DateTimeRange? selected;
  final ValueChanged<DateTimeRange?> onChanged;
  final String label;

  const DateRangeFilter({
    super.key,
    required this.selected,
    required this.onChanged,
    this.label = 'Rango de fechas',
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final hasRange = selected != null;
    final textColor = isDark ? AppColors.darkText : AppColors.lightText;

    return GestureDetector(
      onTap: () => _pick(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: hasRange
              ? AppColors.primary.withValues(alpha: 0.12)
              : (isDark ? AppColors.darkCardAlt : AppColors.lightCardAlt),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: hasRange
                ? AppColors.primary
                : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.date_range_rounded,
              size: 16,
              color: hasRange ? AppColors.primary : textColor,
            ),
            const SizedBox(width: 6),
            Text(
              hasRange ? _formatRange(selected!) : label,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: hasRange ? FontWeight.w600 : FontWeight.w500,
                color: hasRange ? AppColors.primary : textColor,
              ),
            ),
            if (hasRange) ...[
              const SizedBox(width: 4),
              GestureDetector(
                onTap: () => onChanged(null),
                child: Icon(
                  Icons.close_rounded,
                  size: 14,
                  color: AppColors.primary,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _pick(BuildContext context) async {
    final now = DateTime.now();
    final result = await showDateRangePicker(
      context: context,
      firstDate: now.subtract(const Duration(days: 365)),
      lastDate: now.add(const Duration(days: 90)),
      initialDateRange: selected,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: AppColors.primary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (result != null) {
      onChanged(result);
    }
  }

  String _formatRange(DateTimeRange range) {
    return '${_formatDate(range.start)} – ${_formatDate(range.end)}';
  }

  String _formatDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}';
}
