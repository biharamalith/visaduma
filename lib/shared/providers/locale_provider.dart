// ============================================================
// FILE: lib/shared/providers/locale_provider.dart
// PURPOSE: Riverpod provider that holds the currently selected
//          [Locale] and persists it to SharedPreferences.
//
// Usage:
//   // Read locale
//   final locale = ref.watch(localeProvider);
//
//   // Change locale
//   ref.read(localeProvider.notifier).setLocale('si');
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/app_strings.dart';

// ── Notifier ──────────────────────────────────────────────

class LocaleNotifier extends Notifier<Locale> {
  @override
  Locale build() {
    // Default to English; actual value loaded asynchronously.
    _loadFromPrefs();
    return const Locale('en');
  }

  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(AppStrings.keyLanguageCode);
    if (code != null) {
      state = Locale(code);
    }
  }

  /// Persists [languageCode] to SharedPreferences and updates state.
  Future<void> setLocale(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppStrings.keyLanguageCode, languageCode);
    state = Locale(languageCode);
  }
}

// ── Provider ──────────────────────────────────────────────

/// Provides the currently active [Locale] for the whole app.
final localeProvider = NotifierProvider<LocaleNotifier, Locale>(
  LocaleNotifier.new,
);
