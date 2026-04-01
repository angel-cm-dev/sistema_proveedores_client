import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/theme/theme_controller.dart';
import '../../../data/datasources/operator_mock_datasource.dart';
import '../../../domain/entities/supplier_entity.dart';
import 'supplier_detail_screen.dart';

class SuppliersScreen extends StatefulWidget {
  const SuppliersScreen({super.key});

  @override
  State<SuppliersScreen> createState() => _SuppliersScreenState();
}

class _SuppliersScreenState extends State<SuppliersScreen> {
  final _ds = OperatorMockDataSource();
  late final List<SupplierEntity> _all;
  SupplierStatus? _statusFilter;
  String? _categoryFilter;
  String _search = '';

  @override
  void initState() {
    super.initState();
    _all = _ds.getSuppliers();
  }

  List<String> get _categories {
    final cats = <String>{};
    for (final s in _all) {
      cats.addAll(s.categories);
    }
    return cats.toList()..sort();
  }

  List<SupplierEntity> get _filtered => _all.where((s) {
    final statusOk = _statusFilter == null || s.status == _statusFilter;
    final catOk = _categoryFilter == null || s.categories.contains(_categoryFilter);
    final searchOk = _search.isEmpty ||
        s.name.toLowerCase().contains(_search.toLowerCase()) ||
        s.categories.any((c) => c.toLowerCase().contains(_search.toLowerCase()));
    return statusOk && catOk && searchOk;
  }).toList()..sort((a, b) => b.complianceScore.compareTo(a.complianceScore));

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeController>().isDark;
    final bgColor = isDark ? AppColors.darkBg : AppColors.lightBg;
    final textPrimary = isDark ? AppColors.darkText : AppColors.lightText;
    final textSecondary = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // ── Title ───────────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
                child: Text(
                  'Proveedores',
                  style: GoogleFonts.poppins(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: textPrimary,
                  ),
                ),
              ),
            ),

            // ── Search bar ──────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
                child: Container(
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkCard : AppColors.lightCard,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                  ),
                  child: TextField(
                    onChanged: (v) => setState(() => _search = v),
                    style: GoogleFonts.inter(fontSize: 14, color: textPrimary),
                    decoration: InputDecoration(
                      hintText: 'Buscar por nombre o RUC...',
                      hintStyle: GoogleFonts.inter(fontSize: 14, color: textSecondary),
                      prefixIcon: Icon(Icons.search_rounded, size: 20, color: textSecondary),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                    ),
                  ),
                ),
              ),
            ),

            // ── Category chips ──────────────────────────────────────────
            SliverToBoxAdapter(
              child: SizedBox(
                height: 40,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  physics: const BouncingScrollPhysics(),
                  children: [
                    _CategoryChip(
                      label: 'Todos',
                      isSelected: _categoryFilter == null && _statusFilter == null,
                      color: AppColors.primary,
                      onTap: () => setState(() {
                        _categoryFilter = null;
                        _statusFilter = null;
                      }),
                    ),
                    ..._categories.map((cat) => Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: _CategoryChip(
                        label: cat,
                        isSelected: _categoryFilter == cat,
                        color: _chipColor(cat),
                        onTap: () => setState(() {
                          _categoryFilter = _categoryFilter == cat ? null : cat;
                        }),
                      ),
                    )),
                  ],
                ),
              ),
            ),

            // ── Featured suppliers (horizontal) ─────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 4),
                child: Text(
                  'Destacados',
                  style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w700, color: textPrimary),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 180,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                  physics: const BouncingScrollPhysics(),
                  itemCount: _filtered.where((s) => s.complianceScore >= 85).length.clamp(0, 4),
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (_, i) {
                    final top = _filtered.where((s) => s.complianceScore >= 85).toList();
                    if (i >= top.length) return const SizedBox.shrink();
                    return _FeaturedCard(
                      supplier: top[i],
                      index: i,
                      onTap: () => _openDetail(top[i]),
                    );
                  },
                ),
              ),
            ),

            // ── List header ─────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
                child: Row(
                  children: [
                    Text(
                      'Directorio',
                      style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w700, color: textPrimary),
                    ),
                    const Spacer(),
                    Text(
                      '${_filtered.length} proveedores',
                      style: GoogleFonts.inter(fontSize: 12, color: textSecondary),
                    ),
                  ],
                ),
              ),
            ),

            // ── Supplier list ───────────────────────────────────────────
            _filtered.isEmpty
                ? SliverFillRemaining(
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.storefront_outlined, size: 52, color: textSecondary.withValues(alpha: 0.3)),
                          const SizedBox(height: 12),
                          Text('Sin resultados', style: GoogleFonts.inter(color: textSecondary, fontSize: 15)),
                        ],
                      ),
                    ),
                  )
                : SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                    sliver: SliverList.builder(
                      itemCount: _filtered.length,
                      itemBuilder: (_, i) => _SupplierListTile(
                        supplier: _filtered[i],
                        isDark: isDark,
                        index: i,
                        onTap: () => _openDetail(_filtered[i]),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  void _openDetail(SupplierEntity s) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => SupplierDetailScreen(supplier: s)));
  }

  Color _chipColor(String cat) {
    const map = {
      'Eléctrico': Color(0xFF4361EE),
      'Industrial': Color(0xFF7209B7),
      'Transporte': Color(0xFFF77F00),
      'Logística': Color(0xFF4CC9F0),
      'Limpieza': Color(0xFF06D6A0),
      'Suministros': Color(0xFF8338EC),
      'Electrónico': Color(0xFF3A86FF),
      'Mantenimiento': Color(0xFFEF233C),
      'Maquinaria': Color(0xFFFF6B6B),
      'Reparaciones': Color(0xFFE76F51),
      'Construcción': Color(0xFFF4A261),
      'Ferretería': Color(0xFF2A9D8F),
      'Agrícola': Color(0xFF06D6A0),
      'Insumos': Color(0xFF457B9D),
    };
    return map[cat] ?? AppColors.primary;
  }
}

