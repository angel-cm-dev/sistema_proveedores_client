import 'dart:ui';
import 'package:flutter/material.dart';
// Usamos 'hide' para evitar que Rive choque con los Widgets de Flutter
import 'package:rive/rive.dart' hide Image;
import 'package:provider/provider.dart';

import '../../core/auth_provider.dart';
import '../../core/assets.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. Imagen de fondo (Spline)
          Positioned(
            width: MediaQuery.of(context).size.width * 1.7,
            bottom: 200,
            left: 100,
            child: Image.asset(AppImages.spline),
          ),

          // 2. Animación Rive (Shapes)
          const RiveAnimation.asset(RiveAssets.shapes),

          // 3. Efecto Blur (Glassmorphism)
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
              child: const SizedBox(),
            ),
          ),

          // 4. Capa de Texto y Botón
          _buildContent(context),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Spacer(),
            const Text(
              "Sistema de\nProveedores",
              style: TextStyle(
                fontSize: 50,
                fontFamily: "Poppins",
                fontWeight: FontWeight.w700,
                height: 1.2,
              ),
            ),
            const Spacer(flex: 2),
            _buildLoginButton(context),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () =>
          Provider.of<AuthProvider>(context, listen: false).login('client'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 56),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      ),
      child: const Text(
        "Ingresar al Portal",
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      ),
    );
  }
}
