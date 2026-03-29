import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/auth_provider.dart';
import 'presentation/auth_wrapper.dart';

void main() => runApp(
  ChangeNotifierProvider(create: (_) => AuthProvider(), child: const MyApp()),
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sistema de Proveedores',
      theme: ThemeData(
        useMaterial3: true,
        // Definimos Poppins como fuente por defecto para títulos
        fontFamily: "Poppins",
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6792FF),
          background: const Color(0xFFF2F5FF),
        ),
        // Personalizamos el estilo de los textos para toda la app
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF171717),
          ),
          bodyMedium: TextStyle(fontFamily: "Inter", color: Color(0xFF4A4A4A)),
        ),
      ),
      home: const AuthWrapper(),
    );
  }
}
