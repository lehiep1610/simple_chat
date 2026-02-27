import 'package:flutter/material.dart';
import 'package:simple_chat/core/di/service_locator.dart';
import 'package:simple_chat/core/network/socket_service.dart';
import 'package:simple_chat/core/utils/error_handler.dart';
import 'package:simple_chat/features/chats/domain/usecases/get_direct_conversation.dart';
import 'package:simple_chat/features/chats/domain/usecases/get_messages_usecase.dart';
import 'package:simple_chat/features/chats/presentation/widgets/message_bubble.dart';
import 'package:simple_chat/features/chats/presentation/widgets/message_input.dart';

import '../../domain/entities/message_page.dart';

class Thread extends StatefulWidget {
  final String friendId;
  final String friendName;
  final String userId;
  final String? conversationId;

  const Thread({
    super.key,
    required this.friendId,
    required this.friendName,
    required this.userId,
    this.conversationId,
  });

  @override
  State<Thread> createState() => _ThreadState();
}

class _ThreadState extends State<Thread> {
  final GetMessagesUsecase _getMessagesUsecase = sl<GetMessagesUsecase>();
  final GetConversationUsecase _getConversationUsecase =
      sl<GetConversationUsecase>();
  late SocketService _socketService;

  MessagePage _messagesPage = MessagePage(messages: [], hasMore: false);
  String _conversationId = '';
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
    await _loadMessages();
    _listenToNewMessages();
  }

  void _listenToNewMessages() {
    _socketService.onNewMessage((message) {
      if (mounted) {
        setState(() {
          // dedupe
          final isDuplicate = _messagesPage.messages.any(
            (m) => m.id == message.id,
          );
          if (!isDuplicate) {
            _messagesPage.messages.add(message);
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

  Future<void> _loadMessages() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    if (widget.conversationId != null) {
      _conversationId = widget.conversationId!;
    } else {
      final result = await _getConversationUsecase.getDirectConversation(
        widget.friendId,
      );
      result.fold(
        (failure) => ErrorHandler.handleFailure(context, failure),
        (conversationId) => _conversationId = conversationId,
      );
    }

    final result = await _getMessagesUsecase.getMessages(_conversationId);

    if (mounted) {
      result.fold(
        (failure) {
          setState(() {
            _error = failure.message;
            _isLoading = false;
          });
          ErrorHandler.handleFailure(context, failure);
        },
        (messages) {
          setState(() {
            _messagesPage = messages;
            _isLoading = false;
          });
        },
      );
    }
  }

  Future<void> _handleSendMessage(String content) async {
    if (_conversationId.isEmpty || content.trim().isEmpty) return;

    if (_socketService.isConnected()) {
      _socketService.sendMessage(
        conversationId: _conversationId,
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
              onPressed: _loadMessages,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_messagesPage.messages.isEmpty) {
      return const Center(
        child: Text('No messages yet. Start the conversation!'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: _messagesPage.messages.length,
      itemBuilder: (context, index) {
        final message = _messagesPage.messages[index];
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
