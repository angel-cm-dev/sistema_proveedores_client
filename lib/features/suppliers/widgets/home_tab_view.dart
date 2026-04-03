import 'package:flutter/material.dart';
// Asegúrate de que esta ruta sea correcta para tu SupplierDetailScreen
import '../screens/supplier_detail_screen.dart';

// ==========================================
// MODELO DE DATOS ROBUSTO (Mantenlo igual para consistencia)
// ==========================================
class Supplier {
  final String name;
  final String location;
  final double rating;
  final Color color;
  final String imageUrl;
  final String description;
  final String phone;
  final List<String> services;

  const Supplier({
    required this.name,
    required this.location,
    required this.rating,
    required this.color,
    required this.imageUrl,
    required this.description,
    required this.phone,
    required this.services,
  });
}

class HomeTabView extends StatelessWidget {
  final String userName;
  const HomeTabView({super.key, required this.userName});

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return "Buenos días";
    if (hour < 19) return "Buenas tardes";
    return "Buenas noches";
  }

  // DATA MOCK (Centralizada)
  static const List<Supplier> _mockSuppliers = [
    Supplier(
      name: "TechLogistics S.A.",
      location: "Lima, Perú",
      rating: 4.9,
      color: Color(0xFF648FFF),
      imageUrl:
          "https://images.unsplash.com/photo-1586528116311-ad8dd3c8310d?q=80&w=400",
      description:
          "Líderes en logística tecnológica con distribución garantizada en menos de 24 horas a nivel nacional.",
      phone: "+51 912 345 678",
      services: ["Distribución", "Almacenaje", "IoT Tracking"],
    ),
    Supplier(
      name: "Connexa Solutions",
      location: "Arequipa, Perú",
      rating: 4.8,
      color: Color(0xFFF77D8E),
      imageUrl:
          "https://images.unsplash.com/photo-1519085360753-af0119f7cbe7?q=80&w=400",
      description:
          "Consultoría y soluciones integrales para la cadena de suministro en el sur del país.",
      phone: "+51 987 654 321",
      services: ["Consultoría", "Carga Pesada", "Seguros"],
    ),
    Supplier(
      name: "Innova Transport",
      location: "Trujillo, Perú",
      rating: 4.7,
      color: Color(0xFF648FFF),
      imageUrl:
          "https://images.unsplash.com/photo-1553413077-190dd305871c?q=80&w=400",
      description:
          "Especialistas en transporte refrigerado y logística de última milla para retail.",
      phone: "+51 944 555 666",
      services: ["Cadena Frío", "Courier", "E-commerce"],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    const navy = Color(0xFF17203A);
    const pink = Color(0xFFF77D8E);

    return SafeArea(
      top: false, // El Dashboard ya maneja el SafeArea superior
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        // AUMENTO DE PADDING SUPERIOR: 150px para evitar colisión con el botón de menú
        padding: const EdgeInsets.fromLTRB(24, 150, 24, 140),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. HEADER (Saludo y Nombre)
            _HeaderSection(
                greeting: _getGreeting(), userName: userName, navy: navy),

            const SizedBox(height: 35),

            // 2. SECCIÓN: PROVEEDORES
            const _SectionHeader(title: "Proveedores", navy: navy, pink: pink),
            const SizedBox(height: 20),
            _buildHorizontalList(),

            const SizedBox(height: 40),

            // 3. SECCIÓN: RECIENTES
            const _SectionHeader(title: "Recientes", navy: navy, pink: pink),
            const SizedBox(height: 16),
            _buildRecentList(),
          ],
        ),
      ),
    );
  }

  Widget _buildHorizontalList() {
    return SizedBox(
      height: 270,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: _mockSuppliers.length,
        separatorBuilder: (_, __) => const SizedBox(width: 20),
        itemBuilder: (context, index) => _FeaturedCard(
          supplier: _mockSuppliers[index],
          // Hero tag único para evitar conflictos si el mismo proveedor está en dos listas
          heroTag: 'featured_${_mockSuppliers[index].name}',
        ),
      ),
    );
  }

  Widget _buildRecentList() {
    return ListView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _mockSuppliers.length,
      itemBuilder: (context, index) => _RecentListTile(
        supplier: _mockSuppliers[index],
        heroTag: 'recent_${_mockSuppliers[index].name}',
      ),
    );
  }
}

// =========================================================================
// COMPONENTES PRIVADOS (Modularizados)
// =========================================================================

class _HeaderSection extends StatelessWidget {
  final String greeting;
  final String userName;
  final Color navy;

  const _HeaderSection(
      {required this.greeting, required this.userName, required this.navy});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4), // Alineación sutil
          child: Text(
            "$greeting,",
            style: TextStyle(
                color: navy.withValues(alpha: 0.5),
                fontSize: 16,
                fontWeight: FontWeight.w600),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          userName,
          style: TextStyle(
              color: navy,
              fontSize: 32, // Un poco más pequeño para evitar saltos de línea
              fontWeight: FontWeight.w900,
              letterSpacing: -1.0),
        ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final Color navy, pink;

  const _SectionHeader(
      {required this.title, required this.navy, required this.pink});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style: TextStyle(
                color: navy,
                fontSize: 22,
                fontWeight: FontWeight.w900,
                letterSpacing: -0.5)),
        Icon(Icons.arrow_forward_ios_rounded, color: pink, size: 18),
      ],
    );
  }
}

class _FeaturedCard extends StatelessWidget {
  final Supplier supplier;
  final String heroTag;
  const _FeaturedCard({required this.supplier, required this.heroTag});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 230,
      decoration: BoxDecoration(
        color: supplier.color,
        borderRadius: BorderRadius.circular(35),
        boxShadow: [
          BoxShadow(
              color: supplier.color.withValues(alpha: 0.35),
              blurRadius: 20,
              offset: const Offset(0, 12))
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SupplierDetailScreen(supplier: supplier)),
          ),
          borderRadius: BorderRadius.circular(35),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(35)),
                child: Hero(
                  tag: heroTag,
                  child: Image.network(
                    supplier.imageUrl,
                    height: 125,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      supplier.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w800),
                    ),
                    Text(supplier.location,
                        style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.75),
                            fontSize: 13)),
                    const SizedBox(height: 14),
                    _buildRatingBadge(supplier.rating),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRatingBadge(double rating) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.25),
          borderRadius: BorderRadius.circular(12)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star_rounded, color: Colors.amber, size: 16),
          const SizedBox(width: 4),
          Text(rating.toString(),
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12)),
        ],
      ),
    );
  }
}

class _RecentListTile extends StatelessWidget {
  final Supplier supplier;
  final String heroTag;
  const _RecentListTile({required this.supplier, required this.heroTag});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 15,
              offset: const Offset(0, 8))
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SupplierDetailScreen(supplier: supplier)),
          ),
          borderRadius: BorderRadius.circular(28),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: supplier.color.withValues(alpha: 0.2),
                          width: 2)),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Hero(
                      tag: heroTag,
                      child: Image.network(
                        supplier.imageUrl,
                        width: 52,
                        height: 52,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(supplier.name,
                          style: const TextStyle(
                              color: Color(0xFF17203A),
                              fontWeight: FontWeight.w800,
                              fontSize: 16)),
                      Text(supplier.location,
                          style: const TextStyle(
                              color: Colors.black45,
                              fontSize: 12,
                              fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
                Icon(Icons.arrow_forward_ios_rounded,
                    color: supplier.color, size: 14),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
