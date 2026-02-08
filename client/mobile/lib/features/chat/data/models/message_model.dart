import 'package:simple_chat/features/chat/domain/entities/message.dart';

class MessageModel extends Message {
  const MessageModel({
    required super.id,
    required super.conversationId,
    required super.senderId,
    required super.content,
    required super.createdAt,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'] as String,
      conversationId: json['conversationId'] as String,
      senderId: json['senderId'] as String,
      content: json['content'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'conversationId': conversationId,
      'senderId': senderId,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
