// ============================================================
// FILE: lib/features/bookings/domain/repositories/booking_repository.dart
// PURPOSE: Abstract repository for booking operations.
//          Defines the contract for data operations without implementation details.
// ============================================================

import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/booking_entity.dart';

abstract class BookingRepository {
  /// Creates a new service booking.
  /// Returns [ValidationFailure] if booking data is invalid.
  /// Returns [ServerFailure] if booking conflicts with existing bookings.
  Future<Either<Failure, BookingEntity>> createBooking({
    required String providerId,
    required String categoryId,
    required DateTime serviceDate,
    required String serviceTime,
    required double durationHours,
    required String serviceAddress,
    required String serviceCity,
    double? serviceLat,
    double? serviceLng,
    required String contactPhone,
    String? description,
    String? specialInstructions,
    required double estimatedCost,
    required PaymentMethod paymentMethod,
  });

  /// Retrieves all bookings for the current user.
  /// Can be filtered by status.
  Future<Either<Failure, List<BookingEntity>>> getMyBookings({
    BookingStatus? status,
    int page = 1,
    int limit = 20,
  });

  /// Retrieves all bookings for a provider (provider view).
  /// Can be filtered by status.
  Future<Either<Failure, List<BookingEntity>>> getProviderBookings({
    required String providerId,
    BookingStatus? status,
    int page = 1,
    int limit = 20,
  });

  /// Retrieves a specific booking by ID.
  /// Returns [NotFoundFailure] if the booking doesn't exist.
  /// Returns [ForbiddenFailure] if user doesn't have access to this booking.
  Future<Either<Failure, BookingEntity>> getBookingById(String id);

  /// Cancels a booking (user action).
  /// Only allowed for bookings in 'pending' or 'confirmed' status.
  Future<Either<Failure, BookingEntity>> cancelBooking({
    required String id,
    required String cancellationReason,
  });

  /// Confirms a booking (provider action).
  /// Changes status from 'pending' to 'confirmed'.
  Future<Either<Failure, BookingEntity>> confirmBooking(String id);

  /// Starts a service (provider action).
  /// Changes status from 'confirmed' to 'in_progress'.
  Future<Either<Failure, BookingEntity>> startBooking(String id);

  /// Completes a service (provider action).
  /// Changes status from 'in_progress' to 'completed'.
  /// May include final cost if different from estimated.
  Future<Either<Failure, BookingEntity>> completeBooking({
    required String id,
    double? finalCost,
  });

  /// Updates payment status for a booking.
  Future<Either<Failure, BookingEntity>> updatePaymentStatus({
    required String id,
    required PaymentStatus paymentStatus,
  });
}
