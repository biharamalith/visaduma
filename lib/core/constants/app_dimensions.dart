// ============================================================
// FILE: lib/core/constants/app_dimensions.dart
// PURPOSE: Spacing, radius, elevation, icon sizes and
//          other dimension tokens used across the app.
// ============================================================

abstract final class AppDimensions {
  // ── Spacing scale (4-pt grid) ─────────────────────────────
  static const double s0 = 0;
  static const double s2 = 2;
  static const double s4 = 4;
  static const double s6 = 6;
  static const double s8 = 8;
  static const double s10 = 10;
  static const double s12 = 12;
  static const double s16 = 16;
  static const double s20 = 20;
  static const double s24 = 24;
  static const double s28 = 28;
  static const double s32 = 32;
  static const double s40 = 40;
  static const double s48 = 48;
  static const double s56 = 56;
  static const double s64 = 64;
  static const double s80 = 80;
  static const double s96 = 96;
  static const double s120 = 120;

  // ── Horizontal page padding ───────────────────────────────
  static const double pagePadding = 20;

  // ── Border radius ─────────────────────────────────────────
  static const double radiusXs = 6;
  static const double radiusSm = 8;
  static const double radiusMd = 12;
  static const double radiusLg = 16;   // buttons
  static const double radiusXl = 20;
  static const double radius2Xl = 24;  // cards
  static const double radiusFull = 999; // pill / circle

  // ── Elevation / shadow blur ───────────────────────────────
  static const double elevation0 = 0;
  static const double elevation1 = 4;
  static const double elevation2 = 8;
  static const double elevation3 = 16;
  static const double elevation4 = 24;

  // ── Icon sizes ────────────────────────────────────────────
  static const double iconSm = 16;
  static const double iconMd = 20;
  static const double iconLg = 24;
  static const double iconXl = 32;
  static const double icon2Xl = 48;

  // ── Button ────────────────────────────────────────────────
  static const double buttonHeight = 52;
  static const double buttonHeightSm = 40;
  static const double buttonHeightXs = 32;

  // ── AppBar ────────────────────────────────────────────────
  static const double appBarHeight = 56;

  // ── Bottom nav bar ────────────────────────────────────────
  static const double bottomNavHeight = 64;

  // ── Avatar sizes ──────────────────────────────────────────
  static const double avatarSm = 32;
  static const double avatarMd = 44;
  static const double avatarLg = 64;
  static const double avatarXl = 96;

  // ── Card ──────────────────────────────────────────────────
  static const double cardMinHeight = 80;
  static const double serviceCardSize = 76; // square service icon card
}
