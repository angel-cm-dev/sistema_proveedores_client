import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/theme/theme_controller.dart';
import '../../../../auth/presentation/controllers/auth_controller.dart';

class OwnerProfileScreen extends StatelessWidget {
  const OwnerProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.read<AuthController>();
    final theme = context.watch<ThemeController>();
    final isDark = theme.isDark;
    final user = auth.currentUser;

    final bgColor = isDark ? AppColors.darkBg : AppColors.lightBg;
    final cardColor = isDark ? AppColors.darkCard : AppColors.lightCard;
    final textPrimary = isDark ? AppColors.darkText : AppColors.lightText;
    final textSecondary = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Perfil', style: GoogleFonts.poppins(fontSize: 17, fontWeight: FontWeight.w700)),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Avatar + name
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: borderColor),
              ),
              child: Column(
                children: [
                  Container(
                    width: 72, height: 72,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [AppColors.secondary, AppColors.primary]),
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: Center(
                      child: Text(
                        user?.initials ?? 'OW',
                        style: GoogleFonts.poppins(fontSize: 26, fontWeight: FontWeight.w800, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(user?.name ?? 'Owner', style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w700, color: textPrimary)),
                  const SizedBox(height: 4),
                  Text(user?.email ?? '', style: GoogleFonts.inter(fontSize: 14, color: textSecondary)),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.secondary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text('Owner', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.secondary)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Theme toggle
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: borderColor),
              ),
              child: Row(
                children: [
                  Icon(isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded, color: AppColors.secondary, size: 20),
                  const SizedBox(width: 12),
                  Expanded(child: Text('Modo oscuro', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: textPrimary))),
                  Switch.adaptive(
                    value: isDark,
                    onChanged: (_) => theme.toggle(),
                    activeColor: AppColors.secondary,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Settings items
            _SettingsTile(icon: Icons.notifications_outlined, label: 'Notificaciones', isDark: isDark, onTap: () {}),
            _SettingsTile(icon: Icons.lock_outline_rounded, label: 'Seguridad', isDark: isDark, onTap: () {}),
            _SettingsTile(icon: Icons.info_outline_rounded, label: 'Acerca de Connexa', isDark: isDark, onTap: () {}),
            const SizedBox(height: 24),

            // Logout
            GestureDetector(
              onTap: () => _confirmLogout(context, auth),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.logout_rounded, size: 18, color: AppColors.error),
                    const SizedBox(width: 8),
                    Text('Cerrar sesión', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.error)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  void _confirmLogout(BuildContext context, AuthController auth) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Cerrar sesión', style: GoogleFonts.poppins(fontWeight: FontWeight.w700)),
        content: Text('¿Estás seguro de que deseas salir?', style: GoogleFonts.inter()),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await auth.logout();
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Salir'),
          ),
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isDark;
  final VoidCallback onTap;

  const _SettingsTile({required this.icon, required this.label, required this.isDark, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final cardColor = isDark ? AppColors.darkCard : AppColors.lightCard;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final textPrimary = isDark ? AppColors.darkText : AppColors.lightText;
    final textSecondary = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: borderColor),
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: AppColors.secondary),
            const SizedBox(width: 12),
            Expanded(child: Text(label, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: textPrimary))),
            Icon(Icons.chevron_right_rounded, size: 18, color: textSecondary),
          ],
        ),
      ),
    );
  }
}
