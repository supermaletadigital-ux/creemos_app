import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../config/app_config.dart';

final appConfigProvider = StateNotifierProvider<AppConfigNotifier, AppConfig>((ref) {
  return AppConfigNotifier();
});

class AppConfigNotifier extends StateNotifier<AppConfig> {
  AppConfigNotifier() : super(const AppConfig()) {
    _loadConfig();
  }

  Future<void> _loadConfig() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final configJson = prefs.getString('app_config');
      
      if (configJson != null) {
        final config = AppConfig.fromJson(json.decode(configJson));
        state = config;
      }
    } catch (e) {
      // Use default config if loading fails
    }
  }

  Future<void> updateConfig(AppConfig newConfig) async {
    state = newConfig;
    
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('app_config', json.encode(newConfig.toJson()));
    } catch (e) {
      // Handle error
    }
  }

  Future<void> resetToDefault() async {
    state = const AppConfig();
    
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('app_config');
    } catch (e) {
      // Handle error
    }
  }
}
