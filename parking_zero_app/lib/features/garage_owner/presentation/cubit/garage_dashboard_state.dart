part of 'garage_dashboard_cubit.dart';

abstract class GarageDashboardState {
  const GarageDashboardState();
}

class GarageDashboardInitial extends GarageDashboardState {
  const GarageDashboardInitial();
}

class GarageDashboardLoading extends GarageDashboardState {
  const GarageDashboardLoading();
}

class GarageDashboardLoaded extends GarageDashboardState {
  final Garage garage;
  final List<Spot> spots;

  const GarageDashboardLoaded({required this.garage, required this.spots});

  GarageDashboardLoaded copyWith({Garage? garage, List<Spot>? spots}) {
    return GarageDashboardLoaded(
      garage: garage ?? this.garage,
      spots: spots ?? this.spots,
    );
  }
}

class GarageDashboardFailure extends GarageDashboardState {
  final String error;
  const GarageDashboardFailure({required this.error});
}
