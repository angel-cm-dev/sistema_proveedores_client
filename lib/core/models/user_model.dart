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

  UserModel({
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

  /// Getters calculados para mejorar el rendimiento en UI
  String get fullName => "$nombre $apellido";
  bool get isPremium => suscripcionTipo.toLowerCase() == 'premium';

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id_usuario'] as int,
      nombre: json['nombre'] as String,
      apellido: json['apellido'] as String,
      email: json['email'] as String,
      telefono: json['telefono'] as String?,
      direccion: json['direccion'] as String?,
      username: json['username'] as String,
      rol: json['rol'] as String,
      suscripcionTipo: json['suscripcion_tipo'] as String,
      suscripcionEstado: json['suscripcion_estado'] as String,
      billingAddress: json['billing_address'] as String?,
    );
  }
}
