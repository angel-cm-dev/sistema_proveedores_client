import '../../../../core/errors/failures.dart';
import '../../domain/entities/user_entity.dart';

/// Contrato de la fuente de datos de autenticación.
abstract class AuthDataSource {
  /// Autentica al usuario con email y contraseña.
  /// Lanza [InvalidCredentialsFailure] si las credenciales son incorrectas.
  Future<UserEntity> login({required String email, required String password});

  /// Registra un nuevo usuario y crea sesión activa.
  /// Lanza [EmailAlreadyInUseFailure] si el correo ya existe.
  Future<UserEntity> register({
    required String name,
    required String email,
    required String password,
    UserRole role = UserRole.operator,
  });

  /// Cierra la sesión del usuario actual.
  Future<void> logout();

  /// Retorna el usuario de la sesión activa, o null si no hay sesión.
  Future<UserEntity?> getSession();
}
