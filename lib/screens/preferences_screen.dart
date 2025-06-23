// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesScreen extends StatefulWidget {
  const PreferencesScreen({super.key});

  @override
  _PreferencesScreenState createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends State<PreferencesScreen> {
  bool darkMode = false;
  bool autoRotate = true;
  String favoriteColor = 'Azul';

  final List<String> colors = ['Azul', 'Negro', 'Violeta', 'Verde'];

  @override
  void initState() {
    super.initState();
    loadPreferences();
  }

  Future<void> loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      darkMode = prefs.getBool('darkMode') ?? false;
      autoRotate = prefs.getBool('autoRotate') ?? true;
      favoriteColor = prefs.getString('favoriteColor') ?? 'Azul';
    });
  }

  Future<void> savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('darkMode', darkMode);
    await prefs.setBool('autoRotate', autoRotate);
    await prefs.setString('favoriteColor', favoriteColor);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Preferencias')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: ListView(
          children: [
            SwitchListTile(
              title: Text('Tema Oscuro'),
              value: darkMode,
              onChanged: (value) {
                setState(() => darkMode = value);
              },
            ),
            SwitchListTile(
              title: Text('Rotación automática del cielo'),
              value: autoRotate,
              onChanged: (value) {
                setState(() => autoRotate = value);
              },
            ),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(labelText: 'Color favorito del cielo'),
              value: favoriteColor,
              onChanged: (String? value) {
                setState(() => favoriteColor = value ?? 'Azul');
              },
              items: colors
                  .map((color) => DropdownMenuItem<String>(
                        value: color,
                        child: Text(color),
                      ))
                  .toList(),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text('Guardar preferencias'),
              onPressed: () async {
                await savePreferences();
                // ignore: use_build_context_synchronously
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Preferencias guardadas')));
              },
            ),
          ],
        ),
      ),
    );
  }
}