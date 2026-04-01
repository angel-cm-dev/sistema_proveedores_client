/// Jerarquía de errores de dominio de Connexa.
/// Las capas de datos convierten excepciones en Failures tipados.
sealed class Failure {
  final String message;
  const Failure(this.message);
}

/// Credenciales inválidas (email o contraseña incorrectos)
class InvalidCredentialsFailure extends Failure {
  const InvalidCredentialsFailure() : super('Correo o contraseña incorrectos.');
}

/// Error de conectividad de red
class NetworkFailure extends Failure {
  const NetworkFailure() : super('Sin conexión a internet. Verifica tu red.');
}

/// El servidor respondió con un error inesperado
class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Error del servidor. Intenta más tarde.']);
}

/// Error desconocido / genérico
class UnknownFailure extends Failure {
  const UnknownFailure([super.message = 'Ocurrió un error inesperado.']);
}

/// Token expirado o sesión inválida
class SessionExpiredFailure extends Failure {
  const SessionExpiredFailure() : super('Tu sesión ha expirado. Inicia sesión nuevamente.');
}
