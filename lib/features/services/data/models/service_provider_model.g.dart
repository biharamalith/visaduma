// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_provider_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ServiceProviderModel _$ServiceProviderModelFromJson(
        Map<String, dynamic> json) =>
    ServiceProviderModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      businessName: json['business_name'] as String,
      description: json['description'] as String?,
      categoryId: json['category_id'] as String,
      hourlyRate: (json['hourly_rate'] as num?)?.toDouble(),
      fixedRates: (json['fixed_rates'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, (e as num).toDouble()),
      ),
      serviceArea: (json['service_area'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      availability: json['availability'] as Map<String, dynamic>?,
      isVerified: json['is_verified'] as bool,
      isAvailable: json['is_available'] as bool,
      rating: (json['rating'] as num).toDouble(),
      totalReviews: (json['total_reviews'] as num).toInt(),
      totalBookings: (json['total_bookings'] as num).toInt(),
      completionRate: (json['completion_rate'] as num).toDouble(),
      responseTimeMin: (json['response_time_min'] as num).toInt(),
      yearsExperience: (json['years_experience'] as num).toInt(),
      portfolio: (json['portfolio'] as List<dynamic>?)
              ?.map((e) => PortfolioModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      certifications: (json['certifications'] as List<dynamic>?)
              ?.map(
                  (e) => CertificationModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$ServiceProviderModelToJson(
        ServiceProviderModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'business_name': instance.businessName,
      'description': instance.description,
      'category_id': instance.categoryId,
      'hourly_rate': instance.hourlyRate,
      'fixed_rates': instance.fixedRates,
      'service_area': instance.serviceArea,
      'availability': instance.availability,
      'is_verified': instance.isVerified,
      'is_available': instance.isAvailable,
      'rating': instance.rating,
      'total_reviews': instance.totalReviews,
      'total_bookings': instance.totalBookings,
      'completion_rate': instance.completionRate,
      'response_time_min': instance.responseTimeMin,
      'years_experience': instance.yearsExperience,
      'portfolio': instance.portfolio.map((e) => e.toJson()).toList(),
      'certifications': instance.certifications.map((e) => e.toJson()).toList(),
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };
