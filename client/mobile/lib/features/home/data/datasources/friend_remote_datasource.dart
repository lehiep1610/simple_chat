import 'package:simple_chat/core/constants/api_constants.dart';
import 'package:simple_chat/core/network/api_client.dart';
import 'package:simple_chat/features/home/data/models/friend_model.dart';

abstract class FriendRemoteDatasource {
  Future<List<FriendModel>> getFriends();
}

class FriendRemoteDatasourceImpl implements FriendRemoteDatasource {
  final ApiClient apiClient;
  const FriendRemoteDatasourceImpl({required this.apiClient});

  @override
  Future<List<FriendModel>> getFriends() async {
    final response = await apiClient.get(ApiConstants.getFriends);
    final List<dynamic> data = response['data'] as List<dynamic>;
    return data.map((json) => FriendModel.fromJson(json)).toList();
  }
}
