import 'package:flutter/material.dart';

class SocialAuthButtons extends StatelessWidget {
  const SocialAuthButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _socialBox(Icons.g_mobiledata, () => debugPrint("Google Auth")),
        _socialBox(Icons.apple, () => debugPrint("Apple Auth")),
        _socialBox(Icons.facebook, () => debugPrint("Facebook Auth")),
      ],
    );
  }

  Widget _socialBox(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        decoration: BoxDecoration(
          // ignore: deprecated_member_use
          color: Colors.white.withOpacity(0.5),
          borderRadius: BorderRadius.circular(16),
          // ignore: deprecated_member_use
          border: Border.all(color: Colors.white.withOpacity(0.2)),
        ),
        child: Icon(icon, size: 30, color: const Color(0xFF17203A)),
      ),
    );
  }
}
