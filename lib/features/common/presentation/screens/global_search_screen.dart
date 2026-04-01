import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../operator/data/datasources/operator_mock_datasource.dart';
import '../../../operator/domain/entities/incident_entity.dart';
import '../../../operator/domain/entities/order_entity.dart';
import '../../../operator/domain/entities/supplier_entity.dart';
import '../../../operator/presentation/screens/incidents/incidents_screen.dart';
import '../../../operator/presentation/screens/orders/order_detail_screen.dart';
import '../../../operator/presentation/screens/suppliers/supplier_detail_screen.dart';

/// Global search across orders, suppliers, and incidents.
class GlobalSearchDelegate extends SearchDelegate<String> {
  final OperatorMockDataSource _ds = OperatorMockDataSource();

  GlobalSearchDelegate()
      : super(
          searchFieldLabel: 'Buscar órdenes, proveedores, incidencias…',
          searchFieldStyle: GoogleFonts.inter(fontSize: 15),
        );

  @override
  ThemeData appBarTheme(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return theme.copyWith(
      appBarTheme: theme.appBarTheme.copyWith(
        backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: InputBorder.none,
        hintStyle: GoogleFonts.inter(
          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
          fontSize: 15,
        ),
      ),
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          icon: const Icon(Icons.clear_rounded),
          onPressed: () => query = '',
        ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back_rounded),
      onPressed: () => close(context, ''),
    );
  }

  @override
  Widget buildResults(BuildContext context) => _buildSearchResults(context);

  @override
  Widget buildSuggestions(BuildContext context) => _buildSearchResults(context);

  Widget _buildSearchResults(BuildContext context) {
    if (query.trim().isEmpty) {
      return _EmptyState(
        icon: Icons.search_rounded,
        message: 'Escribe para buscar en órdenes, proveedores e incidencias',
      );
    }

    final q = query.toLowerCase().trim();
    final orders = _ds.getOrders().where((o) =>
        o.id.toLowerCase().contains(q) ||
        o.supplierName.toLowerCase().contains(q) ||
        (o.description?.toLowerCase().contains(q) ?? false));
    final suppliers = _ds.getSuppliers().where((s) =>
        s.name.toLowerCase().contains(q) ||
        s.contactName.toLowerCase().contains(q) ||
        s.email.toLowerCase().contains(q) ||
        s.categories.any((c) => c.toLowerCase().contains(q)));
    final incidents = _ds.getIncidents().where((i) =>
        i.id.toLowerCase().contains(q) ||
        i.title.toLowerCase().contains(q) ||
        i.supplierName.toLowerCase().contains(q) ||
        i.orderCode.toLowerCase().contains(q));

    final totalResults = orders.length + suppliers.length + incidents.length;

    if (totalResults == 0) {
      return _EmptyState(
        icon: Icons.search_off_rounded,
        message: 'Sin resultados para "$query"',
      );
    }

    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 8),
      children: [
        if (orders.isNotEmpty) ...[
          _SectionHeader(title: 'Órdenes', count: orders.length),
          ...orders.map((o) => _OrderResult(order: o)),
        ],
        if (suppliers.isNotEmpty) ...[
          _SectionHeader(title: 'Proveedores', count: suppliers.length),
          ...suppliers.map((s) => _SupplierResult(supplier: s)),
        ],
        if (incidents.isNotEmpty) ...[
          _SectionHeader(title: 'Incidencias', count: incidents.length),
          ...incidents.map((i) => _IncidentResult(incident: i)),
        ],
      ],
    );
  }
}

// ── Section Header ──────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String title;
  final int count;
  const _SectionHeader({required this.title, required this.count});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Row(
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
            ),
          ),
          const SizedBox(width: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '$count',
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Order Result ────────────────────────────────────────────────────────────

class _OrderResult extends StatelessWidget {
  final OrderEntity order;
  const _OrderResult({required this.order});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary = isDark ? AppColors.darkText : AppColors.lightText;
    final textSecondary = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    final statusColor = _orderStatusColor(order.status);

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: statusColor.withValues(alpha: 0.15),
        child: Icon(Icons.receipt_long_rounded, color: statusColor, size: 20),
      ),
      title: Text(
        '${order.id} — ${order.supplierName}',
        style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: textPrimary),
      ),
      subtitle: Text(
        order.status.label,
        style: GoogleFonts.inter(fontSize: 12, color: textSecondary),
      ),
      trailing: Icon(Icons.chevron_right_rounded, color: textSecondary),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => OrderDetailScreen(order: order)),
        );
      },
    );
  }

  Color _orderStatusColor(OrderStatus s) => switch (s) {
    OrderStatus.pending => AppColors.statusPending,
    OrderStatus.inProgress => AppColors.statusInProgress,
    OrderStatus.completed => AppColors.statusCompleted,
    OrderStatus.delayed => AppColors.statusDelayed,
  };
}

// ── Supplier Result ─────────────────────────────────────────────────────────

class _SupplierResult extends StatelessWidget {
  final SupplierEntity supplier;
  const _SupplierResult({required this.supplier});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary = isDark ? AppColors.darkText : AppColors.lightText;
    final textSecondary = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: AppColors.primary.withValues(alpha: 0.15),
        child: Text(
          supplier.initials,
          style: GoogleFonts.poppins(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: AppColors.primary,
          ),
        ),
      ),
      title: Text(
        supplier.name,
        style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: textPrimary),
      ),
      subtitle: Text(
        '${supplier.categories.join(", ")} · Score: ${supplier.complianceScore}',
        style: GoogleFonts.inter(fontSize: 12, color: textSecondary),
      ),
      trailing: Icon(Icons.chevron_right_rounded, color: textSecondary),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => SupplierDetailScreen(supplier: supplier)),
        );
      },
    );
  }
}

// ── Incident Result ─────────────────────────────────────────────────────────

class _IncidentResult extends StatelessWidget {
  final IncidentEntity incident;
  const _IncidentResult({required this.incident});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary = isDark ? AppColors.darkText : AppColors.lightText;
    final textSecondary = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    final priorityColor = _priorityColor(incident.priority);

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: priorityColor.withValues(alpha: 0.15),
        child: Icon(Icons.bug_report_rounded, color: priorityColor, size: 20),
      ),
      title: Text(
        '${incident.id} — ${incident.title}',
        style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: textPrimary),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        '${incident.orderCode} · ${incident.status.label}',
        style: GoogleFonts.inter(fontSize: 12, color: textSecondary),
      ),
      trailing: Icon(Icons.chevron_right_rounded, color: textSecondary),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const IncidentsScreen()),
        );
      },
    );
  }

  Color _priorityColor(IncidentPriority p) => switch (p) {
    IncidentPriority.low => AppColors.info,
    IncidentPriority.medium => AppColors.warning,
    IncidentPriority.high => AppColors.error,
    IncidentPriority.critical => const Color(0xFF9B1D20),
  };
}

// ── Empty State ─────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String message;
  const _EmptyState({required this.icon, required this.message});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 48, color: color),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(fontSize: 14, color: color),
            ),
          ),
        ],
      ),
    );
  }
}
