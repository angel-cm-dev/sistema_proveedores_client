import 'package:flutter/material.dart';
import '../../domain/entities/incident_entity.dart';
import '../../domain/entities/kpi_entity.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/entities/supplier_entity.dart';

/// Mock del datasource del operador.
/// Provee KPIs, órdenes recientes y eventos de calendario.
class OperatorMockDataSource {
  /// KPIs del dashboard
  List<KpiEntity> getKpis() => [
    KpiEntity(
      label: 'Órdenes hoy',
      value: '12',
      subtitle: '+3 vs ayer',
      icon: Icons.receipt_long_rounded,
      accentColor: const Color(0xFF4361EE),
      bgColor: const Color(0xFF1D2F6F),
      trendPercent: 33.3,
    ),
    KpiEntity(
      label: 'Atrasadas',
      value: '3',
      subtitle: 'Requieren atención',
      icon: Icons.warning_amber_rounded,
      accentColor: const Color(0xFFEF233C),
      bgColor: const Color(0xFF4D0A0F),
      trendPercent: -10,
    ),
    KpiEntity(
      label: 'Incidencias',
      value: '2',
      subtitle: 'Sin resolver',
      icon: Icons.bug_report_rounded,
      accentColor: const Color(0xFFF77F00),
      bgColor: const Color(0xFF4D2A00),
      trendPercent: null,
    ),
    KpiEntity(
      label: 'SLA cumplido',
      value: '87%',
      subtitle: 'Meta: 90%',
      icon: Icons.verified_rounded,
      accentColor: const Color(0xFF06D6A0),
      bgColor: const Color(0xFF0A3D2A),
      trendPercent: 5.2,
    ),
  ];

  /// Lista completa de órdenes mock
  List<OrderEntity> getOrders() {
    final now = DateTime.now();
    return [
      OrderEntity(
        id: 'ORD-0041',
        supplierId: 'sup-001',
        supplierName: 'Distribuidora Montes S.A.',
        status: OrderStatus.inProgress,
        createdAt: now.subtract(const Duration(hours: 3)),
        dueDate: now.add(const Duration(hours: 5)),
        description: 'Entrega de 200 unidades de material eléctrico.',
      ),
      OrderEntity(
        id: 'ORD-0040',
        supplierId: 'sup-002',
        supplierName: 'LogiTrans Norte',
        status: OrderStatus.delayed,
        createdAt: now.subtract(const Duration(days: 2)),
        dueDate: now.subtract(const Duration(hours: 6)),
        description: 'Transporte de equipos de refrigeración.',
      ),
      OrderEntity(
        id: 'ORD-0039',
        supplierId: 'sup-003',
        supplierName: 'Proveedores del Valle',
        status: OrderStatus.completed,
        createdAt: now.subtract(const Duration(days: 1)),
        dueDate: now.subtract(const Duration(hours: 2)),
        description: 'Insumos de limpieza industrial.',
      ),
      OrderEntity(
        id: 'ORD-0038',
        supplierId: 'sup-004',
        supplierName: 'Tech Supply Group',
        status: OrderStatus.pending,
        createdAt: now.subtract(const Duration(hours: 8)),
        dueDate: now.add(const Duration(days: 1)),
        description: 'Componentes electrónicos para mantenimiento.',
      ),
      OrderEntity(
        id: 'ORD-0037',
        supplierId: 'sup-005',
        supplierName: 'Maquinaria Industrial CR',
        status: OrderStatus.inProgress,
        createdAt: now.subtract(const Duration(days: 1, hours: 4)),
        dueDate: now.add(const Duration(hours: 10)),
        description: 'Reparación de turbina central.',
      ),
      OrderEntity(
        id: 'ORD-0036',
        supplierId: 'sup-001',
        supplierName: 'Distribuidora Montes S.A.',
        status: OrderStatus.completed,
        createdAt: now.subtract(const Duration(days: 3)),
        dueDate: now.subtract(const Duration(days: 1)),
        description: 'Cable de alta tensión.',
      ),
      OrderEntity(
        id: 'ORD-0035',
        supplierId: 'sup-006',
        supplierName: 'Ferretería Central',
        status: OrderStatus.pending,
        createdAt: now.subtract(const Duration(hours: 1)),
        dueDate: now.add(const Duration(days: 2)),
        description: 'Materiales de construcción.',
      ),
      OrderEntity(
        id: 'ORD-0034',
        supplierId: 'sup-007',
        supplierName: 'Agro Proveedores',
        status: OrderStatus.delayed,
        createdAt: now.subtract(const Duration(days: 4)),
        dueDate: now.subtract(const Duration(days: 1)),
        description: 'Insumos agrícolas.',
      ),
      OrderEntity(
        id: 'ORD-0033',
        supplierId: 'sup-002',
        supplierName: 'LogiTrans Norte',
        status: OrderStatus.inProgress,
        createdAt: now.subtract(const Duration(hours: 12)),
        dueDate: now.add(const Duration(days: 1, hours: 6)),
        description: 'Transporte de combustible.',
      ),
      OrderEntity(
        id: 'ORD-0032',
        supplierId: 'sup-003',
        supplierName: 'Proveedores del Valle',
        status: OrderStatus.completed,
        createdAt: now.subtract(const Duration(days: 5)),
        dueDate: now.subtract(const Duration(days: 3)),
        description: 'Papelería y suministros de oficina.',
      ),
    ];
  }

