// ============================================================
// FILE: lib/core/utils/helpers.dart
// PURPOSE: General utility / helper functions used across
//          the entire app. Pure functions with no side effects.
// ============================================================

import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_dimensions.dart';

abstract final class AppHelpers {
  // ── Navigation ────────────────────────────────────────────

  /// Shows a floating SnackBar with the given message.
  static void showSnackBar(
    BuildContext context,
    String message, {
    bool isError = false,
    Duration duration = const Duration(seconds: 3),
  }) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: isError ? AppColors.error : AppColors.textPrimary,
          duration: duration,
        ),
      );
  }

  /// Shows a loading dialog. Call [hideLoadingDialog] to dismiss.
  static void showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(
        child: CircularProgressIndicator(
          color: AppColors.primary,
          strokeWidth: 3,
        ),
      ),
    );
  }

  static void hideLoadingDialog(BuildContext context) {
    if (Navigator.of(context, rootNavigator: true).canPop()) {
      Navigator.of(context, rootNavigator: true).pop();
    }
  }

  // ── UI Helpers ────────────────────────────────────────────

  /// Blue-tinted soft shadow for cards.
  static List<BoxShadow> get cardShadow => const [
        BoxShadow(
          color: AppColors.shadow,
          blurRadius: AppDimensions.elevation2,
          offset: Offset(0, 2),
        ),
      ];

  static List<BoxShadow> get elevatedShadow => const [
        BoxShadow(
          color: AppColors.shadow,
          blurRadius: AppDimensions.elevation3,
          offset: Offset(0, 4),
        ),
      ];

  // ── SizedBox shortcuts ────────────────────────────────────

  static const Widget h4 = SizedBox(height: 4);
  static const Widget h8 = SizedBox(height: 8);
  static const Widget h12 = SizedBox(height: 12);
  static const Widget h16 = SizedBox(height: 16);
  static const Widget h20 = SizedBox(height: 20);
  static const Widget h24 = SizedBox(height: 24);
  static const Widget h32 = SizedBox(height: 32);
  static const Widget h48 = SizedBox(height: 48);

  static const Widget w4 = SizedBox(width: 4);
  static const Widget w8 = SizedBox(width: 8);
  static const Widget w12 = SizedBox(width: 12);
  static const Widget w16 = SizedBox(width: 16);
  static const Widget w24 = SizedBox(width: 24);

  // ── Misc ──────────────────────────────────────────────────

  /// Returns true if the list is null or empty.
  static bool isNullOrEmpty(List? list) => list == null || list.isEmpty;

  /// Debounces a callback — useful for search fields.
  static Function debounce(Function fn, Duration delay) {
    DateTime? lastCall;
    return () {
      final now = DateTime.now();
      if (lastCall == null || now.difference(lastCall!) > delay) {
        lastCall = now;
        fn();
      }
    };
  }
}
