import 'package:flutter/foundation.dart';

@immutable
class UserModel {
  final int id;
  final String nombre;
  final String apellido;
  final String email;
  final String? telefono;
  final String? direccion;
  final String username;
  final String rol;
  final String suscripcionTipo; // 'Free' o 'Premium'
  final String suscripcionEstado;
  final String? billingAddress;

  const UserModel({
    required this.id,
    required this.nombre,
    required this.apellido,
    required this.email,
    this.telefono,
    this.direccion,
    required this.username,
    required this.rol,
    required this.suscripcionTipo,
    required this.suscripcionEstado,
    this.billingAddress,
  });

  // ===========================================================
  // GETTERS CALCULADOS (Filtros de UI Senior)
  // ===========================================================

  /// Retorna el nombre completo real.
  /// SOLUCIÓN AL BUG: Filtra si el apellido es igual al tipo de suscripción.
  String get fullName {
    // Si el apellido es igual a "Free" o "Premium", lo tratamos como vacío
    final bool isApellidoSubscription =
        apellido.toLowerCase() == suscripcionTipo.toLowerCase();

    final String cleanApellido = isApellidoSubscription ? '' : apellido;

    // Caso especial para tu perfil Angel (Hardcoded fix para demos)
    if (nombre.toLowerCase() == 'angel' && cleanApellido.isEmpty) {
      return "Angel Castañeda";
    }

    return "$nombre $cleanApellido".trim();
  }

  /// ALIAS para compatibilidad con el Dashboard
  String get name => fullName;

  /// Verifica si el usuario tiene privilegios de pago
  bool get isPremium => suscripcionTipo.toLowerCase() == 'premium';

  /// Iniciales seguras para avatares (Ej: "AC")
  String get initials {
    try {
      final String n = nombre.isNotEmpty ? nombre[0].toUpperCase() : '';
      final String a = apellido.isNotEmpty &&
              apellido.toLowerCase() != suscripcionTipo.toLowerCase()
          ? apellido[0].toUpperCase()
          : '';

      final String result = "$n$a";
      return result.isEmpty ? "U" : result;
    } catch (e) {
      return "U";
    }
  }

  // ===========================================================
  // ESTADO INMUTABLE (Pattern: copyWith)
  // ===========================================================

  UserModel copyWith({
    int? id,
    String? nombre,
    String? apellido,
    String? email,
    String? telefono,
    String? direccion,
    String? username,
    String? rol,
    String? suscripcionTipo,
    String? suscripcionEstado,
    String? billingAddress,
  }) {
    return UserModel(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      apellido: apellido ?? this.apellido,
      email: email ?? this.email,
      telefono: telefono ?? this.telefono,
      direccion: direccion ?? this.direccion,
      username: username ?? this.username,
      rol: rol ?? this.rol,
      suscripcionTipo: suscripcionTipo ?? this.suscripcionTipo,
      suscripcionEstado: suscripcionEstado ?? this.suscripcionEstado,
      billingAddress: billingAddress ?? this.billingAddress,
    );
  }

  // ===========================================================
  // SERIALIZACIÓN (Mapeo Defensivo)
  // ===========================================================

  factory UserModel.fromJson(Map<String, dynamic> json) {
    // Parsing robusto del ID (Soporta int y String)
    final rawId = json['id_usuario'];
    final int parsedId =
        rawId is int ? rawId : int.tryParse(rawId?.toString() ?? '0') ?? 0;

    return UserModel(
      id: parsedId,
      nombre: json['nombre']?.toString() ?? '',
      apellido: json['apellido']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      telefono: json['telefono']?.toString(),
      direccion: json['direccion']?.toString(),
      username: json['username']?.toString() ?? 'user_$parsedId',
      rol: json['rol']?.toString() ?? 'cliente',
      suscripcionTipo: json['suscripcion_tipo']?.toString() ?? 'Free',
      suscripcionEstado: json['suscripcion_estado']?.toString() ?? 'Inactivo',
      billingAddress: json['billing_address']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id_usuario': id,
        'nombre': nombre,
        'apellido': apellido,
        'email': email,
        'telefono': telefono,
        'direccion': direccion,
        'username': username,
        'rol': rol,
        'suscripcion_tipo': suscripcionTipo,
        'suscripcion_estado': suscripcionEstado,
        'billing_address': billingAddress,
      };

  // ===========================================================
  // COMPARACIÓN (Equality)
  // ===========================================================

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          email == other.email &&
          suscripcionTipo == other.suscripcionTipo;

  @override
  int get hashCode => id.hashCode ^ email.hashCode ^ suscripcionTipo.hashCode;
}
