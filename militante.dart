import 'package:cloud_firestore/cloud_firestore.dart';

class Militante {
  final String id;
  final String nombres;
  final String apellidos;
  final String ci;
  final String telefono;
  final String email;
  final String direccion;
  final String zona;
  final String? fotoCarnetFrontal;
  final String? fotoCarnetReverso;
  final DateTime fechaRegistro;
  final bool verificado;
  final GeoLocation? ubicacion;
  final bool aceptoTerminos;
  final bool autorizoFotoCI;
  final bool autorizoGPS;
  final bool autorizoDatos;

  Militante({
    required this.id,
    required this.nombres,
    required this.apellidos,
    required this.ci,
    required this.telefono,
    required this.email,
    required this.direccion,
    required this.zona,
    this.fotoCarnetFrontal,
    this.fotoCarnetReverso,
    required this.fechaRegistro,
    this.verificado = false,
    this.ubicacion,
    required this.aceptoTerminos,
    required this.autorizoFotoCI,
    required this.autorizoGPS,
    required this.autorizoDatos,
  });

  String get nombreCompleto => '$nombres $apellidos';

  factory Militante.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Militante(
      id: doc.id,
      nombres: data['nombres'] ?? '',
      apellidos: data['apellidos'] ?? '',
      ci: data['ci'] ?? '',
      telefono: data['telefono'] ?? '',
      email: data['email'] ?? '',
      direccion: data['direccion'] ?? '',
      zona: data['zona'] ?? '',
      fotoCarnetFrontal: data['fotoCarnetFrontal'],
      fotoCarnetReverso: data['fotoCarnetReverso'],
      fechaRegistro: (data['fechaRegistro'] as Timestamp).toDate(),
      verificado: data['verificado'] ?? false,
      ubicacion: data['ubicacion'] != null
          ? GeoLocation.fromMap(data['ubicacion'])
          : null,
      aceptoTerminos: data['aceptoTerminos'] ?? false,
      autorizoFotoCI: data['autorizoFotoCI'] ?? false,
      autorizoGPS: data['autorizoGPS'] ?? false,
      autorizoDatos: data['autorizoDatos'] ?? false,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'nombres': nombres,
      'apellidos': apellidos,
      'ci': ci,
      'telefono': telefono,
      'email': email,
      'direccion': direccion,
      'zona': zona,
      'fotoCarnetFrontal': fotoCarnetFrontal,
      'fotoCarnetReverso': fotoCarnetReverso,
      'fechaRegistro': Timestamp.fromDate(fechaRegistro),
      'verificado': verificado,
      'ubicacion': ubicacion?.toMap(),
      'aceptoTerminos': aceptoTerminos,
      'autorizoFotoCI': autorizoFotoCI,
      'autorizoGPS': autorizoGPS,
      'autorizoDatos': autorizoDatos,
    };
  }
}

class GeoLocation {
  final double latitude;
  final double longitude;
  final double accuracy;
  final DateTime timestamp;

  GeoLocation({
    required this.latitude,
    required this.longitude,
    required this.accuracy,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'accuracy': accuracy,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }

  factory GeoLocation.fromMap(Map<String, dynamic> map) {
    return GeoLocation(
      latitude: map['latitude'] as double,
      longitude: map['longitude'] as double,
      accuracy: map['accuracy'] as double,
      timestamp: (map['timestamp'] as Timestamp).toDate(),
    );
  }

  String get coordinates => 
      'Lat: ${latitude.toStringAsFixed(6)}, Lng: ${longitude.toStringAsFixed(6)}';
}
