// ============================================================
// FILE: lib/features/services/data/models/service_provider_model.dart
// PURPOSE: JSON-serializable model that maps the API response
//          to a ServiceProviderEntity.
//
// Run `flutter pub run build_runner build` to generate
// service_provider_model.g.dart after editing this file.
// ============================================================

import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/service_provider_entity.dart';
import 'portfolio_model.dart';
import 'certification_model.dart';

part 'service_provider_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ServiceProviderModel {
  const ServiceProviderModel({
    required this.id,
    required this.userId,
    required this.businessName,
    this.description,
    required this.categoryId,
    this.hourlyRate,
    this.fixedRates,
    required this.serviceArea,
    this.availability,
    required this.isVerified,
    required this.isAvailable,
    required this.rating,
    required this.totalReviews,
    required this.totalBookings,
    required this.completionRate,
    required this.responseTimeMin,
    required this.yearsExperience,
    this.portfolio = const [],
    this.certifications = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  factory ServiceProviderModel.fromJson(Map<String, dynamic> json) =>
      _$ServiceProviderModelFromJson(json);

  /// Creates a model from a domain entity
  factory ServiceProviderModel.fromEntity(ServiceProviderEntity entity) {
    return ServiceProviderModel(
      id: entity.id,
      userId: entity.userId,
      businessName: entity.businessName,
      description: entity.description,
      categoryId: entity.categoryId,
      hourlyRate: entity.hourlyRate,
      fixedRates: entity.fixedRates,
      serviceArea: entity.serviceArea,
      availability: entity.availability,
      isVerified: entity.isVerified,
      isAvailable: entity.isAvailable,
      rating: entity.rating,
      totalReviews: entity.totalReviews,
      totalBookings: entity.totalBookings,
      completionRate: entity.completionRate,
      responseTimeMin: entity.responseTimeMin,
      yearsExperience: entity.yearsExperience,
      portfolio: entity.portfolio.map((e) => PortfolioModel.fromEntity(e)).toList(),
      certifications: entity.certifications.map((e) => CertificationModel.fromEntity(e)).toList(),
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  final String id;
  @JsonKey(name: 'user_id')
  final String userId;
  @JsonKey(name: 'business_name')
  final String businessName;
  final String? description;
  @JsonKey(name: 'category_id')
  final String categoryId;
  @JsonKey(name: 'hourly_rate')
  final double? hourlyRate;
  @JsonKey(name: 'fixed_rates')
  final Map<String, double>? fixedRates;
  @JsonKey(name: 'service_area')
  final List<String> serviceArea;
  final Map<String, dynamic>? availability;
  @JsonKey(name: 'is_verified')
  final bool isVerified;
  @JsonKey(name: 'is_available')
  final bool isAvailable;
  final double rating;
  @JsonKey(name: 'total_reviews')
  final int totalReviews;
  @JsonKey(name: 'total_bookings')
  final int totalBookings;
  @JsonKey(name: 'completion_rate')
  final double completionRate;
  @JsonKey(name: 'response_time_min')
  final int responseTimeMin;
  @JsonKey(name: 'years_experience')
  final int yearsExperience;
  final List<PortfolioModel> portfolio;
  final List<CertificationModel> certifications;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  Map<String, dynamic> toJson() => _$ServiceProviderModelToJson(this);

  /// Converts this model to a domain entity
  ServiceProviderEntity toEntity() {
    return ServiceProviderEntity(
      id: id,
      userId: userId,
      businessName: businessName,
      description: description,
      categoryId: categoryId,
      hourlyRate: hourlyRate,
      fixedRates: fixedRates,
      serviceArea: serviceArea,
      availability: availability,
      isVerified: isVerified,
      isAvailable: isAvailable,
      rating: rating,
      totalReviews: totalReviews,
      totalBookings: totalBookings,
      completionRate: completionRate,
      responseTimeMin: responseTimeMin,
      yearsExperience: yearsExperience,
      portfolio: portfolio.map((e) => e.toEntity()).toList(),
      certifications: certifications.map((e) => e.toEntity()).toList(),
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
