import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final consentimientosProvider = StateProvider<Map<String, bool>>((ref) {
  return {
    'terminos': false,
    'fotoCI': false,
    'gps': false,
    'datos': false,
  };
});

class AcuerdoScreen extends ConsumerWidget {
  const AcuerdoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final consentimientos = ref.watch(consentimientosProvider);
    final todosAceptados = consentimientos.values.every((v) => v == true);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).primaryColor,
              Theme.of(context).primaryColor.withOpacity(0.7),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header con logo
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Text(
                          'C',
                          style: TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFFF6B35),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'CREEMOS',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 4,
                      ),
                    ),
                    const Text(
                      'Santa Cruz',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
              ),

              // Contenido scrollable
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Consentimiento Informado',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Para continuar con el registro como militante de Creemos Santa Cruz, es necesario que acepte los siguientes términos:',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Checkbox 1: Términos generales
                        _ConsentCheckbox(
                          value: consentimientos['terminos']!,
                          onChanged: (value) {
                            ref.read(consentimientosProvider.notifier).state = {
                              ...consentimientos,
                              'terminos': value ?? false,
                            };
                          },
                          title: 'Acepto los términos y condiciones',
                          description:
                              'Declaro bajo juramento que soy militante activo del partido político Creemos. Entiendo que cualquier falsedad en mi declaración será de mi exclusiva responsabilidad y podrá resultar en acciones legales según las leyes bolivianas (Código Penal, Art. 198 - Falsedad ideológica).',
                        ),
                        const SizedBox(height: 16),

                        // Checkbox 2: Foto CI
                        _ConsentCheckbox(
                          value: consentimientos['fotoCI']!,
                          onChanged: (value) {
                            ref.read(consentimientosProvider.notifier).state = {
                              ...consentimientos,
                              'fotoCI': value ?? false,
                            };
                          },
                          title: 'Autorizo captura fotográfica de mi Cédula de Identidad',
                          description:
                              'Autorizo la captura de fotografías de alta definición de mi Cédula de Identidad (frente y reverso) para verificación de identidad. Las imágenes incluirán detalles nítidos de mi fotografía, número de CI, y demás datos personales. Estas imágenes serán almacenadas de forma segura y utilizadas exclusivamente para verificación interna del partido.',
                        ),
                        const SizedBox(height: 16),

                        // Checkbox 3: GPS
                        _ConsentCheckbox(
                          value: consentimientos['gps']!,
                          onChanged: (value) {
                            ref.read(consentimientosProvider.notifier).state = {
                              ...consentimientos,
                              'gps': value ?? false,
                            };
                          },
                          title: 'Autorizo captura de mi ubicación GPS',
                          description:
                              'Autorizo la captura de mi ubicación GPS de alta precisión (latitud/longitud) en el momento del registro para verificar mi domicilio en Santa Cruz. Esta información será utilizada para validar mi residencia en el departamento y podrá ser revocada en cualquier momento contactando a los administradores del sistema.',
                        ),
                        const SizedBox(height: 16),

                        // Checkbox 4: Tratamiento de datos
                        _ConsentCheckbox(
                          value: consentimientos['datos']!,
                          onChanged: (value) {
                            ref.read(consentimientosProvider.notifier).state = {
                              ...consentimientos,
                              'datos': value ?? false,
                            };
                          },
                          title: 'Autorizo el tratamiento de mis datos personales',
                          description:
                              'Autorizo el tratamiento de mis datos personales para fines de gestión interna del partido, incluyendo: (1) Verificación de militancia, (2) Comunicaciones oficiales, (3) Procesos electorales internos, (4) Expulsión en caso de falsedad de información. Entiendo que mis datos serán parte de una lista de administración interna con medidas de seguridad. Puedo solicitar la revocación de esta autorización en cualquier momento.',
                        ),
                        const SizedBox(height: 24),

                        // Aviso legal
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.orange.shade50,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.orange.shade200),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(Icons.info_outline, color: Colors.orange.shade700),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Protección de Datos',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.orange.shade900,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Tus datos están protegidos según la normativa boliviana. Ley N° 164 de Telecomunicaciones y TIC, garantiza tu derecho a la privacidad y protección de datos personales.',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.orange.shade700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 32),

                        // Botón continuar
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: todosAceptados
                                ? () => context.push('/registro')
                                : null,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              backgroundColor: todosAceptados
                                  ? Theme.of(context).primaryColor
                                  : Colors.grey,
                            ),
                            child: Text(
                              todosAceptados
                                  ? 'CONTINUAR AL REGISTRO'
                                  : 'DEBE ACEPTAR TODOS LOS TÉRMINOS',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ConsentCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?> onChanged;
  final String title;
  final String description;

  const _ConsentCheckbox({
    required this.value,
    required this.onChanged,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: value ? Colors.green.shade50 : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: value ? Colors.green.shade300 : Colors.grey.shade300,
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Checkbox(
                value: value,
                onChanged: onChanged,
                activeColor: Theme.of(context).primaryColor,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 48, top: 8),
            child: Text(
              description,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[700],
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
