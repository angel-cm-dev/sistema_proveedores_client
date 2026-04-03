import 'package:flutter/material.dart';
import '../widgets/home_tab_view.dart'; // Importa el modelo Supplier

class SupplierDetailScreen extends StatelessWidget {
  final Supplier supplier;
  const SupplierDetailScreen({super.key, required this.supplier});

  @override
  Widget build(BuildContext context) {
    const navy = Color(0xFF17203A);

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Header con Imagen y Hero
          SliverAppBar(
            expandedHeight: 300,
            backgroundColor: navy,
            leading: const BackButton(color: Colors.white),
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: 'supplier_img_${supplier.name}',
                child: Image.network(
                  supplier.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nombre y Rating
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          supplier.name,
                          style: const TextStyle(color: navy, fontSize: 28, fontWeight: FontWeight.w900),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(color: Colors.amber.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                        child: Row(
                          children: [
                            const Icon(Icons.star_rounded, color: Colors.amber, size: 20),
                            const SizedBox(width: 4),
                            Text(supplier.rating.toString(), style: const TextStyle(fontWeight: FontWeight.bold, color: navy)),
                          ],
                        ),
                      ),
                    ],
                  ),

                  Text(supplier.location, style: TextStyle(color: navy.withOpacity(0.5), fontSize: 16)),

                  const SizedBox(height: 30),

                  const Text("Sobre nosotros", style: TextStyle(color: navy, fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Text(supplier.description, style: const TextStyle(color: Colors.black54, fontSize: 15, height: 1.5)),

                  const SizedBox(height: 30),

                  const Text("Servicios", style: TextStyle(color: navy, fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 10,
                    children: supplier.services.map((s) => Chip(
                      label: Text(s, style: const TextStyle(color: Colors.white)),
                      backgroundColor: supplier.color,
                      side: BorderSide.none,
                    )).toList(),
                  ),

                  const SizedBox(height: 100), // Espacio para el botón inferior
                ],
              ),
            ),
          ),
        ],
      ),
      bottomSheet: _buildBottomAction(supplier),
    );
  }

  Widget _buildBottomAction(Supplier supplier) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, -10))],
      ),
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: supplier.color,
          minimumSize: const Size(double.infinity, 60),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 0,
        ),
        child: const Text("Contactar Proveedor", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
