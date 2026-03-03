// ============================================================
// FILE: lib/core/constants/app_strings.dart
// PURPOSE: Static (non-localised) string constants.
//          For user-facing strings use AppLocalizations (l10n).
// ============================================================

abstract final class AppStrings {
  // ── App identity ─────────────────────────────────────────
  static const String appName = 'VisaDuma';
  static const String appTagline = "Sri Lanka's Super Service App";

  // ── SharedPreferences keys ────────────────────────────────
  static const String keyLanguageCode = 'selected_language_code';
  static const String keyAuthToken = 'auth_token';
  static const String keyRefreshToken = 'refresh_token';
  static const String keyUserId = 'user_id';
  static const String keyUserRole = 'user_role';
  static const String keyOnboardingDone = 'onboarding_complete';

  // ── User roles ────────────────────────────────────────────
  static const String roleUser = 'user';
  static const String roleProvider = 'provider';
  static const String roleShopOwner = 'shop_owner';
  static const String roleAdmin = 'admin';

  // ── Language codes (BCP-47) ───────────────────────────────
  static const String langEnglish = 'en';
  static const String langSinhala = 'si';
  static const String langTamil = 'ta';

  // ── Date/Time formats ─────────────────────────────────────
  static const String dateFormat = 'dd MMM yyyy';
  static const String timeFormat = 'hh:mm a';
  static const String dateTimeFormat = 'dd MMM yyyy, hh:mm a';

  // ── Asset paths ───────────────────────────────────────────
  static const String logoImage = 'assets/images/logo.png';
  static const String logoSvg = 'assets/icons/logo.svg';
  static const String splashBg = 'assets/images/splash_bg.png';
  static const String onboarding1 = 'assets/images/onboarding_1.png';
  static const String onboarding2 = 'assets/images/onboarding_2.png';
  static const String onboarding3 = 'assets/images/onboarding_3.png';
  static const String emptyState = 'assets/images/empty_state.png';
  static const String errorImage = 'assets/images/error.png';

  // ── Route names (mirrors GoRouter names) ─────────────────
  static const String routeSplash = 'splash';
  static const String routeLanguage = 'language';
  static const String routeOnboarding = 'onboarding';
  static const String routeLogin = 'login';
  static const String routeRegister = 'register';
  static const String routeHome = 'home';
  static const String routeServices = 'services';
  static const String routeServiceDetail = 'service-detail';
  static const String routeBooking = 'booking';
  static const String routeBookingConfirm = 'booking-confirm';
  static const String routeChat = 'chat';
  static const String routeRides = 'rides';
  static const String routeShops = 'shops';
  static const String routeShopDetail = 'shop-detail';
  static const String routeVehicles = 'vehicles';
  static const String routeJobs = 'jobs';
  static const String routeBoarding = 'boarding';
  static const String routeProfile = 'profile';
  static const String routeNotifications = 'notifications';
  static const String routeReviews = 'reviews';
  static const String routeProviderProfile = 'provider-profile';
}
