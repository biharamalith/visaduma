// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'portfolio_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PortfolioModel _$PortfolioModelFromJson(Map<String, dynamic> json) =>
    PortfolioModel(
      id: (json['id'] as num).toInt(),
      providerId: json['provider_id'] as String,
      imageUrl: json['image_url'] as String,
      title: json['title'] as String?,
      description: json['description'] as String?,
      displayOrder: (json['display_order'] as num).toInt(),
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$PortfolioModelToJson(PortfolioModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'provider_id': instance.providerId,
      'image_url': instance.imageUrl,
      'title': instance.title,
      'description': instance.description,
      'display_order': instance.displayOrder,
      'created_at': instance.createdAt.toIso8601String(),
    };
