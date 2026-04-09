import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_users_usecase.dart';
import '../../domain/usecases/send_friend_request_usecase.dart';
import 'people_state.dart';

class PeopleCubit extends Cubit<PeopleState> {
  final GetUsersUsecase _getUsersUsecase;
  final SendFriendRequestUsecase _sendFriendRequestUsecase;

  PeopleCubit({
    required GetUsersUsecase getUsersUsecase,
    required SendFriendRequestUsecase sendFriendRequestUsecase,
  }) : _getUsersUsecase = getUsersUsecase,
       _sendFriendRequestUsecase = sendFriendRequestUsecase,
       super(const PeopleState());

  Future<void> loadUsers() async {
    emit(state.copyWith(
      status: PeopleStatus.loading,
      users: [],
      page: 0,
      hasMore: true,
      clearFailure: true,
      clearLoadMoreFailure: true,
      // Issue 3: reset stale "Requested" states when refreshing the list.
      requestStatusMap: {},
    ));

    final result = await _getUsersUsecase.call(
      limit: PeopleState.pageSize,
      offset: 0,
    );

    result.fold(
      (failure) => emit(state.copyWith(
        status: PeopleStatus.failure,
        failure: failure,
      )),
      // Issue 1: use server-provided hasMore instead of length heuristic.
      (result) => emit(state.copyWith(
        status: PeopleStatus.success,
        users: result.users,
        hasMore: result.hasMore,
        page: 0,
      )),
    );
  }

  Future<void> loadMore() async {
    if (!state.hasMore || state.isLoadingMore) return;
    if (state.status != PeopleStatus.success) return;

    emit(state.copyWith(isLoadingMore: true, clearLoadMoreFailure: true));

    final nextPage = state.page + 1;
    final result = await _getUsersUsecase.call(
      limit: PeopleState.pageSize,
      offset: nextPage * PeopleState.pageSize,
    );

    result.fold(
      // Issue 2: surface the failure so the UI can show a SnackBar.
      (failure) => emit(state.copyWith(
        isLoadingMore: false,
        loadMoreFailure: failure,
      )),
      // Issue 1: use server-provided hasMore instead of length heuristic.
      (result) => emit(state.copyWith(
        users: [...state.users, ...result.users],
        hasMore: result.hasMore,
        page: nextPage,
        isLoadingMore: false,
      )),
    );
  }

  Future<void> sendFriendRequest(String userId) async {
    final currentStatus = state.requestStatusMap[userId];
    if (currentStatus == FriendRequestStatus.sending ||
        currentStatus == FriendRequestStatus.requested) {
      return;
    }

    emit(state.copyWith(
      requestStatusMap: {
        ...state.requestStatusMap,
        userId: FriendRequestStatus.sending,
      },
    ));

    final result = await _sendFriendRequestUsecase.call(userId);

    result.fold(
      (failure) => emit(state.copyWith(
        requestStatusMap: {
          ...state.requestStatusMap,
          userId: FriendRequestStatus.error,
        },
      )),
      (_) => emit(state.copyWith(
        requestStatusMap: {
          ...state.requestStatusMap,
          userId: FriendRequestStatus.requested,
        },
      )),
    );
  }
}
