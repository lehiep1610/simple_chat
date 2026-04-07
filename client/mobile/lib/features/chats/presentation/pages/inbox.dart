import 'package:flutter/material.dart';
import 'package:simple_chat/core/di/service_locator.dart';
import 'package:simple_chat/core/router/app_router.dart';
import 'package:simple_chat/core/router/route_names.dart';
import 'package:simple_chat/core/utils/error_handler.dart';
import 'package:simple_chat/features/chats/domain/entities/conversation_summary.dart';
import 'package:simple_chat/features/chats/domain/entities/friend.dart';
import 'package:simple_chat/features/chats/domain/usecases/get_conversations_usecase.dart';
import 'package:simple_chat/features/chats/domain/usecases/get_friends_usecase.dart';

import '../../../../core/network/socket_service.dart';

class Inbox extends StatefulWidget {
  final String userId;
  const Inbox({super.key, required this.userId});

  @override
  State<Inbox> createState() => _InboxState();
}

class _InboxState extends State<Inbox> {
  final GetFriendsUsecase _getFriendsUsecase = sl<GetFriendsUsecase>();
  final GetConversationsUsecase _getConversationsUsecase =
      sl<GetConversationsUsecase>();
  final SocketService _socketService = sl<SocketService>();

  List<Friend> _friends = [];
  bool _isLoading = false;
  String? _error;
  List<ConversationSummary> _conversationSummaries = [];

  @override
  void initState() {
    super.initState();
    _getFriends();
    _getConversations();
  }

  @override
  void dispose() {
    _socketService.disconnect();
    super.dispose();
  }

  Future<void> _getConversations() async {
    final result = await _getConversationsUsecase.call();
    if (mounted) {
      result.fold((failure) => ErrorHandler.handleFailure(context, failure), (
        summaries,
      ) async {
        setState(() => _conversationSummaries = summaries);
        await _socketService.connect();
        for (var summary in summaries) {
          _socketService.joinConversation(summary.id);
        }
      });
    }
  }

  Future<void> _getFriends() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    final result = await _getFriendsUsecase.getFriends();
    if (mounted) {
      result.fold(
        (failure) {
          setState(() {
            _error = failure.message;
            _isLoading = false;
          });
          ErrorHandler.handleFailure(context, failure);
        },
        (friends) {
          setState(() {
            _friends = friends;
            _isLoading = false;
          });
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Simple chat',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 100, width: double.infinity, child: _listFriend()),
            const SizedBox(height: 8),
            Expanded(
              child: _listConversations(), // vertical list bên dưới
            ),
          ],
        ),
      ),
    );
  }

  Widget _listFriend() {
    return ListView.separated(
      shrinkWrap: true,
      itemBuilder: (context, index) => _friendWidget(_friends[index]),
      separatorBuilder: (context, index) => SizedBox(width: 6),
      scrollDirection: Axis.horizontal,
      itemCount: _friends.length,
    );
  }

  Widget _friendWidget(Friend friend) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            AppRouter.navigateTo(
              context,
              RouteNames.chat,
              arguments: {
                'friendId': friend.id,
                'friendName': friend.name,
                'userId': widget.userId,
              },
            );
          },
          child: CircleAvatar(
            radius: 32,
            backgroundColor:
                friend.avatarUrl != null ? null : Colors.grey.shade300,
            child:
                friend.avatarUrl == null
                    ? Image.asset(
                      'assets/images/default_avatar.png',
                      width: 36,
                      height: 36,
                      fit: BoxFit.cover,
                    )
                    : ClipOval(
                      clipBehavior: Clip.hardEdge,
                      child: Image.network(
                        friend.avatarUrl!,
                        errorBuilder:
                            (context, error, stackTrace) => Image.asset(
                              'assets/images/default_avatar.png',
                              width: 36,
                              height: 36,
                              fit: BoxFit.cover,
                            ),
                      ),
                    ),
          ),
        ),
        SizedBox(
          width: 64,
          child: Text(
            friend.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _listConversations() {
    if (_conversationSummaries.isEmpty) {
      return const Center(child: Text('No conversations yet'));
    }
    return ListView.separated(
      itemCount: _conversationSummaries.length,
      separatorBuilder: (_, _) => const Divider(height: 1),
      itemBuilder:
          (context, index) => _conversationTile(_conversationSummaries[index]),
    );
  }

  Widget _conversationTile(ConversationSummary summary) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      onTap: () {
        AppRouter.navigateTo(
          context,
          RouteNames.chat,
          arguments: {
            'friendId': summary.id,
            'friendName': summary.name,
            'userId': widget.userId,
            'conversationId': summary.id,
          },
        );
      },
      leading: CircleAvatar(
        radius: 24,
        backgroundColor: Colors.grey.shade300,
        child:
            summary.avatarUrl == null
                ? Image.asset(
                  'assets/images/default_avatar.png',
                  width: 28,
                  height: 28,
                  fit: BoxFit.cover,
                )
                : ClipOval(
                  child: Image.network(
                    summary.avatarUrl!,
                    errorBuilder:
                        (_, __, ___) => Image.asset(
                          'assets/images/default_avatar.png',
                          width: 28,
                          height: 28,
                          fit: BoxFit.cover,
                        ),
                  ),
                ),
      ),
      title: Text(summary.name, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Text(
        summary.lastMessage ?? '',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing:
          summary.lastMessageAt != null
              ? Text(
                _formatTime(summary.lastMessageAt!),
                style: Theme.of(context).textTheme.bodySmall,
              )
              : null,
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);
    if (diff.inDays >= 1) return '${diff.inDays}d ago';
    if (diff.inHours >= 1) return '${diff.inHours}h ago';
    if (diff.inMinutes >= 1) return '${diff.inMinutes}m ago';
    return 'Just now';
  }
}
