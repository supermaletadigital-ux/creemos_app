import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MilitantesScreen extends ConsumerWidget {
  const MilitantesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Militantes Registrados'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 10,
        itemBuilder: (context, index) => Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).primaryColor,
              child: Text('${index + 1}'),
            ),
            title: Text('Militante ${index + 1}'),
            subtitle: Text('CI: 123456${index + 1} • Santa Cruz'),
            trailing: const Icon(Icons.check_circle, color: Colors.green),
          ),
        ),
      ),
    );
  }
}
