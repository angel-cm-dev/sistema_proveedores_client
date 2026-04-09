import 'package:flutter/material.dart';

/// Modelo simple para las sub-opciones
class ProfileOption {
  final String title;
  final VoidCallback? onTap;
  const ProfileOption({required this.title, this.onTap});
}

class ExpandableProfileCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final List<ProfileOption> options;

  const ExpandableProfileCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.options,
  });

  @override
  State<ExpandableProfileCard> createState() => _ExpandableProfileCardState();
}

class _ExpandableProfileCardState extends State<ExpandableProfileCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 20,
            offset: const Offset(0, 8),
          )
        ],
      ),
      child: Column(
        children: [
          // Header de la tarjeta (Parte siempre visible)
          InkWell(
            borderRadius: BorderRadius.circular(24),
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  _buildIconBox(),
                  const SizedBox(width: 16),
                  _buildTextSection(),
                  _buildAnimatedChevron(),
                ],
              ),
            ),
          ),
          // Contenido expandible (FIX: Usamos AnimatedSize para evitar deformación)
          _buildExpandedContent(),
        ],
      ),
    );
  }

  Widget _buildIconBox() => Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF6792FF).withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(widget.icon, color: const Color(0xFF6792FF), size: 24),
      );

  Widget _buildTextSection() => Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.title,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            Text(widget.subtitle,
                style: const TextStyle(fontSize: 12, color: Colors.black38)),
          ],
        ),
      );

  Widget _buildAnimatedChevron() => AnimatedRotation(
        turns: _isExpanded ? 0.5 : 0.0,
        duration: const Duration(milliseconds: 300),
        child: const Icon(Icons.expand_more, color: Colors.black26),
      );

  // FIX: AnimatedSize recorta el contenido fluidamente sin aplastarlo
  Widget _buildExpandedContent() => AnimatedSize(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        alignment: Alignment.topCenter,
        child: _isExpanded
            ? Column(
                children: [
                  const Divider(height: 1, indent: 20, endIndent: 20),
                  ...widget.options.map((opt) => ListTile(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 24),
                        title: Text(opt.title,
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w500)),
                        trailing: const Icon(Icons.arrow_forward_ios,
                            size: 14, color: Colors.black26),
                        onTap: opt.onTap ?? () => _showMockAction(opt.title),
                      )),
                  const SizedBox(height: 8),
                ],
              )
            : const SizedBox(
                width: double.infinity,
                height: 0), // Oculto sin perder su ancho
      );

  void _showMockAction(String title) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Falta crear el archivo para: $title"),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
