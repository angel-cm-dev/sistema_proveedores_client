import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ClientDashboard extends StatefulWidget {
  const ClientDashboard({super.key});

  @override
  State<ClientDashboard> createState() => _ClientDashboardState();
}

class _ClientDashboardState extends State<ClientDashboard> {
  bool isGrid = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            const SizedBox(height: 10),
            const Expanded(
              child: Center(child: Text("Aquí irán tus CRUDs de Proveedores")),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() => Container(
    padding: const EdgeInsets.all(20),
    decoration: const BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(30),
        bottomRight: Radius.circular(30),
      ),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Bienvenido,", style: GoogleFonts.poppins(color: Colors.grey)),
            Text(
              "Portal Cliente",
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
          ],
        ),
        IconButton(
          icon: Icon(
            isGrid ? Icons.grid_view_rounded : Icons.list_alt_rounded,
            color: Colors.blueAccent,
          ),
          onPressed: () => setState(() => isGrid = !isGrid),
        ),
      ],
    ),
  );
}
