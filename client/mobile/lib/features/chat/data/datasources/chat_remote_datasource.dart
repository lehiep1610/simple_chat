import 'package:simple_chat/core/constants/api_constants.dart';
import 'package:simple_chat/core/network/api_client.dart';
import 'package:simple_chat/features/chat/data/models/conversation_model.dart';

abstract class ChatRemoteDatasource {
  Future<ConversationModel> getDirectConversation(String friendId);
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
}
