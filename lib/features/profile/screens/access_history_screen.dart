import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Modelo de datos para representar una sesión activa
class AccessDevice {
  final String id;
  final String name;
  final String location;
  final String browser;
  final String ip;
  final String lastAccess;
  final bool isMobile;
  final bool isCurrent;

  const AccessDevice({
    required this.id,
    required this.name,
    required this.location,
    required this.browser,
    required this.ip,
    required this.lastAccess,
    this.isMobile = true,
    this.isCurrent = false,
  });
}

class AccessHistoryScreen extends StatefulWidget {
  const AccessHistoryScreen({super.key});

  @override
  State<AccessHistoryScreen> createState() => _AccessHistoryScreenState();
}

class _AccessHistoryScreenState extends State<AccessHistoryScreen> {
  bool _isLoading = false;

  // Simulación de datos provenientes de un Backend (Laravel/MySQL)
  List<AccessDevice> _devices = [
    const AccessDevice(
      id: "1",
      name: "Samsung Galaxy S24",
      location: "Lima, Perú",
      browser: "Connexa App v1.2",
      ip: "190.235.15.22",
      lastAccess: "Activo ahora",
      isCurrent: true,
    ),
    const AccessDevice(
      id: "2",
      name: "Windows PC",
      location: "San Juan de Lurigancho, Perú",
      browser: "Chrome 122.0.x",
      ip: "181.176.85.10",
      lastAccess: "Hace 2 horas",
      isMobile: false,
    ),
    const AccessDevice(
      id: "3",
      name: "iPhone 13",
      location: "Arequipa, Perú",
      browser: "Safari Mobile",
      ip: "190.232.10.5",
      lastAccess: "30 Mar, 2026",
    ),
  ];

  Future<void> _refreshHistory() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1)); // Simulación de Red
    setState(() => _isLoading = false);
  }

  void _removeDevice(String id) {
    setState(() => _devices.removeWhere((d) => d.id == id));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text("Sesión cerrada correctamente"),
          behavior: SnackBarBehavior.floating),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentDevice = _devices.firstWhere((d) => d.isCurrent);
    final otherDevices = _devices.where((d) => !d.isCurrent).toList();

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
        title: const Text("Seguridad de Cuenta",
            style: TextStyle(
                color: Color(0xFF17203A),
                fontWeight: FontWeight.w800,
                fontSize: 18)),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshHistory,
        color: const Color(0xFF6792FF),
        child: ListView(
          padding: const EdgeInsets.all(24),
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            _buildSecurityHeader(),
            const SizedBox(height: 32),
            _buildSectionLabel("DISPOSITIVO ACTUAL"),
            _buildDeviceTile(currentDevice),
            const SizedBox(height: 32),
            _buildSectionLabel("OTRAS SESIONES ACTIVAS"),
            if (otherDevices.isEmpty)
              _buildEmptyState()
            else
              ...otherDevices.map((d) => Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _buildDeviceTile(d),
                  )),
            const SizedBox(height: 24),
            _buildLogoutAllButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildSecurityHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF6792FF),
            const Color(0xFF6792FF).withOpacity(0.8)
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
              color: const Color(0xFF6792FF).withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 10))
        ],
      ),
      child: const Row(
        children: [
          Icon(CupertinoIcons.shield_fill, color: Colors.white, size: 40),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Tu cuenta está protegida",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16)),
                SizedBox(height: 4),
                Text(
                    "Revisa tus sesiones activas y cierra las que no reconozcas.",
                    style: TextStyle(color: Colors.white70, fontSize: 12)),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 12),
      child: Text(label,
          style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: Colors.black26,
              letterSpacing: 1.2)),
    );
  }

  Widget _buildDeviceTile(AccessDevice device) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: device.isCurrent
            ? Border.all(
                color: const Color(0xFF6792FF).withOpacity(0.3), width: 2)
            : null,
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 15,
              offset: const Offset(0, 8))
        ],
      ),
      child: Row(
        children: [
          _buildDeviceIcon(device.isMobile),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(device.name,
                    style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 15,
                        color: Color(0xFF17203A))),
                const SizedBox(height: 4),
                Text("${device.browser} • ${device.ip}",
                    style:
                        const TextStyle(color: Colors.black45, fontSize: 11)),
                Text(device.location,
                    style:
                        const TextStyle(color: Colors.black45, fontSize: 11)),
                const SizedBox(height: 6),
                Text(device.lastAccess,
                    style: TextStyle(
                        color: device.isCurrent ? Colors.green : Colors.black26,
                        fontSize: 11,
                        fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          if (!device.isCurrent)
            IconButton(
              onPressed: () => _confirmLogout(device),
              icon: const Icon(Icons.logout_rounded,
                  color: Colors.redAccent, size: 20),
            ),
        ],
      ),
    );
  }

  Widget _buildDeviceIcon(bool isMobile) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F4FF),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Icon(
        isMobile
            ? CupertinoIcons.device_phone_portrait
            : CupertinoIcons.desktopcomputer,
        color: const Color(0xFF6792FF),
        size: 24,
      ),
    );
  }

  Widget _buildLogoutAllButton() {
    return TextButton.icon(
      onPressed: () => _confirmLogoutAll(),
      icon: const Icon(Icons.phonelink_erase_rounded, size: 18),
      label: const Text("Cerrar todas las demás sesiones"),
      style: TextButton.styleFrom(
          foregroundColor: Colors.redAccent,
          textStyle: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Text("No hay otras sesiones activas.",
            style: TextStyle(color: Colors.black.withOpacity(0.2))),
      ),
    );
  }

  void _confirmLogout(AccessDevice device) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        title: Text("Cerrar sesión en ${device.name}"),
        message: Text(
            "Se cerrará la sesión con IP ${device.ip}. El usuario tendrá que loguearse de nuevo."),
        actions: [
          CupertinoActionSheetAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.pop(context);
              _removeDevice(device.id);
            },
            child: const Text("Cerrar sesión"),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          child: const Text("Cancelar"),
          onPressed: () => Navigator.pop(context),
        ),
      ),
    );
  }

  void _confirmLogoutAll() {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text("Cerrar todas las sesiones"),
        content: const Text(
            "Esta acción cerrará sesión en todos tus dispositivos excepto en este. ¿Continuar?"),
        actions: [
          CupertinoDialogAction(
              child: const Text("Cancelar"),
              onPressed: () => Navigator.pop(context)),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () {
              setState(() => _devices.removeWhere((d) => !d.isCurrent));
              Navigator.pop(context);
            },
            child: const Text("Cerrar todas"),
          ),
        ],
      ),
    );
  }
}
