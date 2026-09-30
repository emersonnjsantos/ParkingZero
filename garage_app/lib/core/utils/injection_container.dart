import 'package:get_it/get_it.dart';
import 'package:parkingzero/core/api/api_client.dart';
import 'package:parkingzero/features/auth/domain/repositories/auth_repository.dart';
import 'package:parkingzero/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:parkingzero/features/auth/presentation/bloc/auth_bloc.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // Core
  sl.registerLazySingleton(() => ApiClient());

  // Repositories
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl());

  // BLoCs
  sl.registerFactory(() => AuthBloc(authRepository: sl()));
}
