import 'package:flutter/material.dart';
import 'package:simple_chat/core/di/service_locator.dart';
import 'package:simple_chat/core/utils/error_handler.dart';
import 'package:simple_chat/features/home/domain/entities/friend.dart';
import 'package:simple_chat/features/home/domain/usecases/get_friends_usecase.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GetFriendsUsecase _getFriendsUsecase = sl<GetFriendsUsecase>();

  List<Friend> _friends = [];
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _getFriends();
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
        child: Column(mainAxisAlignment: .start, children: [_listFriend()]),
      ),
    );
  }

  Widget _listFriend() {
    return Expanded(
      child: ListView.separated(
        shrinkWrap: true,
        itemBuilder: (context, index) => _friendWidget(_friends[0]),
        separatorBuilder: (context, index) => SizedBox(width: 6),
        scrollDirection: .horizontal,
        itemCount: _friends.length,
      ),
    );
  }

  Widget _friendWidget(Friend friend) {
    return Column(
      children: [
        CircleAvatar(
          radius: 32,
          backgroundColor: friend.avatarUrl != null
              ? null
              : Colors.grey.shade300,
          child: friend.avatarUrl == null
              ? Image.asset(
                  'assets/images/default_avatar.png',
                  width: 36,
                  height: 36,
                  fit: BoxFit.cover,
                )
              : ClipOval(
                  clipBehavior: .hardEdge,
                  child: Image.network(
                    friend.avatarUrl!,
                    errorBuilder: (context, error, stackTrace) => Image.asset(
                      'assets/images/default_avatar.png',
                      width: 36,
                      height: 36,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
        ),
        SizedBox(
          width: 64,
          child: Text(
            friend.name,
            maxLines: 1,
            overflow: .ellipsis,
            textAlign: .center,
          ),
        ),
      ],
    );
  }
}
