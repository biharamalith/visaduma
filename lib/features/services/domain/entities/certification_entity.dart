// ============================================================
// FILE: lib/features/services/domain/entities/certification_entity.dart
// PURPOSE: Pure domain entity for a service provider's certification.
// ============================================================

class CertificationEntity {
  final int id;
  final String providerId;
  final String certificationName;
  final String? issuingOrg;
  final DateTime? issueDate;
  final DateTime? expiryDate;
  final String? documentUrl;
  final bool isVerified;
  final DateTime createdAt;

  const CertificationEntity({
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

  /// Checks if the certification is currently valid (not expired).
  bool get isValid {
    if (expiryDate == null) return true;
    return DateTime.now().isBefore(expiryDate!);
  }

  /// Creates a copy of this entity with the given fields replaced.
  CertificationEntity copyWith({
    int? id,
    String? providerId,
    String? certificationName,
    String? issuingOrg,
    DateTime? issueDate,
    DateTime? expiryDate,
    String? documentUrl,
    bool? isVerified,
    DateTime? createdAt,
  }) {
    return CertificationEntity(
      id: id ?? this.id,
      providerId: providerId ?? this.providerId,
      certificationName: certificationName ?? this.certificationName,
      issuingOrg: issuingOrg ?? this.issuingOrg,
      issueDate: issueDate ?? this.issueDate,
      expiryDate: expiryDate ?? this.expiryDate,
      documentUrl: documentUrl ?? this.documentUrl,
      isVerified: isVerified ?? this.isVerified,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CertificationEntity &&
        other.id == id &&
        other.providerId == providerId &&
        other.certificationName == certificationName &&
        other.issuingOrg == issuingOrg &&
        other.issueDate == issueDate &&
        other.expiryDate == expiryDate &&
        other.documentUrl == documentUrl &&
        other.isVerified == isVerified &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        providerId.hashCode ^
        certificationName.hashCode ^
        issuingOrg.hashCode ^
        issueDate.hashCode ^
        expiryDate.hashCode ^
        documentUrl.hashCode ^
        isVerified.hashCode ^
        createdAt.hashCode;
  }

  @override
  String toString() {
    return 'CertificationEntity(id: $id, providerId: $providerId, certificationName: $certificationName, issuingOrg: $issuingOrg, isVerified: $isVerified, isValid: $isValid)';
  }
}
