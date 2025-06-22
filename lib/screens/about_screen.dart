import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatefulWidget {
  @override
  _AboutScreenState createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  List<String> preguntas = [];
  Map<String, int> respuestas = {};

  @override
  void initState() {
    super.initState();
    cargarPreguntas();
  }

  Future<void> cargarPreguntas() async {
    final String jsonStr = await rootBundle.loadString('assets/feedback_questions.json');
    final Map<String, dynamic> jsonData = json.decode(jsonStr);

    setState(() {
      preguntas = List<String>.from(jsonData['usabilidad'].map((q) => q['titulo']));
      for (int i = 0; i < preguntas.length; i++) {
        respuestas['pregunta_$i'] = 0;
      }
    });
  }

  Future<void> enviarCorreo() async {
    final body = preguntas.asMap().entries.map((e) {
      final idx = e.key;
      final texto = e.value;
      return '${texto}\nRespuesta: ${respuestas['pregunta_$idx']} estrellas\n';
    }).join('\n');

    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'daniel@email.com',
      query: Uri.encodeFull('subject=Opinión sobre Cielo Móvil&body=$body'),
    );

    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No se pudo abrir la app de correo.')),
      );
    }
  }

  Widget buildPregunta(int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(preguntas[index], style: TextStyle(fontWeight: FontWeight.bold)),
        Slider(
          value: (respuestas['pregunta_$index'] ?? 0).toDouble(),
          onChanged: (value) {
            setState(() => respuestas['pregunta_$index'] = value.toInt());
          },
          min: 0,
          max: 5,
          divisions: 5,
          label: '${respuestas['pregunta_$index']} estrellas',
        ),
        SizedBox(height: 10),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Acerca de')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Text(
              '📱 Cielo Móvil\nVersión 1.0\nDesarrollador: Daniel Arias\nContacto: daniel@email.com',
              style: TextStyle(fontSize: 16),
            ),
            Divider(height: 30),
            Text('⭐ Valora tu experiencia:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ...List.generate(preguntas.length, (i) => buildPregunta(i)),
            SizedBox(height: 20),
            ElevatedButton.icon(
              icon: Icon(Icons.send),
              label: Text('Enviar valoración por correo'),
              onPressed: enviarCorreo,
            ),
          ],
        ),
      ),
    );
  }
}