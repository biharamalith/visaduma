// ============================================================
// FILE: lib/features/shops/domain/entities/shop_entity.dart
// ============================================================
class ShopEntity {
  final String id;
  final String name;
  final String category;
  final String description;
  final double rating;
  final int reviewCount;
  final bool isOpen;
  final String? imageUrl;
  final double distanceKm;

  const ShopEntity({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.rating,
    required this.reviewCount,
    required this.isOpen,
    this.imageUrl,
    required this.distanceKm,
  });
}
