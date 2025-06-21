import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cielo Móvil'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.indigo),
              child: Text(
                'Menú',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: Icon(Icons.nightlight),
              title: Text('Ver cielo estrellado'),
              onTap: () {
                Navigator.pushNamed(context, '/sky');
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Preferencias'),
              onTap: () {
                Navigator.pushNamed(context, '/preferences');
              },
            ),
            ListTile(
              leading: Icon(Icons.info),
              title: Text('Acerca de'),
              onTap: () {
                Navigator.pushNamed(context, '/about');
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Text(
          'Bienvenido a Cielo Móvil 🌠\nAbre el menú para comenzar',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}