// ============================================================
// FILE: lib/core/router/app_router.dart
// PURPOSE: GoRouter configuration for the entire app.
//          All route paths and names are defined here.
//          The router reads auth state from Riverpod to handle
//          redirect logic (guest vs authenticated user).
//
// To add a new route:
//   1. Add a path const at the top.
//   2. Add a GoRoute entry in _routes.
//   3. Export a named route key via AppStrings.routeXxx.
// ============================================================

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/boarding/presentation/screens/boarding_list_screen.dart';
import '../../features/booking/presentation/screens/booking_confirm_screen.dart';
import '../../features/booking/presentation/screens/booking_screen.dart';
import '../../features/chat/presentation/screens/chat_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/jobs/presentation/screens/jobs_list_screen.dart';
import '../../features/language_selection/presentation/screens/language_selection_screen.dart';
import '../../features/notifications/presentation/screens/notifications_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/reviews/presentation/screens/reviews_screen.dart';
import '../../features/rides/presentation/screens/rides_screen.dart';
import '../../features/services/presentation/screens/service_detail_screen.dart';
import '../../features/services/presentation/screens/services_list_screen.dart';
import '../../features/shops/presentation/screens/shop_detail_screen.dart';
import '../../features/shops/presentation/screens/shops_list_screen.dart';
import '../../features/vehicles/presentation/screens/vehicles_screen.dart';
import '../constants/app_strings.dart';
import 'splash_screen.dart';

part 'app_router.g.dart';

// ── Route paths ───────────────────────────────────────────

abstract final class RoutePaths {
  static const String splash = '/';
  static const String language = '/language';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String services = '/services';
  static const String serviceDetail = '/services/:id';
  static const String booking = '/booking';
  static const String bookingConfirm = '/booking/confirm';
  static const String chat = '/chat/:conversationId';
  static const String rides = '/rides';
  static const String shops = '/shops';
  static const String shopDetail = '/shops/:id';
  static const String vehicles = '/vehicles';
  static const String jobs = '/jobs';
  static const String boarding = '/boarding';
  static const String profile = '/profile';
  static const String notifications = '/notifications';
  static const String reviews = '/reviews/:providerId';
}

// ── Router provider ───────────────────────────────────────

@riverpod
GoRouter appRouter(Ref ref) {
  return GoRouter(
    initialLocation: RoutePaths.splash,
    debugLogDiagnostics: true,
    redirect: (context, state) {
      // TODO: Read auth state from Riverpod provider.
      // final isAuthenticated = ref.read(authStateProvider).isAuthenticated;
      // final isOnboarded = ref.read(onboardingProvider);
      // Handle redirects here: guest → /login, etc.
      return null;
    },
    routes: _routes,
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Route not found: ${state.uri}'),
      ),
    ),
  );
}

// ── Route definitions ─────────────────────────────────────

final List<RouteBase> _routes = [
  GoRoute(
    path: RoutePaths.splash,
    name: AppStrings.routeSplash,
    builder: (context, state) => const SplashScreen(),
  ),
  GoRoute(
    path: RoutePaths.language,
    name: AppStrings.routeLanguage,
    builder: (context, state) => const LanguageSelectionScreen(),
  ),
  GoRoute(
    path: RoutePaths.login,
    name: AppStrings.routeLogin,
    builder: (context, state) => const LoginScreen(),
  ),
  GoRoute(
    path: RoutePaths.register,
    name: AppStrings.routeRegister,
    builder: (context, state) => const RegisterScreen(),
  ),
  GoRoute(
    path: RoutePaths.home,
    name: AppStrings.routeHome,
    builder: (context, state) => const HomeScreen(),
  ),
  GoRoute(
    path: RoutePaths.services,
    name: AppStrings.routeServices,
    builder: (context, state) => const ServicesListScreen(),
    routes: [
      GoRoute(
        path: ':id',
        name: AppStrings.routeServiceDetail,
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return ServiceDetailScreen(serviceId: id);
        },
      ),
    ],
  ),
  GoRoute(
    path: RoutePaths.booking,
    name: AppStrings.routeBooking,
    builder: (context, state) => const BookingScreen(),
    routes: [
      GoRoute(
        path: 'confirm',
        name: AppStrings.routeBookingConfirm,
        builder: (context, state) => const BookingConfirmScreen(),
      ),
    ],
  ),
  GoRoute(
    path: '/chat/:conversationId',
    name: AppStrings.routeChat,
    builder: (context, state) {
      final id = state.pathParameters['conversationId']!;
      return ChatScreen(conversationId: id);
    },
  ),
  GoRoute(
    path: RoutePaths.rides,
    name: AppStrings.routeRides,
    builder: (context, state) => const RidesScreen(),
  ),
  GoRoute(
    path: RoutePaths.shops,
    name: AppStrings.routeShops,
    builder: (context, state) => const ShopsListScreen(),
    routes: [
      GoRoute(
        path: ':id',
        name: AppStrings.routeShopDetail,
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return ShopDetailScreen(shopId: id);
        },
      ),
    ],
  ),
  GoRoute(
    path: RoutePaths.vehicles,
    name: AppStrings.routeVehicles,
    builder: (context, state) => const VehiclesScreen(),
  ),
  GoRoute(
    path: RoutePaths.jobs,
    name: AppStrings.routeJobs,
    builder: (context, state) => const JobsListScreen(),
  ),
  GoRoute(
    path: RoutePaths.boarding,
    name: AppStrings.routeBoarding,
    builder: (context, state) => const BoardingListScreen(),
  ),
  GoRoute(
    path: RoutePaths.profile,
    name: AppStrings.routeProfile,
    builder: (context, state) => const ProfileScreen(),
  ),
  GoRoute(
    path: RoutePaths.notifications,
    name: AppStrings.routeNotifications,
    builder: (context, state) => const NotificationsScreen(),
  ),
  GoRoute(
    path: '/reviews/:providerId',
    name: AppStrings.routeReviews,
    builder: (context, state) {
      final id = state.pathParameters['providerId']!;
      return ReviewsScreen(providerId: id);
    },
  ),
];
