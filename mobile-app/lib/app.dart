import 'package:flutter/material.dart';
import 'package:parkingzero/core/constants/app_constants.dart';
import 'package:parkingzero/core/theme/app_theme.dart';
import 'package:parkingzero/core/routes/app_routes.dart';
import 'package:sizer/sizer.dart';

class ParkingZeroApp extends StatelessWidget {
  const ParkingZeroApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp(
          title: AppConstants.appName,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.light,
          initialRoute: AppRoutes.splash,
          routes: AppRoutes.getRoutes(),
        );
      },
    );
  }
}
