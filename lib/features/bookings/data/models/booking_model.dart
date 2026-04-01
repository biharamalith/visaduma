// ============================================================
// FILE: lib/features/bookings/data/models/booking_model.dart
// PURPOSE: Data model for booking with JSON serialization.
//          Converts between JSON and BookingEntity.
// ============================================================

import '../../domain/entities/booking_entity.dart';

/// Booking data model with JSON serialization
class BookingModel {
  const BookingModel({
    required this.id,
    required this.bookingNumber,
    required this.userId,
    required this.providerId,
    required this.categoryId,
    required this.status,
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
    this.finalCost,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.createdAt,
    this.confirmedAt,
    this.startedAt,
    this.completedAt,
    this.cancelledAt,
    this.cancellationReason,
  });

  /// Create BookingModel from BookingEntity
  factory BookingModel.fromEntity(BookingEntity entity) {
    return BookingModel(
      id: entity.id,
      bookingNumber: entity.bookingNumber,
      userId: entity.userId,
      providerId: entity.providerId,
      categoryId: entity.categoryId,
      status: _bookingStatusToString(entity.status),
      serviceDate: entity.serviceDate.toIso8601String().split('T')[0],
      serviceTime: entity.serviceTime,
      durationHours: entity.durationHours,
      serviceAddress: entity.serviceAddress,
      serviceCity: entity.serviceCity,
      serviceLat: entity.serviceLat,
      serviceLng: entity.serviceLng,
      contactPhone: entity.contactPhone,
      description: entity.description,
      specialInstructions: entity.specialInstructions,
      estimatedCost: entity.estimatedCost,
      finalCost: entity.finalCost,
      paymentMethod: _paymentMethodToString(entity.paymentMethod),
      paymentStatus: _paymentStatusToString(entity.paymentStatus),
      createdAt: entity.createdAt.toIso8601String(),
      confirmedAt: entity.confirmedAt?.toIso8601String(),
      startedAt: entity.startedAt?.toIso8601String(),
      completedAt: entity.completedAt?.toIso8601String(),
      cancelledAt: entity.cancelledAt?.toIso8601String(),
      cancellationReason: entity.cancellationReason,
    );
  }

