// ============================================================
// FILE: lib/features/bookings/data/datasources/booking_remote_datasource.dart
// PURPOSE: Remote data source for bookings API calls
// ============================================================

import 'package:dio/dio.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/api_endpoints.dart';
import '../models/booking_model.dart';

/// Request data for creating a booking
class CreateBookingRequest {
  final String providerId;
  final String categoryId;
  final String serviceDate; // ISO 8601 date string
  final String serviceTime; // "HH:mm" format
  final double durationHours;
  final String serviceAddress;
  final String serviceCity;
  final double? serviceLat;
  final double? serviceLng;
  final String contactPhone;
  final String? description;
  final String? specialInstructions;
  final double estimatedCost;
  final String paymentMethod; // 'cash', 'wallet', 'card'

  const CreateBookingRequest({
    required this.providerId,
    required this.categoryId,
    required this.serviceDate,
    required this.serviceTime,
    required this.durationHours,
    required this.serviceAddress,
    required this.serviceCity,
    this.serviceLat,
    this.serviceLng,
    required this.contactPhone,
    this.description,
    this.specialInstructions,
    required this.estimatedCost,
    required this.paymentMethod,
  });

  Map<String, dynamic> toJson() {
    return {
      'provider_id': providerId,
      'category_id': categoryId,
      'service_date': serviceDate,
      'service_time': serviceTime,
      'duration_hours': durationHours,
      'service_address': serviceAddress,
      'service_city': serviceCity,
      'service_lat': serviceLat,
      'service_lng': serviceLng,
      'contact_phone': contactPhone,
      'description': description,
      'special_instructions': specialInstructions,
      'estimated_cost': estimatedCost,
      'payment_method': paymentMethod,
    };
  }
}

/// Abstract interface for booking remote data source
abstract class BookingRemoteDatasource {
  /// Create a new booking
  Future<BookingModel> createBooking(CreateBookingRequest request);

  /// Fetch all bookings for the current user
  Future<List<BookingModel>> getUserBookings();

  /// Fetch a single booking by ID
  Future<BookingModel> getBookingById(String id);

  /// Cancel a booking
  Future<BookingModel> cancelBooking(String id, String? cancellationReason);

  /// Confirm a booking (provider only)
  Future<BookingModel> confirmBooking(String id);

  /// Start a service (provider only)
  Future<BookingModel> startService(String id);

  /// Complete a service (provider only)
  Future<BookingModel> completeService(String id, double? finalCost);
}

/// Implementation of booking remote data source using Dio
class BookingRemoteDatasourceImpl implements BookingRemoteDatasource {
  final Dio _dio;

  const BookingRemoteDatasourceImpl(this._dio);

  @override
  Future<BookingModel> createBooking(CreateBookingRequest request) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.bookings,
        data: request.toJson(),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = response.data;
        final bookingJson = data['data'] ?? data;
        
