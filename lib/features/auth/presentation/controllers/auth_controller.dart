import 'package:flutter/foundation.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';

enum AuthStatus { initial, loading, authenticated, unauthenticated, error }

class AuthController extends ChangeNotifier {
  final AuthRepository _repository;

  AuthController(this._repository) {
    _checkSession();
  }

  AuthStatus _status = AuthStatus.initial;
  UserEntity? _currentUser;
  String? _errorMessage;

  AuthStatus get status => _status;
  UserEntity? get currentUser => _currentUser;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _status == AuthStatus.authenticated;

  // ── Session check on startup ──────────────────────────────────────────────
  Future<void> _checkSession() async {
    _status = AuthStatus.initial;
    notifyListeners();

    final user = await _repository.getSession();
    if (user != null) {
      _currentUser = user;
      _status = AuthStatus.authenticated;
    } else {
      _status = AuthStatus.unauthenticated;
    }
    notifyListeners();
  }

  // ── Login ─────────────────────────────────────────────────────────────────
  Future<bool> login({required String email, required String password}) async {
    _status = AuthStatus.loading;
    _errorMessage = null;
    notifyListeners();

    final (user, failure) = await _repository.login(
      email: email,
      password: password,
    );

    if (failure != null) {
      _status = AuthStatus.error;
      _errorMessage = failure.message;
      notifyListeners();
      return false;
    }

    _currentUser = user;
    _status = AuthStatus.authenticated;
    notifyListeners();
    return true;
  }

  // ── Logout ────────────────────────────────────────────────────────────────
  Future<void> logout() async {
    await _repository.logout();
    _currentUser = null;
    _status = AuthStatus.unauthenticated;
    _errorMessage = null;
    notifyListeners();
  }

  // ── Clear error ───────────────────────────────────────────────────────────
  void clearError() {
    _errorMessage = null;
    if (_status == AuthStatus.error) {
      _status = AuthStatus.unauthenticated;
    }
    notifyListeners();
  }
}
