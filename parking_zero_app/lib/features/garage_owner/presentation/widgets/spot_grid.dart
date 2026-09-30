import 'package:flutter/material.dart';
import 'package:parking_app/features/garage_owner/domain/entities/spot.dart';
import 'package:sizer/sizer.dart';

class SpotGrid extends StatelessWidget {
  final List<Spot> spots;
  final void Function(Spot) onSpotTap;

  const SpotGrid({super.key, required this.spots, required this.onSpotTap});

  @override
  Widget build(BuildContext context) {
    final crossAxisCount = (MediaQuery.of(context).size.width / 80).floor().clamp(2, 8);
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 2.w,
        mainAxisSpacing: 2.w,
        childAspectRatio: 1,
      ),
      itemCount: spots.length,
      itemBuilder: (context, index) {
        final spot = spots[index];
        return GestureDetector(
          onTap: () => onSpotTap(spot),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            decoration: BoxDecoration(
              color: spot.isOccupied ? Colors.redAccent : Colors.greenAccent,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  spot.isOccupied ? Icons.directions_car : Icons.local_parking,
                  color: Colors.white,
                  size: 20.sp,
                ),
                const SizedBox(height: 4),
                Text(
                  '${spot.number}',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