        return BookingModel.fromJson(bookingJson as Map<String, dynamic>);
      } else if (response.statusCode == 400) {
        throw ValidationException(
          message: response.data['message'] ?? 'Invalid booking data',
        );
      } else if (response.statusCode == 409) {
        throw ConflictException(
          message: response.data['message'] ?? 'Booking conflict detected',
        );
      } else {
        throw ServerException(
          message: 'Failed to create booking',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        throw ValidationException(
          message: e.response?.data['message'] ?? 'Invalid booking data',
        );
      } else if (e.response?.statusCode == 409) {
        throw ConflictException(
          message: e.response?.data['message'] ?? 'Booking conflict detected',
        );
      }
      throw ServerException(
        message: e.message ?? 'Network error occurred',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      if (e is ValidationException || e is ConflictException) rethrow;
      throw ServerException(message: 'Unexpected error: $e');
    }
  }

  @override
  Future<List<BookingModel>> getUserBookings() async {
    try {
      final response = await _dio.get(ApiEndpoints.bookings);

      if (response.statusCode == 200) {
        final data = response.data;
        final List<dynamic> bookingsJson = data['data'] ?? data;
        
        return bookingsJson
            .map((json) => BookingModel.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw ServerException(
          message: 'Failed to fetch bookings',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw ServerException(
        message: e.message ?? 'Network error occurred',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw ServerException(message: 'Unexpected error: $e');
    }
  }

  @override
  Future<BookingModel> getBookingById(String id) async {
    try {
      final response = await _dio.get(ApiEndpoints.bookingById(id));

      if (response.statusCode == 200) {
        final data = response.data;
        final bookingJson = data['data'] ?? data;
        
        return BookingModel.fromJson(bookingJson as Map<String, dynamic>);
      } else if (response.statusCode == 404) {
        throw NotFoundException(message: 'Booking not found');
      } else {
        throw ServerException(
          message: 'Failed to fetch booking',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw NotFoundException(message: 'Booking not found');
      }
      throw ServerException(
        message: e.message ?? 'Network error occurred',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      if (e is NotFoundException) rethrow;
      throw ServerException(message: 'Unexpected error: $e');
    }
  }

  @override
  Future<BookingModel> cancelBooking(String id, String? cancellationReason) async {
    try {
      final response = await _dio.put(
        ApiEndpoints.cancelBooking(id),
        data: {
          if (cancellationReason != null) 'cancellation_reason': cancellationReason,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final bookingJson = data['data'] ?? data;
        
        return BookingModel.fromJson(bookingJson as Map<String, dynamic>);
      } else if (response.statusCode == 404) {
        throw NotFoundException(message: 'Booking not found');
      } else if (response.statusCode == 400) {
        throw ValidationException(
          message: response.data['message'] ?? 'Cannot cancel this booking',
        );
      } else {
        throw ServerException(
          message: 'Failed to cancel booking',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw NotFoundException(message: 'Booking not found');
      } else if (e.response?.statusCode == 400) {
        throw ValidationException(
          message: e.response?.data['message'] ?? 'Cannot cancel this booking',
        );
      }
      throw ServerException(
        message: e.message ?? 'Network error occurred',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      if (e is NotFoundException || e is ValidationException) rethrow;
      throw ServerException(message: 'Unexpected error: $e');
    }
  }

  @override
  Future<BookingModel> confirmBooking(String id) async {
    try {
      final response = await _dio.put(ApiEndpoints.confirmBooking(id));

      if (response.statusCode == 200) {
        final data = response.data;
        final bookingJson = data['data'] ?? data;
        
        return BookingModel.fromJson(bookingJson as Map<String, dynamic>);
      } else if (response.statusCode == 404) {
        throw NotFoundException(message: 'Booking not found');
      } else if (response.statusCode == 403) {
        throw UnauthorizedException(
          message: 'You are not authorized to confirm this booking',
        );
      } else {
        throw ServerException(
          message: 'Failed to confirm booking',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw NotFoundException(message: 'Booking not found');
      } else if (e.response?.statusCode == 403) {
        throw UnauthorizedException(
          message: 'You are not authorized to confirm this booking',
        );
      }
      throw ServerException(
        message: e.message ?? 'Network error occurred',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      if (e is NotFoundException || e is UnauthorizedException) rethrow;
      throw ServerException(message: 'Unexpected error: $e');
    }
  }

  @override
  Future<BookingModel> startService(String id) async {
    try {
      final response = await _dio.put('${ApiEndpoints.bookingById(id)}/start');

      if (response.statusCode == 200) {
        final data = response.data;
        final bookingJson = data['data'] ?? data;
        
        return BookingModel.fromJson(bookingJson as Map<String, dynamic>);
      } else if (response.statusCode == 404) {
        throw NotFoundException(message: 'Booking not found');
      } else if (response.statusCode == 403) {
        throw UnauthorizedException(
          message: 'You are not authorized to start this service',
        );
      } else {
        throw ServerException(
          message: 'Failed to start service',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw NotFoundException(message: 'Booking not found');
      } else if (e.response?.statusCode == 403) {
        throw UnauthorizedException(
          message: 'You are not authorized to start this service',
        );
      }
      throw ServerException(
        message: e.message ?? 'Network error occurred',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      if (e is NotFoundException || e is UnauthorizedException) rethrow;
      throw ServerException(message: 'Unexpected error: $e');
    }
  }

  @override
  Future<BookingModel> completeService(String id, double? finalCost) async {
    try {
      final response = await _dio.put(
        '${ApiEndpoints.bookingById(id)}/complete',
        data: {
          if (finalCost != null) 'final_cost': finalCost,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final bookingJson = data['data'] ?? data;
        
        return BookingModel.fromJson(bookingJson as Map<String, dynamic>);
      } else if (response.statusCode == 404) {
        throw NotFoundException(message: 'Booking not found');
      } else if (response.statusCode == 403) {
        throw UnauthorizedException(
          message: 'You are not authorized to complete this service',
        );
      } else {
        throw ServerException(
          message: 'Failed to complete service',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw NotFoundException(message: 'Booking not found');
      } else if (e.response?.statusCode == 403) {
        throw UnauthorizedException(
          message: 'You are not authorized to complete this service',
        );
      }
      throw ServerException(
        message: e.message ?? 'Network error occurred',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      if (e is NotFoundException || e is UnauthorizedException) rethrow;
      throw ServerException(message: 'Unexpected error: $e');
    }
  }
}
