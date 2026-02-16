import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:store_app/core/routes/app_routes.dart';
import 'package:store_app/core/theme/app_theme.dart';

class StorePartnerApp extends StatelessWidget {
  const StorePartnerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp(
          title: 'ParkingZero Store',
          debugShowCheckedModeBanner: false,
          theme: StoreTheme.darkTheme,
          darkTheme: StoreTheme.darkTheme,
          themeMode: ThemeMode.dark,
          initialRoute: AppRoutes.splash,
          routes: AppRoutes.getRoutes(),
        );
      },
    );
  }
}