  /// Eventos del calendario tipados (date → lista de CalendarEvent)
  Map<DateTime, List<CalendarEvent>> getCalendarEvents() {
    final today = _dayOnly(DateTime.now());
    return {
      today: [
        CalendarEvent(title: 'Entrega ORD-0041 - Distribuidora Montes', type: CalendarEventType.delivery),
        CalendarEvent(title: 'Reunión de seguimiento SLA', type: CalendarEventType.meeting),
      ],
      today.add(const Duration(days: 1)): [
        CalendarEvent(title: 'Visita proveedor LogiTrans Norte', type: CalendarEventType.visit),
        CalendarEvent(title: 'Cierre mes - reporte incidencias', type: CalendarEventType.milestone),
      ],
      today.add(const Duration(days: 3)): [
        CalendarEvent(title: 'Entrega ORD-0038 - Tech Supply Group', type: CalendarEventType.delivery),
      ],
      today.add(const Duration(days: 5)): [
        CalendarEvent(title: 'Visita proveedor Ferretería Central', type: CalendarEventType.visit),
        CalendarEvent(title: 'Revisión contrato Maquinaria Industrial CR', type: CalendarEventType.milestone),
      ],
      today.subtract(const Duration(days: 1)): [
        CalendarEvent(title: 'Cierre ORD-0039 - entregado', type: CalendarEventType.delivery),
      ],
    };
  }

  /// Lista de incidencias mock
  List<IncidentEntity> getIncidents() {
    final now = DateTime.now();
    return [
      IncidentEntity(
        id: 'INC-001',
        orderId: 'ORD-0040',
        orderCode: 'ORD-0040',
        supplierName: 'LogiTrans Norte',
        title: 'Retraso en entrega de equipos',
        description: 'El proveedor confirmó retraso de 2 días por problemas logísticos en el transporte de equipos de refrigeración.',
        status: IncidentStatus.inProgress,
        priority: IncidentPriority.high,
        createdAt: now.subtract(const Duration(days: 2, hours: 3)),
        reportedBy: 'Carlos Méndez',
        timeline: [
          IncidentEvent(description: 'Incidencia creada', timestamp: now.subtract(const Duration(days: 2, hours: 3)), author: 'Carlos Méndez'),
          IncidentEvent(description: 'Proveedor notificado vía correo', timestamp: now.subtract(const Duration(days: 2, hours: 1)), author: 'Sistema'),
          IncidentEvent(description: 'Proveedor confirma nuevo plazo de entrega', timestamp: now.subtract(const Duration(days: 1, hours: 4)), author: 'LogiTrans Norte'),
        ],
      ),
      IncidentEntity(
        id: 'INC-002',
        orderId: 'ORD-0034',
        orderCode: 'ORD-0034',
        supplierName: 'Agro Proveedores',
        title: 'Insumos incompletos en el pedido',
        description: 'Se recibió el pedido con el 70% de los insumos agrícolas. Faltan 30 unidades de fertilizante según factura.',
        status: IncidentStatus.open,
        priority: IncidentPriority.critical,
        createdAt: now.subtract(const Duration(hours: 18)),
        reportedBy: 'Carlos Méndez',
        timeline: [
          IncidentEvent(description: 'Incidencia registrada al recibir el pedido incompleto', timestamp: now.subtract(const Duration(hours: 18)), author: 'Carlos Méndez'),
        ],
      ),
      IncidentEntity(
        id: 'INC-003',
        orderId: 'ORD-0036',
        orderCode: 'ORD-0036',
        supplierName: 'Distribuidora Montes S.A.',
        title: 'Cable dañado en la entrega',
        description: 'Parte del cable de alta tensión llegó con daños físicos visibles. Se rechazó la recepción de 5 rollos.',
        status: IncidentStatus.resolved,
        priority: IncidentPriority.medium,
        createdAt: now.subtract(const Duration(days: 4)),
        resolvedAt: now.subtract(const Duration(days: 2)),
        reportedBy: 'Carlos Méndez',
        timeline: [
          IncidentEvent(description: 'Incidencia reportada con evidencia fotográfica', timestamp: now.subtract(const Duration(days: 4)), author: 'Carlos Méndez'),
          IncidentEvent(description: 'Proveedor acepta reposición de los 5 rollos', timestamp: now.subtract(const Duration(days: 3, hours: 5)), author: 'Distribuidora Montes S.A.'),
          IncidentEvent(description: 'Reposición recibida y verificada', timestamp: now.subtract(const Duration(days: 2)), author: 'Carlos Méndez'),
          IncidentEvent(description: 'Incidencia marcada como resuelta', timestamp: now.subtract(const Duration(days: 2)), author: 'Carlos Méndez'),
        ],
      ),
      IncidentEntity(
        id: 'INC-004',
        orderId: 'ORD-0033',
        orderCode: 'ORD-0033',
        supplierName: 'LogiTrans Norte',
        title: 'Falla en documentación de transporte',
        description: 'El vehículo llegó sin el permiso de transporte de combustible actualizado. Se requiere subsanar antes del próximo viaje.',
        status: IncidentStatus.open,
        priority: IncidentPriority.high,
        createdAt: now.subtract(const Duration(hours: 6)),
        reportedBy: 'Carlos Méndez',
        timeline: [
          IncidentEvent(description: 'Incidencia abierta por documentación incompleta', timestamp: now.subtract(const Duration(hours: 6)), author: 'Carlos Méndez'),
        ],
      ),
    ];
  }

