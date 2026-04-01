import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rive/rive.dart' hide Image, LinearGradient;
import '../../../../core/assets.dart';
import '../../../../core/theme/app_theme.dart';

/// First-time onboarding carousel with 3 feature slides.
class OnboardingScreen extends StatefulWidget {
  final VoidCallback onComplete;
  const OnboardingScreen({super.key, required this.onComplete});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _pageCtrl = PageController();
  int _current = 0;

  static const _slides = [
    _SlideData(
      icon: Icons.receipt_long_rounded,
      color: AppColors.primary,
      title: 'Gestión de órdenes',
      subtitle: 'Crea, rastrea y actualiza órdenes en tiempo real. '
          'Mantén el control de cada entrega.',
    ),
    _SlideData(
      icon: Icons.people_alt_rounded,
      color: AppColors.secondary,
      title: 'Red de proveedores',
      subtitle: 'Directorio completo con scoring, cumplimiento SLA y '
          'seguimiento de incidencias por proveedor.',
    ),
    _SlideData(
      icon: Icons.analytics_rounded,
      color: AppColors.success,
      title: 'KPIs en tiempo real',
      subtitle: 'Dashboard ejecutivo con métricas operativas y financieras '
          'para tomar decisiones informadas.',
    ),
  ];

  void _next() {
    if (_current < _slides.length - 1) {
      _pageCtrl.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutCubic,
      );
    } else {
      widget.onComplete();
    }
  }

  @override
  void dispose() {
    _pageCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          const RiveAnimation.asset(RiveAssets.shapes),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
            child: Container(color: Colors.black.withValues(alpha: 0.50)),
          ),
          SafeArea(
            child: Column(
              children: [
                // Skip button
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: GestureDetector(
                      onTap: widget.onComplete,
                      child: Text(
                        'Omitir',
                        style: GoogleFonts.inter(
                          color: Colors.white60,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),

                // Page view
                Expanded(
                  child: PageView.builder(
                    controller: _pageCtrl,
                    itemCount: _slides.length,
                    onPageChanged: (i) => setState(() => _current = i),
                    itemBuilder: (_, i) => _SlideView(data: _slides[i]),
                  ),
                ),

                // Indicators + button
                Padding(
                  padding: const EdgeInsets.fromLTRB(28, 0, 28, 40),
                  child: Column(
                    children: [
                      // Dots
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          _slides.length,
                          (i) => AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: _current == i ? 28 : 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: _current == i
                                  ? AppColors.primary
                                  : Colors.white.withValues(alpha: 0.25),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),

                      // CTA button
                      GestureDetector(
                        onTap: _next,
                        child: Container(
                          width: double.infinity,
                          height: 56,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [AppColors.primary, AppColors.secondary],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withValues(alpha: 0.45),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                _current == _slides.length - 1
                                    ? 'Comenzar'
                                    : 'Siguiente',
                                style: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Icon(
                                _current == _slides.length - 1
                                    ? Icons.check_rounded
                                    : Icons.arrow_forward_rounded,
                                color: Colors.white,
                                size: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Slide data ───────────────────────────────────────────────────────────────

class _SlideData {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  const _SlideData({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
  });
}

// ── Slide view ───────────────────────────────────────────────────────────────

class _SlideView extends StatelessWidget {
  final _SlideData data;
  const _SlideView({required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 36),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon circle
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  data.color.withValues(alpha: 0.25),
                  data.color.withValues(alpha: 0.08),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border.all(
                color: data.color.withValues(alpha: 0.3),
                width: 2,
              ),
            ),
            child: Icon(data.icon, color: data.color, size: 52),
          ),
          const SizedBox(height: 40),

          // Title
          Text(
            data.title,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 16),

          // Subtitle
          Text(
            data.subtitle,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 15,
              color: Colors.white60,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
