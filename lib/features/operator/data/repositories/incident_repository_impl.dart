import 'package:flutter/foundation.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/incident_entity.dart';
import '../../domain/repositories/incident_repository.dart';
import '../datasources/operator_mock_datasource.dart';

class IncidentRepositoryImpl implements IncidentRepository {
  final OperatorMockDataSource _mockDs;

  const IncidentRepositoryImpl(this._mockDs);

  @override
  Future<(List<IncidentEntity>?, Failure?)> getIncidents() async {
    try {
      final incidents = _mockDs.getIncidents();
      return (incidents, null);
    } catch (e) {
      debugPrint('IncidentRepositoryImpl.getIncidents error: $e');
      return (null, const UnknownFailure());
    }
  }

  @override
  Future<(List<IncidentEntity>?, Failure?)> getIncidentsForOrder(String orderId) async {
    try {
      final incidents = _mockDs.getIncidentsForOrder(orderId);
      return (incidents, null);
    } catch (e) {
      debugPrint('IncidentRepositoryImpl.getIncidentsForOrder error: $e');
      return (null, const UnknownFailure());
    }
  }

  @override
  Future<Failure?> createIncident({
    required String orderId,
    required String title,
    required String description,
    required IncidentPriority priority,
  }) async {
    try {
      // Mock: simulate creation delay
      await Future.delayed(const Duration(milliseconds: 500));
      return null;
    } catch (e) {
      debugPrint('IncidentRepositoryImpl.createIncident error: $e');
      return const UnknownFailure();
    }
  }
}
