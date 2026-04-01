import 'package:flutter_test/flutter_test.dart';
import 'package:sistema_proveedores_client/core/errors/failures.dart';
import 'package:sistema_proveedores_client/features/auth/domain/entities/user_entity.dart';
import 'package:sistema_proveedores_client/features/auth/domain/repositories/auth_repository.dart';
import 'package:sistema_proveedores_client/features/auth/presentation/controllers/auth_controller.dart';

// ── Fake repository for testing ──────────────────────────────────────────────

class FakeAuthRepository implements AuthRepository {
  UserEntity? sessionUser;
  (UserEntity?, Failure?) loginResult = (null, null);
  bool logoutCalled = false;

  @override
  Future<UserEntity?> getSession() async => sessionUser;

  @override
  Future<(UserEntity?, Failure?)> login({required String email, required String password}) async {
    await Future.delayed(const Duration(milliseconds: 10));
    return loginResult;
  }

  @override
  Future<Failure?> logout() async {
    logoutCalled = true;
    return null;
  }
}

// ── Tests ────────────────────────────────────────────────────────────────────

void main() {
  late FakeAuthRepository repo;
  late AuthController controller;

  const operatorUser = UserEntity(
    id: 'usr-001',
    name: 'Carlos Méndez',
    email: 'operator@connexa.app',
    role: UserRole.operator,
  );

  const ownerUser = UserEntity(
    id: 'usr-002',
    name: 'Andrés Villareal',
    email: 'owner@connexa.app',
    role: UserRole.owner,
  );

  setUp(() {
    repo = FakeAuthRepository();
  });

  group('AuthController - initialization', () {
    test('starts with unauthenticated when no session', () async {
      controller = AuthController(repo);
      // Wait for _checkSession to complete
      await Future.delayed(const Duration(milliseconds: 50));
      expect(controller.status, AuthStatus.unauthenticated);
      expect(controller.currentUser, isNull);
    });

    test('starts authenticated when session exists', () async {
      repo.sessionUser = operatorUser;
      controller = AuthController(repo);
      await Future.delayed(const Duration(milliseconds: 50));
      expect(controller.status, AuthStatus.authenticated);
      expect(controller.currentUser, operatorUser);
      expect(controller.isAuthenticated, isTrue);
    });
  });

  group('AuthController - login', () {
    test('successful login sets authenticated + user', () async {
      repo.loginResult = (operatorUser, null);
      controller = AuthController(repo);
      await Future.delayed(const Duration(milliseconds: 50));

      final success = await controller.login(email: 'operator@connexa.app', password: 'pass123');

      expect(success, isTrue);
      expect(controller.status, AuthStatus.authenticated);
      expect(controller.currentUser?.email, 'operator@connexa.app');
      expect(controller.currentUser?.role, UserRole.operator);
    });

    test('failed login sets error + message', () async {
      repo.loginResult = (null, const InvalidCredentialsFailure());
      controller = AuthController(repo);
      await Future.delayed(const Duration(milliseconds: 50));

      final success = await controller.login(email: 'bad@email.com', password: 'wrong');

      expect(success, isFalse);
      expect(controller.status, AuthStatus.error);
      expect(controller.errorMessage, isNotNull);
      expect(controller.errorMessage, contains('incorrectos'));
    });

    test('login with owner role returns owner user', () async {
      repo.loginResult = (ownerUser, null);
      controller = AuthController(repo);
      await Future.delayed(const Duration(milliseconds: 50));

      final success = await controller.login(email: 'owner@connexa.app', password: 'pass123');

      expect(success, isTrue);
      expect(controller.currentUser?.role, UserRole.owner);
    });
  });

  group('AuthController - logout', () {
    test('logout clears user and sets unauthenticated', () async {
      repo.sessionUser = operatorUser;
      controller = AuthController(repo);
      await Future.delayed(const Duration(milliseconds: 50));

      expect(controller.isAuthenticated, isTrue);

      await controller.logout();

      expect(controller.status, AuthStatus.unauthenticated);
      expect(controller.currentUser, isNull);
      expect(controller.errorMessage, isNull);
      expect(repo.logoutCalled, isTrue);
    });
  });

  group('AuthController - clearError', () {
    test('clearError resets error status', () async {
      repo.loginResult = (null, const InvalidCredentialsFailure());
      controller = AuthController(repo);
      await Future.delayed(const Duration(milliseconds: 50));

      await controller.login(email: 'x', password: 'x');
      expect(controller.status, AuthStatus.error);

      controller.clearError();
      expect(controller.status, AuthStatus.unauthenticated);
      expect(controller.errorMessage, isNull);
    });
  });
}
