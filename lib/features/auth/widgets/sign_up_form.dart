import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

// --- CORE ---
import '../providers/auth_provider.dart';
// --- PRESENTATION ---
import '../screens/otp_verification_screen.dart'; // <--- IMPORTANTE: Para navegar al OTP

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passController = TextEditingController();
  final _confirmPassController = TextEditingController();

  bool _isObscure = true;
  bool _isObscureConfirm = true;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _passController.dispose();
    _confirmPassController.dispose();
    super.dispose();
  }

  // ==========================================
  // VALIDACIONES
  // ==========================================

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) return 'El nombre es obligatorio';
    if (value.length < 3) return 'Nombre demasiado corto';
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) return 'El número es obligatorio';
    if (!RegExp(r'^9\d{8}$').hasMatch(value)) return 'Ingresa un número válido';
    return null;
  }

  String? _validateConfirmPass(String? value) {
    if (value != _passController.text) return 'Las contraseñas no coinciden';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Form(
      key: _formKey,
      child: Column(
        children: [
          const SizedBox(height: 5),
          const Text(
            "Crear Cuenta",
            style: TextStyle(
              fontSize: 32,
              fontFamily: "Poppins",
              fontWeight: FontWeight.bold,
              color: Color(0xFF17203A),
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            "Únete a Connexa y gestiona tus proveedores.",
            style: TextStyle(
                color: Colors.black54, fontFamily: "Inter", fontSize: 14),
          ),
          const SizedBox(height: 24), // Espaciado optimizado

          _buildLabel("Nombre Completo"),
          _buildInput(
            controller: _nameController,
            hint: "Ej. Angel Castañeda",
            icon: Icons.person_outline_rounded,
            validator: _validateName,
            keyboardType: TextInputType.name,
          ),
          const SizedBox(height: 12), // Reducido de 16 a 12

          _buildLabel("Número de celular"),
          _buildInput(
            controller: _phoneController,
            hint: "987 654 321",
            icon: Icons.smartphone_rounded,
            keyboardType: TextInputType.phone,
            validator: _validatePhone,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(9),
            ],
          ),
          const SizedBox(height: 12),

          _buildLabel("Contraseña"),
          _buildInput(
            controller: _passController,
            hint: "••••••••••••",
            icon: Icons.lock_outline_rounded,
            isPassword: true,
            obscureText: _isObscure,
            validator: (value) => (value != null && value.length < 6)
                ? 'Mínimo 6 caracteres'
                : null,
            suffix: IconButton(
              icon: Icon(_isObscure ? Icons.visibility_off : Icons.visibility,
                  size: 20, color: Colors.black38),
              onPressed: () => setState(() => _isObscure = !_isObscure),
            ),
          ),
          const SizedBox(height: 12),

          _buildLabel("Confirmar Contraseña"),
          _buildInput(
            controller: _confirmPassController,
            hint: "••••••••••••",
            icon: Icons.shield_outlined,
            isPassword: true,
            obscureText: _isObscureConfirm,
            validator: _validateConfirmPass,
            suffix: IconButton(
              icon: Icon(
                  _isObscureConfirm ? Icons.visibility_off : Icons.visibility,
                  size: 20,
                  color: Colors.black38),
              onPressed: () =>
                  setState(() => _isObscureConfirm = !_isObscureConfirm),
            ),
          ),

          const SizedBox(height: 24),

          _buildSubmitButton(auth),

          const SizedBox(height: 16),
          _buildFooter(),
        ],
      ),
    );
  }

  // ==========================================
  // HELPERS DE DISEÑO (COMPACTOS)
  // ==========================================

  Widget _buildLabel(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 4, bottom: 4),
        child: Text(text,
            style: const TextStyle(
                fontWeight: FontWeight.w700,
                color: Colors.black87,
                fontSize: 13)),
      ),
    );
  }

  Widget _buildInput({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isPassword = false,
    bool obscureText = false,
    Widget? suffix,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      inputFormatters: inputFormatters,
      style: const TextStyle(color: Colors.black87, fontSize: 15),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.black38, size: 22),
        suffixIcon: suffix,
        hintText: hint,
        hintStyle: TextStyle(color: Colors.black.withValues(alpha: 0.2)),
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.6),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none),
        contentPadding: const EdgeInsets.symmetric(
            vertical: 16, horizontal: 16), // Relleno reducido
      ),
    );
  }

  Widget _buildSubmitButton(AuthProvider auth) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: auth.isLoading
            ? null
            : () async {
                if (_formKey.currentState!.validate()) {
                  HapticFeedback.mediumImpact();

                  // 1. Simulación de carga (o llamada real a tu API)
                  // final success = await auth.register(_nameController.text, _phoneController.text, _passController.text);

                  // 2. Navegación al OTP (Para que puedas ver la pantalla que creamos)
                  if (mounted) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OtpVerificationScreen(
                          phoneNumber: _phoneController.text,
                        ),
                      ),
                    );
                  }
                }
              },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFF77D8E),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 0,
        ),
        child: auth.isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                    color: Colors.white, strokeWidth: 2))
            : const Text("Registrarse",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16)),
      ),
    );
  }

  Widget _buildFooter() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("¿Ya tienes una cuenta?",
                style: TextStyle(color: Colors.black54, fontSize: 13)),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Inicia Sesión",
                  style: TextStyle(
                      color: Color(0xFFF77D8E),
                      fontWeight: FontWeight.bold,
                      fontSize: 14)),
            ),
          ],
        ),
        const Text(
          "Versión 1.0 - Connexa",
          style: TextStyle(
              color: Colors.black12,
              fontWeight: FontWeight.w800,
              fontSize: 11,
              letterSpacing: 0.5),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
