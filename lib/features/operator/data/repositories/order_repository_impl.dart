import 'package:flutter/foundation.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/repositories/order_repository.dart';
import '../datasources/operator_mock_datasource.dart';

class OrderRepositoryImpl implements OrderRepository {
  final OperatorMockDataSource _mockDs;

  const OrderRepositoryImpl(this._mockDs);

  @override
  Future<(List<OrderEntity>?, Failure?)> getOrders() async {
    try {
      final orders = _mockDs.getOrders();
      return (orders, null);
    } catch (e) {
      debugPrint('OrderRepositoryImpl.getOrders error: $e');
      return (null, const UnknownFailure());
    }
  }

  @override
  Future<(OrderEntity?, Failure?)> getOrderById(String id) async {
    try {
      final orders = _mockDs.getOrders();
      final order = orders.firstWhere((o) => o.id == id);
      return (order, null);
    } catch (e) {
      debugPrint('OrderRepositoryImpl.getOrderById error: $e');
      return (null, const ServerFailure('Orden no encontrada.'));
    }
  }

  @override
  Future<(List<OrderEntity>?, Failure?)> getOrdersForSupplier(String supplierId) async {
    try {
      final orders = _mockDs.getOrdersForSupplier(supplierId);
      return (orders, null);
    } catch (e) {
      debugPrint('OrderRepositoryImpl.getOrdersForSupplier error: $e');
      return (null, const UnknownFailure());
    }
  }

  @override
  Future<Failure?> updateOrderStatus(String orderId, OrderStatus newStatus) async {
    try {
      // In mock mode, just simulate success with delay
      await Future.delayed(const Duration(milliseconds: 300));
      return null;
    } catch (e) {
      debugPrint('OrderRepositoryImpl.updateOrderStatus error: $e');
      return const UnknownFailure();
    }
  }
}
