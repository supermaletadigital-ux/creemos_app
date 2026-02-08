# Creemos Santa Cruz - Aplicación Oficial

Aplicación móvil completa para verificación y gestión de militantes del partido político Creemos en Santa Cruz, Bolivia.

## 🚀 Características Principales

### ✅ Sistema de Consentimiento Legal
- **Acuerdo informado** con 4 checkboxes detallados:
  - Términos y condiciones con declaración jurada
  - Autorización para captura de CI de alta calidad
  - Autorización GPS de alta precisión
  - Autorización de tratamiento de datos personales
- Cumplimiento normativa boliviana (Ley 164, Código Penal Art. 198)

### 📸 Registro Completo de Militantes
- **Captura CI profesional:**
  - Alta resolución (1920px, calidad 100%)
  - Flash automático para máxima nitidez
  - Frente y reverso del carnet
  - Detalles verificables (foto, número, firma)
- **Ubicación GPS de alta precisión:**
  - LocationAccuracy.best
  - Precisión en metros
  - Timestamp de captura
  - Validación de domicilio en Santa Cruz

### 📰 Feed de Noticias Estilo Facebook
- Posts con texto enriquecido
- Carrusel de imágenes con swipe
- Reproductor de video integrado
- Visor de documentos PDF
- Likes, comentarios y compartir

### ⚖️ Asistente Legal "Patria Asesora"
- **Base de conocimientos completa:**
  - Constitución Política del Estado (CPE Art. 21, 130)
  - Ley 026 (Régimen Electoral) - Art. 47, 52
  - Ley 1096 (Partidos Políticos)
  - Decretos Supremos (DS 2026, 29894, 1214)
  - Resoluciones TSE
- **Tutoriales paso a paso:**
  - Inscripción de candidaturas
  - Registro de partidos
  - Propaganda electoral
- **Citas exactas de artículos** con fuente oficial

