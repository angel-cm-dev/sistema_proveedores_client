import 'package:flutter/material.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          const SizedBox(height: 10),
          const Text(
            "Crear Cuenta",
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Color(0xFF17203A),
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Únete a Connexa y gestiona tus pedidos.",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black54),
          ),
          const SizedBox(height: 32),

          _buildLabel("Nombre Completo"),
          _buildInput(hint: "Ej. Angel Castañeda", icon: Icons.person_outline),
          const SizedBox(height: 20),

          _buildLabel("Correo Electrónico"),
          _buildInput(hint: "angel@connexa.com", icon: Icons.alternate_email),
          const SizedBox(height: 20),

          _buildLabel("Contraseña"),
          _buildInput(
            hint: "••••••••••••",
            icon: Icons.lock_outline,
            isPassword: true,
          ),
          const SizedBox(height: 20),

          _buildLabel("Confirmar Contraseña"),
          _buildInput(
            hint: "••••••••••••",
            icon: Icons.shield_outlined,
            isPassword: true,
          ),

          const SizedBox(height: 40),
          _buildSubmitButton(),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

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
    required String hint,
    required IconData icon,
    bool isPassword = false,
  }) => Padding(
    padding: const EdgeInsets.only(top: 8),
    child: TextFormField(
      obscureText: isPassword,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.black38, size: 22),
        hintText: hint,
        // HINT TRANSPARENTE PROFESIONAL
        hintStyle: TextStyle(
          // ignore: deprecated_member_use
          color: Colors.black.withOpacity(0.15),
          fontWeight: FontWeight.w400,
        ),
        filled: true,
        // ignore: deprecated_member_use
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

  Widget _buildSubmitButton() => SizedBox(
    width: double.infinity,
    height: 60,
    child: ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFF77D8E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        elevation: 0,
      ),
      child: const Text(
        "Registrarse",
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 17,
        ),
      ),
    ),
  );
}
