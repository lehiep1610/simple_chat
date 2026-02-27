import 'package:simple_chat/features/chats/domain/entities/message.dart';

class MessagePage {
  final List<Message> messages;
  final bool hasMore;

  const MessagePage({required this.messages, required this.hasMore});
}
