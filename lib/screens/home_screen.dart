import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String location = "Detectando ubicación...";
  String favoriteColor = 'Azul';
  bool darkMode = false;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
    _getLocation();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      favoriteColor = prefs.getString('favoriteColor') ?? 'Azul';
      darkMode = prefs.getBool('darkMode') ?? false;
    });
  }

  Future<void> _getLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() => location = "GPS desactivado");
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        setState(() => location = "Permiso de ubicación denegado");
        return;
      }
    }

    final pos = await Geolocator.getCurrentPosition();
    setState(() {
      location = "📍 ${pos.latitude.toStringAsFixed(4)}, ${pos.longitude.toStringAsFixed(4)}";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _getColor(favoriteColor),
      appBar: AppBar(
        title: Text('Cielo Móvil'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.indigo),
              child: Text('Menú', style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            ListTile(
              leading: Icon(Icons.nightlight),
              title: Text('Ver cielo estrellado'),
              onTap: () => Navigator.pushNamed(context, '/sky'),
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Preferencias'),
              onTap: () => Navigator.pushNamed(context, '/preferences'),
            ),
            ListTile(
              leading: Icon(Icons.info),
              title: Text('Acerca de'),
              onTap: () => Navigator.pushNamed(context, '/about'),
            ),
            ListTile(
              leading: Icon(Icons.visibility),
              title: Text('Observaciones'),
              onTap: () => Navigator.pushNamed(context, '/observations'),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: ListView(
          children: [
            Text(
              '🌌 Bienvenido a Cielo Móvil',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Tu ubicación actual: $location',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            ElevatedButton.icon(
              icon: Icon(Icons.explore),
              label: Text('Explorar cielo estrellado'),
              onPressed: () => Navigator.pushNamed(context, '/sky'),
            ),
            SizedBox(height: 10),
            ElevatedButton.icon(
              icon: Icon(Icons.note_add),
              label: Text('Registrar nueva observación'),
              onPressed: () => Navigator.pushNamed(context, '/observations'),
            ),
            SizedBox(height: 30),
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      '¿Sabías que puedes guardar tus observaciones y revisarlas más tarde?',
                      style: TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Personalización activa: Tema ${darkMode ? "Oscuro" : "Claro"} / Color $favoriteColor',
                      style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getColor(String nombre) {
    switch (nombre.toLowerCase()) {
      case 'azul':
        return Colors.blue.shade100;
      case 'negro':
        return Colors.grey.shade900;
      case 'violeta':
        return Colors.deepPurple.shade100;
      case 'verde':
        return Colors.green.shade100;
      default:
        return Colors.white;
    }
  }
}