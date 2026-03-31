import 'package:flutter/material.dart';
import 'package:sistema_proveedores_client/core/models/supplier_model.dart';
import 'package:sistema_proveedores_client/features/suppliers/widgets/hcard.dart';

class SupplierSearchTabView extends StatefulWidget {
  const SupplierSearchTabView({super.key});

  @override
  State<SupplierSearchTabView> createState() => _SupplierSearchTabViewState();
}

class _SupplierSearchTabViewState extends State<SupplierSearchTabView> {
  String _searchQuery = "";
  String _selectedCategory = "Todos";

  final List<String> _categories = [
    "Todos",
    "Tecnología",
    "Logística",
    "Energía",
    "Construcción"
  ];

  @override
  Widget build(BuildContext context) {
    final filteredSuppliers = SupplierModel.suppliers.where((s) {
      final matchesQuery =
          s.nombre.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCategory = _selectedCategory == "Todos" ||
          s.descripcion.contains(_selectedCategory);
      return matchesQuery && matchesCategory;
    }).toList();

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. CABECERA: Corregida para no chocar con el botón de menú
          _buildSearchHeader(),

          // 2. FILTROS: Chips de categorías
          _buildCategoryFilters(),

          // 3. LISTADO: Con padding inferior para evitar el corte con la barra
          Expanded(
            child: _buildResultsList(filteredSuppliers),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchHeader() {
    return Padding(
      padding: EdgeInsets.only(
        // Senior Tip: Usamos + 80 para bajar el título del nivel del botón de menú
        top: MediaQuery.of(context).padding.top + 80,
        left: 24,
        right: 24,
        bottom: 16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Directorio",
            style: TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.bold,
              fontFamily: "Poppins",
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                )
              ],
            ),
            child: TextField(
              onChanged: (value) => setState(() => _searchQuery = value),
              style: const TextStyle(color: Colors.black87),
              decoration: const InputDecoration(
                hintText: "Buscar por nombre o RUC...",
                hintStyle: TextStyle(color: Colors.black38),
                prefixIcon: Icon(Icons.search, color: Colors.black38),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 15),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryFilters() {
    return SizedBox(
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 18),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = _selectedCategory == category;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
            child: FilterChip(
              label: Text(category),
              selected: isSelected,
              onSelected: (val) => setState(() => _selectedCategory = category),
              selectedColor: const Color(0xFF6792FF),
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : Colors.black87,
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              backgroundColor: Colors.white,
              checkmarkColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                  color: isSelected ? Colors.transparent : Colors.black12,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildResultsList(List<SupplierModel> results) {
    if (results.isEmpty) {
      return const Center(
        child: Text(
          "No se encontraron proveedores.",
          style: TextStyle(color: Colors.black38, fontSize: 16),
        ),
      );
    }

    return ListView.builder(
      // FIX VISUAL: Añadimos 100 de padding inferior para que la última tarjeta
      // no quede tapada por la barra de navegación flotante
      padding: const EdgeInsets.only(left: 24, right: 24, top: 10, bottom: 120),
      physics: const BouncingScrollPhysics(),
      itemCount: results.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: HCard(supplier: results[index]),
        );
      },
    );
  }
}
