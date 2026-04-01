// ============================================================
// FILE: lib/features/services/data/models/portfolio_model.dart
// PURPOSE: JSON-serializable model that maps the API response
//          to a PortfolioEntity.
//
// Run `flutter pub run build_runner build` to generate
// portfolio_model.g.dart after editing this file.
// ============================================================

import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/portfolio_entity.dart';

part 'portfolio_model.g.dart';

@JsonSerializable()
class PortfolioModel {
  const PortfolioModel({
    required this.id,
    required this.providerId,
    required this.imageUrl,
    this.title,
    this.description,
    required this.displayOrder,
    required this.createdAt,
  });

  factory PortfolioModel.fromJson(Map<String, dynamic> json) =>
      _$PortfolioModelFromJson(json);

  /// Creates a model from a domain entity
  factory PortfolioModel.fromEntity(PortfolioEntity entity) {
    return PortfolioModel(
      id: entity.id,
      providerId: entity.providerId,
      imageUrl: entity.imageUrl,
      title: entity.title,
      description: entity.description,
      displayOrder: entity.displayOrder,
      createdAt: entity.createdAt,
    );
  }

  final int id;
  @JsonKey(name: 'provider_id')
  final String providerId;
  @JsonKey(name: 'image_url')
  final String imageUrl;
  final String? title;
  final String? description;
  @JsonKey(name: 'display_order')
  final int displayOrder;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  Map<String, dynamic> toJson() => _$PortfolioModelToJson(this);

  /// Converts this model to a domain entity
  PortfolioEntity toEntity() {
    return PortfolioEntity(
      id: id,
      providerId: providerId,
      imageUrl: imageUrl,
      title: title,
      description: description,
      displayOrder: displayOrder,
      createdAt: createdAt,
    );
  }
}
