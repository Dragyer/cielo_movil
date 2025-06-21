import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'screens/home_screen.dart';
import 'screens/sky_view_screen.dart';
import 'screens/preferences_screen.dart';
import 'screens/about_screen.dart';

void main() {
  runApp(CieloMovilApp());
}

class CieloMovilApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cielo Móvil',
      theme: ThemeData(primarySwatch: Colors.indigo),
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        '/home': (context) => HomeScreen(),
        '/sky': (context) => SkyViewScreen(),
        '/preferences': (context) => PreferencesScreen(),
        '/about': (context) => AboutScreen(),
      },
    );
  }
}