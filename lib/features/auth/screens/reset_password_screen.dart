import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart' hide Image;
import '../../../core/assets.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passController = TextEditingController();
  final _confirmPassController = TextEditingController();
  bool _isObscure = true;

  void _handleReset() {
    if (_formKey.currentState!.validate()) {
      // Lógica de actualización en DB vía Laravel
      _showSuccessDialog();
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Icon(Icons.check_circle_outline,
            color: Colors.green, size: 64),
        content: const Text(
            "Contraseña actualizada con éxito. Ya puedes iniciar sesión.",
            textAlign: TextAlign.center),
        actions: [
          TextButton(
            onPressed: () =>
                Navigator.of(context).popUntil((route) => route.isFirst),
            child: const Text("ENTENDIDO",
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Color(0xFFF77D8E))),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const Positioned.fill(
              child: RiveAnimation.asset(RiveAssets.shapes, fit: BoxFit.cover)),
          Positioned.fill(
              child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                  child: Container(color: Colors.black12))),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: _buildCard(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(40),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            const Text("Nueva Contraseña",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 32),
            _buildPasswordField(_passController, "Contraseña"),
            const SizedBox(height: 16),
            _buildPasswordField(_confirmPassController, "Confirmar Contraseña",
                isConfirm: true),
            const SizedBox(height: 32),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordField(TextEditingController controller, String label,
      {bool isConfirm = false}) {
    return TextFormField(
      controller: controller,
      obscureText: _isObscure,
      decoration: InputDecoration(
        labelText: label,
        suffixIcon: IconButton(
            icon: Icon(_isObscure ? Icons.visibility : Icons.visibility_off),
            onPressed: () => setState(() => _isObscure = !_isObscure)),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
      ),
      validator: (v) {
        if (v == null || v.length < 6) return "Mínimo 6 caracteres";
        if (isConfirm && v != _passController.text) return "No coinciden";
        return null;
      },
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _handleReset,
        style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFF77D8E),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16))),
        child: const Text("Cambiar Contraseña",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
