import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Para control del sistema (Status Bar)
import 'package:provider/provider.dart';

// Importaciones de lógica (Core)
import 'features/auth/providers/auth_provider.dart';

// Importaciones de interfaz (Presentation)
import 'presentation/auth_wrapper.dart';

void main() {
  // Aseguramos que los bindings de Flutter estén listos antes de cualquier lógica
  WidgetsFlutterBinding.ensureInitialized();

  // Nivel Senior: Configuramos la barra de estado para que sea transparente
  // y se integre perfectamente con tus animaciones de Rive.
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness:
          Brightness.dark, // Íconos oscuros sobre fondo claro
    ),
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        // Aquí podrás agregar más providers (ej. ProveedoresProvider, PedidosProvider)
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Connexa - Gestión de Proveedores',

      // CONFIGURACIÓN DE TEMA SENIOR
      theme: ThemeData(
        useMaterial3: true,

        // Colores base de la marca Connexa
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF17203A), // Navy principal
          primary: const Color(0xFF17203A),
          secondary: const Color(0xFFF77D8E), // Coral de acento
          surface: const Color(0xFFF2F5FF),
        ),

        // Tipografía Senior: Poppins (Títulos) e Inter (Cuerpo)
        // Nota: Asegúrate de tener estas fuentes en tus pubspec.yaml
        fontFamily: "Poppins",

        textTheme: const TextTheme(
          displayLarge: TextStyle(
            fontWeight: FontWeight.w900,
            color: Color(0xFF17203A),
          ),
          bodyMedium: TextStyle(
            fontFamily: "Inter", // Inter es más legible para textos largos
            color: Color(0xFF4A4A4A),
          ),
          labelLarge: TextStyle(
            fontWeight: FontWeight.w600,
            color: Color(0xFF17203A),
          ),
        ),

        // Estilo global para botones (Opcional, pero recomendado)
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),
      ),

      // El AuthWrapper decide si ir al Login o al Dashboard
      home: const AuthWrapper(),
    );
  }
}
