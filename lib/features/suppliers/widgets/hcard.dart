import 'package:flutter/material.dart';
import 'package:sistema_proveedores_client/core/models/supplier_model.dart';

class HCard extends StatelessWidget {
  final SupplierModel supplier;
  const HCard({super.key, required this.supplier});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        color: supplier.color,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  supplier.nombre,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(supplier.ubicacion,
                    style: const TextStyle(color: Colors.white70)),
              ],
            ),
          ),
          // ACCIÓN: Reemplazamos "iOS" por un botón de acción funcional
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.arrow_forward_ios,
                color: Colors.white, size: 16),
          ),
        ],
      ),
    );
  }
}
