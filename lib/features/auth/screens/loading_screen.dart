import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:rive/rive.dart' hide Image;
import '../../../core/assets.dart';
import 'sign_in_screen.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen>
    with TickerProviderStateMixin {
  late final AnimationController _animController;
  late final Animation<double> _fadeAnim;
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeIn);
    _animController.forward();

    _timer = Timer(const Duration(milliseconds: 3800), _navigateToLogin);
  }

  void _navigateToLogin() {
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, anim, __) => const SignInScreen(),
        transitionsBuilder: (context, anim, __, child) =>
            FadeTransition(opacity: anim, child: child),
        transitionDuration: const Duration(milliseconds: 800),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const brandPink = Color(0xFFF77D8E);
    const darkNavy = Color(0xFF17203A);

    return Scaffold(
      backgroundColor: darkNavy,
      body: Stack(
        children: [
          // 1. FONDO RIVE (Performance optimizado)
          const Positioned.fill(
            child: RepaintBoundary(
              child: RiveAnimation.asset(RiveAssets.shapes, fit: BoxFit.cover),
            ),
          ),

          // 2. VIDRIO ESMERILADO (Glassmorphism)
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 35, sigmaY: 35),
              child: Container(color: darkNavy.withOpacity(0.4)),
            ),
          ),

          // 3. CONTENIDO CENTRAL (Estructura robusta)
          Center(
            child: FadeTransition(
              opacity: _fadeAnim,
              child: Column(
                mainAxisAlignment:
                    MainAxisAlignment.center, // Centrado vertical
                crossAxisAlignment:
                    CrossAxisAlignment.center, // Centrado horizontal
                children: [
                  // LOGO REDIMENSIONADO
                  const Text(
                    "CONNEXA",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 38, // Tamaño balanceado
                      fontWeight: FontWeight.w900,
                      letterSpacing: 10.0,
                      fontFamily: "Poppins",
                    ),
                  ),

                  const SizedBox(height: 40),

                  // ANIMACIÓN LOTTIE (Centrada y controlada)
                  SizedBox(
                    width: 100, // Más pequeño es más profesional
                    height: 100,
                    child: Lottie.asset(
                      'assets/samples/animations/animation_loader.json',
                      fit: BoxFit.contain,
                      delegates: LottieDelegates(
                        values: [
                          ValueDelegate.color(const ['**'],
                              callback: (_) => brandPink),
                        ],
                      ),
                      errorBuilder: (context, error, stackTrace) =>
                          const CircularProgressIndicator(
                              color: brandPink, strokeWidth: 2),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 4. ESCLOGAN INFERIOR (Fijado al fondo con SafeArea)
          Positioned(
            bottom: 60,
            left: 0,
            right: 0,
            child: FadeTransition(
              opacity: _fadeAnim,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "CONECTANDO TU NEGOCIO",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 12,
                      letterSpacing: 3,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Detalle visual de la marca
                  Container(
                    width: 40,
                    height: 3,
                    decoration: BoxDecoration(
                      color: brandPink,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: brandPink.withOpacity(0.5),
                          blurRadius: 10,
                          offset: const Offset(0, 0),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
