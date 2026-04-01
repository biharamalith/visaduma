// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'certification_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CertificationModel _$CertificationModelFromJson(Map<String, dynamic> json) =>
    CertificationModel(
      id: (json['id'] as num).toInt(),
      providerId: json['provider_id'] as String,
      certificationName: json['certification_name'] as String,
      issuingOrg: json['issuing_org'] as String?,
      issueDate: json['issue_date'] == null
          ? null
          : DateTime.parse(json['issue_date'] as String),
      expiryDate: json['expiry_date'] == null
          ? null
          : DateTime.parse(json['expiry_date'] as String),
      documentUrl: json['document_url'] as String?,
      isVerified: json['is_verified'] as bool,
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$CertificationModelToJson(CertificationModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'provider_id': instance.providerId,
      'certification_name': instance.certificationName,
      'issuing_org': instance.issuingOrg,
      'issue_date': instance.issueDate?.toIso8601String(),
      'expiry_date': instance.expiryDate?.toIso8601String(),
      'document_url': instance.documentUrl,
      'is_verified': instance.isVerified,
      'created_at': instance.createdAt.toIso8601String(),
    };
