import 'package:flutter/material.dart';
import 'package:simple_chat/core/di/service_locator.dart';
import 'package:simple_chat/core/utils/error_handler.dart';
import 'package:simple_chat/features/chat/domain/entities/conversation.dart';
import 'package:simple_chat/features/chat/domain/usecases/get_direct_conversation.dart';
import 'package:simple_chat/features/chat/presentation/widgets/message_bubble.dart';
import 'package:simple_chat/features/chat/presentation/widgets/message_input.dart';

class ChatPage extends StatefulWidget {
  final String friendId;
  final String friendName;

  const ChatPage({super.key, required this.friendId, required this.friendName});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final GetConversationUsecase _getConversationUsecase =
      sl<GetConversationUsecase>();

  Conversation? _conversation;
  bool _isLoading = false;
  String? _error;
  String? _currentUserId;

  @override
  void initState() {
    super.initState();
    _loadConversation();
  }

  Future<void> _loadConversation() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    final result = await _getConversationUsecase.call(widget.friendId);

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
            _currentUserId = conversation.participantIds.firstWhere(
              (id) => id != widget.friendId,
              orElse: () => '',
            );
          });
        },
      );
    }
  }

  void _handleSendMessage(String content) {
    // TODO: Implement send message functionality
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Send message: $content')));
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
        final isMe = message.senderId == _currentUserId;
        return MessageBubble(message: message, isMe: isMe);
      },
    );
  }
}
