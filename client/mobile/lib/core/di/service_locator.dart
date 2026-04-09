import 'package:get_it/get_it.dart';
import 'package:simple_chat/core/network/socket_service.dart';
import 'package:simple_chat/core/session/auth_session_manager.dart';
import 'package:simple_chat/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:simple_chat/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:simple_chat/features/auth/domain/repositories/auth_repository.dart';
import 'package:simple_chat/features/chats/data/datasources/chat_remote_datasource.dart';
import 'package:simple_chat/features/chats/data/repositories/chat_repository_impl.dart';
import 'package:simple_chat/features/chats/domain/repositories/chat_repository.dart';
import 'package:simple_chat/features/chats/domain/repositories/friend_repository.dart';
import 'package:simple_chat/features/chats/domain/usecases/get_direct_conversation.dart';
import 'package:simple_chat/features/chats/data/datasources/friend_remote_datasource.dart';
import 'package:simple_chat/features/chats/data/repositories/friend_repository_impl.dart';
import 'package:simple_chat/features/chats/domain/usecases/get_conversations_usecase.dart';
import 'package:simple_chat/features/chats/domain/usecases/get_friends_usecase.dart';
import 'package:simple_chat/features/chats/domain/usecases/get_messages_usecase.dart';
import 'package:simple_chat/features/people/data/datasources/people_remote_datasource.dart';
import 'package:simple_chat/features/people/data/repositories/people_repository_impl.dart';
import 'package:simple_chat/features/people/domain/repositories/people_repository.dart';
import 'package:simple_chat/features/people/domain/usecases/get_users_usecase.dart';
import 'package:simple_chat/features/people/domain/usecases/send_friend_request_usecase.dart';
import 'package:simple_chat/features/people/presentation/cubit/people_cubit.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/domain/usecases/register_usecase.dart';
import '../network/api_client.dart';

final sl = GetIt.instance;

void setupServiceLocator() {
  // Core
  sl.registerLazySingleton<AuthSessionManager>(
    () => AuthSessionManager.instance,
  );
  sl.registerLazySingleton<ApiClient>(
    () => ApiClient(authSessionManager: sl()),
  );

  // === Auth Feature ===
  //Datasources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(apiClient: sl(), authSessionManager: sl()),
  );

  //Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl()),
  );

  // Usecases
  sl.registerLazySingleton(() => LoginUsecase(sl()));
  sl.registerLazySingleton(() => RegisterUsecase(sl()));

  // === Home/Friend Feature ===
  // Datasources
  sl.registerLazySingleton<FriendRemoteDatasource>(
    () => FriendRemoteDatasourceImpl(apiClient: sl()),
  );

  // Repositories
  sl.registerLazySingleton<FriendRepository>(() => FriendRepositoryImpl(sl()));

  // Usecases
  sl.registerLazySingleton(() => GetFriendsUsecase(sl()));
  sl.registerLazySingleton(() => GetConversationsUsecase(sl()));
  sl.registerLazySingleton(() => GetMessagesUsecase(sl()));

  // === Chat Feature ===  // ADD THIS SECTION
  // Datasources
  sl.registerLazySingleton<ChatRemoteDatasource>(
    () => ChatRemoteDatasourceImpl(apiClient: sl()),
  );

  // Repositories
  sl.registerLazySingleton<ChatRepository>(() => ChatRepositoryImpl(sl()));

  // Usecases
  sl.registerLazySingleton(() => GetConversationUsecase(sl()));

  sl.registerLazySingleton<SocketService>(
    () => SocketService(authSessionManager: sl()),
  );

  // === People Feature ===
  // Datasources
  sl.registerLazySingleton<PeopleRemoteDatasource>(
    () => PeopleRemoteDatasourceImpl(apiClient: sl()),
  );

  // Repositories
  sl.registerLazySingleton<PeopleRepository>(
    () => PeopleRepositoryImpl(sl()),
  );

  // Usecases
  sl.registerLazySingleton(() => GetUsersUsecase(sl()));
  sl.registerLazySingleton(() => SendFriendRequestUsecase(sl()));

  // Cubit - factory so each page gets fresh state
  sl.registerFactory(
    () => PeopleCubit(
      getUsersUsecase: sl(),
      sendFriendRequestUsecase: sl(),
    ),
  );
}
