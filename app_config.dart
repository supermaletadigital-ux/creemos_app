import 'package:flutter/material.dart';

class AppConfig {
  final Color primaryColor;
  final Color secondaryColor;
  final Color accentColor;
  final String fontFamily;
  final double fontSize;
  final bool neonGlow;
  final String? backgroundImage;
  final String? backgroundVideo;
  final double backgroundBlur;
  final Color overlayColor;
  
  const AppConfig({
    this.primaryColor = const Color(0xFFFF6B35), // Naranja-Rojo Creemos
    this.secondaryColor = const Color(0xFF1E3A8A), // Azul
    this.accentColor = const Color(0xFFFFA726), // Naranja Acento
    this.fontFamily = 'Poppins',
    this.fontSize = 16.0,
    this.neonGlow = false,
    this.backgroundImage,
    this.backgroundVideo,
    this.backgroundBlur = 10.0,
    this.overlayColor = const Color(0x80000080), // Azul oscuro semi-transparente
  });

  AppConfig copyWith({
    Color? primaryColor,
    Color? secondaryColor,
    Color? accentColor,
    String? fontFamily,
    double? fontSize,
    bool? neonGlow,
    String? backgroundImage,
    String? backgroundVideo,
    double? backgroundBlur,
    Color? overlayColor,
  }) {
    return AppConfig(
      primaryColor: primaryColor ?? this.primaryColor,
      secondaryColor: secondaryColor ?? this.secondaryColor,
      accentColor: accentColor ?? this.accentColor,
      fontFamily: fontFamily ?? this.fontFamily,
      fontSize: fontSize ?? this.fontSize,
      neonGlow: neonGlow ?? this.neonGlow,
      backgroundImage: backgroundImage ?? this.backgroundImage,
      backgroundVideo: backgroundVideo ?? this.backgroundVideo,
      backgroundBlur: backgroundBlur ?? this.backgroundBlur,
      overlayColor: overlayColor ?? this.overlayColor,
    );
  }

  ThemeData toThemeData() {
    return ThemeData(
      primaryColor: primaryColor,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        secondary: secondaryColor,
      ),
      fontFamily: fontFamily,
      textTheme: TextTheme(
        bodyLarge: TextStyle(fontSize: fontSize),
        bodyMedium: TextStyle(fontSize: fontSize - 2),
        bodySmall: TextStyle(fontSize: fontSize - 4),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: neonGlow 
              ? BorderSide(color: accentColor, width: 2)
              : BorderSide.none,
          ),
          elevation: neonGlow ? 8 : 2,
          shadowColor: neonGlow ? accentColor.withOpacity(0.5) : null,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: neonGlow ? accentColor : Colors.grey.shade300,
            width: neonGlow ? 2 : 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: neonGlow ? accentColor.withOpacity(0.5) : Colors.grey.shade300,
            width: neonGlow ? 2 : 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: primaryColor,
            width: 2,
          ),
        ),
      ),
      cardTheme: CardTheme(
        elevation: neonGlow ? 8 : 2,
        shadowColor: neonGlow ? accentColor.withOpacity(0.3) : null,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: neonGlow 
            ? BorderSide(color: accentColor.withOpacity(0.3), width: 1)
            : BorderSide.none,
        ),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'primaryColor': primaryColor.value,
      'secondaryColor': secondaryColor.value,
      'accentColor': accentColor.value,
      'fontFamily': fontFamily,
      'fontSize': fontSize,
      'neonGlow': neonGlow,
      'backgroundImage': backgroundImage,
      'backgroundVideo': backgroundVideo,
      'backgroundBlur': backgroundBlur,
      'overlayColor': overlayColor.value,
    };
  }

  factory AppConfig.fromJson(Map<String, dynamic> json) {
    return AppConfig(
      primaryColor: Color(json['primaryColor'] ?? 0xFFFF6B35),
      secondaryColor: Color(json['secondaryColor'] ?? 0xFF1E3A8A),
      accentColor: Color(json['accentColor'] ?? 0xFFFFA726),
      fontFamily: json['fontFamily'] ?? 'Poppins',
      fontSize: json['fontSize'] ?? 16.0,
      neonGlow: json['neonGlow'] ?? false,
      backgroundImage: json['backgroundImage'],
      backgroundVideo: json['backgroundVideo'],
      backgroundBlur: json['backgroundBlur'] ?? 10.0,
      overlayColor: Color(json['overlayColor'] ?? 0x80000080),
    );
  }
}
