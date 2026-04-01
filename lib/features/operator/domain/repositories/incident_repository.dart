import '../../../../core/errors/failures.dart';
import '../entities/incident_entity.dart';

/// Domain contract for incident data access.
abstract class IncidentRepository {
  Future<(List<IncidentEntity>?, Failure?)> getIncidents();
  Future<(List<IncidentEntity>?, Failure?)> getIncidentsForOrder(String orderId);
  Future<Failure?> createIncident({
    required String orderId,
    required String title,
    required String description,
    required IncidentPriority priority,
  });
}
