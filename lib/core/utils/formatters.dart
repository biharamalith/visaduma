// ============================================================
// FILE: lib/core/utils/formatters.dart
// PURPOSE: Utility functions for formatting strings, dates,
//          currency, distances, durations, etc.
// ============================================================

import 'package:intl/intl.dart';

abstract final class Formatters {
  // ── Currency ─────────────────────────────────────────────

  /// Formats a number as Sri Lankan Rupees.
  /// e.g. 12500 → "Rs. 12,500.00"
  static String currency(num amount, {bool showDecimals = false}) {
    final formatter = NumberFormat(
      showDecimals ? '#,##0.00' : '#,##0',
      'en_US',
    );
    return 'Rs. ${formatter.format(amount)}';
  }

  // ── Date & Time ───────────────────────────────────────────

  static String date(DateTime dt) => DateFormat('dd MMM yyyy').format(dt);

  static String time(DateTime dt) => DateFormat('hh:mm a').format(dt);

  static String dateTime(DateTime dt) =>
      DateFormat('dd MMM yyyy, hh:mm a').format(dt);

  /// Returns a human-readable relative time ("2 hours ago", "just now", etc.)
  static String timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inSeconds < 60) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    if (diff.inDays < 30) return '${(diff.inDays / 7).floor()}w ago';
    if (diff.inDays < 365) return '${(diff.inDays / 30).floor()}mo ago';
    return '${(diff.inDays / 365).floor()}y ago';
  }

  // ── Distance ─────────────────────────────────────────────

  /// Formats metres as a human-readable distance ("500 m" / "2.3 km").
  static String distance(double metres) {
    if (metres < 1000) return '${metres.toStringAsFixed(0)} m';
    return '${(metres / 1000).toStringAsFixed(1)} km';
  }

  // ── Phone ────────────────────────────────────────────────

  /// Formats a raw 10-digit SL number: "0712345678" → "071 234 5678"
  static String phone(String raw) {
    final digits = raw.replaceAll(RegExp(r'\D'), '');
    if (digits.length != 10) return raw;
    return '${digits.substring(0, 3)} ${digits.substring(3, 6)} ${digits.substring(6)}';
  }

  // ── Rating ───────────────────────────────────────────────

  /// Formats a double rating: 4.0 → "4.0", 4.56 → "4.6"
  static String rating(double r) => r.toStringAsFixed(1);

  // ── File size ────────────────────────────────────────────

  static String fileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1048576) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / 1048576).toStringAsFixed(1)} MB';
  }

  // ── Name initial ─────────────────────────────────────────

  /// Returns up to 2 capitalised initials from a display name.
  static String initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty) return '';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }

  // ── Truncate ─────────────────────────────────────────────

  static String truncate(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}…';
  }
}
