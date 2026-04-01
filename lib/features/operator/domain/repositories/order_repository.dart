import '../../../../core/errors/failures.dart';
import '../entities/order_entity.dart';

/// Domain contract for order data access.
abstract class OrderRepository {
  Future<(List<OrderEntity>?, Failure?)> getOrders();
  Future<(OrderEntity?, Failure?)> getOrderById(String id);
  Future<(List<OrderEntity>?, Failure?)> getOrdersForSupplier(String supplierId);
  Future<Failure?> updateOrderStatus(String orderId, OrderStatus newStatus);
}
