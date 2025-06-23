import 'package:flutter/material.dart';
import '../models/observation.dart';
import '../database/db_helper.dart';

class ObservationsScreen extends StatefulWidget {
  const ObservationsScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ObservationsScreenState createState() => _ObservationsScreenState();
}

class _ObservationsScreenState extends State<ObservationsScreen> {
  List<Observation> observations = [];
  final TextEditingController nameController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadObservations();
  }

  Future<void> loadObservations() async {
    final data = await DBHelper.getAll();
    setState(() => observations = data);
  }

  void showForm({Observation? obs}) {
    if (obs != null) {
      nameController.text = obs.name;
      dateController.text = obs.date;
    } else {
      nameController.clear();
      dateController.clear();
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(obs == null ? 'Nueva observación' : 'Editar observación'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Nombre de la estrella/constelación'),
            ),
            TextField(
              controller: dateController,
              decoration: InputDecoration(labelText: 'Fecha (ej: 2025-06-20)'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              final name = nameController.text;
              final date = dateController.text;

              if (name.isEmpty || date.isEmpty) return;

              if (obs == null) {
                await DBHelper.insert(Observation(name: name, date: date));
              } else {
                await DBHelper.update(Observation(id: obs.id, name: name, date: date));
              }

              // ignore: use_build_context_synchronously
              Navigator.pop(context);
              await loadObservations();
            },
            child: Text('Guardar'),
          ),
        ],
      ),
    );
  }

  Future<void> deleteObservation(int id) async {
    await DBHelper.delete(id);
    await loadObservations();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Mis Observaciones')),
      body: ListView.builder(
        itemCount: observations.length,
        itemBuilder: (_, index) {
          final obs = observations[index];
          return ListTile(
            title: Text(obs.name),
            subtitle: Text(obs.date),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () => showForm(obs: obs),
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => deleteObservation(obs.id!),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => showForm(),
      ),
    );
  }
}