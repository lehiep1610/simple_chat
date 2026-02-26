import 'package:simple_chat/core/constants/api_constants.dart';
import 'package:simple_chat/core/network/api_client.dart';
import 'package:simple_chat/features/chats/data/models/conversation_model.dart';
import 'package:simple_chat/features/chats/data/models/conversation_summary_model.dart';
import 'package:simple_chat/features/chats/data/models/message_model.dart';

abstract class ChatRemoteDatasource {
  Future<ConversationModel> getDirectConversation(String friendId);
  Future<MessageModel> sendMessage({
    required String conversationId,
    required String senderId,
    required String body,
    String messageType = 'text',
  });
  Future<List<ConversationSummaryModel>> getConversationSummaries();
}

class ChatRemoteDatasourceImpl implements ChatRemoteDatasource {
  final ApiClient apiClient;
  const ChatRemoteDatasourceImpl({required this.apiClient});

  @override
  Future<ConversationModel> getDirectConversation(String friendId) async {
    final response = await apiClient.get(
      '${ApiConstants.directConversation}/$friendId',
    );
    return ConversationModel.fromJson(response);
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

  @override
  Future<List<ConversationSummaryModel>> getConversationSummaries() async {
    final response = await apiClient.get(ApiConstants.conversations);
    final List<dynamic> data = response['conversations'] as List<dynamic>;
    return data.map((json) => ConversationSummaryModel.fromJson(json)).toList();
  }
}
