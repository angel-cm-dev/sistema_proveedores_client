import 'package:flutter/material.dart';
import 'expandable_profile_card.dart';

class ProfileTabView extends StatelessWidget {
  const ProfileTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Mantenemos la transparencia para ver el fondo animado del Dashboard
      backgroundColor: Colors.transparent,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildProfileHeader(context),
          _buildProfileBody(context),
          // Espaciador final para que el menú flotante no tape el contenido
          const SliverToBoxAdapter(child: SizedBox(height: 120)),
        ],
      ),
    );
  }

  /// Sección de Cabecera: Avatar, Nombre y Rol
  Widget _buildProfileHeader(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + 60,
          bottom: 32,
        ),
        child: Column(
          children: [
            _buildAvatarStack(),
            const SizedBox(height: 20),
            const Text(
              "Angel Castañeda",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                fontFamily: "Poppins",
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "Ingeniero de Sistemas",
              style: TextStyle(
                fontSize: 16,
                color: Colors.black.withValues(alpha: 0.4),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Construye el Avatar con el Asset específico de Rive
  Widget _buildAvatarStack() {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: const CircleAvatar(
        radius: 65,
        backgroundColor: Color(0xFFF3F4F6),
        // RUTA SOLICITADA: assets/samples/ui/rive_app/images/avatars/avatar_1.jpg
        backgroundImage: AssetImage(
          'assets/samples/ui/rive_app/images/avatars/avatar_1.jpg',
        ),
      ),
    );
  }

  /// Sección de Cuerpo: Lista de tarjetas expandibles
  Widget _buildProfileBody(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      sliver: SliverList(
        delegate: SliverChildListDelegate([
          _buildSectionTitle("CONFIGURACIÓN PROFESIONAL"),
          const ExpandableProfileCard(
            icon: Icons.badge_outlined,
            title: "Información de Usuario",
            subtitle: "Especialidades, contacto y biografía",
            options: [
              ProfileOption(title: "Editar Especialidades"),
              ProfileOption(title: "Datos de Contacto"),
              ProfileOption(title: "Portafolio de Proyectos"),
            ],
          ),
          const ExpandableProfileCard(
            icon: Icons.lock_person_outlined,
            title: "Seguridad y Acceso",
            subtitle: "Contraseña y doble factor (2FA)",
            options: [
              ProfileOption(title: "Cambiar Contraseña"),
              ProfileOption(title: "Configurar 2FA"),
              ProfileOption(title: "Historial de Inicios de Sesión"),
            ],
          ),
          const SizedBox(height: 24),
          _buildSectionTitle("PREFERENCIAS"),
          const ExpandableProfileCard(
            icon: Icons.notifications_none_rounded,
            title: "Notificaciones",
            subtitle: "Alertas de órdenes y proveedores",
            options: [
              ProfileOption(title: "Alertas Push"),
              ProfileOption(title: "Resumen Semanal por Email"),
              ProfileOption(title: "Sonidos de Alerta"),
            ],
          ),
          const ExpandableProfileCard(
            icon: Icons.palette_outlined,
            title: "Apariencia",
            subtitle: "Modo oscuro y temas visuales",
            options: [
              ProfileOption(title: "Modo Oscuro (Beta)"),
              ProfileOption(title: "Personalizar Colores"),
            ],
          ),
          const SizedBox(height: 32),
          _buildLogoutButton(context),
        ]),
      ),
    );
  }

  /// Títulos de sección con estilo profesional
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 16),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w800,
          color: Colors.black26,
          letterSpacing: 1.5,
        ),
      ),
    );
  }

  /// Botón de Cierre de Sesión con estilo de alerta
  Widget _buildLogoutButton(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.redAccent.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(24),
      ),
      child: ListTile(
        onTap: () => _handleLogout(context),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
        leading: const Icon(Icons.logout_rounded, color: Colors.redAccent),
        title: const Text(
          "Cerrar Sesión",
          style: TextStyle(
            color: Colors.redAccent,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        trailing:
            const Icon(Icons.chevron_right, color: Colors.redAccent, size: 20),
      ),
    );
  }

  void _handleLogout(BuildContext context) {
    // Aquí conectarás con tu AuthProvider más adelante
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Cerrando sesión de Angel Castañeda..."),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
