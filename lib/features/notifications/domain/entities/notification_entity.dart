// ============================================================
// FILE: lib/features/notifications/domain/entities/notification_entity.dart
// ============================================================
class NotificationEntity {
  final String id;
  final String title;
  final String body;
  final String type; // booking | chat | system | promo
  final bool isRead;
  final DateTime createdAt;
  final Map<String, dynamic>? payload;

  const NotificationEntity({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    required this.isRead,
    required this.createdAt,
    this.payload,
  });
}
