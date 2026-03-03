// ============================================================
// FILE: lib/features/services/domain/entities/service_entity.dart
// PURPOSE: Pure domain entity for a service listing.
// ============================================================

class ServiceEntity {
  final String id;
  final String name;
  final String description;
  final String category;
  final String subCategory;
  final double pricePerHour;
  final double rating;
  final int reviewCount;
  final bool isAvailable;
  final String providerId;
  final String providerName;
  final String? providerAvatarUrl;
  final double distanceKm;
  final List<String> imageUrls;

  const ServiceEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.subCategory,
    required this.pricePerHour,
    required this.rating,
    required this.reviewCount,
    required this.isAvailable,
    required this.providerId,
    required this.providerName,
    this.providerAvatarUrl,
    required this.distanceKm,
    required this.imageUrls,
  });
}
