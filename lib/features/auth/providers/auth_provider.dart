import 'package:flutter/material.dart';

// --- IMPORTACIÓN DEL MODELO QUE CREAMOS (Separación de responsabilidades) ---
import 'package:sistema_proveedores_client/core/models/user_model.dart';

/// Roles de usuario permitidos en el ecosistema Connexa.
enum UserRole { admin, operator, client, guest }

class AuthProvider extends ChangeNotifier {
  // --- ESTADO PRIVADO ---
  UserModel? _user;
  bool _isLoading = true;
  bool _hasError = false;
  String? _errorMessage;

  // --- GETTERS (Encapsulamiento SOLID & Arrow Functions) ---
  bool get isAuthenticated => _user != null && _user!.rol != "guest";
  bool get isLoading => _isLoading;
  bool get hasError => _hasError;
  String? get errorMessage => _errorMessage;
  UserModel? get user => _user;

  // Retornamos el rol como Enum para el Switch del AuthWrapper
  UserRole get role {
    if (_user == null) return UserRole.guest;
    return switch (_user!.rol.toLowerCase()) {
      'admin' => UserRole.admin,
      'operator' => UserRole.operator,
      'client' => UserRole.client,
      _ => UserRole.guest,
    };
  }

  AuthProvider() {
    checkAuthStatus();
  }

  /// EL CORAZÓN DEL AUTH: Verifica si hay sesión activa.
  /// Senior Tip: Aquí es donde leerías el JWT de FlutterSecureStorage.
  Future<void> checkAuthStatus() async {
    _setLoading(true);
    _hasError = false;
    _errorMessage = null;

    try {
      // Simulamos la latencia de verificación del token con Laravel Sanctum
      await Future.delayed(const Duration(seconds: 2));

      // Por defecto iniciamos como Guest (null)
      _user = null;
    } catch (e) {
      _hasError = true;
      _errorMessage = "No se pudo verificar la sesión: $e";
      debugPrint("❌ Error Session Init: $e");
    } finally {
      // SIEMPRE cambiamos el estado de carga al final para desbloquear la UI
      _setLoading(false);
    }
  }

  /// Autenticación con Backend (Laravel).
  Future<bool> login(String email, String password) async {
    _setLoading(true);
    _hasError = false;

    try {
      // Simulación de petición API
      await Future.delayed(const Duration(seconds: 1));

      // Mapeamos al UserModel que definimos anteriormente
      _user = UserModel(
        id: 1,
        nombre: "Angel",
        apellido: "Castañeda",
        email: email,
        username: "angel_dev",
        rol: "client",
        suscripcionTipo: "Free",
        suscripcionEstado: "active",
      );

      return true;
    } catch (e) {
      _hasError = true;
      _errorMessage = "Credenciales incorrectas o error de servidor";
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// MÉTODO UNIFICADO BYPASS (Corregido y Async)
  /// Corregimos el error del Future.delayed que no esperaba el resultado.
  Future<void> entrarComoDemo(String tipoSuscripcion) async {
    _setLoading(true);
    _hasError = false;

    await Future.delayed(const Duration(milliseconds: 800));

    _user = UserModel(
      id: tipoSuscripcion == "Premium" ? 777 : 111,
      nombre: "Angel",
      apellido: tipoSuscripcion,
      email: "demo@connexa.com",
      username: "demo_user",
      rol: "client",
      suscripcionTipo: tipoSuscripcion,
      suscripcionEstado: "active",
    );

    _setLoading(false);
  }

  /// Cierra sesión y limpia el estado global.
  void logout() {
    _user = null;
    _hasError = false;
    _errorMessage = null;
    notifyListeners();
  }

  // --- PRIVATE HELPERS ---

  /// Centraliza el estado de carga y asegura el notifyListeners.
  void _setLoading(bool value) {
    if (_isLoading == value) return; // Optimización de performance
    _isLoading = value;
    notifyListeners(); // Esto es lo que saca al AuthWrapper del estado de carga
  }
}
