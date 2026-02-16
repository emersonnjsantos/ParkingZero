import 'package:flutter/foundation.dart';
import 'package:parkingzero/core/services/parking_grpc_client.dart';
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
      debugPrint('Erro gRPC: $e');
      rethrow;
    }
  }
}
