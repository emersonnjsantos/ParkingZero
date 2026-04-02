import 'package:bloc/bloc.dart';
import 'package:parking_app/features/garage_owner/domain/repositories/garage_repository.dart';

part 'create_garage_state.dart';

class CreateGarageCubit extends Cubit<CreateGarageState> {
  final GarageRepository _repository;

  CreateGarageCubit(this._repository) : super(const CreateGarageInitial());

  Future<void> createGarage({
    required String name,
    required double latitude,
    required double longitude,
    required int totalSpots,
    required List<String> imagePaths,
  }) async {
    emit(const CreateGarageLoading());
    try {
      await _repository.createGarage(
        name: name,
        latitude: latitude,
        longitude: longitude,
        totalSpots: totalSpots,
        imagePaths: imagePaths,
      );
      emit(const CreateGarageSuccess());
    } catch (e) {
      emit(CreateGarageFailure(error: e.toString()));
    }
  }
}
