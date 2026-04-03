import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// --- IMPORTACIONES DE CAPAS ---
import 'package:sistema_proveedores_client/features/auth/providers/auth_provider.dart';
import 'package:sistema_proveedores_client/features/auth/screens/sign_in_screen.dart';
import 'package:sistema_proveedores_client/features/auth/screens/loading_screen.dart';
import 'package:sistema_proveedores_client/presentation/client/client_dashboard.dart';

/// El "Orquestador" de la aplicación.
/// Maneja el estado global de autenticación y decide qué vista presentar.
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    // Escucha de forma reactiva el estado del AuthProvider.
    final auth = context.watch<AuthProvider>();

    // Usamos AnimatedSwitcher para que el paso entre Login, Carga y Dashboard
    // sea suave y profesional.
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      switchInCurve: Curves.easeIn,
      switchOutCurve: Curves.easeOut,
      // Indispensable para que el Switcher identifique el cambio de Widget
      child: _mapStateToScreen(auth),
    );
  }

  /// Mapea el estado del Provider a la pantalla correspondiente.
  Widget _mapStateToScreen(AuthProvider auth) {
    // 1. Prioridad: Estado de Carga (Splash/Auth Check)
    if (auth.isLoading) {
      return const LoadingScreen(key: ValueKey('auth_loading'));
    }

    // 2. Manejo de Errores Globales (Fallo de servidor o red)
    if (auth.hasError) {
      return _AuthErrorScreen(
        key: const ValueKey('auth_error'),
        message: auth.errorMessage ?? "Error de conexión con Connexa",
        onRetry: () => auth.checkAuthStatus(),
      );
    }

    // 3. Enrutamiento por Roles (Dart 3 Pattern Matching)
    return switch (auth.role) {
      UserRole.admin => const _AdminPlaceholder(key: ValueKey('view_admin')),
      UserRole.operator =>
        const _OperatorPlaceholder(key: ValueKey('view_operator')),
      UserRole.client => const ClientDashboard(key: ValueKey('view_client')),
      UserRole.guest => const SignInScreen(key: ValueKey('view_guest')),
    };
  }
}

// --- COMPONENTES DE INTERFAZ PRIVADOS ---

class _AuthErrorScreen extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _AuthErrorScreen(
      {super.key, required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF17203A),
      body: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.cloud_off_rounded,
                  color: Color(0xFFF77D8E), size: 80),
              const SizedBox(height: 24),
              const Text(
                "¡UPS!",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white70, fontSize: 16),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onRetry,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF77D8E),
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                  ),
                  child: const Text("REINTENTAR CONEXIÓN",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Placeholders temporales para otros roles
class _AdminPlaceholder extends StatelessWidget {
  const _AdminPlaceholder({super.key});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text("Panel Admin")));
}

class _OperatorPlaceholder extends StatelessWidget {
  const _OperatorPlaceholder({super.key});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text("Panel Operador")));
}
