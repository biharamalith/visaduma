// ============================================================
// FILE: lib/features/booking/domain/repositories/booking_repository.dart
// ============================================================
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/booking_entity.dart';

abstract class BookingRepository {
  Future<Either<Failure, List<BookingEntity>>> getMyBookings();
  Future<Either<Failure, BookingEntity>> getBookingById(String id);
  Future<Either<Failure, BookingEntity>> createBooking({
    required String serviceId,
    required DateTime scheduledAt,
    required int durationHours,
    String? notes,
  });
  Future<Either<Failure, BookingEntity>> cancelBooking(String id);
}
