# 🚀 Guía Rápida de Inicio - Creemos Santa Cruz

## ⚡ Instalación en 5 Pasos

### 1️⃣ Requisitos Previos
- Flutter 3.0+ instalado
- Android Studio o VS Code
- Cuenta Firebase (gratuita)

### 2️⃣ Instalar Dependencias
```bash
cd creemos_app
flutter pub get
```

### 3️⃣ Configurar Firebase (5 minutos)

1. **Crear proyecto en Firebase:**
   - Ir a https://console.firebase.google.com/
   - Clic en "Agregar proyecto"
   - Nombre: "Creemos Santa Cruz"
   - Crear proyecto

2. **Configurar Android:**
   - En el proyecto Firebase, clic en ícono Android
   - Package name: `com.creemos.santacruz`
   - Descargar `google-services.json`
   - Colocar en: `android/app/google-services.json`

3. **Habilitar servicios:**
   - **Authentication:**
     - Ir a Authentication > Sign-in method
     - Habilitar "Email/Password"
   
   - **Firestore:**
     - Ir a Firestore Database
     - Crear base de datos (modo producción)
     - Ubicación: us-central1
   
   - **Storage:**
     - Ir a Storage
     - Comenzar (modo producción)

4. **Configurar reglas de seguridad:**

**Firestore:**
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /militantes/{document=**} {
      allow read, write: if request.auth != null;
    }
  }
}
```

**Storage:**
```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /militantes/{allPaths=**} {
      allow read, write: if request.auth != null;
    }
  }
}
```

### 4️⃣ Crear Usuario Administrador

En Firebase Console > Authentication > Users:
- Clic "Add user"
- Email: `admin@creemos.bo`
- Password: `Creemos2025!`
- Guardar

### 5️⃣ Ejecutar App

```bash
flutter run
```

## 📱 Primer Uso

1. **Acuerdo Legal:**
   - Aceptar los 4 checkboxes de consentimiento
   - Continuar al registro

2. **Registro de Militante:**
   - Capturar foto CI (frente y reverso)
   - Capturar ubicación GPS
   - Completar datos personales
   - Registrar

3. **Login:**
   - Email: `admin@creemos.bo`
   - Password: `Creemos2025!`

4. **Explorar:**
   - Noticias
   - Patria Asesora (asistente legal)
   - Militantes
   - Admin (personalizar tema)

## ⚙️ Personalización del Tema (Admin Panel)

1. Ir a Home > Admin
2. Configurar:
   - **Colores:** Primario, secundario, acento
   - **Fuente:** Poppins o Roboto
   - **Tamaño:** 12-20pt
   - **Efectos:** Neón glow, desenfoque
3. Ver vista previa
4. Guardar cambios

## 🎯 Características Principales

### ✅ Acuerdo Legal Completo
4 checkboxes granulares según normativa boliviana:
- Términos y condiciones (declaración jurada)
- Autorización foto CI alta calidad
- Autorización GPS alta precisión
- Autorización tratamiento de datos

### 📸 Registro Profesional
- **CI:** Alta resolución (1920px, 100% calidad)
- **GPS:** LocationAccuracy.best (precisión metros)
- **Datos:** Formulario completo validado

### 📰 Feed de Noticias
- Posts estilo Facebook
- Imágenes, videos, PDFs
- Likes y comentarios

### ⚖️ Patria Asesora
Asistente legal con conocimiento de:
- CPE (Art. 21, 130)
- Ley 026 (Art. 47, 52)
- Ley 1096
- Decretos Supremos
- Tutoriales paso a paso

## 🐛 Solución de Problemas

### Error: google-services.json no encontrado
**Solución:** Descarga el archivo de Firebase Console y colócalo en `android/app/`

### Error: Permisos denegados
**Solución:** Los permisos están en AndroidManifest.xml. Acepta cuando la app los solicite.

### Error de compilación
```bash
flutter clean
flutter pub get
flutter run
```

### App se cierra al capturar foto/GPS
**Solución:** Verifica que aceptaste los permisos de cámara y ubicación.

## 📦 Compilar para Producción

```bash
# APK para distribución
flutter build apk --release

# App Bundle para Google Play
flutter build appbundle --release
```

APK estará en: `build/app/outputs/flutter-apk/app-release.apk`

## 📞 Soporte

- Email: soporte@creemos.bo
- Web: www.creemos.org.bo

## ✅ Checklist de Funcionalidad

Después de la instalación, verifica:

- [ ] Acuerdo legal muestra 4 checkboxes
- [ ] Registro captura CI (frente y reverso)
- [ ] Registro captura GPS con precisión
- [ ] Login funciona con credenciales
- [ ] Feed de noticias carga
- [ ] Patria Asesora responde consultas
- [ ] Admin Panel permite cambiar colores
- [ ] Cambios de tema persisten al cerrar app

---

**¡Listo! Tu app Creemos está funcionando 🎉**

Para más detalles técnicos, consulta el README.md principal.
