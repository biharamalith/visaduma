// ============================================================
// FILE: lib/shared/providers/shared_providers.dart
// PURPOSE: Global Riverpod providers shared across features.
//          Feature-specific providers live inside their own
//          feature/presentation/viewmodels/ folder.
// ============================================================

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/network/dio_client.dart';
import 'package:dio/dio.dart';

// ── SharedPreferences ─────────────────────────────────────

/// Provides a [SharedPreferences] instance; must be overridden
/// in ProviderScope overrides with the real value if you want
/// to use it synchronously during app start.
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError(
    'sharedPreferencesProvider must be overridden in ProviderScope.',
  );
});

// ── Dio ───────────────────────────────────────────────────

/// Provides the singleton [Dio] client configured in DioClient.
final dioProvider = Provider<Dio>((ref) => DioClient.instance);

// ── Connectivity ──────────────────────────────────────────

/// TODO: Add connectivity_plus stream provider here.
/// Example:
/// final connectivityProvider = StreamProvider<ConnectivityResult>(
///   (ref) => Connectivity().onConnectivityChanged,
/// );
