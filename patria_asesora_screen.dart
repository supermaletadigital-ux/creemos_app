import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final chatMessagesProvider = StateProvider<List<ChatMessage>>((ref) {
  return [
    ChatMessage(
      text: '¡Hola! Soy Patria Asesora, tu asistente legal especializada en normativa electoral boliviana. Puedo ayudarte con consultas sobre:\n\n• Constitución Política del Estado (CPE)\n• Ley del Régimen Electoral (Ley 026)\n• Ley de Partidos Políticos (Ley 1096)\n• Decretos Supremos electorales\n• Resoluciones del TSE\n• Procedimientos electorales\n\n¿En qué puedo ayudarte hoy?',
      isUser: false,
      timestamp: DateTime.now(),
    ),
  ];
});

class PatriaAsesoraScreen extends ConsumerStatefulWidget {
  const PatriaAsesoraScreen({super.key});

  @override
  ConsumerState<PatriaAsesoraScreen> createState() => _PatriaAsesoraScreenState();
}

class _PatriaAsesoraScreenState extends ConsumerState<PatriaAsesoraScreen> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    final messages = ref.read(chatMessagesProvider);
    ref.read(chatMessagesProvider.notifier).state = [
      ...messages,
      ChatMessage(text: text, isUser: true, timestamp: DateTime.now()),
    ];

    _messageController.clear();

    // Simular respuesta del asistente
    Future.delayed(const Duration(seconds: 1), () {
      final response = _getAssistantResponse(text);
      final updatedMessages = ref.read(chatMessagesProvider);
      ref.read(chatMessagesProvider.notifier).state = [
        ...updatedMessages,
        ChatMessage(text: response, isUser: false, timestamp: DateTime.now()),
      ];

      // Scroll al final
      Future.delayed(const Duration(milliseconds: 100), () {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    });
  }

  String _getAssistantResponse(String query) {
    final lowerQuery = query.toLowerCase();

    if (lowerQuery.contains('cpe') || lowerQuery.contains('constitución')) {
      return '''📜 **Constitución Política del Estado (CPE)**

**Artículo 21** - Derechos políticos:
Las bolivianas y los bolivianos tienen los siguientes derechos políticos:
1. A la participación libre en la formación, ejercicio y control del poder político
2. A elegir y ser elegidos
3. A ejercer funciones políticas, de dirección y de administración pública

**Artículo 130** - Participación electoral:
El voto es universal, único, secreto, directo, individual, libre y obligatorio. Los ciudadanos bolivianos tienen derecho al sufragio activo y pasivo desde los 18 años cumplidos.

**Fuente:** Constitución Política del Estado Plurinacional de Bolivia (Promulgada el 7 de febrero de 2009)

¿Necesitas información sobre algún artículo específico?''';
    } else if (lowerQuery.contains('ley 026') || lowerQuery.contains('régimen electoral')) {
      return '''📋 **Ley del Régimen Electoral (Ley Nº 026)**

**Artículo 47** - Inscripción de candidaturas:
Las organizaciones políticas deberán inscribir sus candidaturas ante el Órgano Electoral con al menos 60 días de anticipación a la fecha de la elección.

Requisitos para candidatos:
• Certificado de militancia del partido político
• Declaración jurada de bienes y rentas
• No tener sentencia condenatoria ejecutoriada pendiente en materia penal
• Certificado de no estar inhabilitado para ejercer funciones públicas

**Artículo 52** - Propaganda electoral:
La propaganda electoral será permitida desde el momento de la inscripción de candidatos hasta 48 horas antes del día de la elección.

**Fuente:** Ley N° 026 del Régimen Electoral (Promulgada el 30 de junio de 2010)

Tutorial paso a paso: ¿Necesitas ayuda con algún procedimiento específico?''';
    } else if (lowerQuery.contains('ley 1096') || lowerQuery.contains('partidos políticos')) {
      return '''🏛️ **Ley de Partidos Políticos (Ley Nº 1096)**

Esta ley regula la constitución, funcionamiento y financiamiento de partidos políticos en Bolivia.

**Aspectos clave:**
• Requisitos para el registro de partidos políticos
• Derechos y obligaciones de los partidos
• Régimen de financiamiento
• Democracia interna y elecciones primarias
• Sanciones por incumplimiento

**Artículo 7** - Democracia interna:
Los partidos políticos deberán garantizar procesos de elección democrática de sus autoridades y candidatos.

**Fuente:** Ley N° 1096 de Organizaciones Políticas (Promulgada el 1 de septiembre de 2018)

¿Necesitas más detalles sobre algún aspecto específico?''';
    } else if (lowerQuery.contains('tse') || lowerQuery.contains('tribunal supremo electoral')) {
      return '''⚖️ **Tribunal Supremo Electoral (TSE)**

El TSE es el máximo organismo electoral en Bolivia y tiene las siguientes atribuciones:

**Principales funciones:**
• Administrar justicia electoral
• Organizar y administrar procesos electorales
• Fiscalizar el financiamiento político
• Llevar el Padrón Electoral
• Sancionar infracciones a la normativa electoral

**Resoluciones TSE:**
El TSE emite resoluciones obligatorias que regulan aspectos específicos de los procesos electorales.

**Página oficial:** www.oep.org.bo

¿Necesitas información sobre alguna resolución específica del TSE?''';
    } else if (lowerQuery.contains('decreto') || lowerQuery.contains('ds')) {
      return '''📑 **Decretos Supremos en materia electoral**

Los Decretos Supremos complementan y reglamentan las leyes electorales.

**Principales Decretos:**
• DS N° 29894 - Estructura Organizativa del Órgano Electoral
• DS N° 2026 - Reglamentación de propaganda electoral
• DS N° 1214 - Sobre financiamiento a partidos políticos

**Consulta de Decretos:**
Puedes consultar los decretos supremos en:
- Gaceta Oficial de Bolivia
- Portal del Órgano Electoral Plurinacional

¿Buscas información sobre algún decreto en particular?''';
    } else if (lowerQuery.contains('inscripción') || lowerQuery.contains('registro')) {
      return '''✅ **Tutorial: Procedimiento de inscripción de candidaturas**

**PASO 1: Preparación de documentos**
• Certificado de militancia
• Fotocopia de CI
• Declaración jurada de bienes
• Certificado judicial
• Programa de gobierno

**PASO 2: Registro en plataforma TSE**
• Ingresar a www.oep.org.bo
• Acceder con credenciales del partido
• Completar formulario de inscripción

**PASO 3: Presentación física**
• Llevar documentos al Tribunal Electoral Departamental
• Plazo: 60 días antes de la elección

**PASO 4: Verificación**
• El TSE verificará documentos en 15 días hábiles
• Se notificará observaciones si las hay

**PASO 5: Subsanación (si aplica)**
• 5 días para subsanar observaciones

**Base legal:** Ley 026, Artículo 47

¿Necesitas ayuda con algún paso específico?''';
    } else if (lowerQuery.contains('ayuda') || lowerQuery.contains('qué puedes hacer')) {
      return '''🤝 **¿En qué puedo ayudarte?**

Puedo asistirte con:

**📜 Normativa:**
• Constitución Política del Estado (CPE)
• Ley 026 (Régimen Electoral)
• Ley 1096 (Partidos Políticos)
• Decretos Supremos
• Resoluciones TSE

**📋 Procedimientos:**
• Inscripción de candidaturas
• Registro de partidos políticos
• Propaganda electoral
• Recursos y apelaciones

**⚖️ Consultas jurídicas:**
• Derechos políticos
• Obligaciones electorales
• Sanciones y multas

Puedes preguntarme sobre cualquier artículo específico o procedimiento electoral. ¡Estoy aquí para ayudarte!''';
    } else {
      return '''Entiendo tu consulta sobre "${query.length > 50 ? query.substring(0, 50) + '...' : query}".

Para darte una respuesta precisa, puedo ayudarte con:

• **Citas de artículos** específicos de la CPE, Ley 026, Ley 1096
• **Procedimientos paso a paso** para trámites electorales
• **Consultas sobre** derechos políticos y obligaciones electorales

¿Podrías reformular tu pregunta o indicarme sobre qué aspecto específico de la normativa electoral boliviana necesitas información?

Ejemplos:
- "¿Qué dice el artículo 21 de la CPE?"
- "¿Cómo se inscriben candidaturas?"
- "¿Cuáles son los requisitos para ser candidato?"''';
    }
  }

  @override
  Widget build(BuildContext context) {
    final messages = ref.watch(chatMessagesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Patria Asesora'),
            Text(
              'Asistente Legal Electoral',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.read(chatMessagesProvider.notifier).state = [
                ChatMessage(
                  text: '¡Hola! Soy Patria Asesora. ¿En qué puedo ayudarte hoy?',
                  isUser: false,
                  timestamp: DateTime.now(),
                ),
              ];
            },
            tooltip: 'Reiniciar conversación',
          ),
        ],
      ),
      body: Column(
        children: [
          // Área de mensajes
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                return _MessageBubble(message: message);
              },
            ),
          ),

          // Área de input
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Escribe tu consulta legal...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                    ),
                    maxLines: null,
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                FloatingActionButton(
                  onPressed: _sendMessage,
                  mini: true,
                  child: const Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}

class _MessageBubble extends StatelessWidget {
  final ChatMessage message;

  const _MessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment:
            message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!message.isUser) ...[
            CircleAvatar(
              backgroundColor: Theme.of(context).primaryColor,
              child: const Icon(Icons.gavel, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: message.isUser
                    ? Theme.of(context).primaryColor
                    : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.text,
                    style: TextStyle(
                      color: message.isUser ? Colors.white : Colors.black87,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${message.timestamp.hour}:${message.timestamp.minute.toString().padLeft(2, '0')}',
                    style: TextStyle(
                      fontSize: 10,
                      color: message.isUser
                          ? Colors.white.withOpacity(0.7)
                          : Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (message.isUser) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              backgroundColor: Colors.blue,
              child: const Icon(Icons.person, color: Colors.white, size: 20),
            ),
          ],
        ],
      ),
    );
  }
}
