import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SocialAuthButtons extends StatelessWidget {
  final VoidCallback? onGoogleTap;
  final VoidCallback? onAppleTap;
  final VoidCallback? onFacebookTap;

  const SocialAuthButtons({
    super.key,
    this.onGoogleTap,
    this.onAppleTap,
    this.onFacebookTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _socialButton(
          iconPath: 'assets/icons/google.png', // Asegúrate de tener los assets
          onTap: onGoogleTap,
          iconData: Icons.g_mobiledata_rounded, // Fallback si no usas imágenes
        ),
        const SizedBox(width: 20),
        _socialButton(
          iconPath: 'assets/icons/apple.png',
          onTap: onAppleTap,
          iconData: Icons.apple_rounded,
        ),
        const SizedBox(width: 20),
        _socialButton(
          iconPath: 'assets/icons/facebook.png',
          onTap: onFacebookTap,
          iconData: Icons.facebook_rounded,
        ),
      ],
    );
  }

  Widget _socialButton({
    String? iconPath,
    required VoidCallback? onTap,
    required IconData iconData,
  }) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact(); // Feedback táctil Senior
        onTap?.call();
      },
      child: Container(
        padding: const EdgeInsets.all(15),
        height: 64,
        width: 80,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withValues(alpha: 0.4)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Center(
          child: Icon(
            iconData,
            size: 28,
            color: const Color(0xFF17203A), // Color Navy de tu tema
          ),
        ),
      ),
    );
  }
}
