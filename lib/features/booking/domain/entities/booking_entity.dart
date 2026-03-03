// ============================================================
// FILE: lib/features/booking/domain/entities/booking_entity.dart
// ============================================================

class BookingEntity {
  final String id;
  final String serviceId;
  final String serviceName;
  final String providerId;
  final String providerName;
  final String userId;
  final DateTime scheduledAt;
  final int durationHours;
  final double totalPrice;
  final String status; // pending | confirmed | cancelled | completed
  final String? notes;
  final DateTime createdAt;

  const BookingEntity({
    required this.id,
    required this.serviceId,
    required this.serviceName,
    required this.providerId,
    required this.providerName,
    required this.userId,
    required this.scheduledAt,
    required this.durationHours,
    required this.totalPrice,
    required this.status,
    this.notes,
    required this.createdAt,
  });
}
