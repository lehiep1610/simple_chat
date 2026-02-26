import 'package:simple_chat/core/session/auth_session_manager.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/api_client.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login({required String email, required String password});
  Future<UserModel> register({
    required String email,
    required String password,
    required String name,
  });
  Future<void> logout();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient apiClient;
  final AuthSessionManager authSessionManager;

  AuthRemoteDataSourceImpl({
    required this.apiClient,
    required this.authSessionManager,
  });

  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    final response = await apiClient.post(
      ApiConstants.login,
      body: {'email': email, 'password': password},
    );

    // Save token if returned
    if (response['token'] != null) {
      await authSessionManager.setSesstion(
        authToken: response['token'],
        userId: response['user']['id'],
      );
    }

    return UserModel.fromJson(response['user']);
  }

  @override
  Future<UserModel> register({
    required String email,
    required String password,
    required String name,
  }) async {
    final response = await apiClient.post(
      ApiConstants.register,
      body: {'email': email, 'password': password, 'name': name},
    );
    return UserModel.fromJson(response['user']);
  }

  @override
  Future<void> logout() async {
    await authSessionManager.clearSession();
  }
}
