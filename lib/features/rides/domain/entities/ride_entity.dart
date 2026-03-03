// ============================================================
// FILE: lib/features/rides/domain/entities/ride_entity.dart
// ============================================================
class RideEntity {
  final String id;
  final String driverName;
  final String driverAvatar;
  final String vehicleType;
  final String vehiclePlate;
  final double rating;
  final int reviewCount;
  final double pricePerKm;
  final bool isAvailable;
  final double distanceKm;

  const RideEntity({
    required this.id,
    required this.driverName,
    required this.driverAvatar,
    required this.vehicleType,
    required this.vehiclePlate,
    required this.rating,
    required this.reviewCount,
    required this.pricePerKm,
    required this.isAvailable,
    required this.distanceKm,
  });
}
