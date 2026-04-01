import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/theme/theme_controller.dart';
import '../../../data/datasources/owner_mock_datasource.dart';

class SupplierPerformanceScreen extends StatefulWidget {
  const SupplierPerformanceScreen({super.key});

  @override
  State<SupplierPerformanceScreen> createState() => _SupplierPerformanceScreenState();
}

class _SupplierPerformanceScreenState extends State<SupplierPerformanceScreen> {
  final _ds = OwnerMockDataSource();
  late final List<SupplierPerformance> _data;

  @override
  void initState() {
    super.initState();
    _data = _ds.getSupplierPerformance();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeController>().isDark;
    final bgColor = isDark ? AppColors.darkBg : AppColors.lightBg;
    final textPrimary = isDark ? AppColors.darkText : AppColors.lightText;
    final textSecondary = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

    final avgScore = _data.fold<int>(0, (s, e) => s + e.score) ~/ _data.length;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Rendimiento proveedores', style: GoogleFonts.poppins(fontSize: 17, fontWeight: FontWeight.w700)),
      ),
      body: Column(
        children: [
          // Average score header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            color: isDark ? AppColors.darkCard : AppColors.lightCard,
            child: Row(
              children: [
                Container(
                  width: 56, height: 56,
                  decoration: BoxDecoration(
                    color: _scoreColor(avgScore.toDouble()).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Text(
                      '$avgScore%',
                      style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w800, color: _scoreColor(avgScore.toDouble())),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Score promedio de la red', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: textPrimary)),
                      const SizedBox(height: 2),
                      Text('Meta: 90% · ${_data.length} proveedores evaluados', style: GoogleFonts.inter(fontSize: 12, color: textSecondary)),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Table header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            color: isDark ? AppColors.darkCardAlt : AppColors.lightCardAlt,
            child: Row(
              children: [
                Expanded(flex: 3, child: Text('Proveedor', style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700, color: textSecondary))),
                Expanded(flex: 1, child: Text('Score', style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700, color: textSecondary), textAlign: TextAlign.center)),
                Expanded(flex: 1, child: Text('A tiempo', style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700, color: textSecondary), textAlign: TextAlign.center)),
                Expanded(flex: 1, child: Text('Inc.', style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700, color: textSecondary), textAlign: TextAlign.center)),
              ],
            ),
          ),

          // List
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 4),
              physics: const BouncingScrollPhysics(),
              itemCount: _data.length,
              separatorBuilder: (_, __) => Divider(height: 1, color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
              itemBuilder: (_, i) => _PerformanceRow(item: _data[i], rank: i + 1, isDark: isDark),
            ),
          ),
        ],
      ),
    );
  }

  Color _scoreColor(double score) {
    if (score >= 85) return AppColors.statusCompleted;
    if (score >= 70) return AppColors.warning;
    return AppColors.statusDelayed;
  }
}

class _PerformanceRow extends StatelessWidget {
  final SupplierPerformance item;
  final int rank;
  final bool isDark;

  const _PerformanceRow({required this.item, required this.rank, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final textPrimary = isDark ? AppColors.darkText : AppColors.lightText;
    final textSecondary = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    final scoreColor = _scoreColor(item.score.toDouble());

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Row(
              children: [
                Container(
                  width: 24, height: 24,
                  decoration: BoxDecoration(
                    color: rank <= 3 ? AppColors.secondary.withValues(alpha: 0.12) : Colors.transparent,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Center(
                    child: Text(
                      '$rank',
                      style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w700, color: rank <= 3 ? AppColors.secondary : textSecondary),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(item.name, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: textPrimary), maxLines: 1, overflow: TextOverflow.ellipsis),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(color: scoreColor.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(6)),
                child: Text('${item.score}%', style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700, color: scoreColor)),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text('${item.onTime}%', style: GoogleFonts.inter(fontSize: 12, color: textPrimary), textAlign: TextAlign.center),
          ),
          Expanded(
            flex: 1,
            child: Text(
              '${item.incidents}',
              style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: item.incidents > 3 ? AppColors.error : textPrimary),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Color _scoreColor(double score) {
    if (score >= 85) return AppColors.statusCompleted;
    if (score >= 70) return AppColors.warning;
    return AppColors.statusDelayed;
  }
}
