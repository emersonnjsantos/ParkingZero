import 'package:get_it/get_it.dart';
import 'package:parking_app/core/api/api_client.dart';
import 'package:parking_app/core/auth/auth_service.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  sl.registerLazySingleton(() => ApiClient());
  sl.registerLazySingleton(() => AuthService());
}