// ── Featured large card (horizontal scroll) ──────────────────────────────────

const _gradients = [
  [Color(0xFF4361EE), Color(0xFF7209B7)],
  [Color(0xFFEF233C), Color(0xFFF77F00)],
  [Color(0xFF06D6A0), Color(0xFF4CC9F0)],
  [Color(0xFF8338EC), Color(0xFF3A86FF)],
];

class _FeaturedCard extends StatelessWidget {
  final SupplierEntity supplier;
  final int index;
  final VoidCallback onTap;

  const _FeaturedCard({required this.supplier, required this.index, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = _gradients[index % _gradients.length];

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 200,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: colors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: colors[0].withValues(alpha: 0.35),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.store_rounded, color: Colors.white, size: 20),
            ),
            const SizedBox(height: 14),
            Text(
              supplier.name,
              style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white, height: 1.2),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              supplier.categories.join(', '),
              style: GoogleFonts.inter(fontSize: 11, color: Colors.white70),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const Spacer(),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${supplier.complianceScore.toStringAsFixed(0)}%',
                    style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white),
                  ),
                ),
                const Spacer(),
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.chevron_right_rounded, color: Colors.white, size: 18),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ── Colorful list tile ───────────────────────────────────────────────────────

const _tileColors = [
  Color(0xFF4361EE),
  Color(0xFFEF233C),
  Color(0xFF7209B7),
  Color(0xFF06D6A0),
  Color(0xFFF77F00),
  Color(0xFF4CC9F0),
  Color(0xFF8338EC),
];

class _SupplierListTile extends StatelessWidget {
  final SupplierEntity supplier;
  final bool isDark;
  final int index;
  final VoidCallback onTap;

  const _SupplierListTile({
    required this.supplier,
    required this.isDark,
    required this.index,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final accentColor = _tileColors[index % _tileColors.length];
    final textSecondary = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              accentColor.withValues(alpha: isDark ? 0.15 : 0.10),
              accentColor.withValues(alpha: isDark ? 0.05 : 0.02),
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: accentColor.withValues(alpha: 0.2)),
        ),
        child: Row(
          children: [
            // Avatar with accent
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  supplier.initials,
                  style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w700, color: accentColor),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    supplier.name,
                    style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700, color: isDark ? Colors.white : AppColors.lightText),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    supplier.categories.join(' · '),
                    style: GoogleFonts.inter(fontSize: 11, color: textSecondary),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            // Chevron
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.chevron_right_rounded, color: accentColor, size: 18),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Category filter chip ─────────────────────────────────────────────────────

class _CategoryChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final Color color;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.label,
    required this.isSelected,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? color : color.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isSelected) ...[
              const Icon(Icons.check_rounded, color: Colors.white, size: 14),
              const SizedBox(width: 4),
            ],
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? Colors.white : color.withValues(alpha: 0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
