import 'package:shared_preferences/shared_preferences.dart';

class AuthSessionManager {
  static const String _authTokenKey = 'auth_token';
  static const String _userIdKey = 'user_id';

  String? _authToken;
  String? _userId;

  static AuthSessionManager? _instance;

  AuthSessionManager._();

  static AuthSessionManager get instance {
    _instance ??= AuthSessionManager._();
    return _instance!;
  }

  String? get authToken => _authToken;
  String? get userId => _userId;
  bool get isAuthenticated => _authToken != null;

  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    _authToken = prefs.getString(_authTokenKey);
    _userId = prefs.getString(_userIdKey);
  }

  Future<void> setSesstion({
    required String authToken,
    required String userId,
  }) async {
    _authToken = authToken;
    _userId = userId;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_authTokenKey, authToken);
    await prefs.setString(_userIdKey, userId);
  }

  Future<void> clearSession() async {
    _authToken = null;
    _userId = null;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_authTokenKey);
    await prefs.remove(_userIdKey);
  }

  Future<void> updateAuthToken({required String authToken}) async {
    _authToken = authToken;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_authTokenKey, authToken);
  }
}
