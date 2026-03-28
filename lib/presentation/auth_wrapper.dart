import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/auth_provider.dart';
import 'client/client_dashboard.dart';

// Aquí importarás tus pantallas reales

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    // Escuchamos el cambio de rol
    final auth = Provider.of<AuthProvider>(context);

    return switch (auth.role) {
      UserRole.admin => const Scaffold(
        body: Center(child: Text("Panel Admin")),
      ),
      UserRole.operator => const Scaffold(
        body: Center(child: Text("Vista Operador (Gustavo)")),
      ),
      UserRole.client => const ClientDashboard(), // Tu tarea principal
      UserRole.guest => const LoginScreen(),
    };
  }
}

// Placeholder temporal para que el código compile
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () =>
              Provider.of<AuthProvider>(context, listen: false).login('client'),
          child: const Text("Entrar como Cliente"),
        ),
      ),
    );
  }
}
