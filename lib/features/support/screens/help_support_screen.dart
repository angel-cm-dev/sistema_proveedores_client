import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:sistema_proveedores_client/features/auth/providers/auth_provider.dart';

class HelpSupportScreen extends StatefulWidget {
  const HelpSupportScreen({super.key});

  @override
  State<HelpSupportScreen> createState() => _HelpSupportScreenState();
}

class _HelpSupportScreenState extends State<HelpSupportScreen> {
  String _searchQuery = "";

  // Base de datos local de Preguntas Frecuentes (Enfoque Cliente Connexa - Sin "Mis Órdenes")
  final List<Map<String, String>> _allFAQs = [
    {
      "question": "¿Cómo busco proveedores específicos en el directorio?",
      "answer":
          "Dirígete a la sección 'Directorio' en el menú principal. Puedes usar la barra de búsqueda superior por nombre o RUC, o utilizar los filtros rápidos como 'Tecnología' o 'Logística'."
    },
    {
      "question": "¿Cómo configuro la seguridad de mi cuenta (2FA)?",
      "answer":
          "Ve a tu 'Perfil' y selecciona 'Seguridad y Acceso'. Allí podrás actualizar tu contraseña y activar la Autenticación de Dos Factores para mayor protección."
    },
    {
      "question": "¿Dónde puedo ver mi historial de facturación y pagos?",
      "answer":
          "En el menú lateral, selecciona 'Historial Pagos'. Allí encontrarás el registro detallado de todas tus transacciones y podrás descargar los comprobantes electrónicos."
    },
    {
      "question": "¿Por qué no recibo alertas sobre mis proveedores favoritos?",
      "answer":
          "Verifica en 'Perfil' > 'Notificaciones' que las alertas push y de correo estén activadas. Asegúrate también de haber marcado al proveedor con la estrella de 'Favoritos'."
    },
    {
      "question": "¿Cómo funcionan las evaluaciones de proveedores?",
      "answer":
          "En la sección 'Mis Evaluaciones' puedes calificar el servicio y cumplimiento de los proveedores con los que has interactuado. Esto ayuda a mantener la calidad de la red Connexa."
    },
    {
      "question": "¿Puedo cambiar la apariencia de la aplicación?",
      "answer":
          "¡Sí! Puedes alternar entre el Modo Claro y el Modo Oscuro desde el panel inferior en el menú lateral, o directamente desde 'Perfil' > 'Apariencia'."
    },
  ];

