import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsData {
  final String namaUsaha;
  final String alamatUsaha;

  SettingsData({
    required this.namaUsaha,
    required this.alamatUsaha,
  });

  factory SettingsData.defaultSettings() {
    return SettingsData(
      namaUsaha: 'UpahKu',
      alamatUsaha: 'Offline Workshop Location',
    );
  }

  SettingsData copyWith({
    String? namaUsaha,
    String? alamatUsaha,
  }) {
    return SettingsData(
      namaUsaha: namaUsaha ?? this.namaUsaha,
      alamatUsaha: alamatUsaha ?? this.alamatUsaha,
    );
  }

  Map<String, dynamic> toJson() => {
        'namaUsaha': namaUsaha,
        'alamatUsaha': alamatUsaha,
      };

  factory SettingsData.fromJson(Map<String, dynamic> json) {
    return SettingsData(
      namaUsaha: json['namaUsaha'] ?? 'UpahKu',
      alamatUsaha: json['alamatUsaha'] ?? 'Offline Workshop Location',
    );
  }
}

class SettingsNotifier extends StateNotifier<SettingsData> {
  SettingsNotifier() : super(SettingsData.defaultSettings()) {
    loadSettings();
  }

  static const _keySettings = 'app_settings_data';

  Future<void> loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final content = prefs.getString(_keySettings);
      if (content != null) {
        final json = jsonDecode(content);
        state = SettingsData.fromJson(json);
      }
    } catch (e) {
      // Keep default settings
    }
  }

  Future<void> saveSettings({
    required String namaUsaha,
    required String alamatUsaha,
  }) async {
    final updated = state.copyWith(
      namaUsaha: namaUsaha,
      alamatUsaha: alamatUsaha,
    );
    state = updated;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_keySettings, jsonEncode(updated.toJson()));
    } catch (e) {
      // Ignored
    }
  }
}

final settingsProvider = StateNotifierProvider<SettingsNotifier, SettingsData>((ref) {
  return SettingsNotifier();
});
