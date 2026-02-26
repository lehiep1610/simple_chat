import 'package:simple_chat/core/constants/api_constants.dart';
import 'package:simple_chat/core/network/api_client.dart';
import 'package:simple_chat/features/chat/data/models/conversation_model.dart';
import 'package:simple_chat/features/chat/data/models/message_model.dart';

abstract class ChatRemoteDatasource {
  Future<ConversationModel> getDirectConversation(String friendId);
  Future<List<ConversationModel>> getConversations();
  Future<MessageModel> sendMessage({
    required String conversationId,
    required String senderId,
    required String body,
    String messageType = 'text',
  });
}

class ChatRemoteDatasourceImpl implements ChatRemoteDatasource {
  final ApiClient apiClient;
  const ChatRemoteDatasourceImpl({required this.apiClient});

  @override
  Future<ConversationModel> getDirectConversation(String friendId) async {
    final response = await apiClient.get(
      '${ApiConstants.conversations}/$friendId',
    );
    return ConversationModel.fromJson(response);
  }

  @override
  Future<List<ConversationModel>> getConversations() async {
    final response = await apiClient.get(ApiConstants.conversations);
    final List<dynamic> data = response['data'] as List<dynamic>;
    return data.map((json) => ConversationModel.fromJson(json)).toList();
  }

  @override
  Future<MessageModel> sendMessage({
    required String conversationId,
    required String senderId,
    required String body,
    String messageType = 'text',
  }) async {
    final response = await apiClient.post(
      ApiConstants.messages,
      body: {
        'conversationId': conversationId,
        'senderId': senderId,
        'body': body,
        'messageType': messageType,
      },
    );
    return MessageModel.fromJson(response['message'] as Map<String, dynamic>);
  }
}
