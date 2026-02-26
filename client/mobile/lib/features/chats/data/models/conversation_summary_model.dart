import 'package:simple_chat/features/chats/domain/entities/conversation_summary.dart';

class ConversationSummaryModel extends ConversationSummary {
  const ConversationSummaryModel({
    required super.id,
    required super.name,
    super.lastMessage,
    super.lastMessageAt,
    super.avatarUrl,
  });

  factory ConversationSummaryModel.fromJson(Map<String, dynamic> json) {
    return ConversationSummaryModel(
      id: json['id'] as String,
      name: (json['name'] as String?) ?? '',
      lastMessage: json['lastMessage'] as String?,
      lastMessageAt: json['lastMessageAt'] != null
          ? DateTime.tryParse(json['lastMessageAt'] as String)
          : null,
      avatarUrl: json['avatarUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'lastMessage': lastMessage,
      'lastMessageAt': lastMessageAt?.toUtc().toIso8601String(),
      'avatarUrl': avatarUrl,
    };
  }
}
