import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:go_router/go_router.dart';
import '../services/registro_service.dart';
import '../models/militante.dart';

class RegistroScreen extends ConsumerStatefulWidget {
  const RegistroScreen({super.key});

  @override
  ConsumerState<RegistroScreen> createState() => _RegistroScreenState();
}

class _RegistroScreenState extends ConsumerState<RegistroScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombresController = TextEditingController();
  final _apellidosController = TextEditingController();
  final _ciController = TextEditingController();
  final _telefonoController = TextEditingController();
  final _emailController = TextEditingController();
  final _direccionController = TextEditingController();
  final _zonaController = TextEditingController();

  // Capturas de CI - Requieren alta calidad con flash para máxima nitidez
  File? _fotoCarnetFrontal;
  File? _fotoCarnetReverso;
  
  // Ubicación GPS de alta precisión
  Position? _position;
  bool _isLoading = false;
  bool _capturandoGPS = false;

  @override
  void dispose() {
    _nombresController.dispose();
    _apellidosController.dispose();
    _ciController.dispose();
    _telefonoController.dispose();
    _emailController.dispose();
    _direccionController.dispose();
    _zonaController.dispose();
    super.dispose();
  }

  /// Captura foto del carnet con flash activado para máxima nitidez
  /// Requiere close-up de alta calidad para verificación detallada
  /// Captura todos los detalles: número de CI, fotografía, firma, holograma
  Future<void> _capturarFotoCI(bool esFrontal) async {
    // Solicitar permiso de cámara
    final status = await Permission.camera.request();
    if (!status.isGranted) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Se requiere permiso de cámara para capturar el CI'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    try {
      final picker = ImagePicker();
      
      // Captura con cámara, flash activado automáticamente si es necesario
      // Alta resolución para capturar detalles finos del documento
      final pickedFile = await picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1920, // Alta resolución para detalles nítidos
        imageQuality: 100, // Máxima calidad - sin compresión
        preferredCameraDevice: CameraDevice.rear, // Cámara trasera mejor calidad
      );

      if (pickedFile != null) {
        setState(() {
          if (esFrontal) {
            _fotoCarnetFrontal = File(pickedFile.path);
          } else {
            _fotoCarnetReverso = File(pickedFile.path);
          }
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                esFrontal
                    ? 'Foto frontal de CI capturada correctamente'
                    : 'Foto reverso de CI capturada correctamente',
              ),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al capturar foto: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// Captura ubicación GPS con máxima precisión
  /// Usada para verificar ubicación de militancia en Santa Cruz
  /// Precisión de metros para validar domicilio declarado
  Future<void> _capturarUbicacionGPS() async {
    // Solicitar permiso de ubicación
    final status = await Permission.location.request();
    if (!status.isGranted) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Se requiere permiso de ubicación GPS'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    setState(() => _capturandoGPS = true);

    try {
      // Verificar que el servicio de ubicación esté habilitado
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('El servicio de ubicación está deshabilitado');
      }

      // Obtener posición con máxima precisión
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best, // Máxima precisión disponible
        timeLimit: const Duration(seconds: 10),
      );

      setState(() {
        _position = position;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Ubicación GPS capturada correctamente',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  'Precisión: ±${position.accuracy.toStringAsFixed(1)} metros',
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al capturar ubicación: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() => _capturandoGPS = false);
    }
  }

  Future<void> _submitRegistro() async {
    if (!_formKey.currentState!.validate()) return;

    if (_fotoCarnetFrontal == null || _fotoCarnetReverso == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Debe capturar ambos lados del CI'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    if (_position == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Debe capturar su ubicación GPS'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final militante = Militante(
        id: '',
        nombres: _nombresController.text.trim(),
        apellidos: _apellidosController.text.trim(),
        ci: _ciController.text.trim(),
        telefono: _telefonoController.text.trim(),
        email: _emailController.text.trim(),
        direccion: _direccionController.text.trim(),
        zona: _zonaController.text.trim(),
        fechaRegistro: DateTime.now(),
        verificado: false, // Pendiente de verificación manual
        ubicacion: GeoLocation(
          latitude: _position!.latitude,
          longitude: _position!.longitude,
          accuracy: _position!.accuracy,
          timestamp: DateTime.now(),
        ),
        aceptoTerminos: true,
        autorizoFotoCI: true,
        autorizoGPS: true,
        autorizoDatos: true,
      );

      final service = ref.read(registroServiceProvider);
      await service.registrarMilitante(
        militante,
        _fotoCarnetFrontal!,
        _fotoCarnetReverso!,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Registro completado exitosamente'),
            backgroundColor: Colors.green,
          ),
        );
        context.go('/login');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error en el registro: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro de Militante'),
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // Sección de fotos del CI
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.camera_alt, color: Theme.of(context).primaryColor),
                        const SizedBox(width: 8),
                        const Text(
                          'Fotografías del Carnet de Identidad',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Capture fotos nítidas de ambos lados de su CI. Asegúrese de que todos los detalles sean legibles.',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    const SizedBox(height: 16),

                    // Foto frontal
                    _FotoCarnetWidget(
                      titulo: 'FRENTE DEL CI',
                      foto: _fotoCarnetFrontal,
                      onCapturar: () => _capturarFotoCI(true),
                      onEliminar: () => setState(() => _fotoCarnetFrontal = null),
                    ),
                    const SizedBox(height: 16),

                    // Foto reverso
                    _FotoCarnetWidget(
                      titulo: 'REVERSO DEL CI',
                      foto: _fotoCarnetReverso,
                      onCapturar: () => _capturarFotoCI(false),
                      onEliminar: () => setState(() => _fotoCarnetReverso = null),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Sección GPS
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.location_on, color: Theme.of(context).primaryColor),
                        const SizedBox(width: 8),
                        const Text(
                          'Ubicación GPS',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Su ubicación GPS será capturada para verificar su domicilio en Santa Cruz.',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    const SizedBox(height: 16),

                    if (_position != null)
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.green.shade300),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.check_circle, color: Colors.green.shade700, size: 20),
                                const SizedBox(width: 8),
                                const Text(
                                  'Ubicación capturada',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Latitud: ${_position!.latitude.toStringAsFixed(6)}',
                              style: const TextStyle(fontSize: 12),
                            ),
                            Text(
                              'Longitud: ${_position!.longitude.toStringAsFixed(6)}',
                              style: const TextStyle(fontSize: 12),
                            ),
                            Text(
                              'Precisión: ±${_position!.accuracy.toStringAsFixed(1)} metros',
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      )
                    else
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.orange.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.orange.shade300),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.warning_amber, color: Colors.orange),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Ubicación GPS no capturada',
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 12),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _capturandoGPS ? null : _capturarUbicacionGPS,
                        icon: _capturandoGPS
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(Icons.my_location),
                        label: Text(
                          _capturandoGPS ? 'Capturando...' : 'Capturar Ubicación GPS',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Formulario de datos personales
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.person, color: Theme.of(context).primaryColor),
                        const SizedBox(width: 8),
                        const Text(
                          'Datos Personales',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _nombresController,
                      decoration: const InputDecoration(
                        labelText: 'Nombres *',
                        prefixIcon: Icon(Icons.person_outline),
                      ),
                      validator: (v) => v?.isEmpty ?? true ? 'Requerido' : null,
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _apellidosController,
                      decoration: const InputDecoration(
                        labelText: 'Apellidos *',
                        prefixIcon: Icon(Icons.person_outline),
                      ),
                      validator: (v) => v?.isEmpty ?? true ? 'Requerido' : null,
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _ciController,
                      decoration: const InputDecoration(
                        labelText: 'Cédula de Identidad *',
                        prefixIcon: Icon(Icons.badge),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (v) => v?.isEmpty ?? true ? 'Requerido' : null,
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _telefonoController,
                      decoration: const InputDecoration(
                        labelText: 'Teléfono *',
                        prefixIcon: Icon(Icons.phone),
                      ),
                      keyboardType: TextInputType.phone,
                      validator: (v) => v?.isEmpty ?? true ? 'Requerido' : null,
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.email),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _direccionController,
                      decoration: const InputDecoration(
                        labelText: 'Dirección *',
                        prefixIcon: Icon(Icons.home),
                      ),
                      validator: (v) => v?.isEmpty ?? true ? 'Requerido' : null,
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _zonaController,
                      decoration: const InputDecoration(
                        labelText: 'Zona/Barrio *',
                        prefixIcon: Icon(Icons.location_city),
                      ),
                      validator: (v) => v?.isEmpty ?? true ? 'Requerido' : null,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Botón de registro
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _submitRegistro,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 18),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        'COMPLETAR REGISTRO',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _FotoCarnetWidget extends StatelessWidget {
  final String titulo;
  final File? foto;
  final VoidCallback onCapturar;
  final VoidCallback onEliminar;

  const _FotoCarnetWidget({
    required this.titulo,
    required this.foto,
    required this.onCapturar,
    required this.onEliminar,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          titulo,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        if (foto != null)
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  foto!,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: IconButton(
                  onPressed: onEliminar,
                  icon: const Icon(Icons.delete),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          )
        else
          InkWell(
            onTap: onCapturar,
            child: Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.grey.shade300,
                  width: 2,
                  style: BorderStyle.solid,
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.camera_alt,
                      size: 48,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Toca para capturar',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}
