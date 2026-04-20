import 'package:cloud_firestore/cloud_firestore.dart';

class NewsPost {
  final String id;
  final String titulo;
  final String contenido;
  final List<String> imagenes;
  final String? videoUrl;
  final String? documentoUrl;
  final TipoDocumento? tipoDocumento;
  final DateTime fechaPublicacion;
  final String autor;
  final int likes;
  final int comentarios;

  NewsPost({
    required this.id,
    required this.titulo,
    required this.contenido,
    this.imagenes = const [],
    this.videoUrl,
    this.documentoUrl,
    this.tipoDocumento,
    required this.fechaPublicacion,
    required this.autor,
    this.likes = 0,
    this.comentarios = 0,
  });

  factory NewsPost.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return NewsPost(
      id: doc.id,
      titulo: data['titulo'] ?? '',
      contenido: data['contenido'] ?? '',
      imagenes: List<String>.from(data['imagenes'] ?? []),
      videoUrl: data['videoUrl'],
      documentoUrl: data['documentoUrl'],
      tipoDocumento: data['tipoDocumento'] != null
          ? TipoDocumento.values.firstWhere(
              (e) => e.toString() == 'TipoDocumento.${data['tipoDocumento']}',
              orElse: () => TipoDocumento.pdf,
            )
          : null,
      fechaPublicacion: (data['fechaPublicacion'] as Timestamp).toDate(),
      autor: data['autor'] ?? '',
      likes: data['likes'] ?? 0,
      comentarios: data['comentarios'] ?? 0,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'titulo': titulo,
      'contenido': contenido,
      'imagenes': imagenes,
      'videoUrl': videoUrl,
      'documentoUrl': documentoUrl,
      'tipoDocumento': tipoDocumento?.toString().split('.').last,
      'fechaPublicacion': Timestamp.fromDate(fechaPublicacion),
      'autor': autor,
      'likes': likes,
      'comentarios': comentarios,
    };
  }

  String get tiempoTranscurrido {
    final diferencia = DateTime.now().difference(fechaPublicacion);
    
    if (diferencia.inDays > 365) {
      final years = (diferencia.inDays / 365).floor();
      return '$years año${years > 1 ? 's' : ''}';
    } else if (diferencia.inDays > 30) {
      final months = (diferencia.inDays / 30).floor();
      return '$months mes${months > 1 ? 'es' : ''}';
    } else if (diferencia.inDays > 0) {
      return '${diferencia.inDays} día${diferencia.inDays > 1 ? 's' : ''}';
    } else if (diferencia.inHours > 0) {
      return '${diferencia.inHours}h';
    } else if (diferencia.inMinutes > 0) {
      return '${diferencia.inMinutes}min';
    } else {
      return 'Ahora';
    }
  }
}

enum TipoDocumento {
  pdf,
  word,
  excel,
}
