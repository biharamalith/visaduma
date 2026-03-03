// ============================================================
// FILE: lib/features/booking/presentation/viewmodels/booking_viewmodel.dart
// ============================================================
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_client.dart';
import '../../data/datasources/booking_remote_datasource.dart';
import '../../data/repositories/booking_repository_impl.dart';
import '../../domain/entities/booking_entity.dart';
import '../../domain/usecases/create_booking_usecase.dart';
import '../../domain/usecases/get_bookings_usecase.dart';

class BookingState {
  final List<BookingEntity> bookings;
  final bool isLoading;
  final String? error;
  final bool isSubmitting;
  const BookingState({
    this.bookings = const [],
    this.isLoading = false,
    this.error,
    this.isSubmitting = false,
  });
  BookingState copyWith({
    List<BookingEntity>? bookings,
    bool? isLoading,
    String? error,
    bool? isSubmitting,
  }) =>
      BookingState(
        bookings: bookings ?? this.bookings,
        isLoading: isLoading ?? this.isLoading,
        error: error,
        isSubmitting: isSubmitting ?? this.isSubmitting,
      );
}

class BookingNotifier extends Notifier<BookingState> {
  late final GetBookingsUsecase _getBookings;
  late final CreateBookingUsecase _createBooking;

  @override
  BookingState build() {
    final repo = BookingRepositoryImpl(
      BookingRemoteDatasourceImpl(DioClient.instance),
    );
    _getBookings = GetBookingsUsecase(repo);
    _createBooking = CreateBookingUsecase(repo);
    Future.microtask(loadBookings);
    return const BookingState(isLoading: true);
  }

  Future<void> loadBookings() async {
    state = state.copyWith(isLoading: true);
    final result = await _getBookings();
    result.fold(
      (f) => state = state.copyWith(isLoading: false, error: f.message),
      (bookings) => state = state.copyWith(bookings: bookings, isLoading: false),
    );
  }

  Future<BookingEntity?> createBooking({
    required String serviceId,
    required DateTime scheduledAt,
    required int durationHours,
    String? notes,
  }) async {
    state = state.copyWith(isSubmitting: true);
    final result = await _createBooking(
      serviceId: serviceId,
      scheduledAt: scheduledAt,
      durationHours: durationHours,
      notes: notes,
    );
    return result.fold(
      (f) {
        state = state.copyWith(isSubmitting: false, error: f.message);
        return null;
      },
      (booking) {
        state = state.copyWith(
          isSubmitting: false,
          bookings: [booking, ...state.bookings],
        );
        return booking;
      },
    );
  }
}

final bookingProvider =
    NotifierProvider<BookingNotifier, BookingState>(BookingNotifier.new);
