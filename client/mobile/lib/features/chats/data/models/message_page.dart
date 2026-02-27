import 'package:simple_chat/features/chats/data/models/message_model.dart';
import 'package:simple_chat/features/chats/domain/entities/message_page.dart';

class MessagePageModel extends MessagePage {
  const MessagePageModel({required super.messages, required super.hasMore});

  factory MessagePageModel.fromJson(Map<String, dynamic> json) {
    final List<dynamic> data = json['messages'] as List<dynamic>;
    return MessagePageModel(
      messages: data
          .map((e) => MessageModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      hasMore: json['hasMore'] as bool,
    );
  }
}
