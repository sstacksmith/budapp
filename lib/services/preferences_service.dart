import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static const String _themeModeKey = 'theme_mode';
  static const String _localeKey = 'locale';

  static final PreferencesService _instance = PreferencesService._internal();
  factory PreferencesService() => _instance;
  PreferencesService._internal();

  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> saveThemeMode(ThemeMode mode) async {
    await _prefs?.setString(_themeModeKey, mode.toString());
  }

  ThemeMode getThemeMode() {
    final String? modeString = _prefs?.getString(_themeModeKey);
    if (modeString == null) {
      return ThemeMode.system;
    }

    switch (modeString) {
      case 'ThemeMode.light':
        return ThemeMode.light;
      case 'ThemeMode.dark':
        return ThemeMode.dark;
      case 'ThemeMode.system':
      default:
        return ThemeMode.system;
    }
  }

  Future<void> saveLocale(Locale? locale) async {
    if (locale == null) {
      await _prefs?.remove(_localeKey);
    } else {
      await _prefs?.setString(_localeKey, locale.languageCode);
    }
  }

  Locale? getLocale() {
    final String? localeCode = _prefs?.getString(_localeKey);
    if (localeCode == null) {
      return null;
    }
    return Locale(localeCode);
  }

  // Clear all preferences
  Future<void> clearAll() async {
    await _prefs?.clear();
  }
}


