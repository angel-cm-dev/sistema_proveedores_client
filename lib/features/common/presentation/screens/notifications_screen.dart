import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/theme_controller.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  late final List<_NotificationItem> _notifications;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _notifications = [
      _NotificationItem(
        icon: Icons.local_shipping_rounded,
        color: AppColors.statusInProgress,
        title: 'Entrega programada',
        body: 'ORD-0041 de Distribuidora Montes S.A. se entrega hoy.',
        time: now.subtract(const Duration(minutes: 15)),
        isRead: false,
      ),
      _NotificationItem(
        icon: Icons.bug_report_rounded,
        color: AppColors.warning,
        title: 'Nueva incidencia',
        body: 'INC-004 abierta por documentación incompleta en ORD-0033.',
        time: now.subtract(const Duration(hours: 6)),
        isRead: false,
      ),
      _NotificationItem(
        icon: Icons.check_circle_rounded,
        color: AppColors.statusCompleted,
        title: 'Incidencia resuelta',
        body: 'INC-003 (cable dañado) fue marcada como resuelta.',
        time: now.subtract(const Duration(days: 2)),
        isRead: true,
      ),
      _NotificationItem(
        icon: Icons.warning_amber_rounded,
        color: AppColors.statusDelayed,
        title: 'Orden atrasada',
        body: 'ORD-0040 de LogiTrans Norte superó la fecha de vencimiento.',
        time: now.subtract(const Duration(days: 2, hours: 5)),
        isRead: true,
      ),
      _NotificationItem(
        icon: Icons.person_add_rounded,
        color: AppColors.primary,
        title: 'Nuevo usuario creado',
        body: 'María López fue agregada como operadora.',
        time: now.subtract(const Duration(days: 5)),
        isRead: true,
      ),
    ];
  }

  void _markAllRead() {
    setState(() {
      for (int i = 0; i < _notifications.length; i++) {
        _notifications[i] = _notifications[i].copyWith(isRead: true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeController>().isDark;
    final bgColor = isDark ? AppColors.darkBg : AppColors.lightBg;
    final textSecondary = isDark
        ? AppColors.darkTextSecondary
        : AppColors.lightTextSecondary;
    final unread = _notifications.where((n) => !n.isRead).length;

    final textPrimary = isDark ? AppColors.darkText : AppColors.lightText;

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // ── Header ──────────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new_rounded),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Expanded(
                      child: Text(
                        'Notificaciones',
                        style: GoogleFonts.poppins(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: textPrimary,
                        ),
                      ),
                    ),
                    if (unread > 0)
                      GestureDetector(
                        onTap: _markAllRead,
                        child: Text(
                          'Leído todo',
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            // ── List ────────────────────────────────────────────────────
            _notifications.isEmpty
                ? SliverFillRemaining(
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.notifications_off_outlined,
                            size: 52,
                            color: textSecondary.withValues(alpha: 0.3),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Sin notificaciones',
                            style: GoogleFonts.inter(
                              color: textSecondary,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                    sliver: SliverList.builder(
                      itemCount: _notifications.length,
                      itemBuilder: (_, i) => _NotificationCard(
                        item: _notifications[i],
                        isDark: isDark,
                        onTap: () {
                          if (!_notifications[i].isRead) {
                            setState(
                              () => _notifications[i] = _notifications[i]
                                  .copyWith(isRead: true),
                            );
                          }
                        },
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}

class _NotificationItem {
  final IconData icon;
  final Color color;
  final String title;
  final String body;
  final DateTime time;
  final bool isRead;

  const _NotificationItem({
    required this.icon,
    required this.color,
    required this.title,
    required this.body,
    required this.time,
    required this.isRead,
  });

  _NotificationItem copyWith({bool? isRead}) => _NotificationItem(
    icon: icon,
    color: color,
    title: title,
    body: body,
    time: time,
    isRead: isRead ?? this.isRead,
  );
}

class _NotificationCard extends StatelessWidget {
  final _NotificationItem item;
  final bool isDark;
  final VoidCallback onTap;

  const _NotificationCard({
    required this.item,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textPrimary = isDark ? AppColors.darkText : AppColors.lightText;
    final textSecondary = isDark
        ? AppColors.darkTextSecondary
        : AppColors.lightTextSecondary;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              item.color.withValues(alpha: isDark ? 0.12 : 0.08),
              item.color.withValues(alpha: isDark ? 0.04 : 0.02),
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: item.color.withValues(alpha: 0.15)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: item.color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Icon(item.icon, color: item.color, size: 20),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      if (!item.isRead)
                        Container(
                          width: 7,
                          height: 7,
                          margin: const EdgeInsets.only(right: 6),
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                      Expanded(
                        child: Text(
                          item.title,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: item.isRead
                                ? FontWeight.w600
                                : FontWeight.w700,
                            color: textPrimary,
                          ),
                        ),
                      ),
                      Text(
                        _relativeTime(item.time),
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.body,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: textSecondary,
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _relativeTime(DateTime d) {
    final diff = DateTime.now().difference(d);
    if (diff.inMinutes < 60) return '${diff.inMinutes}min';
    if (diff.inHours < 24) return '${diff.inHours}h';
    return '${diff.inDays}d';
  }
}
