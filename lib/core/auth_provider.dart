import 'package:flutter/material.dart';

/// Niveles de acceso para la lógica de rutas.
enum UserRole { admin, operator, client, guest }

/// Niveles de suscripción para la lógica de negocio (SaaS).
enum SubscriptionLevel { free, premium, none }

class AuthProvider extends ChangeNotifier {
  // --- ESTADO PRIVADO ---
  UserRole _role = UserRole.guest;
  SubscriptionLevel _subscription = SubscriptionLevel.none;
  bool _isLoading = true;

  // --- GETTERS (Encapsulamiento SOLID) ---
  UserRole get role => _role;
  SubscriptionLevel get subscription => _subscription;
  bool get isLoading => _isLoading;

  // Helper Senior para validaciones rápidas en la UI
  bool get isPremium => _subscription == SubscriptionLevel.premium;

  AuthProvider() {
    _initAuth();
  }

  /// Inicializa la sesión buscando tokens o estados persistidos.
  Future<void> _initAuth() async {
    _isLoading = true;
    notifyListeners();

    // Simulación de lectura de SharedPreferences o SecureStorage (2 seg)
    await Future.delayed(const Duration(seconds: 2));

    // Por defecto, iniciamos como invitado
    _role = UserRole.guest;
    _subscription = SubscriptionLevel.none;

    _isLoading = false;
    notifyListeners();
  }

  /// Simula el inicio de sesión desde el Backend (Laravel).
  /// [email] y [password] se usarán luego para la petición HTTP.
  Future<void> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    // Aquí iría tu petición al endpoint de Laravel:
    // final response = await http.post(...);
    await Future.delayed(const Duration(seconds: 1));

    // Lógica de prueba:
    _role = UserRole.client;
    _subscription = SubscriptionLevel.free; // Cambiar a premium según la DB

    _isLoading = false;
    notifyListeners();
  }

  /// Cierra la sesión y limpia el estado local.
  void logout() {
    _role = UserRole.guest;
    _subscription = SubscriptionLevel.none;
    notifyListeners();
  }
}
