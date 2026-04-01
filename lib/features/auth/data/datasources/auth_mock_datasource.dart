import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/user_entity.dart';
import '../models/user_model.dart';
import 'auth_datasource.dart';

/// Mock datasource que simula la respuesta del backend de auth.
/// Usuarios disponibles para testing:
///   - operator@connexa.app / pass123  → rol operator
///   - owner@connexa.app    / pass123  → rol owner
class AuthMockDataSource implements AuthDataSource {
  static final _users = <String, ({UserModel user, String password})>{
    'operator@connexa.app': (
      user: UserModel(
        id: 'usr-001',
        name: 'Carlos Méndez',
        email: 'operator@connexa.app',
        role: UserRole.operator,
      ),
      password: 'pass123',
    ),
    'owner@connexa.app': (
      user: UserModel(
        id: 'usr-002',
        name: 'Andrés Villareal',
        email: 'owner@connexa.app',
        role: UserRole.owner,
      ),
      password: 'pass123',
    ),
  };

  static const _sessionKey = 'connexa_session';
  static const _sessionExpiryKey = 'connexa_session_expiry';
  static const _sessionTtl = Duration(hours: 8);

  final FlutterSecureStorage _storage;

  AuthMockDataSource({FlutterSecureStorage? storage})
    : _storage =
          storage ??
          const FlutterSecureStorage(
            aOptions: AndroidOptions(encryptedSharedPreferences: true),
          );

  UserModel? _session;

  @override
  Future<UserEntity> login({
    required String email,
    required String password,
  }) async {
    // Simula latencia de red
    await Future.delayed(const Duration(milliseconds: 800));

    final normalizedEmail = email.toLowerCase().trim();
    final record = _users[normalizedEmail];

    if (record == null || record.password != password) {
      throw const InvalidCredentialsFailure();
    }

    _session = record.user;
    await _persistSession(record.user);
    return record.user;
  }

  @override
  Future<UserEntity> register({
    required String name,
    required String email,
    required String password,
    UserRole role = UserRole.operator,
  }) async {
    await Future.delayed(const Duration(milliseconds: 900));

    final normalizedEmail = email.toLowerCase().trim();
    if (_users.containsKey(normalizedEmail)) {
      throw const EmailAlreadyInUseFailure();
    }

    final user = UserModel(
      id: 'usr-${_users.length + 1}'.padLeft(7, '0'),
      name: name.trim(),
      email: normalizedEmail,
      role: role,
    );

    _users[normalizedEmail] = (user: user, password: password);
    _session = user;
    await _persistSession(user);
    return user;
  }

  @override
  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 200));
    _session = null;
    await _clearPersistedSession();
  }

  @override
  Future<UserEntity?> getSession() async {
    await Future.delayed(const Duration(milliseconds: 300));
    final rawUser = await _storage.read(key: _sessionKey);
    final rawExpiry = await _storage.read(key: _sessionExpiryKey);

    if (rawUser == null || rawExpiry == null) {
      return _session;
    }

    final expiry = DateTime.tryParse(rawExpiry);
    if (expiry == null || DateTime.now().isAfter(expiry)) {
      await _clearPersistedSession();
      _session = null;
      return null;
    }

    final decoded = jsonDecode(rawUser) as Map<String, dynamic>;
    final user = UserModel.fromJson(decoded);
    _session = user;
    return user;
  }

  Future<void> _persistSession(UserModel user) async {
    final expiresAt = DateTime.now().add(_sessionTtl).toIso8601String();
    await _storage.write(key: _sessionKey, value: jsonEncode(user.toJson()));
    await _storage.write(key: _sessionExpiryKey, value: expiresAt);
  }

  Future<void> _clearPersistedSession() async {
    await _storage.delete(key: _sessionKey);
    await _storage.delete(key: _sessionExpiryKey);
  }
}
