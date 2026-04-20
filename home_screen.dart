import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CREEMOS Santa Cruz'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => ref.read(authServiceProvider).signOut(),
          ),
        ],
      ),
      body: GridView.count(
        padding: const EdgeInsets.all(16),
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        children: [
          _MenuCard(
            icon: Icons.newspaper,
            title: 'Noticias',
            color: Colors.blue,
            onTap: () => context.push('/news'),
          ),
          _MenuCard(
            icon: Icons.gavel,
            title: 'Patria Asesora',
            color: Colors.purple,
            onTap: () => context.push('/legal'),
          ),
          _MenuCard(
            icon: Icons.people,
            title: 'Militantes',
            color: Colors.green,
            onTap: () => context.push('/militantes'),
          ),
          _MenuCard(
            icon: Icons.settings,
            title: 'Admin',
            color: Colors.orange,
            onTap: () => context.push('/admin'),
          ),
        ],
      ),
    );
  }
}

class _MenuCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback onTap;

  const _MenuCard({
    required this.icon,
    required this.title,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: color),
            const SizedBox(height: 12),
            Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
