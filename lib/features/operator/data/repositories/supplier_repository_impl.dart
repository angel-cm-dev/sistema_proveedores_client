import 'package:flutter/foundation.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/supplier_entity.dart';
import '../../domain/repositories/supplier_repository.dart';
import '../datasources/operator_mock_datasource.dart';

class SupplierRepositoryImpl implements SupplierRepository {
  final OperatorMockDataSource _mockDs;

  const SupplierRepositoryImpl(this._mockDs);

  @override
  Future<(List<SupplierEntity>?, Failure?)> getSuppliers() async {
    try {
      final suppliers = _mockDs.getSuppliers();
      return (suppliers, null);
    } catch (e) {
      debugPrint('SupplierRepositoryImpl.getSuppliers error: $e');
      return (null, const UnknownFailure());
    }
  }

  @override
  Future<(SupplierEntity?, Failure?)> getSupplierById(String id) async {
    try {
      final supplier = _mockDs.getSupplierById(id);
      if (supplier == null) {
        return (null, const ServerFailure('Proveedor no encontrado.'));
      }
      return (supplier, null);
    } catch (e) {
      debugPrint('SupplierRepositoryImpl.getSupplierById error: $e');
      return (null, const UnknownFailure());
    }
  }
}
