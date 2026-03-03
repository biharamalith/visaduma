// ============================================================
// FILE: lib/features/booking/data/datasources/booking_remote_datasource.dart
// ============================================================
import 'package:dio/dio.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/api_endpoints.dart';
import '../models/booking_model.dart';

abstract class BookingRemoteDatasource {
  Future<List<BookingModel>> getMyBookings();
  Future<BookingModel> getBookingById(String id);
  Future<BookingModel> createBooking(Map<String, dynamic> body);
  Future<BookingModel> cancelBooking(String id);
}

class BookingRemoteDatasourceImpl implements BookingRemoteDatasource {
  final Dio _dio;
  const BookingRemoteDatasourceImpl(this._dio);

  @override
  Future<List<BookingModel>> getMyBookings() async {
    try {
      final res = await _dio.get(ApiEndpoints.bookings);
      final list = res.data['data'] as List;
      return list.map((e) => BookingModel.fromJson(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data?['message'] as String? ?? 'Server error.',
        statusCode: e.response?.statusCode,
        data: e.response?.data,
      );
    }
  }

  @override
  Future<BookingModel> getBookingById(String id) async {
    try {
      final res = await _dio.get(ApiEndpoints.bookingById(id));
      return BookingModel.fromJson(res.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data?['message'] as String? ?? 'Server error.',
        statusCode: e.response?.statusCode,
        data: e.response?.data,
      );
    }
  }

  @override
  Future<BookingModel> createBooking(Map<String, dynamic> body) async {
    try {
      final res = await _dio.post(ApiEndpoints.bookings, data: body);
      return BookingModel.fromJson(res.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data?['message'] as String? ?? 'Server error.',
        statusCode: e.response?.statusCode,
        data: e.response?.data,
      );
    }
  }

  @override
  Future<BookingModel> cancelBooking(String id) async {
    try {
      final res = await _dio.patch('${ApiEndpoints.bookingById(id)}/cancel');
      return BookingModel.fromJson(res.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data?['message'] as String? ?? 'Server error.',
        statusCode: e.response?.statusCode,
        data: e.response?.data,
      );
    }
  }
}
