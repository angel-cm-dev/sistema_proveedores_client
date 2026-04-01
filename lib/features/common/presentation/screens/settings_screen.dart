import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/theme_controller.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeController>();
    final isDark = theme.isDark;

    final bgColor = isDark ? AppColors.darkBg : AppColors.lightBg;
    final cardColor = isDark ? AppColors.darkCard : AppColors.lightCard;
    final textPrimary = isDark ? AppColors.darkText : AppColors.lightText;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text(
          'Ajustes',
          style: GoogleFonts.poppins(fontSize: 17, fontWeight: FontWeight.w700),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Apariencia ────────────────────────────────────────────────
            Text(
              'Apariencia',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: textPrimary,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: borderColor),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        isDark
                            ? Icons.dark_mode_rounded
                            : Icons.light_mode_rounded,
                        color: AppColors.primary,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Modo oscuro',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: textPrimary,
                          ),
                        ),
                      ),
                      Switch.adaptive(
                        value: isDark,
                        onChanged: (_) => theme.toggle(),
                        activeColor: AppColors.primary,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ── Notificaciones ────────────────────────────────────────────
            Text(
              'Notificaciones',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: textPrimary,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: borderColor),
              ),
              child: Column(
                children: [
                  _ToggleTile(
                    icon: Icons.notifications_active_rounded,
                    label: 'Push notifications',
                    initialValue: true,
                    isDark: isDark,
                  ),
                  Divider(color: borderColor, height: 20),
                  _ToggleTile(
                    icon: Icons.mail_outline_rounded,
                    label: 'Notificaciones por correo',
                    initialValue: false,
                    isDark: isDark,
                  ),
                  Divider(color: borderColor, height: 20),
                  _ToggleTile(
                    icon: Icons.warning_amber_rounded,
                    label: 'Alertas de órdenes vencidas',
                    initialValue: true,
                    isDark: isDark,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ── Seguridad ─────────────────────────────────────────────────
            Text(
              'Seguridad',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: textPrimary,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: borderColor),
              ),
              child: Column(
                children: [
                  _ActionTile(
                    icon: Icons.lock_outline_rounded,
                    label: 'Cambiar contraseña',
                    isDark: isDark,
                    onTap: () {},
                  ),
                  Divider(color: borderColor, height: 20),
                  _ActionTile(
                    icon: Icons.fingerprint_rounded,
                    label: 'Autenticación biométrica',
                    isDark: isDark,
                    onTap: () {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ── Acerca de ─────────────────────────────────────────────────
            Text(
              'Acerca de',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: textPrimary,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: borderColor),
              ),
              child: Column(
                children: [
                  _InfoTile(
                    label: 'Versión',
                    value: '1.0.0-beta',
                    isDark: isDark,
                  ),
                  Divider(color: borderColor, height: 20),
                  _InfoTile(
                    label: 'Build',
                    value: '2026.03.31',
                    isDark: isDark,
                  ),
                  Divider(color: borderColor, height: 20),
                  _ActionTile(
                    icon: Icons.description_outlined,
                    label: 'Términos y condiciones',
                    isDark: isDark,
                    onTap: () {},
                  ),
                  Divider(color: borderColor, height: 20),
                  _ActionTile(
                    icon: Icons.shield_outlined,
                    label: 'Política de privacidad',
                    isDark: isDark,
                    onTap: () {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _ToggleTile extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool initialValue;
  final bool isDark;

  const _ToggleTile({
    required this.icon,
    required this.label,
    required this.initialValue,
    required this.isDark,
  });

  @override
  State<_ToggleTile> createState() => _ToggleTileState();
}

class _ToggleTileState extends State<_ToggleTile> {
  late bool _value;

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    final textPrimary = widget.isDark
        ? AppColors.darkText
        : AppColors.lightText;
    return Row(
      children: [
        Icon(widget.icon, size: 20, color: AppColors.primary),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            widget.label,
            style: GoogleFonts.inter(fontSize: 14, color: textPrimary),
          ),
        ),
        Switch.adaptive(
          value: _value,
          onChanged: (v) => setState(() => _value = v),
          activeColor: AppColors.primary,
        ),
      ],
    );
  }
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isDark;
  final VoidCallback onTap;

  const _ActionTile({
    required this.icon,
    required this.label,
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
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.inter(fontSize: 14, color: textPrimary),
            ),
          ),
          Icon(Icons.chevron_right_rounded, size: 18, color: textSecondary),
        ],
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final String label;
  final String value;
  final bool isDark;

  const _InfoTile({
    required this.label,
    required this.value,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final textPrimary = isDark ? AppColors.darkText : AppColors.lightText;
    final textSecondary = isDark
        ? AppColors.darkTextSecondary
        : AppColors.lightTextSecondary;
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: GoogleFonts.inter(fontSize: 14, color: textPrimary),
          ),
        ),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 14,
            color: textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
