import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/theme/theme_controller.dart';
import '../../../data/datasources/operator_mock_datasource.dart';
import '../../../domain/entities/incident_entity.dart';
import 'incident_form_screen.dart';

class IncidentsScreen extends StatefulWidget {
  const IncidentsScreen({super.key});

  @override
  State<IncidentsScreen> createState() => _IncidentsScreenState();
}

class _IncidentsScreenState extends State<IncidentsScreen> {
  final _ds = OperatorMockDataSource();
  late List<IncidentEntity> _all;
  IncidentStatus? _statusFilter;
  IncidentPriority? _priorityFilter;

  @override
  void initState() {
    super.initState();
    _all = _ds.getIncidents();
  }

  List<IncidentEntity> get _filtered => _all.where((i) {
    final statusOk = _statusFilter == null || i.status == _statusFilter;
    final priorityOk = _priorityFilter == null || i.priority == _priorityFilter;
    return statusOk && priorityOk;
  }).toList();

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
          'Incidencias',
          style: GoogleFonts.poppins(fontSize: 17, fontWeight: FontWeight.w700),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: IconButton(
              icon: const Icon(Icons.add_circle_outline_rounded),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const IncidentFormScreen()),
              ).then((_) => setState(() => _all = _ds.getIncidents())),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // ── Status filter ───────────────────────────────────────────────
          Container(
            height: 48,
            color: isDark ? AppColors.darkCard : AppColors.lightCard,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              children: [
                _FilterChip(
                  label: 'Todas',
                  isSelected: _statusFilter == null,
                  onTap: () => setState(() => _statusFilter = null),
                  color: AppColors.primary,
                ),
                ...IncidentStatus.values.map(
                  (s) => Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: _FilterChip(
                      label: s.label,
                      isSelected: _statusFilter == s,
                      onTap: () => setState(
                        () => _statusFilter = _statusFilter == s ? null : s,
                      ),
                      color: _statusColor(s),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── Priority filter ─────────────────────────────────────────────
          Container(
            height: 44,
            color: isDark ? AppColors.darkCard : AppColors.lightCard,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
              children: IncidentPriority.values
                  .map(
                    (p) => Padding(
                      padding: EdgeInsets.only(
                        right: p != IncidentPriority.critical ? 8 : 0,
                      ),
                      child: _FilterChip(
                        label: p.label,
                        isSelected: _priorityFilter == p,
                        onTap: () => setState(
                          () =>
                              _priorityFilter = _priorityFilter == p ? null : p,
                        ),
                        color: _priorityColor(p),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),

          // ── Count ───────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 6),
            child: Row(
              children: [
                Text(
                  '${_filtered.length} incidencias',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          // ── List ────────────────────────────────────────────────────────
          Expanded(
            child: _filtered.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.check_circle_outline_rounded,
                          size: 52,
                          color: AppColors.success.withValues(alpha: 0.5),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Sin incidencias con este filtro',
                          style: GoogleFonts.inter(
                            color: textSecondary,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 20),
                    physics: const BouncingScrollPhysics(),
                    itemCount: _filtered.length,
                    itemBuilder: (_, i) => _IncidentListItem(
                      incident: _filtered[i],
                      isDark: isDark,
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Color _statusColor(IncidentStatus s) => switch (s) {
    IncidentStatus.open => AppColors.error,
    IncidentStatus.inProgress => AppColors.statusInProgress,
    IncidentStatus.resolved => AppColors.statusCompleted,
    IncidentStatus.closed => AppColors.darkTextSecondary,
  };

  Color _priorityColor(IncidentPriority p) => switch (p) {
    IncidentPriority.low => AppColors.info,
    IncidentPriority.medium => AppColors.warning,
    IncidentPriority.high => AppColors.error,
    IncidentPriority.critical => const Color(0xFFB5179E),
  };
}

// ── List item ────────────────────────────────────────────────────────────────

class _IncidentListItem extends StatelessWidget {
  final IncidentEntity incident;
  final bool isDark;

  const _IncidentListItem({required this.incident, required this.isDark});

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
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 4,
            height: 56,
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
                          fontWeight: FontWeight.w700,
                          color: textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    _StatusBadge(status: incident.status),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '${incident.orderCode} · ${incident.supplierName}',
                  style: GoogleFonts.inter(fontSize: 12, color: textSecondary),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(
                      Icons.schedule_rounded,
                      size: 11,
                      color: textSecondary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _relativeTime(incident.createdAt),
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: textSecondary,
                      ),
                    ),
                    const Spacer(),
                    _PriorityChip(priority: incident.priority),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _relativeTime(DateTime d) {
    final diff = DateTime.now().difference(d);
    if (diff.inMinutes < 60) return 'Hace ${diff.inMinutes}min';
    if (diff.inHours < 24) return 'Hace ${diff.inHours}h';
    return 'Hace ${diff.inDays}d';
  }

  Color _priorityColor(IncidentPriority p) => switch (p) {
    IncidentPriority.low => AppColors.info,
    IncidentPriority.medium => AppColors.warning,
    IncidentPriority.high => AppColors.error,
    IncidentPriority.critical => const Color(0xFFB5179E),
  };
}

class _StatusBadge extends StatelessWidget {
  final IncidentStatus status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final color = _color(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
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

  Color _color(IncidentStatus s) => switch (s) {
    IncidentStatus.open => AppColors.error,
    IncidentStatus.inProgress => AppColors.statusInProgress,
    IncidentStatus.resolved => AppColors.statusCompleted,
    IncidentStatus.closed => AppColors.darkTextSecondary,
  };
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
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
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
              fontSize: 11,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              color: isSelected ? color : color.withValues(alpha: 0.7),
            ),
          ),
        ),
      ),
    );
  }
}

class _PriorityChip extends StatelessWidget {
  final IncidentPriority priority;
  const _PriorityChip({required this.priority});

  @override
  Widget build(BuildContext context) {
    final color = _color(priority);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
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
