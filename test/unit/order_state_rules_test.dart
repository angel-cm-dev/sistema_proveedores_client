import 'package:flutter_test/flutter_test.dart';
import 'package:sistema_proveedores_client/features/operator/domain/entities/order_entity.dart';

/// Tests for order status transition rules.
/// Valid transitions:
///   pending     → inProgress
///   inProgress  → completed, delayed
///   delayed     → inProgress, completed
///   completed   → (none)

void main() {
  // Helper that mirrors the rules in OrderDetailScreen._validTransitions
  List<OrderStatus> validTransitions(OrderStatus current) => switch (current) {
    OrderStatus.pending => [OrderStatus.inProgress],
    OrderStatus.inProgress => [OrderStatus.completed, OrderStatus.delayed],
    OrderStatus.delayed => [OrderStatus.inProgress, OrderStatus.completed],
    OrderStatus.completed => [],
  };

  group('Order state transition rules', () {
    test('pending can only go to inProgress', () {
      final transitions = validTransitions(OrderStatus.pending);
      expect(transitions, [OrderStatus.inProgress]);
      expect(transitions.contains(OrderStatus.completed), isFalse);
      expect(transitions.contains(OrderStatus.delayed), isFalse);
    });

    test('inProgress can go to completed or delayed', () {
      final transitions = validTransitions(OrderStatus.inProgress);
      expect(transitions, containsAll([OrderStatus.completed, OrderStatus.delayed]));
      expect(transitions.contains(OrderStatus.pending), isFalse);
    });

    test('delayed can go back to inProgress or to completed', () {
      final transitions = validTransitions(OrderStatus.delayed);
      expect(transitions, containsAll([OrderStatus.inProgress, OrderStatus.completed]));
      expect(transitions.contains(OrderStatus.pending), isFalse);
    });

    test('completed is a terminal state (no transitions)', () {
      final transitions = validTransitions(OrderStatus.completed);
      expect(transitions, isEmpty);
    });

    test('all statuses have a label', () {
      for (final status in OrderStatus.values) {
        expect(status.label, isNotEmpty);
      }
    });
  });

  group('OrderEntity - isOverdue', () {
    test('order past due date and not completed is overdue', () {
      final order = OrderEntity(
        id: 'ORD-001',
        supplierId: 'sup-001',
        supplierName: 'Test',
        status: OrderStatus.pending,
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
        dueDate: DateTime.now().subtract(const Duration(days: 1)),
      );
      expect(order.isOverdue, isTrue);
    });

    test('completed order is never overdue', () {
      final order = OrderEntity(
        id: 'ORD-002',
        supplierId: 'sup-001',
        supplierName: 'Test',
        status: OrderStatus.completed,
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
        dueDate: DateTime.now().subtract(const Duration(days: 1)),
      );
      expect(order.isOverdue, isFalse);
    });

    test('order with future due date is not overdue', () {
      final order = OrderEntity(
        id: 'ORD-003',
        supplierId: 'sup-001',
        supplierName: 'Test',
        status: OrderStatus.inProgress,
        createdAt: DateTime.now(),
        dueDate: DateTime.now().add(const Duration(days: 3)),
      );
      expect(order.isOverdue, isFalse);
    });
  });
}
