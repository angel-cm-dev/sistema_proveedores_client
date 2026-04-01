import 'package:flutter_test/flutter_test.dart';
import 'package:sistema_proveedores_client/core/errors/failures.dart';
import 'package:sistema_proveedores_client/features/auth/domain/entities/user_entity.dart';
import 'package:sistema_proveedores_client/features/auth/domain/repositories/auth_repository.dart';
import 'package:sistema_proveedores_client/features/auth/presentation/controllers/auth_controller.dart';

class FakeAuthRepository implements AuthRepository {
  UserEntity? sessionUser;

  @override
  Future<UserEntity?> getSession() async => sessionUser;

  @override
  Future<(UserEntity?, Failure?)> login({
    required String email,
    required String password,
  }) async {
    return (null, const InvalidCredentialsFailure());
  }

  @override
  Future<(UserEntity?, Failure?)> register({
    required String name,
    required String email,
    required String password,
    UserRole role = UserRole.operator,
  }) async {
    final created = UserEntity(
      id: 'usr-new-001',
      name: name,
      email: email,
      role: role,
    );
    sessionUser = created;
    return (created, null);
  }

  @override
  Future<Failure?> logout() async {
    sessionUser = null;
    return null;
  }
}

void main() {
  group('Smoke auth flow: register -> autologin -> logout', () {
    test('new operator user is authenticated and can close session', () async {
      final repo = FakeAuthRepository();
      final auth = AuthController(repo);
      await Future<void>.delayed(const Duration(milliseconds: 50));

      expect(auth.status, AuthStatus.unauthenticated);

      final registered = await auth.register(
        name: 'Operador Nuevo',
        email: 'nuevo@connexa.app',
        password: 'pass123',
      );

      expect(registered, isTrue);
      expect(auth.isAuthenticated, isTrue);
      expect(auth.currentUser?.email, 'nuevo@connexa.app');
      expect(auth.currentUser?.role, UserRole.operator);

      final destination = switch (auth.currentUser!.role) {
        UserRole.operator => 'OperatorShell',
        UserRole.owner => 'OwnerShell',
      };
      expect(destination, 'OperatorShell');

      await auth.logout();
      expect(auth.status, AuthStatus.unauthenticated);
      expect(auth.currentUser, isNull);
    });
  });
}
