import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/user_preview.dart';

enum PeopleStatus { initial, loading, success, failure }

enum FriendRequestStatus { idle, sending, requested, error }

class PeopleState extends Equatable {
  final PeopleStatus status;
  final List<UserPreview> users;
  final bool hasMore;
  final int page; // 0-indexed
  final bool isLoadingMore;
  final Failure? failure;
  // Separate from [failure] so a loadMore error does not replace the full-page
  // error state and can be surfaced as a transient SnackBar.
  final Failure? loadMoreFailure;
  final Map<String, FriendRequestStatus> requestStatusMap;

  static const int pageSize = 20;

  const PeopleState({
    this.status = PeopleStatus.initial,
    this.users = const [],
    this.hasMore = true,
    this.page = 0,
    this.isLoadingMore = false,
    this.failure,
    this.loadMoreFailure,
    this.requestStatusMap = const {},
  });

  PeopleState copyWith({
    PeopleStatus? status,
    List<UserPreview>? users,
    bool? hasMore,
    int? page,
    bool? isLoadingMore,
    Failure? failure,
    bool clearFailure = false,
    Failure? loadMoreFailure,
    bool clearLoadMoreFailure = false,
    Map<String, FriendRequestStatus>? requestStatusMap,
  }) {
    return PeopleState(
      status: status ?? this.status,
      users: users ?? this.users,
      hasMore: hasMore ?? this.hasMore,
      page: page ?? this.page,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      failure: clearFailure ? null : failure ?? this.failure,
      loadMoreFailure:
          clearLoadMoreFailure ? null : loadMoreFailure ?? this.loadMoreFailure,
      requestStatusMap: requestStatusMap ?? this.requestStatusMap,
    );
  }

  @override
  List<Object?> get props => [
    status,
    users,
    hasMore,
    page,
    isLoadingMore,
    failure,
    loadMoreFailure,
    requestStatusMap,
  ];
}
