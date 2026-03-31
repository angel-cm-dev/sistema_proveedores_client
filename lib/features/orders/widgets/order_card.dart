import 'package:flutter/material.dart';

// --- 1. CORE & MODELS ---
// Importamos el modelo para habilitar el tipado fuerte
import 'package:sistema_proveedores_client/core/models/order_model.dart';

/// [OrderCard] representa una tarjeta de venta individual.
/// Utiliza el modelo [OrderModel] para garantizar la integridad de los datos.
class OrderCard extends StatelessWidget {
  final OrderModel order;

  const OrderCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    // Extraemos el color del estado directamente del modelo (Lógica centralizada)
    final Color statusColor = order.statusColor;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 6),
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            // Feedback táctil profesional al presionar la tarjeta
            onTap: () => debugPrint("Navegando al detalle de: ${order.id}"),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _buildHeader(statusColor),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Divider(
                        height: 1, thickness: 0.8, color: Color(0xFFF1F1F1)),
                  ),
                  _buildBody(statusColor),
                  const SizedBox(height: 16),
                  _buildFooter(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ==========================================
  // COMPONENTES INTERNOS (MODULARIZADOS)
  // ==========================================

  /// Cabecera con el ID de la orden y el Chip de estado
  Widget _buildHeader(Color statusColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          order.id,
          style: const TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 15,
            color: Colors.black45,
            letterSpacing: 0.5,
          ),
        ),
        _buildStatusChip(order.estadoLabel, statusColor),
      ],
    );
  }

  /// Cuerpo con icono dinámico, información del producto y chevron
  Widget _buildBody(Color statusColor) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: statusColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Icon(_getIconForStatus(order.estado),
              color: statusColor, size: 28),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                order.producto,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    fontSize: 17, fontWeight: FontWeight.bold, height: 1.2),
              ),
              const SizedBox(height: 4),
              Text(
                order.proveedor,
                style: const TextStyle(
                    color: Colors.black38,
                    fontSize: 14,
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
        const Icon(Icons.chevron_right, color: Colors.black12),
      ],
    );
  }

  /// Pie de tarjeta con el monto en Soles (S/.) y la fecha
  Widget _buildFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        RichText(
          text: TextSpan(
            style: const TextStyle(color: Colors.black87, fontSize: 14),
            children: [
              const TextSpan(
                  text: "Total: ", style: TextStyle(color: Colors.black38)),
              TextSpan(
                  text: "S/. ${order.total.toStringAsFixed(2)}",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),
        ),
        Text(
          order.fecha,
          style: const TextStyle(
              color: Colors.black45, fontSize: 13, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  // ==========================================
  // HELPERS DE UI
  // ==========================================

  /// Retorna un icono específico según el estado de la orden
  IconData _getIconForStatus(OrderStatus status) {
    switch (status) {
      case OrderStatus.entregado:
        return Icons.check_circle_outline;
      case OrderStatus.enCamino:
        return Icons.local_shipping_outlined;
      case OrderStatus.procesando:
        return Icons.pending_actions_outlined;
    }
  }

  /// Construye el chip visual para el estado de la orden
  Widget _buildStatusChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
            color: color,
            fontWeight: FontWeight.w800,
            fontSize: 10,
            letterSpacing: 0.8),
      ),
    );
  }
}
