import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/config_provider.dart';
import '../config/app_config.dart';

class AdminPanelScreen extends ConsumerStatefulWidget {
  const AdminPanelScreen({super.key});

  @override
  ConsumerState<AdminPanelScreen> createState() => _AdminPanelScreenState();
}

class _AdminPanelScreenState extends ConsumerState<AdminPanelScreen> {
  late Color _primaryColor;
  late Color _secondaryColor;
  late Color _accentColor;
  late String _fontFamily;
  late double _fontSize;
  late bool _neonGlow;
  late double _backgroundBlur;
  late Color _overlayColor;

  @override
  void initState() {
    super.initState();
    final config = ref.read(appConfigProvider);
    _primaryColor = config.primaryColor;
    _secondaryColor = config.secondaryColor;
    _accentColor = config.accentColor;
    _fontFamily = config.fontFamily;
    _fontSize = config.fontSize;
    _neonGlow = config.neonGlow;
    _backgroundBlur = config.backgroundBlur;
    _overlayColor = config.overlayColor;
  }

  void _guardarCambios() {
    final newConfig = AppConfig(
      primaryColor: _primaryColor,
      secondaryColor: _secondaryColor,
      accentColor: _accentColor,
      fontFamily: _fontFamily,
      fontSize: _fontSize,
      neonGlow: _neonGlow,
      backgroundBlur: _backgroundBlur,
      overlayColor: _overlayColor,
    );

    ref.read(appConfigProvider.notifier).updateConfig(newConfig);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Configuración guardada exitosamente'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _restaurarDefecto() {
    ref.read(appConfigProvider.notifier).resetToDefault();
    
    setState(() {
      const config = AppConfig();
      _primaryColor = config.primaryColor;
      _secondaryColor = config.secondaryColor;
      _accentColor = config.accentColor;
      _fontFamily = config.fontFamily;
      _fontSize = config.fontSize;
      _neonGlow = config.neonGlow;
      _backgroundBlur = config.backgroundBlur;
      _overlayColor = config.overlayColor;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Configuración restaurada a valores por defecto'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Panel de Administración'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _restaurarDefecto,
            tooltip: 'Restaurar valores por defecto',
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Sección: Colores
          _SectionHeader(
            icon: Icons.palette,
            title: 'Colores del Tema',
          ),
          const SizedBox(height: 16),

          _ColorPickerTile(
            title: 'Color Primario',
            subtitle: 'Color principal de la aplicación',
            color: _primaryColor,
            onColorChanged: (color) => setState(() => _primaryColor = color),
          ),
          const SizedBox(height: 12),

          _ColorPickerTile(
            title: 'Color Secundario',
            subtitle: 'Color secundario y detalles',
            color: _secondaryColor,
            onColorChanged: (color) => setState(() => _secondaryColor = color),
          ),
          const SizedBox(height: 12),

          _ColorPickerTile(
            title: 'Color de Acento',
            subtitle: 'Color para resaltar elementos',
            color: _accentColor,
            onColorChanged: (color) => setState(() => _accentColor = color),
          ),
          const SizedBox(height: 24),

          // Sección: Tipografía
          _SectionHeader(
            icon: Icons.text_fields,
            title: 'Tipografía',
          ),
          const SizedBox(height: 16),

          Card(
            child: Column(
              children: [
                ListTile(
                  title: const Text('Familia de Fuente'),
                  subtitle: Text(_fontFamily),
                  trailing: DropdownButton<String>(
                    value: _fontFamily,
                    items: const [
                      DropdownMenuItem(value: 'Poppins', child: Text('Poppins')),
                      DropdownMenuItem(value: 'Roboto', child: Text('Roboto')),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => _fontFamily = value);
                      }
                    },
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  title: const Text('Tamaño de Fuente'),
                  subtitle: Text('${_fontSize.toStringAsFixed(0)} pt'),
                ),
                Slider(
                  value: _fontSize,
                  min: 12,
                  max: 20,
                  divisions: 8,
                  label: _fontSize.toStringAsFixed(0),
                  onChanged: (value) => setState(() => _fontSize = value),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Sección: Efectos Visuales
          _SectionHeader(
            icon: Icons.auto_awesome,
            title: 'Efectos Visuales',
          ),
          const SizedBox(height: 16),

          Card(
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('Efecto Neón Glow'),
                  subtitle: const Text('Añade brillo neón a botones y bordes'),
                  value: _neonGlow,
                  onChanged: (value) => setState(() => _neonGlow = value),
                ),
                const Divider(height: 1),
                ListTile(
                  title: const Text('Desenfoque de Fondo'),
                  subtitle: Text('${_backgroundBlur.toStringAsFixed(0)} px'),
                ),
                Slider(
                  value: _backgroundBlur,
                  min: 0,
                  max: 20,
                  divisions: 20,
                  label: _backgroundBlur.toStringAsFixed(0),
                  onChanged: (value) => setState(() => _backgroundBlur = value),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Sección: Overlay
          _SectionHeader(
            icon: Icons.layers,
            title: 'Capa de Overlay',
          ),
          const SizedBox(height: 16),

          _ColorPickerTile(
            title: 'Color de Overlay',
            subtitle: 'Capa semi-transparente sobre fondos',
            color: _overlayColor,
            onColorChanged: (color) => setState(() => _overlayColor = color),
            showOpacity: true,
          ),
          const SizedBox(height: 32),

          // Vista Previa
          Card(
            color: Colors.blue.shade50,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.visibility, color: Colors.blue.shade700),
                      const SizedBox(width: 8),
                      Text(
                        'Vista Previa',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade900,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: _primaryColor,
                      borderRadius: BorderRadius.circular(12),
                      border: _neonGlow
                          ? Border.all(color: _accentColor, width: 2)
                          : null,
                      boxShadow: _neonGlow
                          ? [
                              BoxShadow(
                                color: _accentColor.withOpacity(0.5),
                                blurRadius: 8,
                                spreadRadius: 2,
                              ),
                            ]
                          : null,
                    ),
                    child: Text(
                      'Botón de ejemplo',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: _fontSize,
                        fontFamily: _fontFamily,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),

          // Botones de acción
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _restaurarDefecto,
                  child: const Text('RESTAURAR'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: _guardarCambios,
                  child: const Text('GUARDAR CAMBIOS'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;

  const _SectionHeader({
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Theme.of(context).primaryColor),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class _ColorPickerTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color color;
  final ValueChanged<Color> onColorChanged;
  final bool showOpacity;

  const _ColorPickerTile({
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onColorChanged,
    this.showOpacity = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: GestureDetector(
          onTap: () => _showColorPicker(context),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color,
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
    );
  }

  void _showColorPicker(BuildContext context) {
    final colors = [
      const Color(0xFFFF6B35), // Naranja Creemos
      const Color(0xFF1E3A8A), // Azul
      const Color(0xFFFFA726), // Naranja claro
      const Color(0xFFEF5350), // Rojo
      const Color(0xFF66BB6A), // Verde
      const Color(0xFF42A5F5), // Azul claro
      const Color(0xFFAB47BC), // Púrpura
      const Color(0xFF26A69A), // Teal
    ];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: colors.map((c) {
            return GestureDetector(
              onTap: () {
                onColorChanged(c);
                Navigator.pop(context);
              },
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: c,
                  border: Border.all(
                    color: c == color ? Colors.black : Colors.grey,
                    width: c == color ? 3 : 1,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: c == color
                    ? const Icon(Icons.check, color: Colors.white)
                    : null,
              ),
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCELAR'),
          ),
        ],
      ),
    );
  }
}
