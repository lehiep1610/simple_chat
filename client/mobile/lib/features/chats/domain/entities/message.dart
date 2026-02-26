class Message {
  final String id;
  final String conversationId;
  final String senderId;
  final String? senderName;
  final String body;
  final String messageType;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Message({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.senderName,
    required this.body,
    required this.messageType,
    required this.createdAt,
    required this.updatedAt,
  });
}