  /// Create BookingModel from JSON
  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['id'] as String,
      bookingNumber: json['booking_number'] as String,
      userId: json['user_id'] as String,
      providerId: json['provider_id'] as String,
      categoryId: json['category_id'] as String,
      status: json['status'] as String,
      serviceDate: json['service_date'] as String,
      serviceTime: json['service_time'] as String,
      durationHours: (json['duration_hours'] as num).toDouble(),
      serviceAddress: json['service_address'] as String,
      serviceCity: json['service_city'] as String,
      serviceLat: json['service_lat'] != null 
          ? (json['service_lat'] as num).toDouble() 
          : null,
      serviceLng: json['service_lng'] != null 
          ? (json['service_lng'] as num).toDouble() 
          : null,
      contactPhone: json['contact_phone'] as String,
      description: json['description'] as String?,
      specialInstructions: json['special_instructions'] as String?,
      estimatedCost: (json['estimated_cost'] as num).toDouble(),
      finalCost: json['final_cost'] != null 
          ? (json['final_cost'] as num).toDouble() 
          : null,
      paymentMethod: json['payment_method'] as String,
      paymentStatus: json['payment_status'] as String,
      createdAt: json['created_at'] as String,
      confirmedAt: json['confirmed_at'] as String?,
      startedAt: json['started_at'] as String?,
      completedAt: json['completed_at'] as String?,
      cancelledAt: json['cancelled_at'] as String?,
      cancellationReason: json['cancellation_reason'] as String?,
    );
  }

  final String id;
  final String bookingNumber;
  final String userId;
  final String providerId;
  final String categoryId;
  final String status;
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
  final double? finalCost;
  final String paymentMethod;
  final String paymentStatus;
  final String createdAt; // ISO 8601 datetime string
  final String? confirmedAt;
  final String? startedAt;
  final String? completedAt;
  final String? cancelledAt;
  final String? cancellationReason;

  /// Convert BookingModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'booking_number': bookingNumber,
      'user_id': userId,
      'provider_id': providerId,
      'category_id': categoryId,
      'status': status,
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
      'final_cost': finalCost,
      'payment_method': paymentMethod,
      'payment_status': paymentStatus,
      'created_at': createdAt,
      'confirmed_at': confirmedAt,
      'started_at': startedAt,
      'completed_at': completedAt,
      'cancelled_at': cancelledAt,
      'cancellation_reason': cancellationReason,
    };
  }

  /// Convert BookingModel to BookingEntity
  BookingEntity toEntity() {
    return BookingEntity(
      id: id,
      bookingNumber: bookingNumber,
      userId: userId,
      providerId: providerId,
      categoryId: categoryId,
      status: _parseBookingStatus(status),
      serviceDate: DateTime.parse(serviceDate),
      serviceTime: serviceTime,
      durationHours: durationHours,
      serviceAddress: serviceAddress,
      serviceCity: serviceCity,
      serviceLat: serviceLat,
      serviceLng: serviceLng,
      contactPhone: contactPhone,
      description: description,
      specialInstructions: specialInstructions,
      estimatedCost: estimatedCost,
      finalCost: finalCost,
      paymentMethod: _parsePaymentMethod(paymentMethod),
      paymentStatus: _parsePaymentStatus(paymentStatus),
      createdAt: DateTime.parse(createdAt),
      confirmedAt: confirmedAt != null ? DateTime.parse(confirmedAt!) : null,
      startedAt: startedAt != null ? DateTime.parse(startedAt!) : null,
      completedAt: completedAt != null ? DateTime.parse(completedAt!) : null,
      cancelledAt: cancelledAt != null ? DateTime.parse(cancelledAt!) : null,
      cancellationReason: cancellationReason,
    );
  }

  /// Parse booking status string to enum
  static BookingStatus _parseBookingStatus(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return BookingStatus.pending;
      case 'confirmed':
        return BookingStatus.confirmed;
      case 'in_progress':
        return BookingStatus.inProgress;
      case 'completed':
        return BookingStatus.completed;
      case 'cancelled':
        return BookingStatus.cancelled;
      default:
        throw ArgumentError('Invalid booking status: $status');
    }
  }

  /// Parse payment method string to enum
  static PaymentMethod _parsePaymentMethod(String method) {
    switch (method.toLowerCase()) {
      case 'cash':
        return PaymentMethod.cash;
      case 'wallet':
        return PaymentMethod.wallet;
      case 'card':
        return PaymentMethod.card;
      default:
        throw ArgumentError('Invalid payment method: $method');
    }
  }

  /// Parse payment status string to enum
  static PaymentStatus _parsePaymentStatus(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return PaymentStatus.pending;
      case 'completed':
        return PaymentStatus.completed;
      case 'failed':
        return PaymentStatus.failed;
      case 'refunded':
        return PaymentStatus.refunded;
      default:
        throw ArgumentError('Invalid payment status: $status');
    }
  }

  /// Convert BookingStatus enum to string
  static String _bookingStatusToString(BookingStatus status) {
    switch (status) {
      case BookingStatus.pending:
        return 'pending';
      case BookingStatus.confirmed:
        return 'confirmed';
      case BookingStatus.inProgress:
        return 'in_progress';
      case BookingStatus.completed:
        return 'completed';
      case BookingStatus.cancelled:
        return 'cancelled';
    }
  }

  /// Convert PaymentMethod enum to string
  static String _paymentMethodToString(PaymentMethod method) {
    switch (method) {
      case PaymentMethod.cash:
        return 'cash';
      case PaymentMethod.wallet:
        return 'wallet';
      case PaymentMethod.card:
        return 'card';
    }
  }

  /// Convert PaymentStatus enum to string
  static String _paymentStatusToString(PaymentStatus status) {
    switch (status) {
      case PaymentStatus.pending:
        return 'pending';
      case PaymentStatus.completed:
        return 'completed';
      case PaymentStatus.failed:
        return 'failed';
      case PaymentStatus.refunded:
        return 'refunded';
    }
  }
}
