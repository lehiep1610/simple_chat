import 'package:simple_chat/features/chat/domain/entities/message.dart';

class Conversation {
  final String id;
  final List<String> participantIds;
  final List<Message> messages;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Conversation({
    required this.id,
    required this.participantIds,
    required this.messages,
    this.createdAt,
    this.updatedAt,
  });
}
