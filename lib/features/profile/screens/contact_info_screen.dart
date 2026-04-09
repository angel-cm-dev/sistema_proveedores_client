import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ContactInfoScreen extends StatefulWidget {
  const ContactInfoScreen({super.key});

  @override
  State<ContactInfoScreen> createState() => _ContactInfoScreenState();
}

class _ContactInfoScreenState extends State<ContactInfoScreen> {
  // Clave global para validar todo el formulario de un solo golpe
  final _formKey = GlobalKey<FormState>();

  // Controladores para leer y escribir los datos
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _linkedinController = TextEditingController();

  // Nodos de enfoque para UX fluida (saltar al siguiente campo con el teclado)
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();
  final FocusNode _linkedinFocus = FocusNode();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Simulamos que obtenemos los datos actuales del usuario desde el AuthProvider/API
    _emailController.text = "angel@connexa.pe";
    _phoneController.text = "950105413";
    _linkedinController.text = "linkedin.com/in/angelcastaneda";
  }

  @override
  void dispose() {
    _emailController.dispose();
    _phoneController.dispose();
    _linkedinController.dispose();
    _emailFocus.dispose();
    _phoneFocus.dispose();
    _linkedinFocus.dispose();
    super.dispose();
  }

  // ==========================================
  // LÓGICA DE VALIDACIÓN Y GUARDADO
  // ==========================================

  void _saveContactInfo() {
    // 1. Cierra el teclado
    FocusScope.of(context).unfocus();

    // 2. Ejecuta todas las validaciones de los TextFormField
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      // 3. Simula la petición a tu API (Ej. PUT /api/user/contact)
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() => _isLoading = false);

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Datos de contacto actualizados correctamente"),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
            ),
          );

          Navigator.pop(context); // Regresa al perfil
        }
      });
    } else {
      // UX: Feedback visual si hay errores
      HapticFeedback.heavyImpact();
    }
  }

  // ==========================================
  // UI DEL WIDGET
  // ==========================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: Color(0xFF17203A), size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Datos de Contacto",
          style: TextStyle(
              color: Color(0xFF17203A),
              fontWeight: FontWeight.w800,
              fontSize: 18),
        ),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey, // Envolvemos todo en el Form
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Mantén tu información actualizada para que proveedores y clientes puedan comunicarse contigo sin problemas.",
                  style: TextStyle(
                      color: Colors.black54, fontSize: 14, height: 1.5),
                ),
                const SizedBox(height: 32),

                // CAMPO: CORREO ELECTRÓNICO
                _buildInputLabel("Correo Electrónico (Corporativo)"),
                TextFormField(
                  controller: _emailController,
                  focusNode: _emailFocus,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) =>
                      FocusScope.of(context).requestFocus(_phoneFocus),
                  decoration: _buildInputDecoration(
                      CupertinoIcons.mail, "ejemplo@empresa.com"),
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return "El correo es obligatorio";
                    // Expresión Regular Senior para validar emails
                    final emailRegex =
                        RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                    if (!emailRegex.hasMatch(value))
                      return "Ingresa un correo válido";
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                // CAMPO: TELÉFONO
                _buildInputLabel("Número de Teléfono / WhatsApp"),
                TextFormField(
                  controller: _phoneController,
                  focusNode: _phoneFocus,
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) =>
                      FocusScope.of(context).requestFocus(_linkedinFocus),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly
                  ], // Solo números
                  decoration:
                      _buildInputDecoration(CupertinoIcons.phone, "999 999 999")
                          .copyWith(
                    prefixIcon: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text("🇵🇪 +51",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16)),
                          const SizedBox(width: 8),
                          Container(
                              width: 1, height: 24, color: Colors.black12),
                        ],
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return "El teléfono es obligatorio";
                    if (value.length < 9)
                      return "Debe tener al menos 9 dígitos";
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                // CAMPO: LINKEDIN (Opcional)
                _buildInputLabel("Perfil de LinkedIn (Opcional)"),
                TextFormField(
                  controller: _linkedinController,
                  focusNode: _linkedinFocus,
                  keyboardType: TextInputType.url,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _saveContactInfo(),
                  decoration: _buildInputDecoration(
                      CupertinoIcons.link, "linkedin.com/in/tu-perfil"),
                ),
                const SizedBox(height: 40),

                // BOTÓN DE GUARDAR
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6792FF),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      elevation: _isLoading ? 0 : 4,
                      shadowColor:
                          const Color(0xFF6792FF).withValues(alpha: 0.4),
                    ),
                    onPressed: _isLoading ? null : _saveContactInfo,
                    child: _isLoading
                        ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                                color: Colors.white, strokeWidth: 3))
                        : const Text("Guardar Cambios",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helpers para mantener limpio el método build
  Widget _buildInputLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Text(
        label,
        style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF17203A),
            fontSize: 13),
      ),
    );
  }

  InputDecoration _buildInputDecoration(IconData icon, String hint) {
    return InputDecoration(
      filled: true,
      fillColor: Colors.white,
      hintText: hint,
      hintStyle: TextStyle(color: Colors.black.withValues(alpha: 0.2)),
      prefixIcon: Icon(icon,
          color: const Color(0xFF6792FF).withValues(alpha: 0.5), size: 20),
      contentPadding: const EdgeInsets.symmetric(vertical: 18),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFF6792FF), width: 2)),
      errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1.5)),
      focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.redAccent, width: 2)),
    );
  }
}
