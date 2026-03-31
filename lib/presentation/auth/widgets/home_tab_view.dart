import 'package:flutter/material.dart';

// --- IMPORTACIONES CORREGIDAS (Rutas reales de tu proyecto) ---
import 'hcard.dart'; // Como están en la misma carpeta, usamos rutas relativas
import 'vcard.dart';
import 'package:sistema_proveedores_client/core/models/courses.dart';
import 'package:sistema_proveedores_client/core/theme.dart';

class HomeTabView extends StatefulWidget {
  const HomeTabView({Key? key}) : super(key: key);

  @override
  State<HomeTabView> createState() => _HomeTabViewState();
}

class _HomeTabViewState extends State<HomeTabView> {
  // Obtenemos los datos de los modelos que corregimos antes
  final List<CourseModel> _courses = CourseModel.courses;
  final List<CourseModel> _courseSections = CourseModel.courseSections;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, // Para que se vea el fondo animado
      body: Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          color: RiveAppTheme.background,
          borderRadius: BorderRadius.circular(30),
        ),
        child: SingleChildScrollView(
          // Ajustamos el padding para que el contenido no choque con el header ni el tabbar
          padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 60,
              bottom: MediaQuery.of(context).padding.bottom + 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "Proveedores",
                  style: TextStyle(
                    fontSize: 34,
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              // Carrusel Horizontal (VCard)
              SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 20),
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _courses
                      .map(
                        (course) => Padding(
                          key: course.id,
                          padding: const EdgeInsets.all(10),
                          child: VCard(course: course),
                        ),
                      )
                      .toList(),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
                child: Text(
                  "Recientes",
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ),
              // Grid de tarjetas horizontales (HCard)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Wrap(
                  children: List.generate(
                    _courseSections.length,
                    (index) => Container(
                      key: _courseSections[index].id,
                      // Si la pantalla es grande (Tablet/Web), muestra 2 columnas
                      width: MediaQuery.of(context).size.width > 992
                          ? ((MediaQuery.of(context).size.width - 20) / 2)
                          : MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 20),
                      child: HCard(section: _courseSections[index]),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
