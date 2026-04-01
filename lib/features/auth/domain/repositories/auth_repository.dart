import '../../../../core/errors/failures.dart';
import '../../domain/entities/user_entity.dart';

/// Interfaz del repositorio de autenticación.
/// El dominio solo conoce esta abstracción, no la implementación concreta.
abstract class AuthRepository {
  Future<(UserEntity?, Failure?)> login({
    required String email,
    required String password,
  });

  Future<(UserEntity?, Failure?)> register({
    required String name,
    required String email,
    required String password,
    UserRole role = UserRole.operator,
  });

  Future<Failure?> logout();

  Future<UserEntity?> getSession();
}
