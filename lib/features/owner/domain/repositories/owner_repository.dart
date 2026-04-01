import '../../../../core/errors/failures.dart';
import '../../../../features/auth/domain/entities/user_entity.dart';
import '../../../owner/data/datasources/owner_mock_datasource.dart';
import '../entities/internal_user_entity.dart';

/// Domain contract for owner-specific data access.
abstract class OwnerRepository {
  Future<(List<OwnerKpi>?, Failure?)> getKpis();
  Future<(List<SupplierPerformance>?, Failure?)> getSupplierPerformance();
  Future<(List<InternalUserEntity>?, Failure?)> getUsers();
  Future<(List<MonthlyMetric>?, Failure?)> getMonthlyOrderTrend();
  Future<Failure?> toggleUserStatus(String userId);
  Future<Failure?> addUser({
    required String name,
    required String email,
    required UserRole role,
  });
}
