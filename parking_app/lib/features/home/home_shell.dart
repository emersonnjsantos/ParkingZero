import 'package:flutter/material.dart';
import 'package:parking_app/features/dashboard/dashboard_screen.dart';
import 'package:parking_app/features/vehicles/vehicle_control_screen.dart';
import 'package:parking_app/features/voucher/voucher_verify_screen.dart';
import 'package:parking_app/core/theme/app_theme.dart';

/// Shell com BottomNavigationBar para as 3 telas principais
class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _currentIndex = 0;

  final _screens = const [
    DashboardScreen(),
    VehicleControlScreen(),
    VoucherVerifyScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: ParkingTheme.border, width: 0.5),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (i) => setState(() => _currentIndex = i),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard_rounded),
              activeIcon: Icon(Icons.dashboard_rounded),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.directions_car_rounded),
              activeIcon: Icon(Icons.directions_car_rounded),
              label: 'Veículos',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.qr_code_scanner_rounded),
              activeIcon: Icon(Icons.qr_code_scanner_rounded),
              label: 'Voucher',
            ),
          ],
        ),
      ),
    );
  }
}
