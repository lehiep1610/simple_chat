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

  AuthRemoteDataSourceImpl({required this.apiClient});

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
      apiClient.setAuthToken(response['token']);
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
    apiClient.clearAuthToken();
  }
}
