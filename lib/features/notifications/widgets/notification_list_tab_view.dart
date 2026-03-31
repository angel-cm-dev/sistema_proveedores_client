// lib/features/notifications/widgets/notification_list_tab_view.dart
import 'package:flutter/material.dart';
import 'package:sistema_proveedores_client/core/models/notification_model.dart';
import 'notification_tile.dart';

class NotificationListTabView extends StatefulWidget {
  const NotificationListTabView({super.key});

  @override
  State<NotificationListTabView> createState() =>
      _NotificationListTabViewState();
}

class _NotificationListTabViewState extends State<NotificationListTabView> {
  // Key crucial para manejar las animaciones de la lista
  final GlobalKey<SliverAnimatedListState> _listKey =
      GlobalKey<SliverAnimatedListState>();

  // Data Mock (10 notificaciones)
  final List<NotificationModel> _notifications = [
    NotificationModel(
        id: "1",
        title: "¡Pedido en camino!",
        body:
            "Tu orden ORD-004 de Racks de 42U ya salió del almacén principal de Connexa ubicado en el Callao.",
        timestamp: DateTime.now(),
        type: NotificationType.pedido),
    NotificationModel(
        id: "2",
        title: "Actualización de Seguridad",
        body:
            "Detectamos un inicio de sesión desde un nuevo dispositivo en San Juan de Lurigancho, Lima. Si no fuiste tú, cambia tu contraseña inmediatamente.",
        timestamp: DateTime.now(),
        type: NotificationType.sistema),
    NotificationModel(
        id: "3",
        title: "Promoción VIP",
        body:
            "Solo por ser cliente de Connexa, accede a la preventa de nuevos servidores Dell con un 30% de descuento directo sobre el precio de lista.",
        timestamp: DateTime.now(),
        type: NotificationType.promocion,
        isRead: true),
    NotificationModel(
        id: "4",
        title: "Confirmación de Pago",
        body:
            "Recibimos S/. 1,200 por el Software Gestión v2. Tu factura electrónica ha sido enviada al correo registrado.",
        timestamp: DateTime.now(),
        type: NotificationType.sistema),
    NotificationModel(
        id: "5",
        title: "Pedido ORD-003 Procesado",
        body:
            "Connexa Solutions ha validado tu orden. Pronto será enviada por nuestro operador logístico.",
        timestamp: DateTime.now(),
        type: NotificationType.pedido,
        isRead: true),
    NotificationModel(
        id: "6",
        title: "Corte de Sistema",
        body:
            "Mantenimiento programado: el portal de proveedores estará fuera de servicio el domingo de 2:00 AM a 4:00 AM.",
        timestamp: DateTime.now(),
        type: NotificationType.sistema),
    NotificationModel(
        id: "7",
        title: "Suscripción Premium",
        body:
            "Tu suscripción anual vence en 30 días. Renuévala ahora para mantener tus beneficios de envío gratis.",
        timestamp: DateTime.now(),
        type: NotificationType.promocion),
    NotificationModel(
        id: "8",
        title: "Nuevos Cables de Fibra",
        body:
            "techLogistics ha agregado Cables OM4 a su catálogo. Revisa los nuevos precios competitivos.",
        timestamp: DateTime.now(),
        type: NotificationType.pedido,
        isRead: true),
    NotificationModel(
        id: "9",
        title: "Seguridad de Cuenta",
        body:
            "Te recordamos activar la autenticación de dos factores (2FA) para proteger tus transacciones.",
        timestamp: DateTime.now(),
        type: NotificationType.sistema),
    NotificationModel(
        id: "10",
        title: "ORD-001: Retraso Logístico",
        body:
            "techLogistics informa un retraso de 24h para tus Servidores Blade X debido a problemas climatológicos.",
        timestamp: DateTime.now(),
        type: NotificationType.pedido),
  ];

  /// Lógica de ELIMINACIÓN PREMIUM con animaciones de lista
  void _deleteNotification(int index) {
    final deletedItem = _notifications[index];

    // 1. Borrado físico de la data
    _notifications.removeAt(index);

    // 2. Avisamos a la lista animada para que ejecute la animación de encogimiento
    _listKey.currentState?.removeItem(
      index,
      (context, animation) => NotificationTile(
        notification:
            deletedItem, // Mostramos el item borrado durante la animación
        onTap: () {}, // Desactivamos interacciones durante borrado
        animation: animation, // Pasamos la animación de la lista
      ),
      duration: const Duration(milliseconds: 350),
    );

    // 3. Mostramos SnackBar con opción de DESHACER
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text("Notificación eliminada"),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        action: SnackBarAction(
          label: "DESHACER",
          textColor: Colors.blueAccent,
          onPressed: () => _undoDeletion(index, deletedItem),
        ),
      ),
    );
  }

  /// Lógica de RECUPERACIÓN PREMIUM con animaciones de lista
  void _undoDeletion(int index, NotificationModel item) {
    // 1. Reinserción física de la data
    _notifications.insert(index, item);
    // 2. Avisamos a la lista animada para que lo inserte con animación de expansión
    _listKey.currentState
        ?.insertItem(index, duration: const Duration(milliseconds: 350));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Colors.transparent, // Mantiene el fondo animado del dashboard
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildSliverHeader(),
          _buildSliverAnimatedList(),
        ],
      ),
    );
  }

  Widget _buildSliverHeader() {
    return SliverPadding(
      padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + 80,
          left: 24,
          right: 24,
          bottom: 20),
      sliver: SliverToBoxAdapter(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Notificaciones",
                style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Poppins")),
            TextButton(
              onPressed: () => setState(() {
                for (var n in _notifications) {
                  n.isRead = true;
                }
              }),
              child: const Text("Leído todo"),
            )
          ],
        ),
      ),
    );
  }

  /// IMPLEMENTACIÓN DE SLIVERANIMATEDLIST
  Widget _buildSliverAnimatedList() {
    return SliverPadding(
      padding: const EdgeInsets.only(left: 24, right: 24, bottom: 120),
      sliver: SliverAnimatedList(
        key: _listKey,
        initialItemCount: _notifications.length,
        itemBuilder: (context, index, animation) {
          final notification = _notifications[index];

          return Dismissible(
            key: Key(notification.id),
            direction:
                DismissDirection.endToStart, // Swipe de derecha a izquierda
            onDismissed: (direction) => _deleteNotification(index),
            background: _buildDismissBackground(),
            // Envolvemos la tarjeta en la SizeTransition de la lista animada
            child: NotificationTile(
              notification: notification,
              onTap: () => setState(() => notification.isRead = true),
              animation:
                  animation, // Pasamos la animación externa para el reacomodo
            ),
          );
        },
      ),
    );
  }

  /// Fondo rojo con icono de basura al deslizar
  Widget _buildDismissBackground() {
    return Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: 30),
      margin:
          const EdgeInsets.only(bottom: 16), // Margen coherente con la tarjeta
      decoration: BoxDecoration(
        color: Colors.redAccent.withOpacity(0.9),
        borderRadius: BorderRadius.circular(22),
      ),
      child: const Icon(Icons.delete_outline, color: Colors.white, size: 30),
    );
  }
}
