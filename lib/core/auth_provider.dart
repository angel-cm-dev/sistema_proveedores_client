import 'package:flutter/material.dart';

/// Roles de usuario permitidos en el ecosistema Connexa.
enum UserRole { admin, operator, client, guest }

/// Niveles de suscripción para clientes.
enum SubscriptionLevel { free, premium, none }

/// Modelo representativo del usuario.
/// Senior Tip: Preparado para mapear respuestas JSON de Laravel.
class UserModel {
  final String id;
  final String name;
  final String email;
  final UserRole role;
  final SubscriptionLevel subscription;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.subscription = SubscriptionLevel.none,
  });

  // Factory para facilitar la integración con la API de Laravel en el futuro
  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json['id'].toString(),
    name: json['name'],
    email: json['email'],
    role: UserRole.values.firstWhere(
      (e) => e.name == json['role'],
      orElse: () => UserRole.client,
    ),
    subscription: SubscriptionLevel.values.firstWhere(
      (e) => e.name == json['subscription'],
      orElse: () => SubscriptionLevel.free,
    ),
  );
}

class AuthProvider extends ChangeNotifier {
  // --- ESTADO PRIVADO ---
  UserModel? _user;
  bool _isLoading = true;

  // --- GETTERS (Encapsulamiento SOLID) ---
  bool get isAuthenticated => _user != null && _user!.role != UserRole.guest;
  bool get isLoading => _isLoading;
  UserModel? get user => _user;

  UserRole get role => _user?.role ?? UserRole.guest;
  bool get isPremium => _user?.subscription == SubscriptionLevel.premium;

  AuthProvider() {
    _initializeSession();
  }

  /// Inicialización de sesión.
  /// En producción, aquí leerías un JWT de FlutterSecureStorage.
  Future<void> _initializeSession() async {
    _setLoading(true);
    try {
      await Future.delayed(const Duration(seconds: 2));
      _user = null; // Iniciamos como Guest
    } catch (e) {
      debugPrint("❌ Error Session Init: $e");
    } finally {
      _setLoading(false);
    }
  }

  /// Autenticación con Backend.
  /// RECUERDA: En Laravel, usa Sanctu/Passport y valida siempre en el server
  /// para prevenir SQL Injection y Mass Assignment.
  Future<bool> login(String email, String password) async {
    _setLoading(true);
    try {
      // Simulación de latencia de red
      await Future.delayed(const Duration(seconds: 1));

      // Mock de respuesta exitosa.
      _user = UserModel(
        id: "1",
        name: "Angel Castañeda",
        email: email,
        role: UserRole.client,
        subscription: SubscriptionLevel.free,
      );

      return true;
    } catch (e) {
      debugPrint("❌ Login Error: $e");
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// MÉTODO UNIFICADO BYPASS (Senior Choice)
  /// Reemplaza los métodos individuales para cumplir con DRY.
  /// Esto corrige el error de "method not defined" en tu sign_in_form.
  void entrarComoDemo(SubscriptionLevel level) {
    _setLoading(true);

    Future.delayed(const Duration(milliseconds: 600), () {
      _user = UserModel(
        id: level == SubscriptionLevel.premium ? "777" : "111",
        name: level == SubscriptionLevel.premium
            ? "Angel Premium"
            : "Angel Free",
        email: "demo@connexa.com",
        role: UserRole.client,
        subscription: level,
      );
      _setLoading(false);
    });
  }

  /// Cierra sesión y limpia el estado global.
  void logout() {
    _user = null;
    notifyListeners();
  }

  // --- PRIVATE HELPERS ---

  /// Centraliza el estado de carga para evitar re-renders innecesarios
  /// si el valor no ha cambiado realmente.
  void _setLoading(bool value) {
    if (_isLoading == value) return; // Optimización de performance
    _isLoading = value;
    notifyListeners();
  }
}
