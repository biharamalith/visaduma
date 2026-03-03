// ============================================================
// FILE: lib/features/services/data/models/service_model.dart
// ============================================================

import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/service_entity.dart';

part 'service_model.g.dart';

@JsonSerializable()
class ServiceModel extends ServiceEntity {
  const ServiceModel({
    required super.id,
    required super.name,
    required super.description,
    required super.category,
    required super.subCategory,
    required super.pricePerHour,
    required super.rating,
    required super.reviewCount,
    required super.isAvailable,
    required super.providerId,
    required super.providerName,
    super.providerAvatarUrl,
    required super.distanceKm,
    required super.imageUrls,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) =>
      _$ServiceModelFromJson(json);

  Map<String, dynamic> toJson() => _$ServiceModelToJson(this);
}
