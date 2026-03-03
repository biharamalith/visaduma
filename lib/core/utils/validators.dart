// ============================================================
// FILE: lib/core/utils/validators.dart
// PURPOSE: Form field validators — pure functions that return
//          a String error message or null (valid).
//          Import in TextFormField.validator callbacks.
// ============================================================

/// Collection of input validators.
abstract final class Validators {
  // ── Generic ───────────────────────────────────────────────

  static String? required(String? value, {String? label}) {
    if (value == null || value.trim().isEmpty) {
      return '${label ?? 'This field'} is required.';
    }
    return null;
  }

  // ── Email ─────────────────────────────────────────────────

  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) return 'Email is required.';
    final regex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!regex.hasMatch(value.trim())) return 'Enter a valid email address.';
    return null;
  }

  // ── Phone (Sri Lanka) ─────────────────────────────────────

  /// Accepts 07X XXXXXXX format (10 digits, may have spaces/dashes).
  static String? phone(String? value) {
    if (value == null || value.trim().isEmpty) return 'Phone number is required.';
    final digits = value.replaceAll(RegExp(r'[\s\-]'), '');
    final regex = RegExp(r'^(07\d{8}|0\d{9})$');
    if (!regex.hasMatch(digits)) {
      return 'Enter a valid Sri Lankan phone number.';
    }
    return null;
  }

  // ── Password ──────────────────────────────────────────────

  static String? password(String? value) {
    if (value == null || value.isEmpty) return 'Password is required.';
    if (value.length < 8) return 'Password must be at least 8 characters.';
    if (!value.contains(RegExp(r'[A-Za-z]'))) {
      return 'Password must contain at least one letter.';
    }
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain at least one number.';
    }
    return null;
  }

  static String? confirmPassword(String? value, String original) {
    if (value == null || value.isEmpty) return 'Please confirm your password.';
    if (value != original) return 'Passwords do not match.';
    return null;
  }

  // ── Name ──────────────────────────────────────────────────

  static String? name(String? value, {String label = 'Name'}) {
    if (value == null || value.trim().isEmpty) return '$label is required.';
    if (value.trim().length < 2) return '$label must be at least 2 characters.';
    if (value.trim().length > 100) return '$label is too long.';
    return null;
  }

  // ── NIC (National Identity Card, Sri Lanka) ───────────────

  static String? nic(String? value) {
    if (value == null || value.trim().isEmpty) return 'NIC is required.';
    final nic = value.trim().toUpperCase();
    final oldFormat = RegExp(r'^\d{9}[VX]$');
    final newFormat = RegExp(r'^\d{12}$');
    if (!oldFormat.hasMatch(nic) && !newFormat.hasMatch(nic)) {
      return 'Enter a valid NIC number.';
    }
    return null;
  }

  // ── URL ───────────────────────────────────────────────────

  static String? url(String? value) {
    if (value == null || value.trim().isEmpty) return null; // optional
    final regex = RegExp(
      r'^https?://[a-zA-Z0-9\-]+(\.[a-zA-Z0-9\-]+)+(:\d+)?(/[^\s]*)?$',
    );
    if (!regex.hasMatch(value.trim())) return 'Enter a valid URL.';
    return null;
  }

  // ── Min / Max length ──────────────────────────────────────

  static String? minLength(String? value, int min, {String? label}) {
    if (value == null || value.length < min) {
      return '${label ?? 'This field'} must be at least $min characters.';
    }
    return null;
  }

  static String? maxLength(String? value, int max, {String? label}) {
    if (value != null && value.length > max) {
      return '${label ?? 'This field'} must be at most $max characters.';
    }
    return null;
  }
}
