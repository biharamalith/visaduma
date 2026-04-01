// ============================================================
// FILE: lib/features/services/domain/entities/service_provider_entity.dart
// PURPOSE: Pure domain entity for a service provider with detailed profile information.
// ============================================================

import 'portfolio_entity.dart';
import 'certification_entity.dart';

class ServiceProviderEntity {
  final String id;
  final String userId;
  final String businessName;
  final String? description;
  final String categoryId;
  final double? hourlyRate;
  final Map<String, double>? fixedRates; // Service name -> price mapping
  final List<String> serviceArea; // List of cities covered
  final Map<String, dynamic>? availability; // Weekly schedule
  final bool isVerified;
  final bool isAvailable;
  final double rating;
  final int totalReviews;
  final int totalBookings;
  final double completionRate; // Percentage (0-100)
  final int responseTimeMin; // Average response time in minutes
  final int yearsExperience;
  final List<PortfolioEntity> portfolio;
  final List<CertificationEntity> certifications;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ServiceProviderEntity({
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

  /// Creates a copy of this entity with the given fields replaced.
  ServiceProviderEntity copyWith({
    String? id,
    String? userId,
    String? businessName,
    String? description,
    String? categoryId,
    double? hourlyRate,
    Map<String, double>? fixedRates,
    List<String>? serviceArea,
    Map<String, dynamic>? availability,
    bool? isVerified,
    bool? isAvailable,
    double? rating,
    int? totalReviews,
    int? totalBookings,
    double? completionRate,
    int? responseTimeMin,
    int? yearsExperience,
    List<PortfolioEntity>? portfolio,
    List<CertificationEntity>? certifications,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ServiceProviderEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      businessName: businessName ?? this.businessName,
      description: description ?? this.description,
      categoryId: categoryId ?? this.categoryId,
      hourlyRate: hourlyRate ?? this.hourlyRate,
      fixedRates: fixedRates ?? this.fixedRates,
      serviceArea: serviceArea ?? this.serviceArea,
      availability: availability ?? this.availability,
      isVerified: isVerified ?? this.isVerified,
      isAvailable: isAvailable ?? this.isAvailable,
      rating: rating ?? this.rating,
      totalReviews: totalReviews ?? this.totalReviews,
      totalBookings: totalBookings ?? this.totalBookings,
      completionRate: completionRate ?? this.completionRate,
      responseTimeMin: responseTimeMin ?? this.responseTimeMin,
      yearsExperience: yearsExperience ?? this.yearsExperience,
      portfolio: portfolio ?? this.portfolio,
      certifications: certifications ?? this.certifications,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ServiceProviderEntity &&
        other.id == id &&
        other.userId == userId &&
        other.businessName == businessName &&
        other.description == description &&
        other.categoryId == categoryId &&
        other.hourlyRate == hourlyRate &&
        other.isVerified == isVerified &&
        other.isAvailable == isAvailable &&
        other.rating == rating &&
        other.totalReviews == totalReviews &&
        other.totalBookings == totalBookings &&
        other.completionRate == completionRate &&
        other.responseTimeMin == responseTimeMin &&
        other.yearsExperience == yearsExperience &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        userId.hashCode ^
        businessName.hashCode ^
        description.hashCode ^
        categoryId.hashCode ^
        hourlyRate.hashCode ^
        isVerified.hashCode ^
        isAvailable.hashCode ^
        rating.hashCode ^
        totalReviews.hashCode ^
        totalBookings.hashCode ^
        completionRate.hashCode ^
        responseTimeMin.hashCode ^
        yearsExperience.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }

  @override
  String toString() {
    return 'ServiceProviderEntity(id: $id, userId: $userId, businessName: $businessName, categoryId: $categoryId, rating: $rating, totalBookings: $totalBookings, yearsExperience: $yearsExperience, isVerified: $isVerified)';
  }
}
