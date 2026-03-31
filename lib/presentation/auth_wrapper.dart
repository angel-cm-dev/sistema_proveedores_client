import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// --- IMPORTACIONES ABSOLUTAS (Sincronizadas con tu estructura de carpetas) ---
//
import 'package:sistema_proveedores_client/core/auth_provider.dart';
import 'package:sistema_proveedores_client/presentation/auth/screens/sign_in_screen.dart';
import 'package:sistema_proveedores_client/presentation/client/client_dashboard.dart';

/// El "Portero" (Gatekeeper) de la aplicación.
/// Orquesta la navegación reactiva basada en el estado del AuthProvider.
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    // Escuchamos los cambios de estado en tiempo real.
    final auth = context.watch<AuthProvider>();

    // Transición suave entre pantallas para una experiencia Premium.
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 600),
      switchInCurve: Curves.easeInOut,
      switchOutCurve: Curves.easeInOut,
      child: _buildCurrentScreen(auth),
    );
  }

  /// Fabrica la vista correspondiente según el estado atómico del AuthProvider.
  Widget _buildCurrentScreen(AuthProvider auth) {
    // 1. ESTADO DE CARGA: Se muestra mientras se verifica el token o sesión.
    if (auth.isLoading) {
      return const _AuthLoadingScreen(key: ValueKey('loading_state'));
    }

    // 2. MANEJO DE ERRORES: Resiliencia ante fallos de red o servidor.
    if (auth.hasError) {
      return _AuthErrorScreen(
        key: const ValueKey('error_state'),
        message: auth.errorMessage ?? "Error de conexión con el servidor",
        onRetry: () => auth.checkAuthStatus(),
      );
    }

    // 3. RUTEO BASADO EN ROLES (Dart 3 Pattern Matching).
    // Sincronizado con UserRole de auth_provider.dart
    return switch (auth.role) {
      UserRole.admin => const Scaffold(
          key: ValueKey('view_admin'),
          body: Center(child: Text("Panel Administrativo de Connexa")),
        ),
      UserRole.operator => const Scaffold(
          key: ValueKey('view_operator'),
          body: Center(child: Text("Panel de Operaciones")),
        ),
      UserRole.client => const ClientDashboard(key: ValueKey('view_client')),
      UserRole.guest => const SignInScreen(key: ValueKey('view_guest')),
    };
  }
}

// --- COMPONENTES DE INTERFAZ DE SOPORTE (Privados para este archivo) ---

class _AuthLoadingScreen extends StatelessWidget {
  const _AuthLoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF17203A), // Navy corporativo
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(
              color: Color(0xFFF77D8E), // Coral Accent
              strokeWidth: 3,
            ),
            const SizedBox(height: 24),
            Text(
              "CONNEXA",
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.9),
                fontSize: 22,
                fontWeight: FontWeight.bold,
                letterSpacing: 4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

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
        padding: const EdgeInsets.all(32.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.wifi_off_rounded,
                  color: Colors.white38, size: 72),
              const SizedBox(height: 20),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white70, fontSize: 16),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onRetry,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF77D8E),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text("REINTENTAR",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
