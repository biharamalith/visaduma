// ============================================================
// FILE: lib/features/chat/domain/entities/message_entity.dart
// ============================================================

class MessageEntity {
  final String id;
  final String conversationId;
  final String senderId;
  final String senderName;
  final String content;
  final String type; // text | image | file
  final bool isRead;
  final DateTime sentAt;

  const MessageEntity({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.senderName,
    required this.content,
    required this.type,
    required this.isRead,
    required this.sentAt,
  });
}

class ConversationEntity {
  final String id;
  final String participantId;
  final String participantName;
  final String? participantAvatar;
  final MessageEntity? lastMessage;
  final int unreadCount;
  final DateTime updatedAt;

  const ConversationEntity({
    required this.id,
    required this.participantId,
    required this.participantName,
    this.participantAvatar,
    this.lastMessage,
    required this.unreadCount,
    required this.updatedAt,
  });
}
