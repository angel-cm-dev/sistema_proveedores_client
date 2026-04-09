import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart'; // Asegúrate de haber ejecutado: flutter pub add qr_flutter

class TwoFactorAuthScreen extends StatefulWidget {
  const TwoFactorAuthScreen({super.key});

  @override
  State<TwoFactorAuthScreen> createState() => _TwoFactorAuthScreenState();
}

class _TwoFactorAuthScreenState extends State<TwoFactorAuthScreen> {
  final TextEditingController _otpController = TextEditingController();
  bool _isVerifying = false;

  // En producción, esta clave secreta la genera el backend (Ej. Laravel/Node)
  final String _secretKey = "JBSWY3DPEHPK3PXP";
  final String _userEmail = "angel@connexa.pe";

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  /// Copia la clave secreta al portapapeles
  void _copySecretKey() {
    Clipboard.setData(ClipboardData(text: _secretKey));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Clave copiada al portapapeles"),
        backgroundColor: Color(0xFF6792FF),
        duration: Duration(seconds: 2),
      ),
    );
  }

  /// Valida el código OTP
  void _verifyCode() {
    if (_otpController.text.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Por favor, ingresa los 6 dígitos."),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    setState(() => _isVerifying = true);

    // Aquí llamarías a tu API (Ej. POST /api/2fa/verify)
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() => _isVerifying = false);

        // Si el código es correcto:
        showCupertinoDialog(
          context: context,
          builder: (context) => CupertinoAlertDialog(
            title: const Text("¡Seguridad Activada!"),
            content: const Text(
                "La autenticación en dos pasos se ha configurado correctamente. Tu cuenta de Connexa ahora está protegida."),
            actions: [
              CupertinoDialogAction(
                child: const Text("Entendido",
                    style: TextStyle(
                        color: Color(0xFF6792FF), fontWeight: FontWeight.bold)),
                onPressed: () {
                  Navigator.pop(context); // Cierra el diálogo
                  Navigator.pop(context); // Regresa al perfil
                },
              )
            ],
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Formato estándar de URI para Google Authenticator / Authy
    final String totpUri =
        "otpauth://totp/Connexa:$_userEmail?secret=$_secretKey&issuer=Connexa";

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
          "Configurar 2FA",
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // HEADER INFO
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF6792FF).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                      color: const Color(0xFF6792FF).withValues(alpha: 0.2)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(CupertinoIcons.shield_lefthalf_fill,
                        color: Color(0xFF6792FF), size: 28),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Protege tu cuenta",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF17203A),
                                  fontSize: 15)),
                          const SizedBox(height: 4),
                          Text(
                            "Añade una capa extra de seguridad vinculando una aplicación de autenticación (como Google Authenticator o Authy).",
                            style: TextStyle(
                                color: const Color(0xFF17203A)
                                    .withValues(alpha: 0.6),
                                fontSize: 13,
                                height: 1.4),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // PASO 1: QR CODE REAL
              const Text("1. Escanea el código QR",
                  style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                      color: Color(0xFF17203A))),
              const SizedBox(height: 8),
              Text(
                  "Abre tu app de autenticación y escanea este código. Si no puedes escanearlo, copia la clave manual.",
                  style: TextStyle(
                      color: const Color(0xFF17203A).withValues(alpha: 0.5),
                      fontSize: 13)),
              const SizedBox(height: 24),

              Center(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 20,
                          offset: const Offset(0, 10))
                    ],
                  ),
                  child: Column(
                    children: [
                      // CÓDIGO QR GENERADO DINÁMICAMENTE
                      QrImageView(
                        data: totpUri,
                        version: QrVersions.auto,
                        size: 160.0,
                        backgroundColor: Colors.white,
                        errorCorrectionLevel: QrErrorCorrectLevel.Q,
                      ),
                      const SizedBox(height: 16),
                      // BOTÓN COPIAR CLAVE
                      OutlinedButton.icon(
                        onPressed: _copySecretKey,
                        icon: const Icon(CupertinoIcons.doc_on_clipboard,
                            size: 16),
                        label: const Text("Copiar clave manual"),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF6792FF),
                          side: const BorderSide(color: Color(0xFF6792FF)),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // PASO 2: INGRESAR CÓDIGO
              const Text("2. Ingresa el código generado",
                  style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                      color: Color(0xFF17203A))),
              const SizedBox(height: 16),

              // INPUT OTP ESTILIZADO
              TextField(
                controller: _otpController,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                maxLength: 6,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 16,
                    color: Color(0xFF6792FF)),
                decoration: InputDecoration(
                  counterText: "",
                  filled: true,
                  fillColor: Colors.white,
                  hintText: "000000",
                  hintStyle: TextStyle(
                      color: Colors.black.withValues(alpha: 0.1),
                      letterSpacing: 16),
                  contentPadding: const EdgeInsets.symmetric(vertical: 20),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide:
                        const BorderSide(color: Color(0xFF6792FF), width: 2),
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // BOTÓN DE VERIFICACIÓN
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6792FF),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    elevation: _isVerifying ? 0 : 4,
                    shadowColor: const Color(0xFF6792FF).withValues(alpha: 0.4),
                  ),
                  onPressed: _isVerifying ? null : _verifyCode,
                  child: _isVerifying
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 3),
                        )
                      : const Text("Verificar y Activar",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16)),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
