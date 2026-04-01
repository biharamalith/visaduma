// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_category_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ServiceCategoryModel _$ServiceCategoryModelFromJson(
        Map<String, dynamic> json) =>
    ServiceCategoryModel(
      id: json['id'] as String,
      name: json['name'] as String,
      nameSi: json['name_si'] as String?,
      nameTa: json['name_ta'] as String?,
      description: json['description'] as String?,
      iconName: json['icon_name'] as String,
      colorHex: json['color_hex'] as String,
      providerCount: (json['provider_count'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ServiceCategoryModelToJson(
        ServiceCategoryModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'name_si': instance.nameSi,
      'name_ta': instance.nameTa,
      'description': instance.description,
      'icon_name': instance.iconName,
      'color_hex': instance.colorHex,
      'provider_count': instance.providerCount,
    };
