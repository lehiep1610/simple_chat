import 'package:simple_chat/core/constants/api_constants.dart';
import 'package:simple_chat/core/session/auth_session_manager.dart';
import 'package:simple_chat/features/chat/data/models/message_model.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  IO.Socket? _socket;

  final AuthSessionManager _authSessionManager;

  SocketService({required AuthSessionManager authSessionManager})
    : _authSessionManager = authSessionManager;

  bool isConnected() => _socket?.connected ?? false;

  Future<void> connect() async {
    final token = _authSessionManager.authToken;
    if (_socket?.connect == true) {
      print('Socket already connected');
      return;
    }

    final socketUrl = ApiConstants.baseUrl.replaceAll('/api', '');

    _socket = IO.io(
      '$socketUrl/chat',
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .enableAutoConnect()
          .setAuth({'token': token})
          .build(),
    );

    _socket?.onConnect((_) {
      print('Socket connected');
    });

    _socket?.onDisconnect((_) {
      print('Socket disconnected');
    });

    _socket?.onConnectError((error) {
      print('Socket connection error: $error');
    });

    _socket?.onError((error) {
      print('Socket error: $error');
    });
  }

  void sendMessage({
    required String conversationId,
    required String body,
    String messageType = 'text',
  }) {
    if (_socket?.connected == false) {
      print('Cannot send message: Socket not connected');
      return;
    }

    _socket?.emit('send:message', {
      'conversationId': conversationId,
      'body': body,
      'messageType': messageType,
    });
    print('Message sent: $body');
  }

  void onNewMessage(Function(MessageModel) callback) {
    _socket?.on('new:message', (data) {
      try {
        final message = MessageModel.fromJson(data);
        callback(message);
      } catch (e) {
        print('Error parsing message: $e');
      }
    });
  }

  void onMessageError(Function(String) callback) {
    _socket?.on('error:message', (data) {
      final errorMessage = data['message'] ?? 'Failed to send message';
      callback(errorMessage);
    });
  }

  void removeAllListeners() {
    _socket?.off('new:message');
    _socket?.off('error:message');
  }

  void disconnect() {
    _socket?.disconnect();
    _socket?.dispose();
    _socket = null;
    print('Socket disconnected and disposed');
  }
}
