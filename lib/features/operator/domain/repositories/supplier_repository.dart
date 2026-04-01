import '../../../../core/errors/failures.dart';
import '../entities/supplier_entity.dart';

/// Domain contract for supplier data access.
abstract class SupplierRepository {
  Future<(List<SupplierEntity>?, Failure?)> getSuppliers();
  Future<(SupplierEntity?, Failure?)> getSupplierById(String id);
}
