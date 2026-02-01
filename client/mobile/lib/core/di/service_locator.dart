import 'package:get_it/get_it.dart';
import 'package:simple_chat/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:simple_chat/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:simple_chat/features/auth/domain/repositories/auth_repository.dart';
import 'package:simple_chat/features/home/data/datasources/friend_remote_datasource.dart';
import 'package:simple_chat/features/home/data/repositories/friend_repository_impl.dart';
import 'package:simple_chat/features/home/domain/repositories/friend_repository.dart';
import 'package:simple_chat/features/home/domain/usecases/get_friends_usecase.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/domain/usecases/register_usecase.dart';
import '../network/api_client.dart';

final sl = GetIt.instance;

void setupServiceLocator() {
  // Core
  sl.registerLazySingleton<ApiClient>(() => ApiClient());

  // === Auth Feature ===
  //Datasources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(apiClient: sl()),
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
}
