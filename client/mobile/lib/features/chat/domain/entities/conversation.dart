import 'package:simple_chat/features/chat/domain/entities/message.dart';

class Conversation {
  final String id;
  final List<Message> messages;

  const Conversation({required this.id, required this.messages});
}
