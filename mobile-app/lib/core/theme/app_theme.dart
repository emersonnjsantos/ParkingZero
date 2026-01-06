import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_app/core/constants/app_constants.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: AppColors.primary,
        onPrimary: Colors.white,
        surface: AppColors.background,
        onSurface: AppColors.textBody,
        brightness: Brightness.light,
      ),
      textTheme: GoogleFonts.interTextTheme().copyWith(
        displayLarge: GoogleFonts.inter(
          color: AppColors.primary,
          fontWeight: FontWeight.bold,
        ),
        bodyLarge: GoogleFonts.inter(
          color: AppColors.textBody,
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.dark,
      ),
      textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
    );
  }
}
