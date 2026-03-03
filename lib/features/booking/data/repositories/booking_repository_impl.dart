// ============================================================
// FILE: lib/features/booking/data/repositories/booking_repository_impl.dart
// ============================================================
import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/booking_entity.dart';
import '../../domain/repositories/booking_repository.dart';
import '../datasources/booking_remote_datasource.dart';

class BookingRepositoryImpl implements BookingRepository {
  final BookingRemoteDatasource _remote;
  const BookingRepositoryImpl(this._remote);

  @override
  Future<Either<Failure, List<BookingEntity>>> getMyBookings() async {
    try {
      return Right(await _remote.getMyBookings());
    } on ServerException catch (e) {
      return Left(ServerFailure(statusCode: e.statusCode));
    } on NetworkException {
      return const Left(NetworkFailure());
    } catch (_) {
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, BookingEntity>> getBookingById(String id) async {
    try {
      return Right(await _remote.getBookingById(id));
    } on ServerException catch (e) {
      return Left(ServerFailure(statusCode: e.statusCode));
    } catch (_) {
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, BookingEntity>> createBooking({
    required String serviceId,
    required DateTime scheduledAt,
    required int durationHours,
    String? notes,
  }) async {
    try {
      final body = {
        'serviceId': serviceId,
        'scheduledAt': scheduledAt.toIso8601String(),
        'durationHours': durationHours,
        if (notes != null) 'notes': notes,
      };
      return Right(await _remote.createBooking(body));
    } on ServerException catch (e) {
      return Left(ServerFailure(statusCode: e.statusCode));
    } catch (_) {
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, BookingEntity>> cancelBooking(String id) async {
    try {
      return Right(await _remote.cancelBooking(id));
    } on ServerException catch (e) {
      return Left(ServerFailure(statusCode: e.statusCode));
    } catch (_) {
      return const Left(UnexpectedFailure());
    }
  }
}
