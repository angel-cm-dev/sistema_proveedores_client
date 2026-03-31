import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Importaciones de lógica (Core)
import '../../../core/auth_provider.dart';

// Pantallas y Widgets (Presentation)
import '../screens/sign_up_screen.dart';
import 'social_auth_buttons.dart';

class SignInForm extends StatefulWidget {
  const SignInForm({super.key});

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isObscure = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Obtenemos el estado de carga del provider para deshabilitar botones
    final auth = context.watch<AuthProvider>();

    return Form(
      key: _formKey,
      child: Column(
        children: [
          const SizedBox(height: 10),
          const Text(
            "¡Bienvenido!",
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Color(0xFF17203A),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Inicia sesión en Connexa para continuar.",
            style: TextStyle(color: Colors.black54),
          ),
          const SizedBox(height: 40),

          _buildLabel("Correo Electrónico"),
          _buildInput(
            controller: _emailController,
            hint: "angel@connexa.com",
            icon: Icons.alternate_email,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 24),

          _buildLabel("Contraseña"),
          _buildInput(
            controller: _passwordController,
            hint: "••••••••••••",
            icon: Icons.lock_outline,
            isPassword: true,
            obscureText: _isObscure,
            suffix: IconButton(
              icon: Icon(
                _isObscure ? Icons.visibility_off : Icons.visibility,
                size: 20,
              ),
              onPressed: () => setState(() => _isObscure = !_isObscure),
            ),
          ),

          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {},
              child: const Text(
                "¿Olvidaste tu contraseña?",
                style: TextStyle(color: Color(0xFF17203A), fontSize: 13),
              ),
            ),
          ),

          const SizedBox(height: 24),

          // BOTÓN PRINCIPAL
          _buildSubmitButton(auth),

          const SizedBox(height: 16),

          // --- SECCIÓN DE BYPASS (TESTING FRONTEND) ---
          _buildBypassSection(context),

          const SizedBox(height: 32),
          _buildDivider(),
          const SizedBox(height: 32),
          const SocialAuthButtons(),
          const SizedBox(height: 40),
          _buildFooter(),
        ],
      ),
    );
  }

  // --- COMPONENTES PRIVADOS ROBUSTOS ---

  Widget _buildSubmitButton(AuthProvider auth) => SizedBox(
    width: double.infinity,
    height: 60,
    child: ElevatedButton(
      onPressed: auth.isLoading
          ? null
          : () {
              if (_formKey.currentState!.validate()) {
                // Lógica de login real iría aquí
              }
            },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFF77D8E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        elevation: 0,
      ),
      child: auth.isLoading
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            )
          : const Text(
              "Iniciar Sesión",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 17,
              ),
            ),
    ),
  );

  Widget _buildBypassSection(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      TextButton(
        onPressed: () =>
            context.read<AuthProvider>().entrarComoDemo(SubscriptionLevel.free),
        child: const Text(
          "DEMO FREE",
          style: TextStyle(
            color: Colors.black45,
            fontWeight: FontWeight.bold,
            fontSize: 11,
          ),
        ),
      ),
      const Text("|", style: TextStyle(color: Colors.black12)),
      TextButton(
        onPressed: () => context.read<AuthProvider>().entrarComoDemo(
          SubscriptionLevel.premium,
        ),
        child: const Text(
          "DEMO PREMIUM",
          style: TextStyle(
            color: Color(0xFFF77D8E),
            fontWeight: FontWeight.bold,
            fontSize: 11,
          ),
        ),
      ),
    ],
  );

  Widget _buildLabel(String text) => Align(
    alignment: Alignment.centerLeft,
    child: Text(
      text,
      style: const TextStyle(
        fontWeight: FontWeight.w700,
        color: Colors.black87,
        fontSize: 14,
      ),
    ),
  );

  Widget _buildInput({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isPassword = false,
    bool obscureText = false,
    Widget? suffix,
    TextInputType? keyboardType,
  }) => Padding(
    padding: const EdgeInsets.only(top: 8),
    child: TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.black38, size: 22),
        suffixIcon: suffix,
        hintText: hint,
        hintStyle: TextStyle(color: Colors.black.withOpacity(0.15)),
        filled: true,
        fillColor: Colors.white.withOpacity(0.6),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 16,
        ),
      ),
    ),
  );

  Widget _buildDivider() => Row(
    children: [
      Expanded(child: Divider(color: Colors.black.withOpacity(0.1))),
      const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Text(
          "O continúa con",
          style: TextStyle(color: Colors.black38, fontSize: 12),
        ),
      ),
      Expanded(child: Divider(color: Colors.black.withOpacity(0.1))),
    ],
  );

  Widget _buildFooter() => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      const Text(
        "¿No tienes una cuenta?",
        style: TextStyle(color: Colors.black54),
      ),
      TextButton(
        onPressed: () => Navigator.of(context).push(_createFadeRoute()),
        child: const Text(
          "Regístrate",
          style: TextStyle(
            color: Color(0xFFF77D8E),
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
      ),
    ],
  );

  Route _createFadeRoute() => PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>
        const SignUpScreen(),
    transitionDuration: const Duration(milliseconds: 500),
    transitionsBuilder: (context, animation, secondaryAnimation, child) =>
        FadeTransition(opacity: animation, child: child),
  );
}
