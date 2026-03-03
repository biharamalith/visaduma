// ============================================================
// FILE: lib/features/auth/data/models/user_model.dart
// PURPOSE: JSON-serializable model that maps the API response
//          to a UserEntity. Extends UserEntity so it can be
//          passed directly into domain-layer code.
//
// Run `flutter pub run build_runner build` to generate
// user_model.g.dart after editing this file.
// ============================================================

import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/user_entity.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.fullName,
    required super.email,
    required super.phone,
    required super.role,
    super.avatarUrl,
    required super.isVerified,
    required super.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}
