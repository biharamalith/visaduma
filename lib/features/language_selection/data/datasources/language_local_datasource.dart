// ============================================================
// FILE: lib/features/language_selection/data/datasources/language_local_datasource.dart
// PURPOSE: Low-level persistence for the selected language code.
//          Reads and writes to SharedPreferences.
//          Called only from LanguageRepositoryImpl.
// ============================================================

import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/errors/exceptions.dart';

abstract class LanguageLocalDatasource {
  /// Returns the saved BCP-47 language code, or null if not yet set.
  Future<String?> getSavedLanguageCode();

  /// Persists the given [languageCode] to local storage.
  Future<void> saveLanguageCode(String languageCode);
}

class LanguageLocalDatasourceImpl implements LanguageLocalDatasource {
  const LanguageLocalDatasourceImpl();

  @override
  Future<String?> getSavedLanguageCode() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(AppStrings.keyLanguageCode);
    } catch (e) {
      throw const CacheException(message: 'Failed to read language preference.');
    }
  }

  @override
  Future<void> saveLanguageCode(String languageCode) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(AppStrings.keyLanguageCode, languageCode);
    } catch (e) {
      throw const CacheException(message: 'Failed to save language preference.');
    }
  }
}
