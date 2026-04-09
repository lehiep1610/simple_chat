import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/api_client.dart';
import '../models/user_preview_model.dart';

/// Wraps the paginated users response from the server.
class UsersResult {
  final List<UserPreviewModel> users;
  final bool hasMore;

  const UsersResult({required this.users, required this.hasMore});
}

abstract class PeopleRemoteDatasource {
  Future<UsersResult> getUsers({
    required int limit,
    required int offset,
  });

  Future<void> sendFriendRequest(String recipientId);
}

class PeopleRemoteDatasourceImpl implements PeopleRemoteDatasource {
  final ApiClient apiClient;

  const PeopleRemoteDatasourceImpl({required this.apiClient});

  @override
  Future<UsersResult> getUsers({
    required int limit,
    required int offset,
  }) async {
    final response = await apiClient.get(
      ApiConstants.users,
      queryParameters: {'limit': limit, 'offset': offset},
    );
    final List<dynamic> data = response['data'] as List<dynamic>;
    final meta = response['meta'] as Map<String, dynamic>? ?? {};
    final hasMore = meta['hasMore'] as bool? ?? false;
    final users = data
        .map((json) => UserPreviewModel.fromJson(json as Map<String, dynamic>))
        .toList();
    return UsersResult(users: users, hasMore: hasMore);
  }

  @override
  Future<void> sendFriendRequest(String recipientId) async {
    await apiClient.post(
      ApiConstants.sendFriendRequest,
      body: {'recipientId': recipientId},
    );
  }
}
