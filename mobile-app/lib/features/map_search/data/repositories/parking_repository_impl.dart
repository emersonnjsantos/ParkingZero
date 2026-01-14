import 'package:parkingzero/core/services/parking_grpc_client.dart';
import 'package:parkingzero/generated/parking_service.pbgrpc.dart' as pb;
import 'package:parkingzero/features/map_search/domain/entities/garage.dart';
import 'package:parkingzero/features/map_search/domain/repositories/parking_repository.dart';

class ParkingRepositoryImpl implements ParkingRepository {
  final ParkingGrpcClient grpcClient;

  ParkingRepositoryImpl({required this.grpcClient});

  @override
  Future<List<Garage>> searchGarages(
    double lat,
    double lng,
    int radiusMeters,
  ) async {
    try {
      final response = await grpcClient.searchGarages(
        latitude: lat,
        longitude: lng,
        radiusMeters: radiusMeters,
      );

      return response.map((pbGarage) {
        return Garage(
          id: pbGarage.id,
          name: pbGarage.name,
          basePrice: pbGarage.basePrice,
          latitude: pbGarage.latitude,
          longitude: pbGarage.longitude,
          imageUrl: pbGarage.imageUrl,
          campaigns: pbGarage.campaigns
              .map(
                (c) => Campaign(
                  partnerName: c.partnerName,
                  discountRule: c.discountRule,
                ),
              )
              .toList(),
        );
      }).toList();
    } catch (e) {
      print('Erro gRPC: $e');
      rethrow;
    }
  }
}