### 🎨 Panel de Administración Completo
- **Configuración de colores:**
  - Color primario (naranja-rojo Creemos #FF6B35)
  - Color secundario (azul #1E3A8A)
  - Color de acento
- **Tipografía personalizable:**
  - Familia: Poppins / Roboto
  - Tamaño de fuente ajustable (12-20pt)
- **Efectos visuales:**
  - Modo neón glow (bordes y sombras brillantes)
  - Desenfoque de fondo ajustable (0-20px)
  - Overlay semitransparente configurable
- **Vista previa en tiempo real**
- **Persistencia con SharedPreferences**

## 📋 Requisitos del Sistema

- Flutter SDK >= 3.0.0
- Dart SDK >= 3.0.0
- Android Studio / VS Code
- Firebase Project configurado

## 🔧 Instalación

### 1. Clonar el repositorio
```bash
git clone <repository-url>
cd creemos_app
```

### 2. Instalar dependencias
```bash
flutter pub get
```

### 3. Configurar Firebase

#### Android
1. Ir a [Firebase Console](https://console.firebase.google.com/)
2. Crear proyecto "Creemos Santa Cruz"
3. Añadir app Android con package: `com.creemos.santacruz`
4. Descargar `google-services.json`
5. Colocar en `android/app/google-services.json`

#### Habilitar servicios Firebase:
- **Authentication:** Email/Password
- **Cloud Firestore:** Modo producción
- **Storage:** Modo producción

#### Reglas de Firestore:
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /militantes/{document=**} {
      allow read, write: if request.auth != null;
    }
    match /news/{document=**} {
      allow read: if true;
      allow write: if request.auth != null;
    }
  }
}
```

#### Reglas de Storage:
```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /militantes/{ci}/{allPaths=**} {
      allow read, write: if request.auth != null;
    }
  }
}
```

### 4. Ejecutar la aplicación
```bash
flutter run
```

## 📁 Estructura del Proyecto

```
lib/
├── config/
│   └── app_config.dart              # Configuración de tema
├── models/
│   ├── militante.dart                # Modelo de militante
│   └── news_post.dart                # Modelo de noticias
├── providers/
│   ├── auth_provider.dart            # Autenticación
│   ├── config_provider.dart          # Estado del tema
│   └── router_provider.dart          # Navegación
├── screens/
│   ├── acuerdo_screen.dart           # Consentimiento legal
│   ├── registro_screen.dart          # Registro con CI y GPS
│   ├── login_screen.dart             # Autenticación
│   ├── home_screen.dart              # Menú principal
│   ├── news_feed_screen.dart         # Feed de noticias
│   ├── admin_panel_screen.dart       # Panel admin
│   ├── patria_asesora_screen.dart    # Asistente legal
│   └── militantes_screen.dart        # Lista de militantes
├── services/
│   └── registro_service.dart         # Lógica Firebase
└── main.dart                          # Entry point
```

## 🎯 Flujo de Usuario

1. **Inicio:** Pantalla de Acuerdo Legal
2. **Consentimiento:** Aceptar 4 checkboxes obligatorios
3. **Registro:**
   - Capturar CI (frente y reverso)
   - Capturar ubicación GPS
   - Completar formulario de datos
4. **Login:** Autenticación con Firebase
5. **Home:** Menú con 4 opciones
   - Noticias
   - Patria Asesora (Legal)
   - Militantes
   - Admin (Configuración)

## 🔐 Seguridad y Privacidad

### Datos Capturados:
- **CI:** Almacenado en Firebase Storage (privado)
- **GPS:** Precisión de metros, timestamp registrado
- **Consentimientos:** 4 autorizaciones granulares

### Cumplimiento Normativo:
- Ley N° 164 (Telecomunicaciones y TIC)
- Código Penal Art. 198 (Falsedad ideológica)
- Protección de datos personales

### Revocación:
- GPS puede ser revocado contactando admins
- Datos personales pueden solicitarse eliminación
- Sistema de expulsión por falsedad

## 🎨 Personalización del Tema

El administrador puede personalizar:
- Colores (primario, secundario, acento)
- Fuente (Poppins o Roboto)
- Tamaño de texto
- Efectos neón glow
- Fondo con desenfoque
- Overlay semitransparente

Los cambios se guardan en `SharedPreferences` y persisten entre sesiones.

## 📱 Permisos Requeridos

### Android (`AndroidManifest.xml`):
- `INTERNET` - Conexión Firebase
- `CAMERA` - Captura de CI
- `ACCESS_FINE_LOCATION` - GPS preciso
- `ACCESS_COARSE_LOCATION` - GPS aproximado
- `READ_EXTERNAL_STORAGE` - Leer imágenes
- `WRITE_EXTERNAL_STORAGE` - Guardar capturas

## 🚀 Compilación para Producción

### APK Android:
```bash
flutter build apk --release
```

El APK estará en: `build/app/outputs/flutter-apk/app-release.apk`

### App Bundle (Google Play):
```bash
flutter build appbundle --release
```

## 🧪 Testing

```bash
# Unit tests
flutter test

# Integration tests
flutter test integration_test/
```

## 📚 Documentación Legal Incluida

### Patria Asesora contiene:
- **CPE:** Artículos 21, 130 (derechos políticos)
- **Ley 026:** Artículos 47, 52 (inscripción, propaganda)
- **Ley 1096:** Partidos políticos y democracia interna
- **Decretos:** DS 2026, 29894, 1214
- **TSE:** Resoluciones y procedimientos

### Tutoriales paso a paso:
- Inscripción de candidaturas (5 pasos)
- Registro de partidos políticos
- Propaganda electoral
- Recursos y apelaciones

## 🤝 Soporte

Para consultas técnicas:
- Email: soporte@creemos.bo
- Web: www.creemos.org.bo

## 📄 Licencia

Propiedad de Creemos - Santa Cruz, Bolivia

---

**Desarrollado con ❤️ para Creemos Santa Cruz**

*Versión 1.0.0 - 2025*
