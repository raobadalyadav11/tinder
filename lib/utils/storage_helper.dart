import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/user_model.dart';

class StorageHelper {
  static final Map<String, dynamic> _storage = {};

  static Future<void> saveToken(String token) async {
    _storage['auth_token'] = token;
  }

  static Future<String?> getToken() async {
    return _storage['auth_token'];
  }

  static Future<void> saveUser(UserModel user) async {
    _storage['current_user'] = jsonEncode(user.toJson());
  }

  static Future<UserModel?> getUser() async {
    final userJson = _storage['current_user'];
    if (userJson != null) {
      return UserModel.fromJson(jsonDecode(userJson));
    }
    return null;
  }

  static Future<void> saveSettings(Map<String, dynamic> settings) async {
    _storage['app_settings'] = jsonEncode(settings);
  }

  static Future<Map<String, dynamic>> getSettings() async {
    final settingsJson = _storage['app_settings'];
    if (settingsJson != null) {
      return Map<String, dynamic>.from(jsonDecode(settingsJson));
    }
    return {};
  }

  static Future<void> saveThemeMode(ThemeMode themeMode) async {
    _storage['theme_mode'] = themeMode.index;
  }

  static Future<ThemeMode> getThemeMode() async {
    final index = _storage['theme_mode'];
    if (index != null) {
      return ThemeMode.values[index];
    }
    return ThemeMode.system;
  }

  static Future<void> clearAll() async {
    _storage.clear();
  }

  static Future<void> remove(String key) async {
    _storage.remove(key);
  }
}