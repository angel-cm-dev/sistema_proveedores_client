import '../../../../core/errors/failures.dart';
import '../../domain/entities/user_entity.dart';
import '../models/user_model.dart';
import 'auth_datasource.dart';

/// Mock datasource que simula la respuesta del backend de auth.
/// Usuarios disponibles para testing:
///   - operator@connexa.app / pass123  → rol operator
///   - owner@connexa.app    / pass123  → rol owner
class AuthMockDataSource implements AuthDataSource {
  static final _users = <String, UserModel>{
    'operator@connexa.app': UserModel(
      id: 'usr-001',
      name: 'Carlos Méndez',
      email: 'operator@connexa.app',
      role: UserRole.operator,
    ),
    'owner@connexa.app': UserModel(
      id: 'usr-002',
      name: 'Andrés Villareal',
      email: 'owner@connexa.app',
      role: UserRole.owner,
    ),
  };

  UserModel? _session;

  @override
  Future<UserEntity> login({required String email, required String password}) async {
    // Simula latencia de red
    await Future.delayed(const Duration(milliseconds: 800));

    final user = _users[email.toLowerCase().trim()];

    if (user == null || password != 'pass123') {
      throw const InvalidCredentialsFailure();
    }

    _session = user;
    return user;
  }

  @override
  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 200));
    _session = null;
  }

  @override
  Future<UserEntity?> getSession() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _session;
  }
}
