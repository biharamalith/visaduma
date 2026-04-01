// ============================================================
// FILE: lib/features/services/domain/entities/service_category_entity.dart
// PURPOSE: Pure domain entity for a service category with multilingual support.
// ============================================================

class ServiceCategoryEntity {
  final String id;
  final String name;
  final String? nameSi; // Sinhala translation
  final String? nameTa; // Tamil translation
  final String? description;
  final String iconName; // Material icon name
  final String colorHex; // Hex color code (e.g., "#2563EB")
  final int? providerCount; // Number of providers in this category

  const ServiceCategoryEntity({
    required this.id,
    required this.name,
    this.nameSi,
    this.nameTa,
    this.description,
    required this.iconName,
    required this.colorHex,
    this.providerCount,
  });

  /// Returns the localized name based on the provided language code.
  /// Falls back to English name if translation is not available.
  String getLocalizedName(String languageCode) {
    switch (languageCode) {
      case 'si':
        return nameSi ?? name;
      case 'ta':
        return nameTa ?? name;
      default:
        return name;
    }
  }

  /// Creates a copy of this entity with the given fields replaced.
  ServiceCategoryEntity copyWith({
    String? id,
    String? name,
    String? nameSi,
    String? nameTa,
    String? description,
    String? iconName,
    String? colorHex,
    int? providerCount,
  }) {
    return ServiceCategoryEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      nameSi: nameSi ?? this.nameSi,
      nameTa: nameTa ?? this.nameTa,
      description: description ?? this.description,
      iconName: iconName ?? this.iconName,
      colorHex: colorHex ?? this.colorHex,
      providerCount: providerCount ?? this.providerCount,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ServiceCategoryEntity &&
        other.id == id &&
        other.name == name &&
        other.nameSi == nameSi &&
        other.nameTa == nameTa &&
        other.description == description &&
        other.iconName == iconName &&
        other.colorHex == colorHex &&
        other.providerCount == providerCount;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        nameSi.hashCode ^
        nameTa.hashCode ^
        description.hashCode ^
        iconName.hashCode ^
        colorHex.hashCode ^
        providerCount.hashCode;
  }

  @override
  String toString() {
    return 'ServiceCategoryEntity(id: $id, name: $name, nameSi: $nameSi, nameTa: $nameTa, description: $description, iconName: $iconName, colorHex: $colorHex, providerCount: $providerCount)';
  }
}
