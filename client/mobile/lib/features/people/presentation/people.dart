import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_chat/core/di/service_locator.dart';
import '../domain/entities/user_preview.dart';
import 'cubit/people_cubit.dart';
import 'cubit/people_state.dart';

class PeoplePage extends StatelessWidget {
  const PeoplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<PeopleCubit>()..loadUsers(),
      child: const _PeopleView(),
    );
  }
}

class _PeopleView extends StatefulWidget {
  const _PeopleView();

  @override
  State<_PeopleView> createState() => _PeopleViewState();
}

class _PeopleViewState extends State<_PeopleView> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    if (currentScroll >= maxScroll - 200) {
      context.read<PeopleCubit>().loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('People')),
      body: BlocConsumer<PeopleCubit, PeopleState>(
        listenWhen: (prev, curr) => curr.loadMoreFailure != null &&
            curr.loadMoreFailure != prev.loadMoreFailure,
        listener: (context, state) {
          final message =
              state.loadMoreFailure?.message ?? 'Failed to load more users.';
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message)),
          );
        },
        builder: (context, state) {
          if (state.status == PeopleStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == PeopleStatus.failure && state.users.isEmpty) {
            return _ErrorView(
              message: state.failure?.message ?? 'Something went wrong.',
              onRetry: () => context.read<PeopleCubit>().loadUsers(),
            );
          }

          if (state.status == PeopleStatus.success && state.users.isEmpty) {
            return const Center(child: Text('No people found.'));
          }

          return ListView.builder(
            controller: _scrollController,
            itemCount: state.users.length + (state.isLoadingMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == state.users.length) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              final user = state.users[index];
              final requestStatus =
                  state.requestStatusMap[user.id] ?? FriendRequestStatus.idle;
              return _UserListItem(user: user, requestStatus: requestStatus);
            },
          );
        },
      ),
    );
  }
}

class _UserListItem extends StatelessWidget {
  final UserPreview user;
  final FriendRequestStatus requestStatus;

  const _UserListItem({required this.user, required this.requestStatus});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: _UserAvatar(user: user),
      title: Text(user.name),
      trailing: _FriendRequestButton(
        userId: user.id,
        requestStatus: requestStatus,
      ),
    );
  }
}

class _UserAvatar extends StatelessWidget {
  final UserPreview user;

  const _UserAvatar({required this.user});

  @override
  Widget build(BuildContext context) {
    if (user.avatarUrl != null && user.avatarUrl!.isNotEmpty) {
      return CircleAvatar(
        backgroundImage: NetworkImage(user.avatarUrl!),
        onBackgroundImageError: (e, s) {},
      );
    }

    return CircleAvatar(
      backgroundImage: const AssetImage('assets/images/default_avatar.png'),
    );
  }
}

class _FriendRequestButton extends StatelessWidget {
  final String userId;
  final FriendRequestStatus requestStatus;

  const _FriendRequestButton({
    required this.userId,
    required this.requestStatus,
  });

  @override
  Widget build(BuildContext context) {
    switch (requestStatus) {
      case FriendRequestStatus.sending:
        return const SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(strokeWidth: 2),
        );
      case FriendRequestStatus.requested:
        return OutlinedButton(
          onPressed: null,
          child: const Text('Requested'),
        );
      case FriendRequestStatus.idle:
      case FriendRequestStatus.error:
        return ElevatedButton(
          onPressed: () => context.read<PeopleCubit>().sendFriendRequest(userId),
          child: const Text('Add Friend'),
        );
    }
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onRetry,
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
