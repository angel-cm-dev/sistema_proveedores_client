import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Importaciones de lógica y pantallas
import '../core/auth_provider.dart';
import 'client/client_dashboard.dart';
import 'auth/login_screen.dart';

/// El "Portero" de la aplicación.
/// Nivel Senior: Decide qué rama del árbol de widgets mostrar según el rol del usuario.
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    // Escuchamos el cambio de rol en el AuthProvider.
    // Flutter se encarga de re-dibujar solo esta sección cuando cambia el estado.
    final auth = Provider.of<AuthProvider>(context);

    // Aplicamos un switch expression (Dart 3.0+) para un ruteo limpio y exhaustivo.
    return switch (auth.role) {
      UserRole.admin => const Scaffold(
        body: Center(child: Text("Panel de Administración Central")),
      ),

      UserRole.operator => const Scaffold(
        body: Center(child: Text("Vista de Operador (Asignado a Gustavo)")),
      ),

      UserRole.client =>
        const ClientDashboard(), // Tu tarea principal de Frontend
      // Si no hay sesión, mandamos a la pantalla animada de Rive
      UserRole.guest => const LoginScreen(),
    };
  }
}
