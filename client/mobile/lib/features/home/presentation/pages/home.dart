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
      body: Center(
        child: Text('Home', style: Theme.of(context).textTheme.bodyLarge),
      ),
    );
  }
}
