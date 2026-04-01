import 'package:flutter/foundation.dart';
import '../../../../core/errors/failures.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../../domain/entities/internal_user_entity.dart';
import '../../domain/repositories/owner_repository.dart';
import '../datasources/owner_mock_datasource.dart';

class OwnerRepositoryImpl implements OwnerRepository {
  final OwnerMockDataSource _mockDs;

  const OwnerRepositoryImpl(this._mockDs);

  @override
  Future<(List<OwnerKpi>?, Failure?)> getKpis() async {
    try {
      return (_mockDs.getKpis(), null);
    } catch (e) {
      debugPrint('OwnerRepositoryImpl.getKpis error: $e');
      return (null, const UnknownFailure());
    }
  }

  @override
  Future<(List<SupplierPerformance>?, Failure?)> getSupplierPerformance() async {
    try {
      return (_mockDs.getSupplierPerformance(), null);
    } catch (e) {
      debugPrint('OwnerRepositoryImpl.getSupplierPerformance error: $e');
      return (null, const UnknownFailure());
    }
  }

  @override
  Future<(List<InternalUserEntity>?, Failure?)> getUsers() async {
    try {
      return (_mockDs.getUsers(), null);
    } catch (e) {
      debugPrint('OwnerRepositoryImpl.getUsers error: $e');
      return (null, const UnknownFailure());
    }
  }

  @override
  Future<(List<MonthlyMetric>?, Failure?)> getMonthlyOrderTrend() async {
    try {
      return (_mockDs.getMonthlyOrderTrend(), null);
    } catch (e) {
      debugPrint('OwnerRepositoryImpl.getMonthlyOrderTrend error: $e');
      return (null, const UnknownFailure());
    }
  }

  @override
  Future<Failure?> toggleUserStatus(String userId) async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      return null;
    } catch (e) {
      debugPrint('OwnerRepositoryImpl.toggleUserStatus error: $e');
      return const UnknownFailure();
    }
  }

  @override
  Future<Failure?> addUser({
    required String name,
    required String email,
    required UserRole role,
  }) async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      return null;
    } catch (e) {
      debugPrint('OwnerRepositoryImpl.addUser error: $e');
      return const UnknownFailure();
    }
  }
}
