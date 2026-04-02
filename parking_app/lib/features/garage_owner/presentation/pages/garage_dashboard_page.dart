import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:parking_app/features/garage_owner/domain/repositories/garage_repository.dart';
import 'package:parking_app/features/garage_owner/presentation/cubit/garage_dashboard_cubit.dart';
import 'package:parking_app/features/garage_owner/presentation/widgets/spot_grid.dart';
import 'package:sizer/sizer.dart';

class GarageDashboardPage extends StatelessWidget {
  final String garageId;
  const GarageDashboardPage({super.key, required this.garageId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          GarageDashboardCubit(context.read<GarageRepository>())
            ..loadGarage(garageId),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Dashboard da Garagem'),
          backgroundColor: Colors.deepPurpleAccent,
        ),
        body: BlocBuilder<GarageDashboardCubit, GarageDashboardState>(
          builder: (context, state) {
            if (state is GarageDashboardLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is GarageDashboardFailure) {
              return Center(child: Text('Erro: ${state.error}'));
            }
            if (state is GarageDashboardLoaded) {
              return Padding(
                padding: EdgeInsets.all(4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      state.garage.name,
                      style: GoogleFonts.inter(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: SpotGrid(
                        spots: state.spots,
                        onSpotTap: (spot) {
                          if (spot.isOccupied && spot.reservationId != null) {
                            context
                                .read<GarageDashboardCubit>()
                                .endReservation(
                                  reservationId: spot.reservationId!,
                                  userId: 'current_user_id',
                                  garageId: garageId,
                                );
                          } else {
                            context
                                .read<GarageDashboardCubit>()
                                .startReservation(
                                  garageId: garageId,
                                  userId: 'current_user_id',
                                );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
