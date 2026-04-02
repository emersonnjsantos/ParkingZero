import 'package:flutter/foundation.dart';
import 'package:grpc/grpc.dart';
import 'package:fixnum/fixnum.dart';
import 'package:parking_common/generated/garage/garage_service.pbgrpc.dart';

/// gRPC client for communication with the ParkingZero backend.
class ParkingGrpcClient {
  static const String _host =
      'parkingzero-backend-565100147812.southamerica-east1.run.app';
  static const int _port = 443;

  late final ClientChannel _channel;
  late final GarageServiceClient _stub;

  ParkingGrpcClient() {
    _channel = ClientChannel(
      _host,
      port: _port,
      options: const ChannelOptions(
        credentials: ChannelCredentials.secure(),
      ),
    );
    _stub = GarageServiceClient(_channel);
  }

  // ---------------------------------------------------------------------
  // Core service methods (matching the generated .proto)
  // ---------------------------------------------------------------------

  /// Search for garages near a location.
  Future<List<Garage>> searchGarages({
    required double latitude,
    required double longitude,
    required int radiusMeters,
  }) async {
    final request = SearchRequest()
      ..latitude = latitude
      ..longitude = longitude
      ..radiusMeters = radiusMeters;
    try {
      final response = await _stub.searchGarages(request);
      return response.garages;
    } catch (e) {
      debugPrint('Erro ao buscar garagens: $e');
      rethrow;
    }
  }

  /// Get details of a specific garage.
  Future<Garage> getGarage(String garageId) async {
    final request = GetGarageRequest()..garageId = garageId;
    try {
      return await _stub.getGarage(request);
    } catch (e) {
      debugPrint('Erro ao obter garagem: $e');
      rethrow;
    }
  }

  /// Create a reservation.
  Future<Reservation> createReservation({
    required String userId,
    required String garageId,
    required int startTime,
    required int endTime,
    required String vehiclePlate,
  }) async {
    final request = CreateReservationRequest()
      ..userId = userId
      ..garageId = garageId
      ..startTime = Int64(startTime)
      ..endTime = Int64(endTime)
      ..vehiclePlate = vehiclePlate;
    try {
      return await _stub.createReservation(request);
    } catch (e) {
      debugPrint('Erro ao criar reserva: $e');
      rethrow;
    }
  }

  /// List reservations for a user.
  Future<List<Reservation>> listReservations({
    required String userId,
  }) async {
    final request = ListReservationsRequest()..userId = userId;
    try {
      final response = await _stub.listReservations(request);
      return response.reservations;
    } catch (e) {
      debugPrint('Erro ao listar reservas: $e');
      rethrow;
    }
  }

  /// Cancel a reservation.
  Future<CancelReservationResponse> cancelReservation({
    required String reservationId,
    required String userId,
  }) async {
    final request = CancelReservationRequest()
      ..reservationId = reservationId
      ..userId = userId;
    try {
      return await _stub.cancelReservation(request);
    } catch (e) {
      debugPrint('Erro ao cancelar reserva: $e');
      rethrow;
    }
  }

  // ---------------------------------------------------------------------
  // Helper / convenience methods for the garage-owner flow
  // ---------------------------------------------------------------------

  /// Create a reservation using simple parameters (garage owner starting
  /// a reservation on behalf of a vehicle entering).
  Future<Reservation> startReservationByIds({
    required String garageId,
    required String userId,
    String vehiclePlate = '',
  }) async {
    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    return createReservation(
      userId: userId,
      garageId: garageId,
      startTime: now,
      endTime: now + 3600, // default 1 hour
      vehiclePlate: vehiclePlate,
    );
  }

  /// End (cancel) a reservation by its ID and userId.
  Future<CancelReservationResponse> endReservation({
    required String reservationId,
    required String userId,
  }) async {
    return cancelReservation(
      reservationId: reservationId,
      userId: userId,
    );
  }

  /// List active reservations for a specific garage.
  /// Since the backend does not support server-streaming yet,
  /// we poll with listReservations and filter by garageId.
  Future<List<Reservation>> listReservationsForGarage({
    required String garageId,
    required String userId,
  }) async {
    final all = await listReservations(userId: userId);
    return all.where((r) => r.garageId == garageId).toList();
  }

  /// Close the gRPC channel.
  Future<void> close() async {
    await _channel.shutdown();
  }
}
