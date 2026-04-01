// ============================================================
// FILE: lib/features/chat/presentation/viewmodels/chat_viewmodel.dart
// PURPOSE: Manages socket.io real-time messaging + conversation list.
//          Validates: Requirements 67.3, 67.4
// ============================================================
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import '../../../../core/storage/secure_storage_service.dart';
import '../../domain/entities/message_entity.dart';

// ── Chat room state ───────────────────────────────────────

class ChatRoomState {
  final List<MessageEntity> messages;
  final bool isConnected;
  final bool isSending;

  const ChatRoomState({
    this.messages = const [],
    this.isConnected = false,
    this.isSending = false,
  });

  ChatRoomState copyWith({
    List<MessageEntity>? messages,
    bool? isConnected,
    bool? isSending,
  }) =>
      ChatRoomState(
        messages: messages ?? this.messages,
        isConnected: isConnected ?? this.isConnected,
        isSending: isSending ?? this.isSending,
      );
}

class ChatRoomNotifier extends FamilyNotifier<ChatRoomState, String> {
  io.Socket? _socket;
  late final String _conversationId;

  @override
  ChatRoomState build(String conversationId) {
    _conversationId = conversationId;
    Future.microtask(_connect);
    ref.onDispose(_disconnect);
    return const ChatRoomState();
  }

  void _connect() async {
    final secureStorage = SecureStorageService();
    final token = await secureStorage.getAccessToken();

    _socket = io.io(
      'http://192.168.1.100:3000',
      io.OptionBuilder()
          .setTransports(['websocket'])
          .setExtraHeaders({'Authorization': 'Bearer $token'})
          .build(),
    );

    _socket?.onConnect((_) {
      state = state.copyWith(isConnected: true);
      _socket?.emit('join', _conversationId);
    });

    _socket?.onDisconnect((_) {
      state = state.copyWith(isConnected: false);
    });

    _socket?.on('message', (data) {
      final message = MessageEntity(
        id: data['id'] as String,
        conversationId: _conversationId,
        senderId: data['senderId'] as String,
        senderName: data['senderName'] as String,
        content: data['content'] as String,
        type: data['type'] as String? ?? 'text',
        isRead: false,
        sentAt: DateTime.parse(data['sentAt'] as String),
      );
      state = state.copyWith(messages: [...state.messages, message]);
    });
  }

  void _disconnect() {
    _socket?.emit('leave', _conversationId);
    _socket?.disconnect();
    _socket = null;
  }

  void sendMessage(String content) {
    if (!state.isConnected || content.trim().isEmpty) return;
    state = state.copyWith(isSending: true);
    _socket?.emit('message', {
      'conversationId': _conversationId,
      'content': content.trim(),
      'type': 'text',
    });
    state = state.copyWith(isSending: false);
  }
}

final chatRoomProvider =
    NotifierProviderFamily<ChatRoomNotifier, ChatRoomState, String>(
  ChatRoomNotifier.new,
);
