import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart' hide Image;
import '../../core/assets.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Usamos un Stack para encimar el fondo, el desenfoque y el contenido
      body: Stack(
        children: [
          // 1. EL FONDO ANIMADO (Ajustado a tus carpetas)
          const RiveAnimation.asset(RiveAssets.shapes),

          // 2. EL EFECTO GLASSMORPHISM (Desenfoque)
          // Senior Tip: Un sigma de 30 da ese toque 'Apple' muy elegante
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
              child: const SizedBox(),
            ),
          ),

          // 3. EL CONTENIDO (UI Mockup)
          const _LoginBody(),
        ],
      ),
    );
  }
}

class _LoginBody extends StatelessWidget {
  const _LoginBody();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Spacer(),
            // Título de alto impacto
            const Text(
              "Gestión de\nProveedores",
              style: TextStyle(
                fontSize: 55,
                fontWeight: FontWeight.w800,
                height: 1.1,
                color: Color(0xFF171717),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "Optimiza tu cadena de suministro con nuestra plataforma inteligente.",
              style: TextStyle(fontSize: 18, color: Colors.black54),
            ),

            const Spacer(flex: 2),

            // Botón Maquetado (Aún sin lógica pesada)
            _buildMockButton(context),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildMockButton(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () {
          // Aquí dispararemos el modal del formulario después
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFF77D8E),
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 56),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.arrow_forward_rounded),
            SizedBox(width: 8),
            Text(
              "COMENZAR",
              style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2),
            ),
          ],
        ),
      ),
    );
  }
}
