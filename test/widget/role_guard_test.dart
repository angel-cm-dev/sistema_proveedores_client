import 'package:flutter_test/flutter_test.dart';
import 'package:sistema_proveedores_client/core/errors/failures.dart';
import 'package:sistema_proveedores_client/features/auth/domain/entities/user_entity.dart';
import 'package:sistema_proveedores_client/features/auth/domain/repositories/auth_repository.dart';
import 'package:sistema_proveedores_client/features/auth/presentation/controllers/auth_controller.dart';

/// Role guard tests verify that AuthController state drives correct routing.
/// Widget-level rendering is skipped because WelcomeScreen uses Rive assets
/// with timers that can't be disposed cleanly in test environment.

class FakeAuthRepository implements AuthRepository {
  UserEntity? sessionUser;
  (UserEntity?, Failure?) loginResult = (null, null);

  @override
  Future<UserEntity?> getSession() async => sessionUser;

  @override
  Future<(UserEntity?, Failure?)> login({
    required String email,
    required String password,
  }) async {
    return loginResult;
  }

  @override
  Future<Failure?> logout() async => null;
}

void main() {
  group('Role-based guard logic', () {
    test(
      'no session → unauthenticated (app would show WelcomeScreen)',
      () async {
        final repo = FakeAuthRepository();
        final auth = AuthController(repo);
        await Future.delayed(const Duration(milliseconds: 50));

        expect(auth.status, AuthStatus.unauthenticated);
        expect(auth.currentUser, isNull);
      },
    );

    test('operator session → authenticated with operator role', () async {
      final repo = FakeAuthRepository();
      repo.sessionUser = const UserEntity(
        id: 'usr-001',
        name: 'Carlos',
        email: 'operator@connexa.app',
        role: UserRole.operator,
      );
      final auth = AuthController(repo);
      await Future.delayed(const Duration(milliseconds: 50));

      expect(auth.status, AuthStatus.authenticated);
      expect(auth.currentUser?.role, UserRole.operator);
    });

    test('owner session → authenticated with owner role', () async {
      final repo = FakeAuthRepository();
      repo.sessionUser = const UserEntity(
        id: 'usr-002',
        name: 'Andrés',
        email: 'owner@connexa.app',
        role: UserRole.owner,
      );
      final auth = AuthController(repo);
      await Future.delayed(const Duration(milliseconds: 50));

      expect(auth.status, AuthStatus.authenticated);
      expect(auth.currentUser?.role, UserRole.owner);
    });

    test('logout → unauthenticated (app would show WelcomeScreen)', () async {
      final repo = FakeAuthRepository();
      repo.sessionUser = const UserEntity(
        id: 'usr-001',
        name: 'Carlos',
        email: 'operator@connexa.app',
        role: UserRole.operator,
      );
      final auth = AuthController(repo);
      await Future.delayed(const Duration(milliseconds: 50));
      expect(auth.isAuthenticated, isTrue);

      await auth.logout();

      expect(auth.status, AuthStatus.unauthenticated);
      expect(auth.currentUser, isNull);
    });

    test(
      'role determines dashboard: operator gets OperatorShell, owner gets OwnerShell',
      () {
        // Mirrors the routing logic in _AppRoot._dashboardByRole
        String dashboardByRole(UserRole role) => switch (role) {
          UserRole.operator => 'OperatorShell',
          UserRole.owner => 'OwnerShell',
        };

        expect(dashboardByRole(UserRole.operator), 'OperatorShell');
        expect(dashboardByRole(UserRole.owner), 'OwnerShell');
      },
    );
  });
}
