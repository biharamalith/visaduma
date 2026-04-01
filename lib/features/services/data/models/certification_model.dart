// ============================================================
// FILE: lib/features/services/data/models/certification_model.dart
// PURPOSE: JSON-serializable model that maps the API response
//          to a CertificationEntity.
//
// Run `flutter pub run build_runner build` to generate
// certification_model.g.dart after editing this file.
// ============================================================

import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/certification_entity.dart';

part 'certification_model.g.dart';

@JsonSerializable()
class CertificationModel {
  const CertificationModel({
    required this.id,
    required this.providerId,
    required this.certificationName,
    this.issuingOrg,
    this.issueDate,
    this.expiryDate,
    this.documentUrl,
    required this.isVerified,
    required this.createdAt,
  });

  factory CertificationModel.fromJson(Map<String, dynamic> json) =>
      _$CertificationModelFromJson(json);

  /// Creates a model from a domain entity
  factory CertificationModel.fromEntity(CertificationEntity entity) {
    return CertificationModel(
      id: entity.id,
      providerId: entity.providerId,
      certificationName: entity.certificationName,
      issuingOrg: entity.issuingOrg,
      issueDate: entity.issueDate,
      expiryDate: entity.expiryDate,
      documentUrl: entity.documentUrl,
      isVerified: entity.isVerified,
      createdAt: entity.createdAt,
    );
  }

  final int id;
  @JsonKey(name: 'provider_id')
  final String providerId;
  @JsonKey(name: 'certification_name')
  final String certificationName;
  @JsonKey(name: 'issuing_org')
  final String? issuingOrg;
  @JsonKey(name: 'issue_date')
  final DateTime? issueDate;
  @JsonKey(name: 'expiry_date')
  final DateTime? expiryDate;
  @JsonKey(name: 'document_url')
  final String? documentUrl;
  @JsonKey(name: 'is_verified')
  final bool isVerified;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  Map<String, dynamic> toJson() => _$CertificationModelToJson(this);

  /// Converts this model to a domain entity
  CertificationEntity toEntity() {
    return CertificationEntity(
      id: id,
      providerId: providerId,
      certificationName: certificationName,
      issuingOrg: issuingOrg,
      issueDate: issueDate,
      expiryDate: expiryDate,
      documentUrl: documentUrl,
      isVerified: isVerified,
      createdAt: createdAt,
    );
  }
}
