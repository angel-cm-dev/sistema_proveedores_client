import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controladores
  final _currentPassController = TextEditingController();
  final _newPassController = TextEditingController();
  final _confirmPassController = TextEditingController();

  // Nodos de Foco
  final _currentFocus = FocusNode();
  final _newFocus = FocusNode();
  final _confirmFocus = FocusNode();

  // Estados de Visibilidad
  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;
  bool _isLoading = false;

  // Estados de Validación en tiempo real
  bool _hasMinLength = false;
  bool _hasUppercase = false;
  bool _hasDigits = false;
  bool _hasSpecialChar = false;

  @override
  void initState() {
    super.initState();
    _newPassController.addListener(_validatePassword);
  }

  @override
  void dispose() {
    _newPassController.removeListener(_validatePassword);
    [_currentPassController, _newPassController, _confirmPassController]
        .forEach((c) => c.dispose());
    [_currentFocus, _newFocus, _confirmFocus].forEach((f) => f.dispose());
    super.dispose();
  }

  void _validatePassword() {
    final text = _newPassController.text;
    setState(() {
      _hasMinLength = text.length >= 8;
      _hasUppercase = text.contains(RegExp(r'[A-Z]'));
      _hasDigits = text.contains(RegExp(r'[0-9]'));
      _hasSpecialChar = text.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
    });
  }

  double get _strengthLevel {
    int score = 0;
    if (_hasMinLength) score++;
    if (_hasUppercase) score++;
    if (_hasDigits) score++;
    if (_hasSpecialChar) score++;
    return score / 4;
  }

  Future<void> _processSubmit() async {
    // 1. Cerrar teclado
    FocusScope.of(context).unfocus();

    // 2. Validar similitud con la actual
    if (_currentPassController.text == _newPassController.text) {
      _showFeedback(
          "La nueva contraseña no puede ser igual a la actual", Colors.orange);
      return;
    }

    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        // Simulación de llamada a API de Connexa
        await Future.delayed(const Duration(seconds: 2));

        if (mounted) {
          _showFeedback("¡Contraseña actualizada con éxito!", Colors.green);
          Navigator.pop(context);
        }
      } catch (e) {
        _showFeedback("Error: Verifica tu contraseña actual", Colors.redAccent);
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    } else {
      HapticFeedback.lightImpact();
    }
  }

  void _showFeedback(String msg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg, style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: _buildAppBar(),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionHeader(),
                const SizedBox(height: 32),

                // CAMPO 1: ACTUAL
                _buildLabel("Contraseña Actual"),
                _buildField(
                  controller: _currentPassController,
                  focusNode: _currentFocus,
                  nextFocus: _newFocus,
                  obscure: _obscureCurrent,
                  onToggle: () =>
                      setState(() => _obscureCurrent = !_obscureCurrent),
                  hint: "Escribe tu clave actual",
                ),

                const SizedBox(height: 24),

                // CAMPO 2: NUEVA
                _buildLabel("Nueva Contraseña"),
                _buildField(
                  controller: _newPassController,
                  focusNode: _newFocus,
                  nextFocus: _confirmFocus,
                  obscure: _obscureNew,
                  onToggle: () => setState(() => _obscureNew = !_obscureNew),
                  hint: "Crea una clave segura",
                  validator: (v) => _strengthLevel < 1.0
                      ? "La clave no cumple los requisitos"
                      : null,
                ),

                // INDICADOR DE FORTALEZA ANIMADO
                _buildStrengthBar(),
                const SizedBox(height: 16),

                // CHECKLIST DE REQUISITOS
                _buildRequirementsChecklist(),

                const SizedBox(height: 24),

                // CAMPO 3: CONFIRMAR
                _buildLabel("Confirmar Nueva Contraseña"),
                _buildField(
                  controller: _confirmPassController,
                  focusNode: _confirmFocus,
                  obscure: _obscureConfirm,
                  onToggle: () =>
                      setState(() => _obscureConfirm = !_obscureConfirm),
                  hint: "Repite tu nueva clave",
                  onSubmitted: (_) => _processSubmit(),
                  validator: (v) => v != _newPassController.text
                      ? "Las contraseñas no coinciden"
                      : null,
                ),

                const SizedBox(height: 48),
                _buildSubmitButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- COMPONENTES DE UI ---

  PreferredSizeWidget _buildAppBar() => AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: Color(0xFF17203A), size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Seguridad y Acceso",
            style: TextStyle(
                color: Color(0xFF17203A),
                fontWeight: FontWeight.w800,
                fontSize: 17)),
      );

  Widget _buildSectionHeader() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Crea una nueva contraseña",
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF17203A),
                  letterSpacing: -0.5)),
          const SizedBox(height: 8),
          Text(
              "Tu seguridad es nuestra prioridad. Asegúrate de que nadie más use esta clave.",
              style: TextStyle(
                  color: Colors.black.withOpacity(0.4),
                  fontSize: 14,
                  height: 1.4)),
        ],
      );

  Widget _buildLabel(String text) => Padding(
        padding: const EdgeInsets.only(left: 4, bottom: 8),
        child: Text(text,
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: Color(0xFF17203A))),
      );

  Widget _buildField({
    required TextEditingController controller,
    required FocusNode focusNode,
    FocusNode? nextFocus,
    required bool obscure,
    required VoidCallback onToggle,
    required String hint,
    String? Function(String?)? validator,
    void Function(String)? onSubmitted,
  }) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      obscureText: obscure,
      textInputAction:
          nextFocus != null ? TextInputAction.next : TextInputAction.done,
      onFieldSubmitted:
          onSubmitted ?? (v) => FocusScope.of(context).requestFocus(nextFocus),
      validator: validator ?? (v) => v!.isEmpty ? "Campo obligatorio" : null,
      cursorColor: const Color(0xFF6792FF),
      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: hint,
        hintStyle: TextStyle(
            color: Colors.black.withOpacity(0.15),
            fontWeight: FontWeight.normal),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFF6792FF), width: 2)),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Colors.redAccent, width: 1)),
        suffixIcon: IconButton(
          icon: Icon(
              obscure ? CupertinoIcons.eye_slash_fill : CupertinoIcons.eye_fill,
              color: const Color(0xFF6792FF).withOpacity(0.4),
              size: 20),
          onPressed: onToggle,
        ),
      ),
    );
  }

  Widget _buildStrengthBar() => Padding(
        padding: const EdgeInsets.only(top: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: 6,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(10)),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: _strengthLevel,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: LinearGradient(colors: _strengthColors),
                  ),
                ),
              ),
            ),
          ],
        ),
      );

  List<Color> get _strengthColors {
    if (_strengthLevel <= 0.25) return [Colors.red, Colors.redAccent];
    if (_strengthLevel <= 0.5) return [Colors.orange, Colors.orangeAccent];
    if (_strengthLevel <= 0.75) return [Colors.blue, Colors.blueAccent];
    return [Colors.green, Colors.greenAccent];
  }

  Widget _buildRequirementsChecklist() {
    return Column(
      children: [
        _checkRow("Mínimo 8 caracteres", _hasMinLength),
        _checkRow("Una letra mayúscula", _hasUppercase),
        _checkRow("Al menos un número", _hasDigits),
        _checkRow("Un carácter especial (!@#\$%)", _hasSpecialChar),
      ],
    );
  }

  Widget _checkRow(String text, bool isMet) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: Icon(
              isMet ? Icons.check_circle_rounded : Icons.circle_outlined,
              key: ValueKey(isMet),
              size: 16,
              color: isMet ? Colors.green : Colors.black12,
            ),
          ),
          const SizedBox(width: 8),
          Text(text,
              style: TextStyle(
                  fontSize: 12,
                  color: isMet ? Colors.black87 : Colors.black26,
                  fontWeight: isMet ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() => SizedBox(
        width: double.infinity,
        height: 58,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF6792FF),
            foregroundColor: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
            elevation: 0,
          ),
          onPressed: _isLoading ? null : _processSubmit,
          child: _isLoading
              ? const CupertinoActivityIndicator(color: Colors.white)
              : const Text("Guardar Cambios",
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
        ),
      );
}
