import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/discipline.dart';

class StorageService {
  static const String _disciplinesKey = 'disciplines_data_v1';
  static const String _themeModeKey = 'app_theme_mode_v1';

  /// Loads all saved disciplines. Returns empty list if none saved.
  Future<List<Discipline>> loadDisciplines() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_disciplinesKey);
      if (jsonString == null || jsonString.isEmpty) {
        return [];
      }
      final List<dynamic> list = jsonDecode(jsonString);
      return list
          .map((item) => Discipline.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      debugPrint('Error loading disciplines: $e');
      return [];
    }
  }

  /// Saves the entire list of disciplines locally.
  Future<bool> saveDisciplines(List<Discipline> disciplines) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonList = disciplines.map((d) => d.toJson()).toList();
      final jsonString = jsonEncode(jsonList);
      return await prefs.setString(_disciplinesKey, jsonString);
    } catch (e) {
      debugPrint('Error saving disciplines: $e');
      return false;
    }
  }

  /// Loads the theme mode. Default is light per specification.
  Future<ThemeMode> loadThemeMode() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final modeStr = prefs.getString(_themeModeKey);
      if (modeStr == 'dark') {
        return ThemeMode.dark;
      }
      return ThemeMode.light;
    } catch (e) {
      debugPrint('Error loading theme mode: $e');
      return ThemeMode.light;
    }
  }

  /// Saves the user's theme mode preference.
  Future<bool> saveThemeMode(ThemeMode mode) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.setString(
        _themeModeKey,
        mode == ThemeMode.dark ? 'dark' : 'light',
      );
    } catch (e) {
      debugPrint('Error saving theme mode: $e');
      return false;
    }
  }

  /// Export backup JSON string for future export/import support
  Future<String> exportBackup(List<Discipline> disciplines) async {
    final data = {
      'version': 1,
      'exportedAt': DateTime.now().toIso8601String(),
      'disciplines': disciplines.map((d) => d.toJson()).toList(),
    };
    return jsonEncode(data);
  }
}
