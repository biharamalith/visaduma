// ============================================================
// FILE: lib/features/boarding/domain/entities/boarding_entity.dart
// ============================================================
class BoardingEntity {
  final String id;
  final String title;
  final String ownerName;
  final String location;
  final String type; // room | apartment | house | hostel
  final double pricePerMonth;
  final int bedrooms;
  final bool isFurnished;
  final List<String> amenities;
  final double rating;
  final bool isAvailable;
  final String? imageUrl;

  const BoardingEntity({
    required this.id,
    required this.title,
    required this.ownerName,
    required this.location,
    required this.type,
    required this.pricePerMonth,
    required this.bedrooms,
    required this.isFurnished,
    required this.amenities,
    required this.rating,
    required this.isAvailable,
    this.imageUrl,
  });
}