  // --- LÓGICA DE ENLACES EXTERNOS (Manejo de Errores Senior) ---
  Future<void> _launchWhatsApp() async {
    const phoneNumber = "51950105413";
    const message = "Hola, necesito soporte desde la app Connexa (Cliente).";
    final Uri url = Uri.parse(
        "https://wa.me/$phoneNumber?text=${Uri.encodeComponent(message)}");

    try {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content:
                Text("No se pudo abrir WhatsApp. Verifica que esté instalado."),
            backgroundColor: Color(0xFFF77D8E),
          ),
        );
      }
    }
  }

  Future<void> _launchEmail() async {
    final Uri emailUrl = Uri(
      scheme: 'mailto',
      path: 'soporte@connexa.pe',
      query: 'subject=Soporte App Connexa - Cliente',
    );

    try {
      await launchUrl(emailUrl, mode: LaunchMode.externalApplication);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("No se pudo abrir la aplicación de correo."),
            backgroundColor: Color(0xFFF77D8E),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final String userName = context.select<AuthProvider, String>(
        (auth) => auth.user?.fullName ?? "Usuario");
    final String firstName = userName.split(' ').first;

    // Buscador Reactivo: Filtra ignorando mayúsculas/minúsculas
    final filteredFAQs = _allFAQs.where((faq) {
      final question = faq["question"]!.toLowerCase();
      final answer = faq["answer"]!.toLowerCase();
      final query = _searchQuery.toLowerCase();
      return question.contains(query) || answer.contains(query);
    }).toList();

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
          "Centro de Ayuda",
          style: TextStyle(
              color: Color(0xFF17203A),
              fontWeight: FontWeight.w800,
              fontSize: 18),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // HEADER HERO
            Text(
              "Hola, $firstName",
              style: TextStyle(
                  color: const Color(0xFF17203A).withOpacity(0.5),
                  fontSize: 16,
                  fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            const Text(
              "¿En qué podemos\nayudarte hoy?",
              style: TextStyle(
                  color: Color(0xFF17203A),
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  height: 1.1,
                  letterSpacing: -0.5),
            ),
            const SizedBox(height: 24),

            // SEARCH BAR FUNCIONAL
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 15,
                      offset: const Offset(0, 5))
                ],
              ),
              child: TextField(
                onChanged: (value) => setState(() => _searchQuery = value),
                decoration: InputDecoration(
                  icon: Icon(CupertinoIcons.search,
                      color: const Color(0xFF17203A).withOpacity(0.4)),
                  hintText: "Buscar términos clave...",
                  hintStyle: TextStyle(
                      color: const Color(0xFF17203A).withOpacity(0.3)),
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: 35),

            // CONTACT CARDS (Deep Links Seguros)
            const Text("Contacto Rápido",
                style: TextStyle(
                    color: Color(0xFF17203A),
                    fontSize: 18,
                    fontWeight: FontWeight.w800)),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _ContactCard(
                    icon: CupertinoIcons.chat_bubble_2_fill,
                    color: const Color(0xFF25D366),
                    title: "WhatsApp",
                    subtitle: "Respuesta rápida",
                    onTap: _launchWhatsApp,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _ContactCard(
                    icon: CupertinoIcons.envelope_fill,
                    color: const Color(0xFF648FFF),
                    title: "Soporte",
                    subtitle: "soporte@connexa.pe",
                    onTap: _launchEmail,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 35),

            // FAQ SECTION CON FILTRO EN TIEMPO REAL
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Preguntas Frecuentes",
                    style: TextStyle(
                        color: Color(0xFF17203A),
                        fontSize: 18,
                        fontWeight: FontWeight.w800)),
                if (_searchQuery.isNotEmpty)
                  Text("${filteredFAQs.length} resultados",
                      style: const TextStyle(
                          color: Color(0xFF648FFF),
                          fontSize: 12,
                          fontWeight: FontWeight.w600)),
              ],
            ),
            const SizedBox(height: 16),

            // Renderizado condicional si no hay resultados
            if (filteredFAQs.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 30),
                  child: Column(
                    children: [
                      Icon(CupertinoIcons.search,
                          size: 40,
                          color: const Color(0xFF17203A).withOpacity(0.2)),
                      const SizedBox(height: 12),
                      Text("No encontramos resultados para\n'$_searchQuery'",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: const Color(0xFF17203A).withOpacity(0.5))),
                    ],
                  ),
                ),
              )
            else
              ...filteredFAQs.map(
                  (faq) => _buildFAQTile(faq["question"]!, faq["answer"]!)),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // WIDGET: Preguntas Frecuentes (Acordeón)
  Widget _buildFAQTile(String question, String answer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4))
        ],
      ),
      child: Theme(
        data: ThemeData(dividerColor: Colors.transparent),
        child: ExpansionTile(
          iconColor: const Color(0xFF648FFF),
          collapsedIconColor: const Color(0xFF17203A).withOpacity(0.3),
          title: Text(question,
              style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: Color(0xFF17203A))),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Text(answer,
                  style: TextStyle(
                      color: const Color(0xFF17203A).withOpacity(0.6),
                      fontSize: 13,
                      height: 1.5)),
            ),
          ],
        ),
      ),
    );
  }
}

// WIDGET: Tarjeta de Contacto Rápido
class _ContactCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ContactCard({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
                color: color.withOpacity(0.15),
                blurRadius: 15,
                offset: const Offset(0, 8))
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: color.withOpacity(0.15), shape: BoxShape.circle),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 16),
            Text(title,
                style: const TextStyle(
                    color: Color(0xFF17203A),
                    fontWeight: FontWeight.w800,
                    fontSize: 15)),
            const SizedBox(height: 4),
            Text(subtitle,
                style: TextStyle(
                    color: const Color(0xFF17203A).withOpacity(0.5),
                    fontSize: 11)),
          ],
        ),
      ),
    );
  }
}
