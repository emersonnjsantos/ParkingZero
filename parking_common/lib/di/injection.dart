import 'package:get_it/get_it.dart';
import 'package:parking_common/services/parking_grpc_client.dart';

final GetIt getIt = GetIt.instance;

void setupInjection() {
  // Register the gRPC client as a singleton
  getIt.registerSingleton<ParkingGrpcClient>(ParkingGrpcClient());
}
