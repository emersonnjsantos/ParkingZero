import 'package:parking_app/features/garage_owner/domain/entities/garage.dart';

abstract class GarageRepository {
  /// Cria uma nova garagem (upload de imagens + criação via API).
  Future<void> createGarage({
    required String name,
    required double latitude,
    required double longitude,
    required int totalSpots,
    required List<String> imagePaths,
  });

  /// Obtém os detalhes de uma garagem pelo ID.
  Future<Garage> getGarage(String garageId);

  /// Inicia uma reserva (entrada de veículo) para a garagem.
  Future<void> startReservation({
    required String garageId,
    required String userId,
  });

  /// Finaliza (cancela) uma reserva (saída de veículo).
  Future<void> endReservation({
    required String reservationId,
    required String userId,
  });
}
