// lib/features/notifications/widgets/notification_tile.dart
import 'package:flutter/material.dart';
import 'package:sistema_proveedores_client/core/models/notification_model.dart';

class NotificationTile extends StatefulWidget {
  final NotificationModel notification;
  final VoidCallback onTap;
  // Agregamos animación externa para el manejo de Slivers
  final Animation<double>? animation;

  const NotificationTile({
    super.key,
    required this.notification,
    required this.onTap,
    this.animation,
  });

  @override
  State<NotificationTile> createState() => _NotificationTileState();
}

class _NotificationTileState extends State<NotificationTile> {
  bool _isExpanded = false; // Estado local de expansión

  @override
  Widget build(BuildContext context) {
    // FIX VISUAL: Corregimos la translucidez
    // Si está expandida, forzamos blanco sólido (opacity 1.0) para legibilidad.
    // Si está contraída y leída, usamos una opacidad sutil (0.6).
    final double cardOpacity =
        _isExpanded ? 1.0 : (widget.notification.isRead ? 0.6 : 1.0);

    final bool isUnread = !widget.notification.isRead;

    // Usamos SizeTransition si recibimos animación externa (para borrados de lista)
    Widget currentTile = GestureDetector(
      onTap: () {
        setState(() => _isExpanded = !_isExpanded);
        widget.onTap(); // Marca como leída
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        curve: Curves.fastOutSlowIn,
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          // Aplicamos opacidad dinámica corregida
          color: Colors.white.withOpacity(cardOpacity),
          borderRadius: BorderRadius.circular(22),
          // Sombra dinámica: Más profunda si está expandida
          boxShadow: [
            BoxShadow(
              color: isUnread || _isExpanded
                  ? const Color(0xFF6792FF).withValues(alpha: 0.1)
                  : Colors.black.withValues(alpha: 0.02),
              blurRadius: _isExpanded ? 20 : 15,
              offset: Offset(0, _isExpanded ? 8 : 6),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildIconSection(isUnread),
                const SizedBox(width: 18),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.notification.title,
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 17,
                          color: (isUnread || _isExpanded)
                              ? Colors.black87
                              : Colors.black45,
                        ),
                      ),
                      const SizedBox(height: 6),
                      // Animación implícita de altura al cambiar maxLines
                      AnimatedSize(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        alignment: Alignment.topLeft,
                        child: Text(
                          widget.notification.body,
                          maxLines: _isExpanded ? 15 : 2,
                          overflow: _isExpanded
                              ? TextOverflow.visible
                              : TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 13,
                            height: 1.6, // Más interlineado para lectura
                            color: (isUnread || _isExpanded)
                                ? Colors.black54
                                : Colors.black38,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // Indicador visual sutil de "Toca para cerrar"
            AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: _isExpanded ? 1.0 : 0.0,
              child: _isExpanded
                  ? const Padding(
                      padding: EdgeInsets.only(top: 16),
                      child: Divider(height: 1),
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );

    // Si hay animación externa, envolvemos en SizeTransition para borrado suave
    if (widget.animation != null) {
      return SizeTransition(
        sizeFactor: widget.animation!,
        child: currentTile,
      );
    }

    return currentTile;
  }

  Widget _buildIconSection(bool isUnread) {
    return Row(
      children: [
        if (isUnread)
          Container(
            width: 4,
            height: 28,
            decoration: BoxDecoration(
                color: Colors.blue, borderRadius: BorderRadius.circular(2)),
          ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: widget.notification.color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Icon(widget.notification.icon,
              color: widget.notification.color, size: 26),
        ),
      ],
    );
  }
}
