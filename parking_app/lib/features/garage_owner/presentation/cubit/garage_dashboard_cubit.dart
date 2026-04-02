import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:parking_app/features/garage_owner/domain/entities/garage.dart';
import 'package:parking_app/features/garage_owner/domain/entities/spot.dart';
import 'package:parking_app/features/garage_owner/domain/repositories/garage_repository.dart';

part 'garage_dashboard_state.dart';

class GarageDashboardCubit extends Cubit<GarageDashboardState> {
  final GarageRepository _repository;

  GarageDashboardCubit(this._repository) : super(const GarageDashboardInitial());

  Future<void> loadGarage(String garageId) async {
    emit(const GarageDashboardLoading());
    try {
      final garage = await _repository.getGarage(garageId);
      // Generate spot list based on totalSpots
      final occupied = garage.totalSpots - garage.availableSpots;
      final spots = List.generate(
        garage.totalSpots,
        (i) => Spot(
          number: i + 1,
          isOccupied: i < occupied,
        ),
      );
      emit(GarageDashboardLoaded(garage: garage, spots: spots));
    } catch (e) {
      emit(GarageDashboardFailure(error: e.toString()));
    }
  }

  Future<void> startReservation({
    required String garageId,
    required String userId,
  }) async {
    try {
      await _repository.startReservation(garageId: garageId, userId: userId);
      // Reload the garage to refresh spot status
      await loadGarage(garageId);
    } catch (e) {
      // Optionally emit error
    }
  }

  Future<void> endReservation({
    required String reservationId,
    required String userId,
    required String garageId,
  }) async {
    try {
      await _repository.endReservation(
        reservationId: reservationId,
        userId: userId,
      );
      // Reload the garage to refresh spot status
      await loadGarage(garageId);
    } catch (e) {
      // Optionally emit error
    }
  }
}
