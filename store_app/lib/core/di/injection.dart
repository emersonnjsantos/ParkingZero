import 'package:get_it/get_it.dart';
import 'package:store_app/core/api/api_client.dart';
import 'package:store_app/core/auth/auth_service.dart';
import 'package:store_app/core/data/store_repository.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  sl.registerLazySingleton(() => ApiClient());
  sl.registerLazySingleton(() => AuthService());
  sl.registerLazySingleton(
    () => StoreRepository(sl<ApiClient>(), sl<AuthService>()),
  );
}
