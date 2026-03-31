import 'package:flutter/material.dart';
import 'package:sistema_proveedores_client/core/models/supplier_model.dart';

class VCard extends StatelessWidget {
  final SupplierModel supplier;
  const VCard({super.key, required this.supplier});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      height: 310,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: supplier.color,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.business_center, color: Colors.white, size: 32),
          const SizedBox(height: 20),
          Text(
            supplier.nombre,
            maxLines: 2,
            style: const TextStyle(
                color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(supplier.ubicacion,
              style: const TextStyle(color: Colors.white70, fontSize: 16)),
          const Spacer(),
          // AVATARES: Cargando imágenes reales de la carpeta assets
          _buildAvatarStack(),
        ],
      ),
    );
  }

  Widget _buildAvatarStack() {
    return Row(
      children: List.generate(3, (i) {
        return Transform.translate(
          offset: Offset(i * -12.0, 0),
          child: CircleAvatar(
            radius: 20,
            backgroundColor: Colors.white24,
            backgroundImage: AssetImage(
                "assets/samples/ui/rive_app/images/avatars/avatar_${i + 1}.jpg"),
          ),
        );
      }),
    );
  }
}
