import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart'; // Asegúrate de instalarlo

class LocationSettingsScreen extends StatefulWidget {
  const LocationSettingsScreen({super.key});

  @override
  State<LocationSettingsScreen> createState() => _LocationSettingsScreenState();
}

class _LocationSettingsScreenState extends State<LocationSettingsScreen> {
  String _locationStatus = "Ubicación no obtenida";
  bool _isFetching = false;

  // ==========================================
  // LÓGICA DE GEOLOCALIZACIÓN ROBUSTA
  // ==========================================

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    setState(() => _isFetching = true);

    try {
      // 1. Verificar si el GPS está encendido
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw 'El GPS está desactivado. Por favor, actívalo.';
      }

      // 2. Verificar permisos actuales
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        // Solicitar permisos por primera vez
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw 'Permisos de ubicación denegados.';
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw 'Los permisos están denegados permanentemente. Actívalos desde la configuración.';
      }

      // 3. Obtener posición actual con precisión alta
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _locationStatus =
            "Lat: ${position.latitude}, Long: ${position.longitude}";
      });

      _showSuccessDialog(position.latitude, position.longitude);
    } catch (e) {
      _showErrorSnackBar(e.toString());
    } finally {
      setState(() => _isFetching = false);
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.redAccent),
    );
  }

  void _showSuccessDialog(double lat, double lng) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text("Ubicación Actualizada"),
        content: Text(
            "Connexa ha registrado tu posición:\n\nLatitud: $lat\nLongitud: $lng\n\nAhora podrás ver proveedores cercanos."),
        actions: [
          CupertinoDialogAction(
            child: const Text("Entendido"),
            onPressed: () => Navigator.pop(context),
          )
        ],
      ),
    );
  }

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
        title: const Text("Geolocalización",
            style: TextStyle(
                color: Color(0xFF17203A),
                fontWeight: FontWeight.w800,
                fontSize: 18)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(CupertinoIcons.location_circle_fill,
                size: 100, color: Color(0xFF6792FF)),
            const SizedBox(height: 32),
            const Text(
              "Optimiza tu experiencia",
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF17203A)),
            ),
            const SizedBox(height: 12),
            Text(
              "Al activar tu ubicación, Connexa podrá mostrarte los almacenes y proveedores logísticos más cercanos a tu posición actual.",
              textAlign: TextAlign.center,
              style:
                  TextStyle(color: Colors.black.withOpacity(0.5), height: 1.5),
            ),
            const SizedBox(height: 40),

            // CARD DE ESTADO
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.05), blurRadius: 10)
                ],
              ),
              child: Row(
                children: [
                  const Icon(Icons.my_location, color: Color(0xFF6792FF)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(_locationStatus,
                        style: const TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 13)),
                  ),
                ],
              ),
            ),

            const Spacer(),

            // BOTÓN DE ACCIÓN
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6792FF),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                onPressed: _isFetching ? null : _getCurrentLocation,
                child: _isFetching
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Actualizar mi Ubicación",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
