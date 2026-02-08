import 'package:simple_chat/features/chat/data/models/message_model.dart';
import 'package:simple_chat/features/chat/domain/entities/conversation.dart';

class ConversationModel extends Conversation {
  const ConversationModel({
    required super.id,
    required super.participantIds,
    required super.messages,
    super.createdAt,
    super.updatedAt,
  });

  factory ConversationModel.fromJson(Map<String, dynamic> json) {
    final messagesJson = json['messages'] as List<dynamic>?;
    final messages = messagesJson != null
        ? messagesJson.map((m) => MessageModel.fromJson(m)).toList()
        : <MessageModel>[];

    return ConversationModel(
      id: json['id'] as String,
      participantIds: List<String>.from(json['participantIds'] as List),
      messages: messages,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'participantIds': participantIds,
      'messages': messages.map((m) => (m as MessageModel).toJson()).toList(),
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}
