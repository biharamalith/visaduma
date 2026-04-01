// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ServiceModel _$ServiceModelFromJson(Map<String, dynamic> json) => ServiceModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      category: json['category'] as String,
      subCategory: json['subCategory'] as String,
      pricePerHour: (json['pricePerHour'] as num).toDouble(),
      rating: (json['rating'] as num).toDouble(),
      reviewCount: (json['reviewCount'] as num).toInt(),
      isAvailable: json['isAvailable'] as bool,
      providerId: json['providerId'] as String,
      providerName: json['providerName'] as String,
      providerAvatarUrl: json['providerAvatarUrl'] as String?,
      distanceKm: (json['distanceKm'] as num).toDouble(),
      imageUrls:
          (json['imageUrls'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$ServiceModelToJson(ServiceModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'category': instance.category,
      'subCategory': instance.subCategory,
      'pricePerHour': instance.pricePerHour,
      'rating': instance.rating,
      'reviewCount': instance.reviewCount,
      'isAvailable': instance.isAvailable,
      'providerId': instance.providerId,
      'providerName': instance.providerName,
      'providerAvatarUrl': instance.providerAvatarUrl,
      'distanceKm': instance.distanceKm,
      'imageUrls': instance.imageUrls,
    };
