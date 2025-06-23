import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';

class SkyViewScreen extends StatefulWidget {
  const SkyViewScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SkyViewScreenState createState() => _SkyViewScreenState();
}

class _SkyViewScreenState extends State<SkyViewScreen> {
  late StreamSubscription<GyroscopeEvent> _gyroscopeSubscription;
  String orientation = "Detectando...";
  String location = "Ubicación no disponible";

  @override
  void initState() {
    super.initState();
    // ignore: deprecated_member_use
    _gyroscopeSubscription = gyroscopeEvents.listen((event) {
      setState(() {
        orientation = getDirectionFromGyroscope(event);
      });
    });
    _determinePosition();
  }

  @override
  void dispose() {
    _gyroscopeSubscription.cancel();
    super.dispose();
  }

  String getDirectionFromGyroscope(GyroscopeEvent event) {
    if (event.y > 1) return "Izquierda";
    if (event.y < -1) return "Derecha";
    if (event.x > 1) return "Arriba";
    if (event.x < -1) return "Abajo";
    return "Estático";
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        location = "GPS desactivado";
      });
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          location = "Permiso denegado";
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        location = "Permiso denegado permanentemente";
      });
      return;
    }

    final pos = await Geolocator.getCurrentPosition();
    setState(() {
      location = "Lat: ${pos.latitude.toStringAsFixed(4)}, Long: ${pos.longitude.toStringAsFixed(4)}";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Cielo Estrellado')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.star, size: 100, color: Colors.amber),
            SizedBox(height: 20),
            Text('Moviendo hacia: $orientation', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('Ubicación: $location', style: TextStyle(fontSize: 16)),
            SizedBox(height: 20),
            Text('🌀 Mueve tu celular para explorar el cielo.', style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic)),
          ],
        ),
      ),
    );
  }
}