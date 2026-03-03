// ============================================================
// FILE: lib/features/vehicles/domain/entities/vehicle_entity.dart
// ============================================================
class VehicleEntity {
  final String id;
  final String ownerName;
  final String vehicleType;
  final String brand;
  final String model;
  final int year;
  final double pricePerDay;
  final double rating;
  final bool isAvailable;
  final String? imageUrl;

  const VehicleEntity({
    required this.id,
    required this.ownerName,
    required this.vehicleType,
    required this.brand,
    required this.model,
    required this.year,
    required this.pricePerDay,
    required this.rating,
    required this.isAvailable,
    this.imageUrl,
  });
}
