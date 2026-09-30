import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:parking_app/core/routes/app_routes.dart';
import 'package:parking_app/core/theme/app_theme.dart';

class ParkingOwnerApp extends StatelessWidget {
  const ParkingOwnerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp(
          title: 'ParkingZero Business',
          debugShowCheckedModeBanner: false,
          theme: ParkingTheme.darkTheme,
          darkTheme: ParkingTheme.darkTheme,
          themeMode: ThemeMode.dark,
          initialRoute: AppRoutes.splash,
          routes: AppRoutes.getRoutes(),
        );
      },
    );
  }
}
