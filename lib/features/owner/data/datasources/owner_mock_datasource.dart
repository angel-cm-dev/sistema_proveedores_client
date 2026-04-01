import '../../../auth/domain/entities/user_entity.dart';
import '../../domain/entities/internal_user_entity.dart';

/// Mock datasource for owner-specific data.
class OwnerMockDataSource {
  /// Executive KPIs
  List<OwnerKpi> getKpis() {
    return const [
      OwnerKpi(label: 'Cumplimiento SLA', value: '87%', delta: '+2.3%', trend: KpiTrend.up),
      OwnerKpi(label: 'Tiempo promedio entrega', value: '3.2d', delta: '-0.4d', trend: KpiTrend.up),
      OwnerKpi(label: 'Incidencias abiertas', value: '5', delta: '+1', trend: KpiTrend.down),
      OwnerKpi(label: 'Órdenes mes', value: '48', delta: '+12%', trend: KpiTrend.up),
      OwnerKpi(label: 'Proveedores activos', value: '6', delta: '0', trend: KpiTrend.neutral),
      OwnerKpi(label: 'Gasto acumulado', value: '\$24.5K', delta: '+8%', trend: KpiTrend.neutral),
    ];
  }

  /// Supplier performance summary
  List<SupplierPerformance> getSupplierPerformance() {
    return const [
      SupplierPerformance(name: 'Proveedores del Valle', score: 95, orders: 27, onTime: 96, incidents: 0),
      SupplierPerformance(name: 'Tech Supply Group', score: 91, orders: 18, onTime: 94, incidents: 1),
      SupplierPerformance(name: 'Distribuidora Montes S.A.', score: 88, orders: 42, onTime: 90, incidents: 2),
      SupplierPerformance(name: 'Maquinaria Industrial CR', score: 84, orders: 15, onTime: 87, incidents: 1),
      SupplierPerformance(name: 'Ferretería Central', score: 79, orders: 22, onTime: 82, incidents: 3),
      SupplierPerformance(name: 'LogiTrans Norte', score: 72, orders: 31, onTime: 77, incidents: 4),
      SupplierPerformance(name: 'Agro Proveedores', score: 61, orders: 12, onTime: 67, incidents: 5),
    ];
  }

  /// Internal users
  List<InternalUserEntity> getUsers() {
    final now = DateTime.now();
    return [
      InternalUserEntity(
        id: 'usr-001',
        name: 'Carlos Méndez',
        email: 'operator@connexa.app',
        role: UserRole.operator,
        status: InternalUserStatus.active,
        createdAt: now.subtract(const Duration(days: 90)),
        lastLogin: now.subtract(const Duration(hours: 2)),
      ),
      InternalUserEntity(
        id: 'usr-002',
        name: 'Andrés Villareal',
        email: 'owner@connexa.app',
        role: UserRole.owner,
        status: InternalUserStatus.active,
        createdAt: now.subtract(const Duration(days: 120)),
        lastLogin: now.subtract(const Duration(minutes: 30)),
      ),
      InternalUserEntity(
        id: 'usr-003',
        name: 'María López',
        email: 'maria.lopez@connexa.app',
        role: UserRole.operator,
        status: InternalUserStatus.active,
        createdAt: now.subtract(const Duration(days: 60)),
        lastLogin: now.subtract(const Duration(days: 1)),
      ),
      InternalUserEntity(
        id: 'usr-004',
        name: 'Roberto Sánchez',
        email: 'r.sanchez@connexa.app',
        role: UserRole.operator,
        status: InternalUserStatus.inactive,
        createdAt: now.subtract(const Duration(days: 200)),
        lastLogin: now.subtract(const Duration(days: 45)),
      ),
    ];
  }

  /// Monthly trend data (last 6 months)
  List<MonthlyMetric> getMonthlyOrderTrend() {
    return const [
      MonthlyMetric(month: 'Oct', value: 32),
      MonthlyMetric(month: 'Nov', value: 38),
      MonthlyMetric(month: 'Dic', value: 29),
      MonthlyMetric(month: 'Ene', value: 41),
      MonthlyMetric(month: 'Feb', value: 44),
      MonthlyMetric(month: 'Mar', value: 48),
    ];
  }
}

enum KpiTrend { up, down, neutral }

class OwnerKpi {
  final String label;
  final String value;
  final String delta;
  final KpiTrend trend;

  const OwnerKpi({required this.label, required this.value, required this.delta, required this.trend});
}

class SupplierPerformance {
  final String name;
  final int score;
  final int orders;
  final int onTime;
  final int incidents;

  const SupplierPerformance({
    required this.name,
    required this.score,
    required this.orders,
    required this.onTime,
    required this.incidents,
  });

  String get initials {
    final parts = name.trim().split(' ');
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return '${parts.first[0]}${parts[1][0]}'.toUpperCase();
  }
}

class MonthlyMetric {
  final String month;
  final double value;

  const MonthlyMetric({required this.month, required this.value});
}
