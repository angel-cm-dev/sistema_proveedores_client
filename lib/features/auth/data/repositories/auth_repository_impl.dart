import 'package:flutter/foundation.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthDataSource _dataSource;

  const AuthRepositoryImpl(this._dataSource);

  @override
  Future<(UserEntity?, Failure?)> login({
    required String email,
    required String password,
  }) async {
    try {
      final user = await _dataSource.login(email: email, password: password);
      return (user, null);
    } on InvalidCredentialsFailure catch (e) {
      return (null, e);
    } on NetworkFailure catch (e) {
      return (null, e);
    } catch (e) {
      debugPrint('AuthRepositoryImpl.login error: $e');
      return (null, const UnknownFailure());
    }
  }

  @override
  Future<Failure?> logout() async {
    try {
      await _dataSource.logout();
      return null;
    } catch (e) {
      debugPrint('AuthRepositoryImpl.logout error: $e');
      return const UnknownFailure();
    }
  }

  @override
  Future<UserEntity?> getSession() async {
    try {
      return await _dataSource.getSession();
    } catch (_) {
      return null;
    }
  }
}
