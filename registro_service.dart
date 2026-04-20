import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/militante.dart';

final registroServiceProvider = Provider<RegistroService>((ref) {
  return RegistroService();
});

class RegistroService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<void> registrarMilitante(
    Militante militante,
    File fotoFrontal,
    File fotoReverso,
  ) async {
    try {
      // Subir foto frontal del CI
      final frontalFileName = 'ci_frontal_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final frontalRef = _storage
          .ref()
          .child('militantes')
          .child(militante.ci)
          .child(frontalFileName);
      
      await frontalRef.putFile(fotoFrontal);
      final frontalUrl = await frontalRef.getDownloadURL();

      // Subir foto reverso del CI
      final reversoFileName = 'ci_reverso_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final reversoRef = _storage
          .ref()
          .child('militantes')
          .child(militante.ci)
          .child(reversoFileName);
      
      await reversoRef.putFile(fotoReverso);
      final reversoUrl = await reversoRef.getDownloadURL();

      // Guardar en Firestore
      final data = militante.toFirestore();
      data['fotoCarnetFrontal'] = frontalUrl;
      data['fotoCarnetReverso'] = reversoUrl;

      await _firestore.collection('militantes').add(data);
    } catch (e) {
      throw Exception('Error al registrar militante: $e');
    }
  }
}
