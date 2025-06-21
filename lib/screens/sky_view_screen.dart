import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'dart:async';

class SkyViewScreen extends StatefulWidget {
  @override
  _SkyViewScreenState createState() => _SkyViewScreenState();
}

class _SkyViewScreenState extends State<SkyViewScreen> {
  late StreamSubscription<GyroscopeEvent> _gyroscopeSubscription;
  String orientation = "Detectando...";

  @override
  void initState() {
    super.initState();
    _gyroscopeSubscription = gyroscopeEvents.listen((GyroscopeEvent event) {
      setState(() {
        orientation = getDirectionFromGyroscope(event);
      });
    });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cielo Estrellado'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.star, size: 100, color: Colors.amber),
            SizedBox(height: 20),
            Text(
              'Moviendo hacia: $orientation',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              '🌀 Mueve tu celular para explorar el cielo.',
              style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
    );
  }
}