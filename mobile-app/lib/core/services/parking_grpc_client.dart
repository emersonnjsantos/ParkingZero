import 'package:flutter/foundation.dart';
import 'package:grpc/grpc.dart';
import 'package:fixnum/fixnum.dart';
import 'package:parkingzero/generated/parking_service.pbgrpc.dart';

/// Cliente gRPC para comunicação com o backend ParkingZero
class ParkingGrpcClient {
  static const String _host =
      'parkingzero-backend-565100147812.southamerica-east1.run.app';
  static const int _port = 443;

  late final ClientChannel _channel;
  late final ParkingServiceClient _stub;

  ParkingGrpcClient() {
    _channel = ClientChannel(
      _host,
      port: _port,
      options: const ChannelOptions(credentials: ChannelCredentials.secure()),
    );
    _stub = ParkingServiceClient(_channel);
  }

  /// Buscar garagens próximas a uma localização
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

  /// Obter detalhes de uma garagem específica
  Future<Garage> getGarage(String garageId) async {
    final request = GetGarageRequest()..garageId = garageId;

    try {
      return await _stub.getGarage(request);
    } catch (e) {
      debugPrint('Erro ao obter garagem: $e');
      rethrow;
    }
  }

  /// Criar uma reserva
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

  /// Listar reservas do usuário
  Future<List<Reservation>> listReservations({
    required String userId,
    ReservationStatus? statusFilter,
  }) async {
    final request = ListReservationsRequest()..userId = userId;

    if (statusFilter != null) {
      request.statusFilter = statusFilter;
    }

    try {
      final response = await _stub.listReservations(request);
      return response.reservations;
    } catch (e) {
      debugPrint('Erro ao listar reservas: $e');
      rethrow;
    }
  }

  /// Cancelar uma reserva
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

  /// Fechar conexão
  Future<void> close() async {
    await _channel.shutdown();
  }
}
