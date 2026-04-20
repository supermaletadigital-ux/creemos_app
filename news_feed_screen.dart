import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class NewsFeedScreen extends ConsumerWidget {
  const NewsFeedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Noticias Creemos')),
      body: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: 5,
        itemBuilder: (context, index) => _NewsPostCard(index: index),
      ),
    );
  }
}

class _NewsPostCard extends StatelessWidget {
  final int index;

  const _NewsPostCard({required this.index});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          ListTile(
            leading: const CircleAvatar(
              child: Text('C'),
              backgroundColor: Color(0xFFFF6B35),
            ),
            title: const Text('Creemos Santa Cruz', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('Hace ${index + 1}h'),
          ),
          
          // Contenido
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Noticia importante #${index + 1}: Avances en propuestas para Santa Cruz...',
              style: const TextStyle(fontSize: 15),
            ),
          ),
          const SizedBox(height: 12),
          
          // Imagen
          CachedNetworkImage(
            imageUrl: 'https://picsum.photos/400/300?random=$index',
            height: 250,
            width: double.infinity,
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(
              height: 250,
              color: Colors.grey[200],
              child: const Center(child: CircularProgressIndicator()),
            ),
          ),
          
          // Acciones
          Row(
            children: [
              TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.thumb_up_outlined),
                label: Text('${(index + 1) * 42}'),
              ),
              TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.comment_outlined),
                label: Text('${(index + 1) * 12}'),
              ),
              TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.share_outlined),
                label: const Text('Compartir'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
