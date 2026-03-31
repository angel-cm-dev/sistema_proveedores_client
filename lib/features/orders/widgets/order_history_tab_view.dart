import 'package:flutter/material.dart';

// --- 1. CORE & MODELS ---
import 'package:sistema_proveedores_client/core/models/order_model.dart';

// --- 2. FEATURE WIDGETS ---
import 'order_card.dart';

/// [OrderHistoryTabView] gestiona la visualización del historial de ventas del proveedor.
/// Utiliza [CustomScrollView] con [Slivers] para una experiencia de scroll elástica y fluida.
class OrderHistoryTabView extends StatefulWidget {
  const OrderHistoryTabView({super.key});

  @override
  State<OrderHistoryTabView> createState() => _OrderHistoryTabViewState();
}

class _OrderHistoryTabViewState extends State<OrderHistoryTabView> {
  // --- ESTADO LOCAL ---
  String _selectedFilter = "Todos";
  final List<String> _filters = [
    "Todos",
    "Procesando",
    "En Camino",
    "Entregado"
  ];

  // DATA MOCK (Reflejando el Diagrama ER de VentasProveedor)
  final List<OrderModel> _allOrders = [
    OrderModel(
        id: "ORD-001",
        producto: "Servidores Blade X",
        proveedor: "TechLogistics S.A.",
        cantidad: 5,
        total: 12500.00,
        fecha: "30 Mar 2026",
        estado: OrderStatus.enCamino),
    OrderModel(
        id: "ORD-002",
        producto: "Cables Fibra Óptica",
        proveedor: "ElectroSuministros",
        cantidad: 20,
        total: 450.00,
        fecha: "28 Mar 2026",
        estado: OrderStatus.entregado),
    OrderModel(
        id: "ORD-003",
        producto: "Software Gestión v2",
        proveedor: "Connexa Solutions",
        cantidad: 1,
        total: 1200.00,
        fecha: "25 Mar 2026",
        estado: OrderStatus.procesando),
    OrderModel(
        id: "ORD-004",
        producto: "Racks de 42U",
        proveedor: "MetalRed",
        cantidad: 2,
        total: 1800.00,
        fecha: "22 Mar 2026",
        estado: OrderStatus.enCamino),
  ];

  @override
  Widget build(BuildContext context) {
    // Lógica de filtrado reactiva
    final filteredOrders = _allOrders
        .where((o) =>
            _selectedFilter == "Todos" || o.estadoLabel == _selectedFilter)
        .toList();

    return Scaffold(
      backgroundColor:
          Colors.transparent, // Permite ver el fondo animado del Dashboard
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildSliverHeader(),
          _buildSliverStats(),
          _buildSliverFilters(),
          _buildSliverList(filteredOrders),
        ],
      ),
    );
  }

  // ==========================================
  // COMPONENTES DE LA INTERFAZ (SLIVERS)
  // ==========================================

  /// Título de la sección con margen de seguridad para el botón de menú
  Widget _buildSliverHeader() {
    return SliverPadding(
      padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + 80, left: 24, right: 24),
      sliver: const SliverToBoxAdapter(
        child: Text(
          "Mis Órdenes",
          style: TextStyle(
              fontSize: 34, fontWeight: FontWeight.bold, fontFamily: "Poppins"),
        ),
      ),
    );
  }

  /// Tarjeta de resumen estadístico (Dashboard rápido)
  Widget _buildSliverStats() {
    return SliverPadding(
      padding: const EdgeInsets.all(24),
      sliver: SliverToBoxAdapter(
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF6792FF),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                  color: const Color(0xFF6792FF).withValues(alpha: 0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10))
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatItem("Total Invertido", "S/. 15,950", Colors.white),
              Container(width: 1, height: 40, color: Colors.white24),
              _buildStatItem("Activas", "03", Colors.white),
            ],
          ),
        ),
      ),
    );
  }

  /// Item individual de estadística
  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style:
                TextStyle(color: color.withValues(alpha: 0.7), fontSize: 12)),
        Text(value,
            style: TextStyle(
                color: color, fontSize: 20, fontWeight: FontWeight.bold)),
      ],
    );
  }

  /// Barra de filtros horizontales dinámica
  Widget _buildSliverFilters() {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: 60,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 18),
          itemCount: _filters.length,
          itemBuilder: (context, index) {
            final filter = _filters[index];
            final isSelected = _selectedFilter == filter;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
              child: FilterChip(
                label: Text(filter),
                selected: isSelected,
                onSelected: (val) => setState(() => _selectedFilter = filter),
                selectedColor: const Color(0xFF6792FF),
                labelStyle: TextStyle(
                    color: isSelected ? Colors.white : Colors.black87,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal),
                backgroundColor: Colors.white,
                checkmarkColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            );
          },
        ),
      ),
    );
  }

  /// Listado de resultados usando SliverList para mayor performance
  Widget _buildSliverList(List<OrderModel> orders) {
    if (orders.isEmpty) {
      return const SliverFillRemaining(
        hasScrollBody: false,
        child: Center(
          child: Text(
            "No hay órdenes en este estado.",
            style: TextStyle(color: Colors.black38, fontSize: 16),
          ),
        ),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.only(left: 24, right: 24, bottom: 140),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) => OrderCard(order: orders[index]),
          childCount: orders.length,
        ),
      ),
    );
  }
}
