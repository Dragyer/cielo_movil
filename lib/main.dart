import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/splash_screen.dart';
import 'screens/home_screen.dart';
import 'screens/sky_view_screen.dart';
import 'screens/preferences_screen.dart';
import 'screens/about_screen.dart';
import 'screens/observations_screen.dart';

void main() {
  runApp(const CieloMovilApp());
}

class CieloMovilApp extends StatelessWidget {
  const CieloMovilApp({super.key});

  Future<bool> cargarTemaOscuro() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('darkMode') ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: cargarTemaOscuro(),
      builder: (context, snapshot) {
        final isDark = snapshot.data ?? false;
        return MaterialApp(
          title: 'Cielo Móvil',
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
          initialRoute: '/',
          routes: {
            '/': (context) => const SplashScreen(),
            '/home': (context) => const HomeScreen(),
            '/sky': (context) => const SkyViewScreen(),
            '/preferences': (context) => const PreferencesScreen(),
            '/about': (context) => const AboutScreen(),
            '/observations': (context) => const ObservationsScreen(),
          },
        );
      },
    );
  }
}