import 'package:flutter_test/flutter_test.dart';
import 'package:sistema_proveedores_client/features/auth/domain/entities/user_entity.dart';
import 'package:sistema_proveedores_client/features/auth/presentation/controllers/auth_controller.dart';

// Smoke test: ConnexaApp renders Rive animations that can't load in test env.
// We verify core app logic instead.

void main() {
  test('App smoke: UserRole enum has operator and owner', () {
    expect(UserRole.values.length, 2);
    expect(UserRole.values, contains(UserRole.operator));
    expect(UserRole.values, contains(UserRole.owner));
  });

  test('App smoke: AuthStatus covers all expected states', () {
    expect(
      AuthStatus.values,
      containsAll([
        AuthStatus.initial,
        AuthStatus.loading,
        AuthStatus.authenticated,
        AuthStatus.unauthenticated,
        AuthStatus.error,
      ]),
    );
  });
}
