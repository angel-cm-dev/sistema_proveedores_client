import 'package:flutter_test/flutter_test.dart';
import 'package:sistema_proveedores_client/core/errors/failures.dart';
import 'package:sistema_proveedores_client/features/auth/domain/entities/user_entity.dart';
import 'package:sistema_proveedores_client/features/auth/domain/repositories/auth_repository.dart';
import 'package:sistema_proveedores_client/features/auth/presentation/controllers/auth_controller.dart';

/// LoginScreen depends on Rive assets that can't load in test env.
/// Instead, we test the auth flow logic that backs the login form.

class FakeAuthRepository implements AuthRepository {
  UserEntity? sessionUser;
  (UserEntity?, Failure?) loginResult = (
    null,
    const InvalidCredentialsFailure(),
  );

  @override
  Future<UserEntity?> getSession() async => sessionUser;

  @override
  Future<(UserEntity?, Failure?)> login({
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 10));
    return loginResult;
  }

  @override
  Future<(UserEntity?, Failure?)> register({
    required String name,
    required String email,
    required String password,
    UserRole role = UserRole.operator,
  }) async {
    await Future.delayed(const Duration(milliseconds: 10));
    return loginResult;
  }

  @override
  Future<Failure?> logout() async => null;
}

void main() {
  late FakeAuthRepository repo;
  late AuthController auth;

  setUp(() {
    repo = FakeAuthRepository();
  });

  group('Login flow (auth controller backing login screen)', () {
    test('invalid credentials produce error state for UI', () async {
      repo.loginResult = (null, const InvalidCredentialsFailure());
      auth = AuthController(repo);
      await Future.delayed(const Duration(milliseconds: 50));

      final success = await auth.login(email: 'bad@email', password: 'x');

      expect(success, isFalse);
      expect(auth.status, AuthStatus.error);
      expect(auth.errorMessage, contains('incorrectos'));
    });

    test('valid credentials produce authenticated state for UI', () async {
      const user = UserEntity(
        id: '1',
        name: 'Test',
        email: 'test@x.com',
        role: UserRole.operator,
      );
      repo.loginResult = (user, null);
      auth = AuthController(repo);
      await Future.delayed(const Duration(milliseconds: 50));

      final success = await auth.login(email: 'test@x.com', password: 'pass');

      expect(success, isTrue);
      expect(auth.status, AuthStatus.authenticated);
      expect(auth.currentUser?.email, 'test@x.com');
    });

    test('network failure produces error with message', () async {
      repo.loginResult = (null, const NetworkFailure());
      auth = AuthController(repo);
      await Future.delayed(const Duration(milliseconds: 50));

      final success = await auth.login(email: 'x@x.com', password: 'x');

      expect(success, isFalse);
      expect(auth.errorMessage, contains('conexión'));
    });

    test('clearError resets to unauthenticated for UI retry', () async {
      repo.loginResult = (null, const InvalidCredentialsFailure());
      auth = AuthController(repo);
      await Future.delayed(const Duration(milliseconds: 50));
      await auth.login(email: 'x', password: 'x');

      auth.clearError();
      expect(auth.status, AuthStatus.unauthenticated);
      expect(auth.errorMessage, isNull);
    });
  });
}
