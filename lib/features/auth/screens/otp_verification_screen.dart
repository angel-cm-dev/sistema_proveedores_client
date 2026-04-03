import 'dart:async';
import 'dart:ui';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart' hide Image;
import '../../../core/assets.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String phoneNumber;
  const OtpVerificationScreen({super.key, required this.phoneNumber});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen>
    with SingleTickerProviderStateMixin {
  // --- Lógica de Estado ---
  int _secondsRemaining = 59;
  late Timer _timer;
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

    // Configuración de animación de sacudida (0.5 segundos)
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining == 0) {
        setState(() => _canResend = true);
        _timer.cancel();
      } else {
        setState(() => _secondsRemaining--);
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _shakeController.dispose();
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  // --- Lógica Senior de Activación de Error ---
  void _triggerErrorFeedback() {
    HapticFeedback.vibrate(); // Feedback físico
    setState(() => _hasError = true);

    // Iniciar animación de sacudida
    _shakeController.forward(from: 0.0);

    // Resetear el estado de error y limpiar campos tras 1 segundo
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) {
        setState(() => _hasError = false);
        for (var controller in _controllers) {
          controller.clear();
        }
        _focusNodes[0].requestFocus(); // Devolver foco al primer campo
      }
    });
  }

  void _verifyOtp() {
    String otp = _controllers.map((e) => e.text).join();
    if (otp.length == 4) {
      // SIMULACIÓN: Supongamos que el código correcto es "1234"
      if (otp == "1234") {
        HapticFeedback.mediumImpact();
        debugPrint("Código Correcto: $otp");
        // Navegar al Dashboard o Siguiente paso
      } else {
        _triggerErrorFeedback();
      }
    }
  }

  // Helper para la animación de sacudida matemática
  double _getShakeOffset(double animationValue) {
    // Curva de oscilación: 3 ciclos de sacudida
    return sin(animationValue * pi * 4) * 8;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          const Positioned.fill(
            child: RiveAnimation.asset(RiveAssets.shapes, fit: BoxFit.cover),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
              child: Container(color: Colors.black.withValues(alpha: 0.05)),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                _buildHeader(context),
                const Spacer(),
                // Aplicar el efecto de sacudida a todo el Card
                AnimatedBuilder(
                  animation: _shakeController,
                  builder: (context, child) {
                    return Transform.translate(
                      offset:
                          Offset(_getShakeOffset(_shakeController.value), 0),
                      child: child,
                    );
                  },
                  child: _buildGlassCard(size),
                ),
                const Spacer(flex: 2),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Align(
          alignment: Alignment.centerLeft,
          child: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios_new_rounded,
                color: Color(0xFF17203A)),
          ),
        ),
      );

  Widget _buildGlassCard(Size size) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(40),
        border: Border.all(
            color: _hasError
                ? Colors.red.withValues(alpha: 0.5)
                : Colors.white.withValues(alpha: 0.4),
            width: 1.5),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Verificación",
            style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF17203A)),
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
            children: List.generate(4, (index) => _buildOtpField(index)),
          ),

          const SizedBox(height: 32),
          _buildVerifyButton(),
          const SizedBox(height: 24),
          _buildResendSection(),
        ],
      ),
    );
  }

  Widget _buildOtpField(int index) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: 56,
      height: 64,
      decoration: BoxDecoration(
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
            color: _hasError ? Colors.red : const Color(0xFF17203A)),
        inputFormatters: [
          LengthLimitingTextInputFormatter(1),
          FilteringTextInputFormatter.digitsOnly,
        ],
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white.withValues(alpha: 0.8),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                  color: _hasError
                      ? Colors.red.withValues(alpha: 0.3)
                      : Colors.white24)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                  color: _hasError ? Colors.red : const Color(0xFFF77D8E),
                  width: 2)),
        ),
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

  Widget _buildVerifyButton() => SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: _verifyOtp,
          style: ElevatedButton.styleFrom(
            backgroundColor:
                _hasError ? Colors.redAccent : const Color(0xFFF77D8E),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 0,
          ),
          child: const Text("Verificar Código",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16)),
        ),
      );

  Widget _buildResendSection() {
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
              color: _canResend ? const Color(0xFFF77D8E) : Colors.black26,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ),
      ],
    );
  }
}
