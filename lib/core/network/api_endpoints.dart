// ============================================================
// FILE: lib/core/network/api_endpoints.dart
// PURPOSE: Centralised API endpoint definitions.
//          Change baseUrl once to target dev / staging / prod.
//          All feature datasources import endpoints from here.
// ============================================================

abstract final class ApiEndpoints {
  // ── Base URL ──────────────────────────────────────────────
  /// Base URL for API requests.
  /// TODO: Use environment variables or flutter_dotenv for configuration
  /// Development: Local backend server
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:3000/api/v1',
  );
  
  // Alternative base URLs for different environments
  // Development: XAMPP local server
  // static const String baseUrlDev = 'http://192.168.1.100:3000/api/v1';
  // Staging
  // static const String baseUrlStaging = 'https://staging-api.visaduma.lk/v1';
  // Production
  // static const String baseUrlProd = 'https://api.visaduma.lk/v1';

  // ── Connection timeouts ───────────────────────────────────
  static const int connectTimeoutMs = 15000;
  static const int receiveTimeoutMs = 20000;
  static const int sendTimeoutMs = 20000;

  // ── Auth ──────────────────────────────────────────────────
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String refreshToken = '/auth/refresh';
  static const String logout = '/auth/logout';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';
  static const String verifyOtp = '/auth/verify-otp';

  // ── User profile ──────────────────────────────────────────
  static const String profile = '/users/profile';
  static const String updateProfile = '/users/profile/update';
  static const String uploadAvatar = '/users/profile/avatar';
  static const String userBookings = '/users/bookings';
  static const String savedProviders = '/users/saved-providers';

  // ── Services ──────────────────────────────────────────────
  static const String services = '/services';
  static const String serviceCategories = '/services/categories';
  static String serviceById(String id) => '/services/$id';
  static const String serviceProviders = '/services/providers';
  static String providerById(String id) => '/services/providers/$id';

  // ── Booking ───────────────────────────────────────────────
  static const String bookings = '/bookings';
  static String bookingById(String id) => '/bookings/$id';
  static String cancelBooking(String id) => '/bookings/$id/cancel';
  static String confirmBooking(String id) => '/bookings/$id/confirm';

  // ── Chat ─────────────────────────────────────────────────
  static const String chatConversations = '/chat/conversations';
  static String chatMessages(String conversationId) =>
      '/chat/conversations/$conversationId/messages';

  // ── Rides ─────────────────────────────────────────────────
  static const String rides = '/rides';
  static const String rideRequest = '/rides/request';
  static String rideById(String id) => '/rides/$id';

  // ── Shops / Marketplace ───────────────────────────────────
  static const String shops = '/shops';
  static String shopById(String id) => '/shops/$id';
  static const String products = '/products';
  static String productById(String id) => '/products/$id';
  static String shopProducts(String shopId) => '/shops/$shopId/products';

  // ── Vehicles / Hire ───────────────────────────────────────
  static const String vehicles = '/vehicles';
  static String vehicleById(String id) => '/vehicles/$id';

  // ── Jobs ──────────────────────────────────────────────────
  static const String jobs = '/jobs';
  static String jobById(String id) => '/jobs/$id';
  static const String applyJob = '/jobs/apply';

  // ── Boarding / Rooms ──────────────────────────────────────
  static const String boardings = '/boardings';
  static String boardingById(String id) => '/boardings/$id';

  // ── Reviews ───────────────────────────────────────────────
  static const String reviews = '/reviews';
  static String reviewsForProvider(String providerId) =>
      '/services/providers/$providerId/reviews';

  // ── Notifications ─────────────────────────────────────────
  static const String notifications = '/notifications';
  static String markNotificationRead(String id) => '/notifications/$id/read';
  static const String markAllRead = '/notifications/read-all';
  static const String registerFcmToken = '/notifications/fcm-token';
}
