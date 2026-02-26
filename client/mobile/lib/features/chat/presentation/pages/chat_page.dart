import 'package:flutter/material.dart';
import 'package:simple_chat/core/di/service_locator.dart';
import 'package:simple_chat/core/network/socket_service.dart';
import 'package:simple_chat/core/utils/error_handler.dart';
import 'package:simple_chat/features/chat/domain/entities/conversation.dart';
import 'package:simple_chat/features/chat/domain/usecases/get_direct_conversation.dart';
import 'package:simple_chat/features/chat/presentation/widgets/message_bubble.dart';
import 'package:simple_chat/features/chat/presentation/widgets/message_input.dart';

class ChatPage extends StatefulWidget {
  final String friendId;
  final String friendName;
  final String userId;

  const ChatPage({
    super.key,
    required this.friendId,
    required this.friendName,
    required this.userId,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final GetConversationUsecase _getConversationUsecase =
      sl<GetConversationUsecase>();
  late SocketService _socketService;

  Conversation? _conversation;
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _socketService = sl<SocketService>();
    _initializeChat();
  }

  Future<void> _initializeChat() async {
    await _socketService.connect();
    await _loadConversation();
    if (_conversation != null) {
      _listenToNewMessages();
    }
  }

  void _listenToNewMessages() {
    _socketService.onNewMessage((message) {
      if (mounted) {
        setState(() {
          // dedupe
          final isDuplicate = _conversation!.messages.any(
            (m) => m.id == message.id,
          );
          if (!isDuplicate) {
            _conversation!.messages.add(message);
          }
        });
      }
    });

    _socketService.onMessageError((errorMessage) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
        );
      }
    });
  }

  Future<void> _loadConversation() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    final result = await _getConversationUsecase.getDirectConversation(
      widget.friendId,
    );

    if (mounted) {
      result.fold(
        (failure) {
          setState(() {
            _error = failure.message;
            _isLoading = false;
          });
          ErrorHandler.handleFailure(context, failure);
        },
        (conversation) {
          setState(() {
            _conversation = conversation;
            _isLoading = false;
          });
        },
      );
    }
  }

  Future<void> _handleSendMessage(String content) async {
    if (_conversation == null || content.trim().isEmpty) return;

    if (_socketService.isConnected()) {
      _socketService.sendMessage(
        conversationId: _conversation!.id,
        body: content.trim(),
        messageType: 'text',
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Socket not connected'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.friendName)),
      body: Column(
        children: [
          Expanded(child: _buildBody()),
          MessageInput(onSend: _handleSendMessage),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Error: $_error'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadConversation,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_conversation == null || _conversation!.messages.isEmpty) {
      return const Center(
        child: Text('No messages yet. Start the conversation!'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: _conversation!.messages.length,
      itemBuilder: (context, index) {
        final message = _conversation!.messages[index];
        final isMe = message.senderId == widget.userId;
        return MessageBubble(message: message, isMe: isMe);
      },
    );
  }

  @override
  void dispose() {
    _socketService.removeAllListeners();
    _socketService.disconnect();
    super.dispose();
  }
}
