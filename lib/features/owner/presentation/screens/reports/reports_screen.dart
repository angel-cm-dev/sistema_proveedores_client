import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../../core/services/report_export_service.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/theme/theme_controller.dart';
import '../../../../operator/data/datasources/operator_mock_datasource.dart';
import '../../../../operator/domain/entities/incident_entity.dart';
import '../../../../operator/domain/entities/order_entity.dart';
import '../../../../operator/domain/entities/supplier_entity.dart';
import '../../../data/datasources/owner_mock_datasource.dart';

/// Screen for generating and exporting CSV reports.
class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  final _operatorDs = OperatorMockDataSource();
  final _ownerDs = OwnerMockDataSource();
  bool _exporting = false;
  String? _lastExportPath;

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeController>().isDark;
    final bgColor = isDark ? AppColors.darkBg : AppColors.lightBg;
    final textPrimary = isDark ? AppColors.darkText : AppColors.lightText;
    final textSecondary = isDark
        ? AppColors.darkTextSecondary
        : AppColors.lightTextSecondary;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text(
          'Reportes',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w700),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        physics: const BouncingScrollPhysics(),
        children: [
          // Header info
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primary, AppColors.secondary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.analytics_rounded,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Exportar datos',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Genera reportes CSV de tus datos operativos',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          Text(
            'Reportes disponibles',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: textPrimary,
            ),
          ),
          const SizedBox(height: 12),

          // Orders report
          _ReportCard(
            icon: Icons.receipt_long_rounded,
            color: AppColors.statusInProgress,
            title: 'Órdenes',
            subtitle:
                'Listado completo de órdenes con estado, proveedor y fechas',
            isDark: isDark,
            isExporting: _exporting,
            onExport: () => _exportOrders(),
          ),
          const SizedBox(height: 10),

          // Suppliers report
          _ReportCard(
            icon: Icons.store_rounded,
            color: AppColors.success,
            title: 'Proveedores',
            subtitle: 'Directorio de proveedores con score y cumplimiento',
            isDark: isDark,
            isExporting: _exporting,
            onExport: () => _exportSuppliers(),
          ),
          const SizedBox(height: 10),

          // Incidents report
          _ReportCard(
            icon: Icons.bug_report_rounded,
            color: AppColors.warning,
            title: 'Incidencias',
            subtitle: 'Historial de incidencias con prioridad y resolución',
            isDark: isDark,
            isExporting: _exporting,
            onExport: () => _exportIncidents(),
          ),
          const SizedBox(height: 10),

          // Performance report
          _ReportCard(
            icon: Icons.leaderboard_rounded,
            color: AppColors.secondary,
            title: 'Rendimiento proveedores',
            subtitle:
                'Score, cumplimiento y cantidad de incidencias por proveedor',
            isDark: isDark,
            isExporting: _exporting,
            onExport: () => _exportPerformance(),
          ),

          if (_lastExportPath != null) ...[
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.success.withValues(alpha: 0.2),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.check_circle_rounded,
                    color: AppColors.success,
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Reporte guardado correctamente',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: textSecondary,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () => _share(_lastExportPath!),
                    child: Text(
                      'Compartir',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _exportOrders() async {
    setState(() => _exporting = true);
    final orders = _operatorDs.getOrders();
    final csv = ReportExportService.toCsv(
      headers: [
        'ID',
        'Proveedor',
        'Estado',
        'Creado',
        'Vencimiento',
        'Descripción',
      ],
      rows: orders
          .map(
            (o) => [
              o.id,
              o.supplierName,
              o.status.label,
              o.createdAt.toIso8601String().substring(0, 10),
              o.dueDate.toIso8601String().substring(0, 10),
              o.description ?? '',
            ],
          )
          .toList(),
    );
    final path = await ReportExportService.saveCsvToFile(
      csv: csv,
      fileName: 'ordenes_${DateTime.now().millisecondsSinceEpoch}.csv',
    );
    if (mounted)
      setState(() {
        _exporting = false;
        _lastExportPath = path;
      });
  }

  Future<void> _exportSuppliers() async {
    setState(() => _exporting = true);
    final suppliers = _operatorDs.getSuppliers();
    final csv = ReportExportService.toCsv(
      headers: [
        'ID',
        'Nombre',
        'Contacto',
        'Email',
        'Estado',
        'Score',
        'Órdenes totales',
        'Completadas',
        'Categorías',
      ],
      rows: suppliers
          .map(
            (s) => [
              s.id,
              s.name,
              s.contactName,
              s.email,
              s.status.label,
              s.complianceScore.toStringAsFixed(0),
              s.totalOrders.toString(),
              s.completedOrders.toString(),
              s.categories.join('; '),
            ],
          )
          .toList(),
    );
    final path = await ReportExportService.saveCsvToFile(
      csv: csv,
      fileName: 'proveedores_${DateTime.now().millisecondsSinceEpoch}.csv',
    );
    if (mounted)
      setState(() {
        _exporting = false;
        _lastExportPath = path;
      });
  }

  Future<void> _exportIncidents() async {
    setState(() => _exporting = true);
    final incidents = _operatorDs.getIncidents();
    final csv = ReportExportService.toCsv(
      headers: [
        'ID',
        'Orden',
        'Proveedor',
        'Título',
        'Prioridad',
        'Estado',
        'Creado',
        'Resuelto',
        'Reportado por',
      ],
      rows: incidents
          .map(
            (i) => [
              i.id,
              i.orderCode,
              i.supplierName,
              i.title,
              i.priority.label,
              i.status.label,
              i.createdAt.toIso8601String().substring(0, 10),
              i.resolvedAt?.toIso8601String().substring(0, 10) ?? 'Pendiente',
              i.reportedBy,
            ],
          )
          .toList(),
    );
    final path = await ReportExportService.saveCsvToFile(
      csv: csv,
      fileName: 'incidencias_${DateTime.now().millisecondsSinceEpoch}.csv',
    );
    if (mounted)
      setState(() {
        _exporting = false;
        _lastExportPath = path;
      });
  }

  Future<void> _exportPerformance() async {
    setState(() => _exporting = true);
    final perf = _ownerDs.getSupplierPerformance();
    final csv = ReportExportService.toCsv(
      headers: ['Proveedor', 'Score', 'Órdenes', 'A tiempo (%)', 'Incidencias'],
      rows: perf
          .map(
            (p) => [
              p.name,
              p.score.toString(),
              p.orders.toString(),
              '${p.onTime}',
              p.incidents.toString(),
            ],
          )
          .toList(),
    );
    final path = await ReportExportService.saveCsvToFile(
      csv: csv,
      fileName: 'rendimiento_${DateTime.now().millisecondsSinceEpoch}.csv',
    );
    if (mounted)
      setState(() {
        _exporting = false;
        _lastExportPath = path;
      });
  }

  Future<void> _share(String path) async {
    await Share.shareXFiles([XFile(path)], text: 'Reporte Connexa');
  }
}

// ── Report card ──────────────────────────────────────────────────────────────

class _ReportCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final bool isDark;
  final bool isExporting;
  final VoidCallback onExport;

  const _ReportCard({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.isDark,
    required this.isExporting,
    required this.onExport,
  });

  @override
  Widget build(BuildContext context) {
    final cardColor = isDark ? AppColors.darkCard : AppColors.lightCard;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final textPrimary = isDark ? AppColors.darkText : AppColors.lightText;
    final textSecondary = isDark
        ? AppColors.darkTextSecondary
        : AppColors.lightTextSecondary;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: GoogleFonts.inter(fontSize: 11, color: textSecondary),
                  maxLines: 2,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: isExporting ? null : onExport,
            style: ElevatedButton.styleFrom(
              backgroundColor: color,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 0,
              minimumSize: Size.zero,
              textStyle: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
            child: isExporting
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : const Text('CSV'),
          ),
        ],
      ),
    );
  }
}
