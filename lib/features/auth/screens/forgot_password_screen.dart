import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart' hide Image;
import '../../../core/assets.dart';
import 'otp_verification_screen.dart';
import 'reset_password_screen.dart'; // Importante para el flujo final

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  /// Navegación Senior con transición de desvanecimiento
  static Route route() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          const ForgotPasswordScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
      transitionDuration: const Duration(milliseconds: 600),
    );
  }

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  bool _isLoading = false;

  late final AnimationController _appearanceController;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _appearanceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _appearanceController,
      curve: const Interval(0.0, 0.8, curve: Curves.easeIn),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.05),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _appearanceController,
      curve: const Interval(0.0, 1.0, curve: Curves.easeOutCubic),
    ));

    _appearanceController.forward();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _appearanceController.dispose();
    super.dispose();
  }

  /// Manejador de recuperación con flujo de navegación robusto
  void _handleRecovery() async {
    if (!_formKey.currentState!.validate()) {
      HapticFeedback.heavyImpact();
      return;
    }

    setState(() => _isLoading = true);
    HapticFeedback.mediumImpact();

    // Simulación de API (Laravel Backend)
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;
    setState(() => _isLoading = false);

    // Flujo Senior: Pasamos el callback para que el OTP sepa qué hacer al validar
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OtpVerificationScreen(
          phoneNumber: _phoneController.text,
          onSuccess: () {
            // Si el OTP es correcto, lo mandamos a resetear la contraseña
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => const ResetPasswordScreen()),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const brandPink = Color(0xFFF77D8E);
    const primaryDark = Color(0xFF17203A);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // 1. Fondo Rive - Optimizado con RepaintBoundary
          const Positioned.fill(
            child: RepaintBoundary(
              child: RiveAnimation.asset(RiveAssets.shapes, fit: BoxFit.cover),
            ),
          ),

          // 2. CAMBIO CLAVE: Overlay luminoso (Glassmorphism Pro)
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
              child: Container(
                color: Colors.white.withValues(alpha: 0.1),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                _buildBackBtn(context, primaryDark),
                const Spacer(),

                // 3. Card Principal Animado
                SlideTransition(
                  position: _slideAnimation,
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: _buildMainCard(brandPink, primaryDark),
                  ),
                ),
                const Spacer(flex: 2),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackBtn(BuildContext context, Color color) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.8),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                )
              ],
            ),
            child: IconButton(
              onPressed: () {
                HapticFeedback.lightImpact();
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back_ios_new_rounded,
                  color: color, size: 20),
            ),
          ),
        ),
      );

  Widget _buildMainCard(Color brandColor, Color darkColor) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.7), // Más blanco, más limpio
        borderRadius: BorderRadius.circular(40),
        border:
            Border.all(color: Colors.white.withValues(alpha: 0.5), width: 2),
        boxShadow: [
          BoxShadow(
            color: darkColor.withValues(alpha: 0.08),
            blurRadius: 40,
            offset: const Offset(0, 20),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle visual sutil (como el de tu Login)
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: darkColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 25),
            Icon(Icons.lock_reset_rounded, size: 60, color: darkColor),
            const SizedBox(height: 20),
            Text(
              "Recuperar Acceso",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w900,
                color: darkColor,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              "Ingresa tu celular para enviarte un código de seguridad.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: darkColor.withValues(alpha: 0.6),
                fontSize: 14,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 35),
            _buildPhoneInput(darkColor),
            const SizedBox(height: 25),
            _buildSubmitButton(brandColor),
          ],
        ),
      ),
    );
  }

  Widget _buildPhoneInput(Color darkColor) {
    final hintColor = darkColor.withValues(alpha: 0.3);

    return TextFormField(
      controller: _phoneController,
      keyboardType: TextInputType.phone,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(9)
      ],
      validator: (v) => (v == null || v.length < 9) ? "Número inválido" : null,
      style: TextStyle(
          fontSize: 16, color: darkColor, fontWeight: FontWeight.w600),
      decoration: InputDecoration(
        hintText: "Ej. 987 654 321",
        hintStyle: TextStyle(color: hintColor, fontWeight: FontWeight.normal),
        prefixIcon:
            Icon(Icons.phone_android_rounded, color: hintColor, size: 22),
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.9),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide:
              BorderSide(color: darkColor.withValues(alpha: 0.05), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide:
              BorderSide(color: darkColor.withValues(alpha: 0.2), width: 1.5),
        ),
      ),
    );
  }

  Widget _buildSubmitButton(Color color) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _handleRecovery,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          elevation: 0,
          shadowColor: color.withValues(alpha: 0.3),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        ),
        child: _isLoading
            ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                    color: Colors.white, strokeWidth: 2),
              )
            : const Text(
                "ENVIAR CÓDIGO",
                style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 15,
                    letterSpacing: 1.2),
              ),
      ),
    );
  }
}
