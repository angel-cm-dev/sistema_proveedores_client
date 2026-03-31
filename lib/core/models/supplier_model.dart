import 'package:flutter/material.dart';

class SupplierModel {
  final int id;
  final String nombre;
  final String contacto;
  final String email;
  final String ubicacion;
  final String descripcion;
  final Color color;
  final String image;

  SupplierModel({
    required this.id,
    required this.nombre,
    required this.contacto,
    required this.email,
    required this.ubicacion,
    required this.descripcion,
    required this.color,
    required this.image,
  });

  static List<SupplierModel> suppliers = [
    SupplierModel(
      id: 1,
      nombre: "TechLogistics S.A.",
      contacto: "Angel Castañeda",
      email: "ventas@techlog.pe",
      ubicacion: "Lima, Perú",
      descripcion: "Líder en componentes de red y servidores.",
      color: const Color(0xFF6792FF),
      image: "assets/samples/ui/rive_app/images/topics/topic_1.png",
    ),
    SupplierModel(
      id: 2,
      nombre: "Connexa Solutions",
      contacto: "Roberto Pérez",
      email: "rperez@connexa.com",
      ubicacion: "Arequipa, Perú",
      descripcion: "Especialistas en soluciones de software B2B.",
      color: const Color(0xFFF77D8E),
      image: "assets/samples/ui/rive_app/images/topics/topic_2.png",
    ),
    SupplierModel(
      id: 3,
      nombre: "ElectroSuministros",
      contacto: "Lucía Fernández",
      email: "info@esum.pe",
      ubicacion: "Trujillo, Perú",
      descripcion: "Distribuidora mayorista de material eléctrico.",
      color: const Color(0xFF7850F0),
      image: "assets/samples/ui/rive_app/images/topics/topic_1.png",
    ),
    SupplierModel(
      id: 4,
      nombre: "Network Global",
      contacto: "Carlos Sánchez",
      email: "carlos@network.global",
      ubicacion: "Piura, Perú",
      descripcion: "Proveedores de infraestructura de telecomunicaciones.",
      color: const Color(0xFFBBA6FF),
      image: "assets/samples/ui/rive_app/images/topics/topic_2.png",
    ),
  ];
}
