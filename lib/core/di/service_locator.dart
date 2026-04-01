import '../config/app_environment.dart';
import '../network/api_client.dart';
import '../../features/auth/data/datasources/auth_mock_datasource.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/operator/data/datasources/operator_mock_datasource.dart';
import '../../features/operator/data/repositories/incident_repository_impl.dart';
import '../../features/operator/data/repositories/order_repository_impl.dart';
import '../../features/operator/data/repositories/supplier_repository_impl.dart';
import '../../features/operator/domain/repositories/incident_repository.dart';
import '../../features/operator/domain/repositories/order_repository.dart';
import '../../features/operator/domain/repositories/supplier_repository.dart';
import '../../features/owner/data/datasources/owner_mock_datasource.dart';
import '../../features/owner/data/repositories/owner_repository_impl.dart';
import '../../features/owner/domain/repositories/owner_repository.dart';

/// Lightweight service locator — no external DI package needed.
/// Provides singleton instances of repositories and the API client.
class ServiceLocator {
  ServiceLocator._();

  static final _instance = ServiceLocator._();
  static ServiceLocator get I => _instance;

  // ── Core ─────────────────────────────────────────────────────────────────
  late final ApiClient apiClient = ApiClient();

  // ── Datasources ──────────────────────────────────────────────────────────
  final _authMockDs = AuthMockDataSource();
  final _operatorMockDs = OperatorMockDataSource();
  final _ownerMockDs = OwnerMockDataSource();

  // ── Repositories ─────────────────────────────────────────────────────────
  late final AuthRepository authRepository = _resolveAuth();
  late final OrderRepository orderRepository = _resolveOrders();
  late final IncidentRepository incidentRepository = _resolveIncidents();
  late final SupplierRepository supplierRepository = _resolveSuppliers();
  late final OwnerRepository ownerRepository = _resolveOwner();

  AuthRepository _resolveAuth() {
    if (AppEnvironment.useMock) {
      return AuthRepositoryImpl(_authMockDs);
    }
    // TODO: return AuthRepositoryImpl(AuthApiDataSource(apiClient));
    return AuthRepositoryImpl(_authMockDs);
  }

  OrderRepository _resolveOrders() {
    if (AppEnvironment.useMock) {
      return OrderRepositoryImpl(_operatorMockDs);
    }
    return OrderRepositoryImpl(_operatorMockDs);
  }

  IncidentRepository _resolveIncidents() {
    if (AppEnvironment.useMock) {
      return IncidentRepositoryImpl(_operatorMockDs);
    }
    return IncidentRepositoryImpl(_operatorMockDs);
  }

  SupplierRepository _resolveSuppliers() {
    if (AppEnvironment.useMock) {
      return SupplierRepositoryImpl(_operatorMockDs);
    }
    return SupplierRepositoryImpl(_operatorMockDs);
  }

  OwnerRepository _resolveOwner() {
    if (AppEnvironment.useMock) {
      return OwnerRepositoryImpl(_ownerMockDs);
    }
    return OwnerRepositoryImpl(_ownerMockDs);
  }
}
