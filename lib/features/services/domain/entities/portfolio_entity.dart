// ============================================================
// FILE: lib/features/services/domain/entities/portfolio_entity.dart
// PURPOSE: Pure domain entity for a service provider's portfolio item.
// ============================================================

class PortfolioEntity {
  final int id;
  final String providerId;
  final String imageUrl;
  final String? title;
  final String? description;
  final int displayOrder;
  final DateTime createdAt;

  const PortfolioEntity({
    required this.id,
    required this.providerId,
    required this.imageUrl,
    this.title,
    this.description,
    required this.displayOrder,
    required this.createdAt,
  });

  /// Creates a copy of this entity with the given fields replaced.
  PortfolioEntity copyWith({
    int? id,
    String? providerId,
    String? imageUrl,
    String? title,
    String? description,
    int? displayOrder,
    DateTime? createdAt,
  }) {
    return PortfolioEntity(
      id: id ?? this.id,
      providerId: providerId ?? this.providerId,
      imageUrl: imageUrl ?? this.imageUrl,
      title: title ?? this.title,
      description: description ?? this.description,
      displayOrder: displayOrder ?? this.displayOrder,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PortfolioEntity &&
        other.id == id &&
        other.providerId == providerId &&
        other.imageUrl == imageUrl &&
        other.title == title &&
        other.description == description &&
        other.displayOrder == displayOrder &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        providerId.hashCode ^
        imageUrl.hashCode ^
        title.hashCode ^
        description.hashCode ^
        displayOrder.hashCode ^
        createdAt.hashCode;
  }

  @override
  String toString() {
    return 'PortfolioEntity(id: $id, providerId: $providerId, title: $title, imageUrl: $imageUrl)';
  }
}
