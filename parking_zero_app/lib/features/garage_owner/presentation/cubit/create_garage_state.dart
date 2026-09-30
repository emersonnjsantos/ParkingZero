part of 'create_garage_cubit.dart';

abstract class CreateGarageState {
  const CreateGarageState();
}

class CreateGarageInitial extends CreateGarageState {
  const CreateGarageInitial();
}

class CreateGarageLoading extends CreateGarageState {
  const CreateGarageLoading();
}

class CreateGarageSuccess extends CreateGarageState {
  const CreateGarageSuccess();
}

class CreateGarageFailure extends CreateGarageState {
  final String error;
  const CreateGarageFailure({required this.error});
}
