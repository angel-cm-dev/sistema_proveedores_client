import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/theme/theme_controller.dart';
import '../../../data/datasources/operator_mock_datasource.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  final _ds = OperatorMockDataSource();
  late final Map<DateTime, List<CalendarEvent>> _allEvents;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  late DateTime _firstDayOfMonth;
  late DateTime _lastDayOfMonth;
  CalendarEventType? _typeFilter;

  @override
  void initState() {
    super.initState();
    _allEvents = _ds.getCalendarEvents();
    _updateMonthBounds();
  }

  void _updateMonthBounds() {
    _firstDayOfMonth = DateTime(_focusedDay.year, _focusedDay.month, 1);
    _lastDayOfMonth = DateTime(_focusedDay.year, _focusedDay.month + 1, 0);
  }

  List<CalendarEvent> _eventsFor(DateTime day) {
    final key = DateTime(day.year, day.month, day.day);
    final events = _allEvents[key] ?? [];
    if (_typeFilter == null) return events;
    return events.where((e) => e.type == _typeFilter).toList();
  }

  bool _isToday(DateTime d) {
    final now = DateTime.now();
    return d.year == now.year && d.month == now.month && d.day == now.day;
  }

  bool _isSelected(DateTime d) =>
      d.year == _selectedDay.year &&
      d.month == _selectedDay.month &&
      d.day == _selectedDay.day;

  void _prevMonth() => setState(() {
    _focusedDay = DateTime(_focusedDay.year, _focusedDay.month - 1);
    _updateMonthBounds();
  });

  void _nextMonth() => setState(() {
    _focusedDay = DateTime(_focusedDay.year, _focusedDay.month + 1);
    _updateMonthBounds();
  });

  // Upcoming events across all days (next 7 days)
  List<({DateTime date, CalendarEvent event})> get _upcomingAlerts {
    final today = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );
    final result = <({DateTime date, CalendarEvent event})>[];
    for (int i = 1; i <= 7; i++) {
      final day = today.add(Duration(days: i));
      for (final e in (_allEvents[day] ?? [])) {
        result.add((date: day, event: e));
      }
    }
    return result;
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

    final selectedEvents = _eventsFor(_selectedDay);
    final alerts = _upcomingAlerts;
    final months = [
      'Enero',
      'Febrero',
      'Marzo',
      'Abril',
      'Mayo',
      'Junio',
      'Julio',
      'Agosto',
      'Septiembre',
      'Octubre',
      'Noviembre',
      'Diciembre',
    ];

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Calendario operativo',
          style: GoogleFonts.poppins(fontSize: 17, fontWeight: FontWeight.w700),
        ),
      ),
      body: Column(
        children: [
          // ── Month header + grid ───────────────────────────────────────
          Container(
            color: cardColor,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.chevron_left_rounded,
                        color: textPrimary,
                      ),
                      onPressed: _prevMonth,
                    ),
                    Text(
                      '${months[_focusedDay.month - 1]} ${_focusedDay.year}',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: textPrimary,
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.chevron_right_rounded,
                        color: textPrimary,
                      ),
                      onPressed: _nextMonth,
                    ),
                  ],
                ),
                Row(
                  children: ['Lu', 'Ma', 'Mi', 'Ju', 'Vi', 'Sa', 'Do']
                      .map(
                        (d) => Expanded(
                          child: Center(
                            child: Text(
                              d,
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: textSecondary,
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 8),
                _buildGrid(textPrimary, textSecondary),
              ],
            ),
          ),

          // ── Type filter chips ─────────────────────────────────────────
          Container(
            height: 44,
            color: cardColor,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.fromLTRB(16, 6, 16, 8),
              children: [
                _TypeChip(
                  label: 'Todos',
                  color: AppColors.primary,
                  isSelected: _typeFilter == null,
                  onTap: () => setState(() => _typeFilter = null),
                ),
                ...CalendarEventType.values.map(
                  (t) => Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: _TypeChip(
                      label: t.label,
                      color: _eventTypeColor(t),
                      isSelected: _typeFilter == t,
                      onTap: () => setState(
                        () => _typeFilter = _typeFilter == t ? null : t,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── Events + alerts ───────────────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Selected day events
                  Text(
                    selectedEvents.isEmpty
                        ? 'Sin eventos para este día'
                        : '${selectedEvents.length} ${selectedEvents.length == 1 ? 'evento' : 'eventos'}',
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: textPrimary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (selectedEvents.isEmpty)
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
                            Icons.event_available_rounded,
                            size: 40,
                            color: textSecondary.withValues(alpha: 0.4),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Sin actividad programada',
                            style: GoogleFonts.inter(
                              color: textSecondary,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    ...selectedEvents.asMap().entries.map(
                      (e) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: _EventTile(event: e.value, isDark: isDark),
                      ),
                    ),

                  // Upcoming alerts (next 7 days)
                  if (alerts.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        const Icon(
                          Icons.notifications_active_rounded,
                          size: 16,
                          color: AppColors.warning,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Próximos 7 días',
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: textPrimary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ...alerts.map(
                      (a) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: _AlertTile(
                          date: a.date,
                          event: a.event,
                          isDark: isDark,
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _eventTypeColor(CalendarEventType t) => switch (t) {
    CalendarEventType.delivery => AppColors.statusInProgress,
    CalendarEventType.visit => AppColors.secondary,
    CalendarEventType.meeting => AppColors.info,
    CalendarEventType.milestone => AppColors.warning,
  };

  Widget _buildGrid(Color textPrimary, Color textSecondary) {
    // First weekday of month (Mon=1, so offset = weekday - 1)
    final startOffset = (_firstDayOfMonth.weekday - 1) % 7;
    final daysInMonth = _lastDayOfMonth.day;
    final totalCells = startOffset + daysInMonth;
    final rows = (totalCells / 7).ceil();

    return Column(
      children: List.generate(rows, (row) {
        return Row(
          children: List.generate(7, (col) {
            final cellIndex = row * 7 + col;
            final dayNum = cellIndex - startOffset + 1;
            if (dayNum < 1 || dayNum > daysInMonth) {
              return const Expanded(child: SizedBox(height: 36));
            }
            final day = DateTime(_focusedDay.year, _focusedDay.month, dayNum);
            final hasEvents = _eventsFor(day).isNotEmpty;
            final isToday = _isToday(day);
            final isSelected = _isSelected(day);

            return Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _selectedDay = day),
                child: Container(
                  height: 36,
                  margin: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary
                        : isToday
                        ? AppColors.primary.withValues(alpha: 0.15)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Text(
                        '$dayNum',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: isSelected || isToday
                              ? FontWeight.w700
                              : FontWeight.w400,
                          color: isSelected
                              ? Colors.white
                              : (isToday ? AppColors.primary : textPrimary),
                        ),
                      ),
                      if (hasEvents)
                        Positioned(
                          bottom: 3,
                          child: Container(
                            width: 4,
                            height: 4,
                            decoration: BoxDecoration(
                              color: isSelected ? Colors.white : AppColors.info,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            );
          }),
        );
      }),
    );
  }
}

// ── Event tile ────────────────────────────────────────────────────────────────

class _EventTile extends StatelessWidget {
  final CalendarEvent event;
  final bool isDark;

  const _EventTile({required this.event, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final color = _typeColor(event.type);
    final textPrimary = isDark ? AppColors.darkText : AppColors.lightText;
    final cardColor = isDark ? AppColors.darkCard : AppColors.lightCard;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border(left: BorderSide(color: color, width: 3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              event.type.label,
              style: GoogleFonts.inter(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              event.title,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _typeColor(CalendarEventType t) => switch (t) {
    CalendarEventType.delivery => AppColors.statusInProgress,
    CalendarEventType.visit => AppColors.secondary,
    CalendarEventType.meeting => AppColors.info,
    CalendarEventType.milestone => AppColors.warning,
  };
}

// ── Alert tile ────────────────────────────────────────────────────────────────

class _AlertTile extends StatelessWidget {
  final DateTime date;
  final CalendarEvent event;
  final bool isDark;

  const _AlertTile({
    required this.date,
    required this.event,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final color = _typeColor(event.type);
    final textPrimary = isDark ? AppColors.darkText : AppColors.lightText;
    final textSecondary = isDark
        ? AppColors.darkTextSecondary
        : AppColors.lightTextSecondary;
    final cardColor = isDark ? AppColors.darkCard : AppColors.lightCard;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final daysUntil = date
        .difference(
          DateTime(
            DateTime.now().year,
            DateTime.now().month,
            DateTime.now().day,
          ),
        )
        .inDays;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Icon(_typeIcon(event.type), color: color, size: 18),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.title,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'En $daysUntil ${daysUntil == 1 ? 'día' : 'días'} · ${date.day}/${date.month}',
                  style: GoogleFonts.inter(fontSize: 11, color: textSecondary),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              event.type.label,
              style: GoogleFonts.inter(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _typeColor(CalendarEventType t) => switch (t) {
    CalendarEventType.delivery => AppColors.statusInProgress,
    CalendarEventType.visit => AppColors.secondary,
    CalendarEventType.meeting => AppColors.info,
    CalendarEventType.milestone => AppColors.warning,
  };

  IconData _typeIcon(CalendarEventType t) => switch (t) {
    CalendarEventType.delivery => Icons.local_shipping_rounded,
    CalendarEventType.visit => Icons.store_rounded,
    CalendarEventType.meeting => Icons.groups_rounded,
    CalendarEventType.milestone => Icons.flag_rounded,
  };
}

// ── Type chip ─────────────────────────────────────────────────────────────────

class _TypeChip extends StatelessWidget {
  final String label;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const _TypeChip({
    required this.label,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected
              ? color.withValues(alpha: 0.15)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? color : color.withValues(alpha: 0.3),
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 11,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected ? color : color.withValues(alpha: 0.7),
          ),
        ),
      ),
    );
  }
}
