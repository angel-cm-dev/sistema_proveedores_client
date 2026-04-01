import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/theme/app_theme.dart';

/// Widget for picking and previewing image attachments for incidents.
class AttachmentPicker extends StatefulWidget {
  final List<XFile> attachments;
  final ValueChanged<List<XFile>> onChanged;
  final int maxAttachments;

  const AttachmentPicker({
    super.key,
    required this.attachments,
    required this.onChanged,
    this.maxAttachments = 5,
  });

  @override
  State<AttachmentPicker> createState() => _AttachmentPickerState();
}

class _AttachmentPickerState extends State<AttachmentPicker> {
  final _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    if (widget.attachments.length >= widget.maxAttachments) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Máximo ${widget.maxAttachments} adjuntos'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final file = await _picker.pickImage(
      source: source,
      maxWidth: 1200,
      maxHeight: 1200,
      imageQuality: 80,
    );

    if (file != null) {
      widget.onChanged([...widget.attachments, file]);
    }
  }

  void _removeAt(int index) {
    final updated = List<XFile>.from(widget.attachments)..removeAt(index);
    widget.onChanged(updated);
  }

  void _showSourcePicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        final isDark = Theme.of(ctx).brightness == Brightness.dark;
        final textPrimary = isDark ? AppColors.darkText : AppColors.lightText;

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Agregar evidencia',
                  style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w700, color: textPrimary),
                ),
                const SizedBox(height: 16),
                ListTile(
                  leading: Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.camera_alt_rounded, color: AppColors.primary),
                  ),
                  title: Text('Tomar foto', style: GoogleFonts.inter(fontWeight: FontWeight.w600, color: textPrimary)),
                  subtitle: Text('Usar la cámara del dispositivo', style: GoogleFonts.inter(fontSize: 12)),
                  onTap: () {
                    Navigator.pop(ctx);
                    _pickImage(ImageSource.camera);
                  },
                ),
                ListTile(
                  leading: Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: AppColors.secondary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.photo_library_rounded, color: AppColors.secondary),
                  ),
                  title: Text('Galería', style: GoogleFonts.inter(fontWeight: FontWeight.w600, color: textPrimary)),
                  subtitle: Text('Seleccionar de la galería', style: GoogleFonts.inter(fontSize: 12)),
                  onTap: () {
                    Navigator.pop(ctx);
                    _pickImage(ImageSource.gallery);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final textSecondary = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Evidencia fotográfica',
              style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            const Spacer(),
            Text(
              '${widget.attachments.length}/${widget.maxAttachments}',
              style: GoogleFonts.inter(fontSize: 12, color: textSecondary),
            ),
          ],
        ),
        const SizedBox(height: 10),

        SizedBox(
          height: 90,
          child: ListView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            children: [
              // Add button
              GestureDetector(
                onTap: _showSourcePicker,
                child: Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    border: Border.all(color: borderColor, width: 1.5),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_a_photo_rounded, color: AppColors.primary, size: 24),
                      const SizedBox(height: 4),
                      Text('Agregar', style: GoogleFonts.inter(fontSize: 10, color: AppColors.primary, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              ),

              // Previews
              ...widget.attachments.asMap().entries.map((e) => Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: Image.file(
                        File(e.value.path),
                        width: 90,
                        height: 90,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: 4,
                      right: 4,
                      child: GestureDetector(
                        onTap: () => _removeAt(e.key),
                        child: Container(
                          width: 22,
                          height: 22,
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.6),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.close_rounded, color: Colors.white, size: 14),
                        ),
                      ),
                    ),
                  ],
                ),
              )),
            ],
          ),
        ),
      ],
    );
  }
}
