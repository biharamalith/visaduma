// ============================================================
// FILE: lib/features/booking/domain/usecases/create_booking_usecase.dart
// ============================================================
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/booking_entity.dart';
import '../repositories/booking_repository.dart';

class CreateBookingUsecase {
  final BookingRepository _repo;
  const CreateBookingUsecase(this._repo);

  Future<Either<Failure, BookingEntity>> call({
    required String serviceId,
    required DateTime scheduledAt,
    required int durationHours,
    String? notes,
  }) =>
      _repo.createBooking(
        serviceId: serviceId,
        scheduledAt: scheduledAt,
        durationHours: durationHours,
        notes: notes,
      );
}
