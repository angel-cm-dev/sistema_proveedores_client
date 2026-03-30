import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Importaciones de lógica (Core)
import '../core/auth_provider.dart';

// Pantallas (Presentation)
import 'auth/screens/sign_in_screen.dart';
import 'client/client_dashboard.dart';

/// El "Gatekeeper" o Portero de la aplicación.
/// Nivel Senior: Implementa manejo de estados de carga y ruteo basado en roles.
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    // Usamos watch para que este widget se reconstruya automáticamente
    // cada vez que el AuthProvider notifique un cambio (notifyListeners).
    final auth = context.watch<AuthProvider>();

    // 1. MANEJO DE CARGA (Loading State)
    // Evita el parpadeo de la pantalla de login mientras se lee el token del storage.
    if (auth.isLoading) {
      return const _AuthLoadingScreen();
    }

    // 2. RUTEO EXHAUSTIVO (Switch Expression - Dart 3+)
    // Es mucho más limpio y nos obliga a manejar todos los UserRole.
    return switch (auth.role) {
      UserRole.admin => const Scaffold(
        body: Center(child: Text("Panel de Administración Central")),
      ),

      UserRole.operator => const Scaffold(
        body: Center(child: Text("Vista de Operador (Asignado a Gustavo)")),
      ),

      UserRole.client => const ClientDashboard(),

      // Si no hay sesión (Guest), mostramos tu pantalla de cristal animada.
      UserRole.guest => const SignInScreen(),
    };
  }
}

/// Pantalla de carga profesional para evitar el salto brusco de UI.
class _AuthLoadingScreen extends StatelessWidget {
  const _AuthLoadingScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF17203A), // Navy corporativo
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: Color(0xFFF77D8E), // Coral Accent
              strokeWidth: 3,
            ),
            SizedBox(height: 20),
            Text(
              "Connexa",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
