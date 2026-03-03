// ============================================================
// FILE: lib/features/booking/domain/usecases/get_bookings_usecase.dart
// ============================================================
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/booking_entity.dart';
import '../repositories/booking_repository.dart';

class GetBookingsUsecase {
  final BookingRepository _repo;
  const GetBookingsUsecase(this._repo);
  Future<Either<Failure, List<BookingEntity>>> call() => _repo.getMyBookings();
}
