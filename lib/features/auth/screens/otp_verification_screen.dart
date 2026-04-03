import 'dart:async';
import 'dart:ui';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart' hide Image;
import '../../../core/assets.dart';
import '../../../presentation/client/client_dashboard.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String phoneNumber;
  // --- MEJORA SENIOR: Callback para reutilizar la pantalla en Login o Password Reset ---
  final VoidCallback? onSuccess;

  const OtpVerificationScreen({
    super.key,
    required this.phoneNumber,
    this.onSuccess,
  });

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen>
    with SingleTickerProviderStateMixin {
  // --- Lógica de Estado ---
  int _secondsRemaining = 59;
  Timer? _timer; // Cambiado a nullable para manejo seguro
  bool _canResend = false;
  bool _hasError = false;

  // --- Controladores y Focos ---
  final List<TextEditingController> _controllers =
      List.generate(4, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());

  // --- Animación de Shake ---
  late AnimationController _shakeController;

  @override
  void initState() {
    super.initState();
    _startTimer();

    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
  }

  void _startTimer() {
    _timer?.cancel(); // Limpiar cualquier timer previo
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      if (_secondsRemaining == 0) {
        setState(() => _canResend = true);
        _timer?.cancel();
      } else {
        setState(() => _secondsRemaining--);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // CRÍTICO: Evita fugas de memoria
    _shakeController.dispose();
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _triggerErrorFeedback() {
    HapticFeedback.heavyImpact(); // Feedback físico más fuerte para error
    setState(() => _hasError = true);

    _shakeController.forward(from: 0.0);

    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) {
        setState(() => _hasError = false);
        for (var controller in _controllers) {
          controller.clear();
        }
        _focusNodes[0].requestFocus();
      }
    });
  }

  void _verifyOtp() {
    final String otp = _controllers.map((e) => e.text).join();
    if (otp.length == 4) {
      // SIMULACIÓN: Backend Laravel valida el código
      if (otp == "1234") {
        HapticFeedback.mediumImpact();

        // --- LÓGICA DE NAVEGACIÓN REUTILIZABLE ---
        if (widget.onSuccess != null) {
          widget
              .onSuccess!(); // Ejecuta la acción personalizada (ej. ir a Reset Password)
        } else {
          // Por defecto va al Dashboard (Flujo de Login)
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const ClientDashboard()),
            (route) => false,
          );
        }
      } else {
        _triggerErrorFeedback();
      }
    }
  }

  double _getShakeOffset(double animationValue) {
    return sin(animationValue * pi * 4) * 8;
  }

  @override
  Widget build(BuildContext context) {
    const brandPink = Color(0xFFF77D8E);
    const primaryDark = Color(0xFF17203A);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          // 1. Fondo Rive con RepaintBoundary para performance
          const Positioned.fill(
            child: RepaintBoundary(
              child: RiveAnimation.asset(RiveAssets.shapes, fit: BoxFit.cover),
            ),
          ),

          // 2. Overlay Glass luminoso
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
              child: Container(color: Colors.white.withValues(alpha: 0.1)),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                _buildHeader(context, primaryDark),
                const Spacer(),

                // 3. Card con Animación de Shake
                AnimatedBuilder(
                  animation: _shakeController,
                  builder: (context, child) => Transform.translate(
                    offset: Offset(_getShakeOffset(_shakeController.value), 0),
                    child: child,
                  ),
                  child: _buildGlassCard(brandPink, primaryDark),
                ),
                const Spacer(flex: 2),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, Color color) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.8),
              shape: BoxShape.circle,
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

  Widget _buildGlassCard(Color pink, Color navy) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(40),
        border: Border.all(
          color: _hasError
              ? Colors.red.withValues(alpha: 0.5)
              : Colors.white.withValues(alpha: 0.4),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: navy.withValues(alpha: 0.08),
            blurRadius: 40,
            offset: const Offset(0, 20),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Verificación",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w900,
              color: navy,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            "Hemos enviado un código SMS al\n+51 ${widget.phoneNumber}",
            textAlign: TextAlign.center,
            style: const TextStyle(
                color: Colors.black54, fontSize: 14, height: 1.5),
          ),
          const SizedBox(height: 32),

          // FILA DE INPUTS OTP
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children:
                List.generate(4, (index) => _buildOtpField(index, navy, pink)),
          ),

          const SizedBox(height: 32),
          _buildVerifyButton(pink),
          const SizedBox(height: 24),
          _buildResendSection(pink),
        ],
      ),
    );
  }

  Widget _buildOtpField(int index, Color navy, Color pink) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: 56,
      height: 64,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _hasError ? Colors.red : Colors.transparent,
          width: 2,
        ),
      ),
      child: TextFormField(
        controller: _controllers[index],
        focusNode: _focusNodes[index],
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: _hasError ? Colors.red : navy),
        inputFormatters: [
          LengthLimitingTextInputFormatter(1),
          FilteringTextInputFormatter.digitsOnly,
        ],
        decoration: const InputDecoration(border: InputBorder.none),
        onChanged: (value) {
          if (value.isNotEmpty && index < 3) {
            _focusNodes[index + 1].requestFocus();
          } else if (value.isEmpty && index > 0) {
            _focusNodes[index - 1].requestFocus();
          }
          if (value.length == 1 && index == 3) {
            _focusNodes[index].unfocus();
            _verifyOtp();
          }
        },
      ),
    );
  }

  Widget _buildVerifyButton(Color pink) => SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: _verifyOtp,
          style: ElevatedButton.styleFrom(
            backgroundColor: _hasError ? Colors.redAccent : pink,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 0,
          ),
          child: const Text(
            "Verificar Código",
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
      );

  Widget _buildResendSection(Color pink) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("¿No recibiste el código? ",
            style: TextStyle(color: Colors.black54, fontSize: 13)),
        GestureDetector(
          onTap: _canResend
              ? () {
                  setState(() {
                    _secondsRemaining = 59;
                    _canResend = false;
                  });
                  _startTimer();
                }
              : null,
          child: Text(
            _canResend
                ? "Reenviar"
                : "00:${_secondsRemaining.toString().padLeft(2, '0')}",
            style: TextStyle(
              color: _canResend ? pink : Colors.black26,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ),
      ],
    );
  }
}
