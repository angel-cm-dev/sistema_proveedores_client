import 'package:flutter/material.dart';
// --- IMPORTACIÓN CORREGIDA ---
import 'package:sistema_proveedores_client/core/assets.dart' as app_assets;

class CourseModel {
  CourseModel({
    this.id,
    this.title = "",
    this.subtitle = "",
    this.caption = "",
    this.color = Colors.white,
    this.image = "",
  });

  UniqueKey? id = UniqueKey();
  String title, caption, image;
  String? subtitle;
  Color color;

  // Lista de cursos principales (Tarjetas Verticales - VCard)
  static List<CourseModel> courses = [
    CourseModel(
        title: "Animaciones en SwiftUI",
        subtitle: "Aprende a animar interfaces desde cero",
        caption: "20 secciones - 3 horas",
        color: const Color(0xFF7850F0),
        image: app_assets.AppImages
            .topic1), // Usando la clase AppImages definida en assets.dart
    CourseModel(
        title: "Build Quick Apps",
        subtitle: "Construye aplicaciones reales rápidamente",
        caption: "47 secciones - 11 horas",
        color: const Color(0xFF6792FF),
        image: app_assets.AppImages.topic2),
    CourseModel(
        title: "Diseño para iOS 15",
        subtitle: "Domina los nuevos layouts y gestos",
        caption: "21 secciones - 4 horas",
        color: const Color(0xFF005FE7),
        image: app_assets.AppImages.topic1),
  ];

  // Lista de secciones (Tarjetas Horizontales - HCard)
  static List<CourseModel> courseSections = [
    CourseModel(
        title: "State Machine",
        caption: "Ver video - 15 mins",
        color: const Color(0xFF9CC5FF),
        image: app_assets.AppImages.topic2),
    CourseModel(
        title: "Menú Animado",
        caption: "Ver video - 10 mins",
        color: const Color(0xFF6E6AE8),
        image: app_assets.AppImages.topic1),
    CourseModel(
        title: "Tab Bar Custom",
        caption: "Ver video - 8 mins",
        color: const Color(0xFF005FE7),
        image: app_assets.AppImages.topic2),
    CourseModel(
        title: "Botones Rive",
        caption: "Ver video - 9 mins",
        color: const Color(0xFFBBA6FF),
        image: app_assets.AppImages.topic1),
  ];
}
