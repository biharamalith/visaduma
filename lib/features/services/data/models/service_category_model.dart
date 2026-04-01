// ============================================================
// FILE: lib/features/services/data/models/service_category_model.dart
// PURPOSE: JSON-serializable model that maps the API response
//          to a ServiceCategoryEntity.
//
// Run `flutter pub run build_runner build` to generate
// service_category_model.g.dart after editing this file.
// ============================================================

import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/service_category_entity.dart';

part 'service_category_model.g.dart';

@JsonSerializable()
class ServiceCategoryModel {
  const ServiceCategoryModel({
    required this.id,
    required this.name,
    this.nameSi,
    this.nameTa,
    this.description,
    required this.iconName,
    required this.colorHex,
    this.providerCount,
  });

  factory ServiceCategoryModel.fromJson(Map<String, dynamic> json) =>
      _$ServiceCategoryModelFromJson(json);

  /// Creates a model from a domain entity
  factory ServiceCategoryModel.fromEntity(ServiceCategoryEntity entity) {
    return ServiceCategoryModel(
      id: entity.id,
      name: entity.name,
      nameSi: entity.nameSi,
      nameTa: entity.nameTa,
      description: entity.description,
      iconName: entity.iconName,
      colorHex: entity.colorHex,
      providerCount: entity.providerCount,
    );
  }

  final String id;
  final String name;
  @JsonKey(name: 'name_si')
  final String? nameSi;
  @JsonKey(name: 'name_ta')
  final String? nameTa;
  final String? description;
  @JsonKey(name: 'icon_name')
  final String iconName;
  @JsonKey(name: 'color_hex')
  final String colorHex;
  @JsonKey(name: 'provider_count')
  final int? providerCount;

  Map<String, dynamic> toJson() => _$ServiceCategoryModelToJson(this);

  /// Converts this model to a domain entity
  ServiceCategoryEntity toEntity() {
    return ServiceCategoryEntity(
      id: id,
      name: name,
      nameSi: nameSi,
      nameTa: nameTa,
      description: description,
      iconName: iconName,
      colorHex: colorHex,
      providerCount: providerCount,
    );
  }
}
