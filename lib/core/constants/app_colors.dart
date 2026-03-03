// ============================================================
// FILE: lib/core/constants/app_colors.dart
// PURPOSE: All brand colours for VisaDuma.
// Import this file wherever you need a colour value.
// ============================================================

import 'package:flutter/material.dart';

/// Central colour palette — Blue & White design system.
abstract final class AppColors {
  // ── Brand Primary ──────────────────────────────────────────
  static const Color primary = Color(0xFF2563EB);
  static const Color primaryDark = Color(0xFF1D4ED8);
  static const Color primaryLight = Color(0xFF3B82F6);
  static const Color primarySurface = Color(0xFFEFF6FF); // 10% primary tint

  // ── Background & Surface ───────────────────────────────────
  static const Color background = Color(0xFFF8FAFF);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF1F5FD);

  // ── Text ───────────────────────────────────────────────────
  static const Color textPrimary = Color(0xFF0F172A);    // Slate-900
  static const Color textSecondary = Color(0xFF475569);  // Slate-600
  static const Color textTertiary = Color(0xFF94A3B8);   // Slate-400
  static const Color textOnPrimary = Color(0xFFFFFFFF);
  static const Color textHint = Color(0xFFCBD5E1);     // Slate-300

  // ── Border & Divider ───────────────────────────────────────
  static const Color border = Color(0xFFE2E8F0);
  static const Color divider = Color(0xFFF1F5F9);

  // ── Status ─────────────────────────────────────────────────
  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);
  static const Color infoBlue = Color(0xFF3B82F6);
  static const Color warningAmber = Color(0xFFF59E0B);

  // ── Shadow ─────────────────────────────────────────────────
  /// Blue-tinted soft shadow — use with BoxShadow.
  static const Color shadow = Color(0x1A2563EB); // 10 % primary

  // ── Misc ───────────────────────────────────────────────────
  static const Color shimmerBase = Color(0xFFE2E8F0);
  static const Color shimmerHighlight = Color(0xFFF8FAFF);
  static const Color ratingStarFill = Color(0xFFFBBF24);
  static const Color transparent = Colors.transparent;
}
