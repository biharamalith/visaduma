// ============================================================
// FILE: lib/features/bookings/domain/entities/booking_entity.dart
// PURPOSE: Pure Dart class representing a service booking.
//          No Flutter or JSON dependencies — domain is framework-free.
// ============================================================

/// Booking status enum
enum BookingStatus {
  pending,
  confirmed,
  inProgress,
  completed,
  cancelled,
}

/// Payment method enum
enum PaymentMethod {
  cash,
  wallet,
  card,
}

/// Payment status enum
enum PaymentStatus {
  pending,
  completed,
  failed,
  refunded,
}

/// Service booking entity
class BookingEntity {
  final String id;
  final String bookingNumber;
  final String userId;
  final String providerId;
  final String categoryId;
  final BookingStatus status;
  final DateTime serviceDate;
  final String serviceTime; // Stored as "HH:mm" format
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
  final PaymentMethod paymentMethod;
  final PaymentStatus paymentStatus;
  final DateTime createdAt;
  final DateTime? confirmedAt;
  final DateTime? startedAt;
  final DateTime? completedAt;
  final DateTime? cancelledAt;
  final String? cancellationReason;

  const BookingEntity({
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
}
