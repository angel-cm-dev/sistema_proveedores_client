import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

// --- CORE (Lógica de Autenticación) ---
import '../providers/auth_provider.dart';

// --- PRESENTATION ---
import '../screens/sign_up_screen.dart';
import 'package:sistema_proveedores_client/features/auth/screens/forgot_password_screen.dart';
import 'social_auth_buttons.dart';

class SignInForm extends StatefulWidget {
  const SignInForm({super.key});

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final _formKey = GlobalKey<FormState>();

  // Controladores robustos
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isObscure = true;

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// Validación Senior: 9 dígitos empezando por 9 (Estándar Perú)
  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) return 'El número es obligatorio';
    if (!RegExp(r'^9\d{8}$').hasMatch(value)) return 'Ingresa un número válido';
    return null;
  }

  /// Manejador de Login Social (Feedback táctil e integración)
  void _handleSocialAuth(String platform) {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Conectando con $platform..."),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 1),
      ),
    );
    // Aquí invocarías: auth.signInWithSocial(platform);
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min, // Compactación para evitar scroll
        children: [
          const SizedBox(height: 10),
          const Text(
            "¡Bienvenido!",
            style: TextStyle(
              fontSize: 32,
              fontFamily: "Poppins",
              fontWeight: FontWeight.bold,
              color: Color(0xFF17203A),
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            "Inicia sesión en Connexa para continuar.",
            style: TextStyle(
                color: Colors.black54, fontFamily: "Inter", fontSize: 14),
          ),

          const SizedBox(height: 28), // Espaciado optimizado

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

          const SizedBox(height: 16),

          _buildLabel("Contraseña"),
          _buildInput(
            controller: _passwordController,
            hint: "••••••••••••",
            icon: Icons.lock_outline_rounded,
            isPassword: true,
            obscureText: _isObscure,
            validator: (value) => (value != null && value.length < 6)
                ? 'Mínimo 6 caracteres'
                : null,
            suffix: IconButton(
              icon: Icon(
                _isObscure ? Icons.visibility_off : Icons.visibility,
                size: 20,
                color: Colors.black38,
              ),
              onPressed: () => setState(() => _isObscure = !_isObscure),
            ),
          ),

          _buildForgotPassword(),

          const SizedBox(height: 12),

          _buildSubmitButton(auth),

          const SizedBox(height: 10),
          _buildBypassSection(auth),

          const SizedBox(height: 16),
          _buildDivider(),
          const SizedBox(height: 16),

          // BOTONES SOCIALES CON CALLBACKS ACTIVOS
          SocialAuthButtons(
            onGoogleTap: () => _handleSocialAuth("Google"),
            onAppleTap: () => _handleSocialAuth("Apple"),
            onFacebookTap: () => _handleSocialAuth("Facebook"),
          ),

          const SizedBox(height: 20),
          _buildFooter(),
        ],
      ),
    );
  }

  // ==========================================
  // COMPONENTES PRIVADOS (CLEAN ARCHITECTURE)
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
                fontSize: 14)),
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
      style: const TextStyle(color: Colors.black87, fontSize: 16),
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
        contentPadding:
            const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
      ),
    );
  }

  Widget _buildForgotPassword() {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap),
        onPressed: () {
          // Retroalimentación háptica sutil para el usuario
          HapticFeedback.lightImpact();

          // Navegación hacia la pantalla de recuperación
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ForgotPasswordScreen(),
            ),
          );
        },
        child: const Text(
          "¿Olvidaste tu contraseña?",
          style: TextStyle(
            color: Color(0xFF17203A),
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
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
                  await auth.login(
                      _phoneController.text, _passwordController.text);
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
            : const Text("Iniciar Sesión",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16)),
      ),
    );
  }

  Widget _buildBypassSection(AuthProvider auth) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton(
            onPressed:
                auth.isLoading ? null : () => auth.entrarComoDemo("Free"),
            child: const Text("DEMO FREE",
                style: TextStyle(
                    color: Colors.black45,
                    fontWeight: FontWeight.bold,
                    fontSize: 11))),
        const Text("|", style: TextStyle(color: Colors.black12)),
        TextButton(
            onPressed:
                auth.isLoading ? null : () => auth.entrarComoDemo("Premium"),
            child: const Text("DEMO PREMIUM",
                style: TextStyle(
                    color: Color(0xFFF77D8E),
                    fontWeight: FontWeight.bold,
                    fontSize: 11))),
      ],
    );
  }

  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(child: Divider(color: Colors.black.withValues(alpha: 0.1))),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text("O continúa con",
              style: TextStyle(color: Colors.black38, fontSize: 11)),
        ),
        Expanded(child: Divider(color: Colors.black.withValues(alpha: 0.1))),
      ],
    );
  }

  Widget _buildFooter() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("¿No tienes una cuenta?",
                style: TextStyle(color: Colors.black54, fontSize: 13)),
            TextButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SignUpScreen()));
              },
              child: const Text("Regístrate",
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
        const SizedBox(height: 8), // Reducido para evitar scroll
      ],
    );
  }
}
