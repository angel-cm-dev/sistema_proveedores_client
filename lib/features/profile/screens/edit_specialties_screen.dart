import 'package:flutter/material.dart';

class EditSpecialtiesScreen extends StatefulWidget {
  const EditSpecialtiesScreen({super.key});

  @override
  State<EditSpecialtiesScreen> createState() => _EditSpecialtiesScreenState();
}

class _EditSpecialtiesScreenState extends State<EditSpecialtiesScreen> {
  // Lista de especialidades disponibles (Vendría de una API en el futuro)
  final List<String> _availableSpecialties = [
    'React',
    'Next.js',
    'Laravel',
    'PHP',
    'Python',
    'Flutter',
    'Docker',
    'MySQL',
    'Node.js',
    'TypeScript',
    'AWS',
    'Clean Code'
  ];

  // Usamos un Set para las seleccionadas por rendimiento (O(1) en búsqueda)
  final Set<String> _selectedSpecialties = {'React', 'Laravel', 'Flutter'};

  void _toggleSpecialty(String specialty) => setState(() {
        _selectedSpecialties.contains(specialty)
            ? _selectedSpecialties.remove(specialty)
            : _selectedSpecialties.add(specialty);
      });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: Color(0xFF17203A), size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Editar Especialidades",
            style: TextStyle(
                color: Color(0xFF17203A),
                fontWeight: FontWeight.w800,
                fontSize: 18)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Selecciona las tecnologías o áreas en las que eres experto. Esto ayudará a los proveedores a conocer tu perfil.",
              style: TextStyle(color: Colors.black54, height: 1.5),
            ),
            const SizedBox(height: 32),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: _availableSpecialties.map((specialty) {
                final isSelected = _selectedSpecialties.contains(specialty);
                return FilterChip(
                  label: Text(specialty),
                  selected: isSelected,
                  onSelected: (_) => _toggleSpecialty(specialty),
                  selectedColor: const Color(0xFF6792FF).withOpacity(0.2),
                  checkmarkColor: const Color(0xFF6792FF),
                  labelStyle: TextStyle(
                    color:
                        isSelected ? const Color(0xFF6792FF) : Colors.black87,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                        color: isSelected
                            ? const Color(0xFF6792FF)
                            : Colors.transparent),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildSaveButton(),
    );
  }

  Widget _buildSaveButton() => Padding(
        padding: const EdgeInsets.all(24.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF6792FF),
            minimumSize: const Size(double.infinity, 56),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
          onPressed: () => Navigator.pop(context),
          child: const Text("Guardar Cambios",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16)),
        ),
      );
}
