import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../domain/entities/kpi_entity.dart';

class KpiCard extends StatelessWidget {
  final KpiEntity kpi;

  const KpiCard({super.key, required this.kpi});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 148,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kpi.bgColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: kpi.accentColor.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: kpi.accentColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(kpi.icon, color: kpi.accentColor, size: 18),
              ),
              if (kpi.trendPercent != null)
                _TrendBadge(value: kpi.trendPercent!, accent: kpi.accentColor),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            kpi.value,
            style: GoogleFonts.poppins(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              height: 1,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            kpi.label,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.white70,
            ),
          ),
          if (kpi.subtitle != null) ...[
            const SizedBox(height: 2),
            Text(
              kpi.subtitle!,
              style: GoogleFonts.inter(fontSize: 11, color: Colors.white38),
            ),
          ],
        ],
      ),
    );
  }
}

class _TrendBadge extends StatelessWidget {
  final double value;
  final Color accent;

  const _TrendBadge({required this.value, required this.accent});

  @override
  Widget build(BuildContext context) {
    final isPositive = value >= 0;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isPositive
                ? Icons.trending_up_rounded
                : Icons.trending_down_rounded,
            color: accent,
            size: 12,
          ),
          const SizedBox(width: 2),
          Text(
            '${value.abs().toStringAsFixed(0)}%',
            style: GoogleFonts.inter(
              color: accent,
              fontSize: 10,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
