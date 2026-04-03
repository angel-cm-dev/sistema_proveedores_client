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
  late AnimationController _mainController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _mainController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _mainController,
      curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
    );

    // FIX: Se cambió Curves.outBack por Curves.easeOutBack
    _scaleAnimation = CurvedAnimation(
      parent: _mainController,
      curve: const Interval(0.2, 0.7, curve: Curves.easeOutBack),
    );

    _mainController.forward();

    _timer = Timer(const Duration(milliseconds: 3500), _completeLoading);
  }

  void _completeLoading() {
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const SignInScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 800),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _mainController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const brandPink = Color(0xFFF77D8E);
    const darkNavy = Color(0xFF17203A);

    return Scaffold(
      backgroundColor: darkNavy,
      body: Stack(
        alignment: Alignment.center,
        children: [
          const Positioned.fill(
            child: RepaintBoundary(
              child: RiveAnimation.asset(RiveAssets.shapes, fit: BoxFit.cover),
            ),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
              child: Container(color: darkNavy.withOpacity(0.3)),
            ),
          ),
          Center(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "CONNEXA",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 54,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 12.0,
                        fontFamily: "Poppins",
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: 130,
                      height: 130,
                      child: Lottie.asset(
                        'assets/samples/animations/animation_loader.json',
                        fit: BoxFit.contain,
                        delegates: LottieDelegates(
                          values: [
                            ValueDelegate.color(const ['**'],
                                callback: (frameInfo) => brandPink),
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
          ),
          Positioned(
            bottom: 60,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Column(
                children: [
                  const Text(
                    "CONECTANDO TU NEGOCIO",
                    style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                        letterSpacing: 4,
                        fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: 40,
                    height: 3,
                    decoration: BoxDecoration(
                      color: brandPink,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                            color: brandPink.withOpacity(0.5),
                            blurRadius: 8,
                            spreadRadius: 2)
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
