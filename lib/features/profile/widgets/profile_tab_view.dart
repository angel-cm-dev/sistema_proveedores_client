import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart'; // IMPORTANTE AÑADIR

import 'package:sistema_proveedores_client/features/auth/providers/auth_provider.dart';
import 'expandable_profile_card.dart';
import '../screens/two_factor_auth_screen.dart';
import '../screens/contact_info_screen.dart';
import '../screens/edit_specialties_screen.dart';
import '../screens/access_history_screen.dart';
import '../screens/change_password_screen.dart';

class ProfileTabView extends StatefulWidget {
  const ProfileTabView({super.key});

  @override
  State<ProfileTabView> createState() => _ProfileTabViewState();
}

class _ProfileTabViewState extends State<ProfileTabView> {
  File? _profileImage;
  final ImagePicker _picker = ImagePicker();

  // ==========================================
  // LÓGICA DE FOTO Y SESIÓN
  // ==========================================

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 80, // Comprime la imagen para rendimiento
      );

      if (pickedFile != null) {
        setState(() {
          _profileImage = File(pickedFile.path);
        });
        // Aquí deberías llamar a tu API para subir la foto al servidor
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Foto actualizada exitosamente'),
                backgroundColor: Colors.green),
          );
        }
      }
    } catch (e) {
      debugPrint("Error al seleccionar imagen: $e");
    }
  }

  void _showImagePickerActionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            const Padding(
              padding: EdgeInsets.all(20),
              child: Text("Actualizar foto de perfil",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            ListTile(
              leading: const Icon(CupertinoIcons.camera),
              title: const Text('Tomar foto'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(CupertinoIcons.photo),
              title: const Text('Elegir de la galería'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _showLogoutConfirmation(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext ctx) {
        return CupertinoAlertDialog(
          title: const Text("Cerrar Sesión"),
          content: const Text(
              "¿Estás seguro de que deseas salir de tu cuenta de Connexa?"),
          actions: [
            CupertinoDialogAction(
              child:
                  const Text("Cancelar", style: TextStyle(color: Colors.blue)),
              onPressed: () => Navigator.of(ctx).pop(),
            ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              child: const Text("Salir"),
              onPressed: () {
                Navigator.of(ctx).pop(); // Cierra el modal

                // LLAMADA REAL A TU AUTH PROVIDER
                // Si tu AuthProvider tiene un método logout, llámalo aquí.
                // context.read<AuthProvider>().logout();

                // Si tienes un enrutador (Ej: GoRouter o Navigator normal), te rediriges al login
                // Navigator.of(context).pushReplacementNamed('/login');

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text("Sesión cerrada. Redirigiendo..."),
                      backgroundColor: Colors.redAccent),
                );
              },
            ),
          ],
        );
      },
    );
  }

  // ==========================================
  // UI DEL WIDGET
  // ==========================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildProfileHeader(context),
          _buildProfileBody(context),
          const SliverToBoxAdapter(child: SizedBox(height: 120)),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    final userData = context.select<AuthProvider, (String, String)>((auth) => (
          auth.user?.fullName ?? "Angel Castañeda",
          auth.user?.suscripcionTipo ?? "Free"
        ));

    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + 60,
          bottom: 32,
        ),
        child: Column(
          children: [
            _buildAvatarStack(context),
            const SizedBox(height: 20),
            Text(
              userData.$1,
              style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Poppins",
                  letterSpacing: -0.5),
            ),
            const SizedBox(height: 4),
            Text(
              "Ingeniero de Sistemas", // Aquí puedes poner el rol que venga del AuthProvider
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.black.withValues(alpha: 0.4),
                  fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatarStack(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 30,
                  offset: const Offset(0, 15)),
            ],
          ),
          child: CircleAvatar(
            radius: 65,
            backgroundColor: const Color(0xFFF3F4F6),
            // Si el usuario subió una imagen, la mostramos. Si no, mostramos el asset por defecto.
            backgroundImage: _profileImage != null
                ? FileImage(_profileImage!) as ImageProvider
                : const AssetImage(
                    'assets/samples/ui/rive_app/images/avatars/avatar_1.jpg'),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 4,
          child: GestureDetector(
            onTap: () => _showImagePickerActionSheet(context),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFF6792FF),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 3),
                boxShadow: [
                  BoxShadow(
                      color: const Color(0xFF6792FF).withValues(alpha: 0.4),
                      blurRadius: 10,
                      offset: const Offset(0, 4))
                ],
              ),
              child: const Icon(CupertinoIcons.camera_fill,
                  color: Colors.white, size: 20),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileBody(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      sliver: SliverList(
        delegate: SliverChildListDelegate([
          _buildSectionTitle("CONFIGURACIÓN PROFESIONAL"),
          ExpandableProfileCard(
            icon: Icons.badge_outlined,
            title: "Información de Usuario",
            subtitle: "Especialidades, contacto y biografía",
            options: [
              ProfileOption(
                title: "Editar Especialidades",
                onTap: () => Navigator.push(
                    context,
                    CupertinoPageRoute(
                        builder: (context) => const EditSpecialtiesScreen())),
              ),
              ProfileOption(
                  title: "Datos de Contacto",
                  onTap: () {
                    Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (context) => const ContactInfoScreen()));
                  }),
            ],
          ),
          ExpandableProfileCard(
            icon: Icons.lock_person_outlined,
            title: "Seguridad y Acceso",
            subtitle: "Contraseña y doble factor (2FA)",
            options: [
              ProfileOption(
                title: "Cambiar Contraseña",
                onTap: () => Navigator.push(
                  context,
                  CupertinoPageRoute(
                      builder: (context) => const ChangePasswordScreen()),
                ),
              ),
              ProfileOption(
                  title: "Configurar 2FA",
                  onTap: () {
                    Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (context) => const TwoFactorAuthScreen()));
                  }),
              ProfileOption(
                  title: "Historial de Accesos",
                  onTap: () => Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (context) => const AccessHistoryScreen()))),
            ],
          ),
          const SizedBox(height: 24),
          _buildSectionTitle("PREFERENCIAS"),
          ExpandableProfileCard(
            icon: Icons.notifications_none_rounded,
            title: "Notificaciones",
            subtitle: "Alertas de órdenes y proveedores",
            options: [
              ProfileOption(
                  title: "Alertas Push",
                  onTap: () => _navigateTo(context, "Alertas Push")),
              ProfileOption(
                  title: "Resumen Semanal",
                  onTap: () => _navigateTo(context, "Resumen Semanal")),
            ],
          ),
          ExpandableProfileCard(
            icon: Icons.palette_outlined,
            title: "Apariencia",
            subtitle: "Modo oscuro y temas visuales",
            options: [
              ProfileOption(
                  title: "Modo Oscuro (Beta)",
                  onTap: () => _navigateTo(context, "Modo Oscuro")),
              ProfileOption(
                  title: "Personalizar Colores",
                  onTap: () => _navigateTo(context, "Colores")),
            ],
          ),
          const SizedBox(height: 32),
          _buildLogoutButton(context),
        ]),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 16),
      child: Text(
        title,
        style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w800,
            color: Colors.black26,
            letterSpacing: 1.5),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.redAccent.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(24),
      ),
      child: ListTile(
        onTap: () => _showLogoutConfirmation(context),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
        leading: const Icon(Icons.logout_rounded, color: Colors.redAccent),
        title: const Text("Cerrar Sesión",
            style: TextStyle(
                color: Colors.redAccent,
                fontWeight: FontWeight.bold,
                fontSize: 16)),
        trailing:
            const Icon(Icons.chevron_right, color: Colors.redAccent, size: 20),
      ),
    );
  }

  void _navigateTo(BuildContext context, String title) {
    Navigator.push(
      context,
      CupertinoPageRoute(
          builder: (context) => GenericSubProfileScreen(title: title)),
    );
  }
}

// Pantalla de Relleno (Para que crees tus archivos aparte después)
class GenericSubProfileScreen extends StatelessWidget {
  final String title;
  const GenericSubProfileScreen({super.key, required this.title});

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
        title: Text(title,
            style: const TextStyle(
                color: Color(0xFF17203A),
                fontWeight: FontWeight.w800,
                fontSize: 18)),
      ),
      body: Center(
        child: Text("Pantalla de $title\n(Crea un archivo nuevo para esto)",
            textAlign: TextAlign.center),
      ),
    );
  }
}
