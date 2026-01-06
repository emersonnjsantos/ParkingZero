import 'package:get_it/get_it.dart';
import 'package:mobile_app/core/api/api_client.dart';
import 'package:mobile_app/features/auth/presentation/bloc/auth_bloc.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // Core
  sl.registerLazySingleton(() => ApiClient());

  // BLoCs
  sl.registerFactory(() => AuthBloc());
}
