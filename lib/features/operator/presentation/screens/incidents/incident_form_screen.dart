import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/theme/theme_controller.dart';
import '../../../domain/entities/incident_entity.dart';
import '../../../domain/entities/order_entity.dart';

class IncidentFormScreen extends StatefulWidget {
  final OrderEntity? order;

  const IncidentFormScreen({super.key, this.order});

  @override
  State<IncidentFormScreen> createState() => _IncidentFormScreenState();
}

class _IncidentFormScreenState extends State<IncidentFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  IncidentPriority _priority = IncidentPriority.medium;
  bool _isSubmitting = false;
  bool _submitted = false;

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    setState(() => _isSubmitting = true);
    await Future.delayed(const Duration(milliseconds: 900));
    if (mounted) {
      setState(() {
        _isSubmitting = false;
        _submitted = true;
      });
    }
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

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text(
          'Nueva incidencia',
          style: GoogleFonts.poppins(fontSize: 17, fontWeight: FontWeight.w700),
        ),
      ),
      body: _submitted
          ? _SuccessView(isDark: isDark, onBack: () => Navigator.pop(context))
          : SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Linked order info ──────────────────────────────────
                    if (widget.order != null) ...[
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: AppColors.primary.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.receipt_long_rounded,
                              size: 18,
                              color: AppColors.primary,
                            ),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Vinculada a orden',
                                  style: GoogleFonts.inter(
                                    fontSize: 11,
                                    color: AppColors.primary,
                                  ),
                                ),
                                Text(
                                  '${widget.order!.id} · ${widget.order!.supplierName}',
                                  style: GoogleFonts.inter(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: textPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],

                    // ── Title ──────────────────────────────────────────────
                    Text(
                      'Título',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _titleCtrl,
                      textInputAction: TextInputAction.next,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: textPrimary,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Ej: Retraso en entrega, material dañado...',
                        hintStyle: GoogleFonts.inter(
                          fontSize: 14,
                          color: textSecondary.withValues(alpha: 0.5),
                        ),
                      ),
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return 'Ingresa un título';
                        }
                        if (v.trim().length < 5) {
                          return 'Mínimo 5 caracteres';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    // ── Priority ───────────────────────────────────────────
                    Text(
                      'Prioridad',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: IncidentPriority.values
                          .map(
                            (p) => Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(
                                  right: p != IncidentPriority.critical ? 8 : 0,
                                ),
                                child: _PriorityOption(
                                  priority: p,
                                  isSelected: _priority == p,
                                  onTap: () => setState(() => _priority = p),
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                    const SizedBox(height: 20),

                    // ── Description ────────────────────────────────────────
                    Text(
                      'Descripción',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _descCtrl,
                      maxLines: 5,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: textPrimary,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Describe el problema con detalle...',
                        hintStyle: GoogleFonts.inter(
                          fontSize: 14,
                          color: textSecondary.withValues(alpha: 0.5),
                        ),
                        alignLabelWithHint: true,
                      ),
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return 'Ingresa una descripción';
                        }
                        if (v.trim().length < 10) {
                          return 'Mínimo 10 caracteres';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),

                    // ── Attachment placeholder ─────────────────────────────
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: cardColor,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: borderColor,
                            style: BorderStyle.solid,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.attach_file_rounded,
                              size: 18,
                              color: textSecondary,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Adjuntar foto o documento',
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                color: textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // ── Submit ─────────────────────────────────────────────
                    GestureDetector(
                      onTap: _isSubmitting ? null : _submit,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: double.infinity,
                        height: 54,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: _isSubmitting
                                ? [
                                    AppColors.warning.withValues(alpha: 0.6),
                                    AppColors.warning.withValues(alpha: 0.4),
                                  ]
                                : [AppColors.warning, const Color(0xFFE8560A)],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: _isSubmitting
                              ? []
                              : [
                                  BoxShadow(
                                    color: AppColors.warning.withValues(
                                      alpha: 0.35,
                                    ),
                                    blurRadius: 16,
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                        ),
                        child: Center(
                          child: _isSubmitting
                              ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2.5,
                                  ),
                                )
                              : Text(
                                  'Registrar incidencia',
                                  style: GoogleFonts.inter(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 15,
                                  ),
                                ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
    );
  }
}

class _PriorityOption extends StatelessWidget {
  final IncidentPriority priority;
  final bool isSelected;
  final VoidCallback onTap;

  const _PriorityOption({
    required this.priority,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = _color(priority);
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? color.withValues(alpha: 0.15)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? color : color.withValues(alpha: 0.3),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Column(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(height: 4),
            Text(
              priority.label,
              style: GoogleFonts.inter(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: color,
              ),
            ),
          ],
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

class _SuccessView extends StatelessWidget {
  final bool isDark;
  final VoidCallback onBack;

  const _SuccessView({required this.isDark, required this.onBack});

  @override
  Widget build(BuildContext context) {
    final textPrimary = isDark ? AppColors.darkText : AppColors.lightText;
    final textSecondary = isDark
        ? AppColors.darkTextSecondary
        : AppColors.lightTextSecondary;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: AppColors.warning.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.bug_report_rounded,
                size: 48,
                color: AppColors.warning,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Incidencia registrada',
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: textPrimary,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'La incidencia fue creada exitosamente.\nEl equipo será notificado para su atención.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: textSecondary,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),
            GestureDetector(
              onTap: onBack,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primary, AppColors.secondary],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  'Volver',
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
