import 'package:flutter/material.dart';
import 'package:mobile_app/core/constants/app_constants.dart';
import 'package:mobile_app/core/theme/app_theme.dart';
import 'package:mobile_app/features/map_search/presentation/screens/onboarding_location_screen.dart';

class FronteiraParkingApp extends StatelessWidget {
  const FronteiraParkingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light, // Forçar light mode para corresponder à imagem
      home: const OnboardingLocationScreen(),
    );
  }
}
