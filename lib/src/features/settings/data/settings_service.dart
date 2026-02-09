import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsService extends StateNotifier<SettingsState> {
  SettingsService(this._prefs)
    : super(
        SettingsState(
          installPath: _prefs.getString(_installPathKey) ?? '',
          themeMode: ThemeMode.values[_prefs.getInt(_themeModeKey) ?? 0],
          locale: Locale(_prefs.getString(_localeKey) ?? 'uk'),
        ),
      );

  final SharedPreferences _prefs;

  static const _installPathKey = 'install_path';
  static const _themeModeKey = 'theme_mode';
  static const _localeKey = 'locale';

  Future<void> setInstallPath(String path) async {
    await _prefs.setString(_installPathKey, path);
    state = state.copyWith(installPath: path);
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    await _prefs.setInt(_themeModeKey, mode.index);
    state = state.copyWith(themeMode: mode);
  }

  Future<void> setLocale(Locale medical) async {
    await _prefs.setString(_localeKey, medical.languageCode);
    state = state.copyWith(locale: medical);
  }
}

class SettingsState {
  final String installPath;
  final ThemeMode themeMode;
  final Locale locale;

  SettingsState({
    required this.installPath,
    required this.themeMode,
    required this.locale,
  });

  SettingsState copyWith({
    String? installPath,
    ThemeMode? themeMode,
    Locale? locale,
  }) {
    return SettingsState(
      installPath: installPath ?? this.installPath,
      themeMode: themeMode ?? this.themeMode,
      locale: locale ?? this.locale,
    );
  }
}

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError(); // Should be overridden in main.dart
});

final settingsServiceProvider =
    StateNotifierProvider<SettingsService, SettingsState>((ref) {
      final prefs = ref.watch(sharedPreferencesProvider);
      return SettingsService(prefs);
    });
