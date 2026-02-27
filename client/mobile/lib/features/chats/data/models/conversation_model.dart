import 'package:simple_chat/features/chats/data/models/message_model.dart';
import 'package:simple_chat/features/chats/domain/entities/conversation.dart';

class ConversationModel extends Conversation {
  const ConversationModel({required super.id, required super.messages});

  factory ConversationModel.fromJson(Map<String, dynamic> json) {
    final messagesJson = json['messages'] as List<dynamic>?;
    final messages = messagesJson != null
        ? messagesJson.map((m) => MessageModel.fromJson(m)).toList()
        : <MessageModel>[];

    return ConversationModel(
      id: json['conversationId'] as String,
      messages: messages,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'messages': messages.map((m) => (m as MessageModel).toJson()).toList(),
    };
  }
}
