// ============================================================
// FILE: lib/features/auth/domain/entities/user_entity.dart
// PURPOSE: Pure Dart class representing an authenticated user.
//          No Flutter or JSON dependencies — domain is framework-free.
// ============================================================

class UserEntity {
  final String id;
  final String fullName;
  final String email;
  final String phone;
  final String role; // 'user' | 'provider' | 'shop_owner' | 'admin'
  final String? avatarUrl;
  final bool isVerified;
  final DateTime createdAt;

  const UserEntity({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.role,
    this.avatarUrl,
    required this.isVerified,
    required this.createdAt,
  });
}
