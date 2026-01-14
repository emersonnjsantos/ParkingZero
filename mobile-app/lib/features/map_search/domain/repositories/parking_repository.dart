import 'package:parkingzero/features/map_search/domain/entities/garage.dart';

abstract class ParkingRepository {
  Future<List<Garage>> searchGarages(double lat, double lng, int radiusMeters);
}