  /// Lista de proveedores mock
  List<SupplierEntity> getSuppliers() => [
    const SupplierEntity(
      id: 'sup-001',
      name: 'Distribuidora Montes S.A.',
      contactName: 'Ricardo Montes',
      email: 'r.montes@distmontes.com',
      phone: '+506 8800-1234',
      status: SupplierStatus.active,
      complianceScore: 88,
      totalOrders: 42,
      completedOrders: 38,
      categories: ['Eléctrico', 'Industrial'],
      address: 'Calle 5, Ave 10, San José',
    ),
    const SupplierEntity(
      id: 'sup-002',
      name: 'LogiTrans Norte',
      contactName: 'María Solano',
      email: 'm.solano@logitrans.cr',
      phone: '+506 8811-5678',
      status: SupplierStatus.active,
      complianceScore: 72,
      totalOrders: 31,
      completedOrders: 24,
      categories: ['Transporte', 'Logística'],
      address: 'Zona Industrial Norte, Alajuela',
    ),
    const SupplierEntity(
      id: 'sup-003',
      name: 'Proveedores del Valle',
      contactName: 'Jorge Ureña',
      email: 'j.urena@provvalle.com',
      phone: '+506 8822-9012',
      status: SupplierStatus.active,
      complianceScore: 95,
      totalOrders: 27,
      completedOrders: 26,
      categories: ['Limpieza', 'Suministros'],
      address: 'Cartago Centro, Cartago',
    ),
    const SupplierEntity(
      id: 'sup-004',
      name: 'Tech Supply Group',
      contactName: 'Ana Vargas',
      email: 'a.vargas@techsupply.cr',
      phone: '+506 8833-3456',
      status: SupplierStatus.active,
      complianceScore: 91,
      totalOrders: 18,
      completedOrders: 17,
      categories: ['Electrónico', 'Mantenimiento'],
      address: 'Escazú Business Park, San José',
    ),
    const SupplierEntity(
      id: 'sup-005',
      name: 'Maquinaria Industrial CR',
      contactName: 'Luis Fallas',
      email: 'l.fallas@maqindustrial.cr',
      phone: '+506 8844-7890',
      status: SupplierStatus.active,
      complianceScore: 84,
      totalOrders: 15,
      completedOrders: 13,
      categories: ['Maquinaria', 'Reparaciones'],
      address: 'Parque Industrial Zeta, Heredia',
    ),
    const SupplierEntity(
      id: 'sup-006',
      name: 'Ferretería Central',
      contactName: 'Sandra Mora',
      email: 's.mora@ferrecentral.com',
      phone: '+506 8855-2345',
      status: SupplierStatus.active,
      complianceScore: 79,
      totalOrders: 22,
      completedOrders: 18,
      categories: ['Construcción', 'Ferretería'],
      address: 'Centro Comercial, Desamparados',
    ),
    const SupplierEntity(
      id: 'sup-007',
      name: 'Agro Proveedores',
      contactName: 'Pedro Jiménez',
      email: 'p.jimenez@agroprov.cr',
      phone: '+506 8866-6789',
      status: SupplierStatus.suspended,
      complianceScore: 61,
      totalOrders: 12,
      completedOrders: 8,
      categories: ['Agrícola', 'Insumos'],
      address: 'Pérez Zeledón, San José',
    ),
  ];

  SupplierEntity? getSupplierById(String id) {
    try {
      return getSuppliers().firstWhere((s) => s.id == id);
    } catch (_) {
      return null;
    }
  }

  List<IncidentEntity> getIncidentsForOrder(String orderId) =>
      getIncidents().where((i) => i.orderId == orderId).toList();

  List<OrderEntity> getOrdersForSupplier(String supplierId) =>
      getOrders().where((o) => o.supplierId == supplierId).toList();

  DateTime _dayOnly(DateTime d) => DateTime(d.year, d.month, d.day);
}

enum CalendarEventType { delivery, visit, meeting, milestone }

extension CalendarEventTypeX on CalendarEventType {
  String get label => switch (this) {
    CalendarEventType.delivery => 'Entrega',
    CalendarEventType.visit => 'Visita',
    CalendarEventType.meeting => 'Reunión',
    CalendarEventType.milestone => 'Hito',
  };
}

class CalendarEvent {
  final String title;
  final CalendarEventType type;

  const CalendarEvent({required this.title, required this.type});
}
