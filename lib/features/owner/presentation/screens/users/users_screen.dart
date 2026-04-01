import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/theme/theme_controller.dart';
import '../../../../auth/domain/entities/user_entity.dart';
import '../../../data/datasources/owner_mock_datasource.dart';
import '../../../domain/entities/internal_user_entity.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  final _ds = OwnerMockDataSource();
  late List<InternalUserEntity> _users;

  @override
  void initState() {
    super.initState();
    _users = _ds.getUsers();
  }

  void _toggleStatus(int index) {
    setState(() {
      final u = _users[index];
      _users[index] = InternalUserEntity(
        id: u.id,
        name: u.name,
        email: u.email,
        role: u.role,
        status: u.status == InternalUserStatus.active
            ? InternalUserStatus.inactive
            : InternalUserStatus.active,
        createdAt: u.createdAt,
        lastLogin: u.lastLogin,
      );
    });
    final u = _users[index];
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${u.name} ahora está ${u.status.label.toLowerCase()}'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeController>().isDark;
    final bgColor = isDark ? AppColors.darkBg : AppColors.lightBg;

    final active = _users
        .where((u) => u.status == InternalUserStatus.active)
        .length;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Usuarios internos',
          style: GoogleFonts.poppins(fontSize: 17, fontWeight: FontWeight.w700),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: TextButton.icon(
              onPressed: () => _showAddUserDialog(context, isDark),
              icon: const Icon(Icons.person_add_rounded, size: 18),
              label: Text(
                'Agregar',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Stats bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            color: isDark ? AppColors.darkCard : AppColors.lightCard,
            child: Row(
              children: [
                _StatChip(
                  label: 'Total',
                  value: '${_users.length}',
                  color: AppColors.primary,
                  isDark: isDark,
                ),
                const SizedBox(width: 12),
                _StatChip(
                  label: 'Activos',
                  value: '$active',
                  color: AppColors.statusCompleted,
                  isDark: isDark,
                ),
                const SizedBox(width: 12),
                _StatChip(
                  label: 'Inactivos',
                  value: '${_users.length - active}',
                  color: AppColors.darkTextSecondary,
                  isDark: isDark,
                ),
              ],
            ),
          ),

          // List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              physics: const BouncingScrollPhysics(),
              itemCount: _users.length,
              itemBuilder: (_, i) => _UserCard(
                user: _users[i],
                isDark: isDark,
                onToggleStatus: () => _toggleStatus(i),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddUserDialog(BuildContext context, bool isDark) {
    final nameCtrl = TextEditingController();
    final emailCtrl = TextEditingController();
    UserRole selectedRole = UserRole.operator;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: Text(
            'Nuevo usuario',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w700),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: 'Nombre completo'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: emailCtrl,
                decoration: const InputDecoration(
                  labelText: 'Correo electrónico',
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<UserRole>(
                value: selectedRole,
                items: UserRole.values
                    .map(
                      (r) => DropdownMenuItem(
                        value: r,
                        child: Text(
                          r == UserRole.operator ? 'Operador' : 'Owner',
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (v) => setDialogState(() => selectedRole = v!),
                decoration: const InputDecoration(labelText: 'Rol'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                if (nameCtrl.text.trim().isEmpty ||
                    emailCtrl.text.trim().isEmpty)
                  return;
                setState(() {
                  _users.add(
                    InternalUserEntity(
                      id: 'usr-${_users.length + 1}'.padLeft(3, '0'),
                      name: nameCtrl.text.trim(),
                      email: emailCtrl.text.trim(),
                      role: selectedRole,
                      status: InternalUserStatus.active,
                      createdAt: DateTime.now(),
                    ),
                  );
                });
                Navigator.pop(ctx);
              },
              child: const Text('Crear'),
            ),
          ],
        ),
      ),
    );
  }
}

class _UserCard extends StatelessWidget {
  final InternalUserEntity user;
  final bool isDark;
  final VoidCallback onToggleStatus;

  const _UserCard({
    required this.user,
    required this.isDark,
    required this.onToggleStatus,
  });

  @override
  Widget build(BuildContext context) {
    final cardColor = isDark ? AppColors.darkCard : AppColors.lightCard;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final textPrimary = isDark ? AppColors.darkText : AppColors.lightText;
    final textSecondary = isDark
        ? AppColors.darkTextSecondary
        : AppColors.lightTextSecondary;
    final isActive = user.status == InternalUserStatus.active;
    final roleColor = user.role == UserRole.owner
        ? AppColors.secondary
        : AppColors.primary;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: roleColor.withValues(alpha: 0.12),
            child: Text(
              user.initials,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: roleColor,
              ),
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
                        user.name,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: textPrimary,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: roleColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        user.role == UserRole.owner ? 'Owner' : 'Operador',
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: roleColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  user.email,
                  style: GoogleFonts.inter(fontSize: 12, color: textSecondary),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: isActive
                            ? AppColors.statusCompleted
                            : AppColors.darkTextSecondary,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      user.status.label,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: isActive
                            ? AppColors.statusCompleted
                            : AppColors.darkTextSecondary,
                      ),
                    ),
                    if (user.lastLogin != null) ...[
                      const SizedBox(width: 12),
                      Icon(
                        Icons.schedule_rounded,
                        size: 11,
                        color: textSecondary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _relativeTime(user.lastLogin!),
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: textSecondary,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert_rounded, size: 18, color: textSecondary),
            itemBuilder: (_) => [
              PopupMenuItem(
                value: 'toggle',
                child: Text(isActive ? 'Desactivar' : 'Activar'),
              ),
            ],
            onSelected: (v) {
              if (v == 'toggle') onToggleStatus();
            },
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
}

class _StatChip extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final bool isDark;

  const _StatChip({
    required this.label,
    required this.value,
    required this.color,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          const SizedBox(width: 6),
          Text(label, style: GoogleFonts.inter(fontSize: 11, color: color)),
        ],
      ),
    );
  }
}
