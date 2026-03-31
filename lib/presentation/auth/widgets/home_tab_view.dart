import 'package:flutter/material.dart';

// --- CORE & MODELS ---
import 'package:sistema_proveedores_client/core/models/supplier_model.dart';
import 'package:sistema_proveedores_client/core/theme.dart';

// --- WIDGETS ---
import 'hcard.dart';
import 'vcard.dart';

/// Vista principal de la pestaña de Inicio.
/// Se mantiene como StatelessWidget para evitar errores de subtipo y optimizar memoria.
class HomeTabView extends StatelessWidget {
  const HomeTabView({super.key});

  @override
  Widget build(BuildContext context) {
    // Obtenemos la data de forma inmutable
    final List<SupplierModel> suppliers = SupplierModel.suppliers;

    return Scaffold(
      backgroundColor:
          Colors.transparent, // Crucial para ver el fondo animado del Dashboard
      body: ShaderMask(
        shaderCallback: (Rect bounds) {
          return LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white,
              Colors.white.withValues(alpha: 0.05),
              Colors.transparent,
            ],
            stops: const [
              0.85,
              0.95,
              1.0
            ], // El desvanecimiento inicia casi al final
          ).createShader(bounds);
        },
        blendMode: BlendMode.dstIn,
        child: SingleChildScrollView(
          // Física elástica premium para una mejor experiencia de usuario (UX)
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + 60,
            bottom:
                140, // Espacio para no chocar con la barra inferior flotante
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionHeader("Proveedores"),
              _buildFeaturedSection(suppliers),
              const SizedBox(height: 12),
              _buildSectionHeader("Recientes", isSmall: true),
              _buildRecentSection(suppliers),
            ],
          ),
        ),
      ),
    );
  }

  // --- COMPONENTES MODULARIZADOS (Clean Code) ---

  /// Títulos de sección con tipografía Poppins.
  Widget _buildSectionHeader(String title, {bool isSmall = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: isSmall ? 22 : 34,
          fontWeight: FontWeight.bold,
          color:
              isSmall ? Colors.black54 : Colors.black87, // Contraste dinámico
          fontFamily: "Poppins",
          letterSpacing: -0.5,
        ),
      ),
    );
  }

  /// Carrusel Horizontal de tarjetas destacadas (VCard).
  Widget _buildFeaturedSection(List<SupplierModel> list) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Row(
        children: list
            .map((supplier) => Padding(
                  key: ValueKey("vcard_${supplier.id}"),
                  padding: const EdgeInsets.all(10),
                  child: VCard(supplier: supplier),
                ))
            .toList(),
      ),
    );
  }

  /// Listado Vertical de tarjetas recientes (HCard).
  Widget _buildRecentSection(List<SupplierModel> list) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: list
            .map((supplier) => Padding(
                  key: ValueKey("hcard_${supplier.id}"),
                  padding: const EdgeInsets.only(bottom: 20),
                  child: HCard(supplier: supplier),
                ))
            .toList(),
      ),
    );
  }
}
