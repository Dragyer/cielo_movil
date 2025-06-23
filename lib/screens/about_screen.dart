import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  final TextEditingController nombreController = TextEditingController();
  List<String> preguntas = [];
  Map<String, int> respuestas = {};

  @override
  void initState() {
    super.initState();
    cargarPreguntas();
  }

  Future<void> cargarPreguntas() async {
    final String jsonStr =
        await rootBundle.loadString('assets/feedback_questions.json');
    final Map<String, dynamic> jsonData = json.decode(jsonStr);

    setState(() {
      preguntas = List<String>.from(jsonData['usabilidad'].map((q) => q['titulo']));
      for (int i = 0; i < preguntas.length; i++) {
        respuestas['pregunta_$i'] = 0;
      }
    });
  }

  Future<void> enviarCorreo() async {
    final body = "Nombre: ${nombreController.text}\n\n${preguntas.asMap().entries.map((e) {
          final idx = e.key;
          final texto = e.value;
          return '$texto\nRespuesta: ${respuestas['pregunta_$idx']} estrellas\n';
        }).join('\n')}";

    final Uri gmailUri = Uri.parse(
        "googlegmail:///co?to=daniel@email.com&subject=Opinión sobre Cielo Móvil&body=${Uri.encodeComponent(body)}");

    final Uri mailtoUri = Uri(
      scheme: 'mailto',
      path: 'daniel@email.com',
      query: Uri.encodeFull('subject=Opinión sobre Cielo Móvil&body=$body'),
    );

    try {
      if (await canLaunchUrl(gmailUri)) {
        await launchUrl(gmailUri, mode: LaunchMode.externalApplication);
      } else if (await canLaunchUrl(mailtoUri)) {
        await launchUrl(mailtoUri, mode: LaunchMode.externalApplication);
      } else {
        throw 'Sin app de correo disponible';
      }
    } catch (e) {
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text('No se pudo abrir la app de correo'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Copia este texto y pégalo en tu correo manualmente:'),
                SizedBox(height: 10),
                SelectableText(body, style: TextStyle(fontSize: 12)),
              ],
            ),
            actions: [
              TextButton(
                child: Text('Cerrar'),
                onPressed: () => Navigator.pop(context),
              )
            ],
          ),
        );
      }
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
              '📱 Cielo Móvil\nVersión 1.0\nDesarrollador: Daniel Arias\nContacto: daniel@email.com\n\n'
              'Cielo Móvil es una app educativa que te muestra el cielo visible desde tu ubicación usando sensores y GPS. '
              'Puedes registrar tus observaciones y enviar tu opinión.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            TextField(
              controller: nombreController,
              decoration: InputDecoration(
                labelText: 'Tu nombre o identificación',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            Text(
              '⭐ Valora tu experiencia:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
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