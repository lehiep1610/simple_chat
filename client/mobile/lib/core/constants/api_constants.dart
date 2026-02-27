class ApiConstants {
  static const String baseUrl = 'http://localhost:3000/api';

  // Auth endpoints
  static const String login = '/auth/login';
  static const String register = '/auth/register';

  // Other endpoints
  static const String ping = '/ping';

  // Friend
  static const String getFriends = '/friends';

  // Chat
  static const String conversations = '/chat/conversations';
  static const String directConversation = '/chat/direct';
  static const String messages = '/chat/conversations/:conversationId/messages';
}
