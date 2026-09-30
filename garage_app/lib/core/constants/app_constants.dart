import 'package:flutter/material.dart';

class AppColors {
  // Blue palette (Tailwind-inspired)
  static const Color blue50 = Color(0xFFE0F2FE);
  static const Color blue100 = Color(0xFFBAE6FD);
  static const Color blue200 = Color(0xFF7DD3FC);
  static const Color blue300 = Color(0xFF38BDF8);
  static const Color blue400 = Color(0xFF38BDF8);
  static const Color blue500 = Color(0xFF3B82F6); // primary
  static const Color primary = blue500;
  static const Color primaryDark = blue700;
  static const Color textBody = textMediumEmphasis;
  // Accent orange for highlights and primary actions
  static const Color accentOrange = Color(0xFFFFA500);
  static const Color blue600 = Color(0xFF2563EB);
  static const Color blue700 = Color(0xFF1D4ED8);
  static const Color blue800 = Color(0xFF1E40AF);
  static const Color blue900 = Color(0xFF1E3A8A);

  // Divider colors (1px with 0.1-0.2 opacity)
  static const Color dividerLight = Color(0x1A0F172A);
  static const Color dividerDark = Color(0x331E3A8A);

  static const Color textHighEmphasis = Color(0xFF0F172A);
  static const Color textMediumEmphasis = Color(0xFF334155);
  static const Color textDisabled = Color(0xFF64748B);
  static const Color error = Color(0xFFEF4444);
  static const Color success = Color(0xFF10B981);
  static const Color background = Color(0xFFFFFFFF);
  
  // Color Specifications from Design Theme

  // Primary Gradient Colors (blue tones)
  static const Color gradientStartLight = AppColors.blue900; // Deep blue
  static const Color gradientEndLight = AppColors.blue500; // Lighter blue

  // Core Brand Colors
  static const Color logoWhite = Color(0xFFFFFFFF);
  static const Color surface = Color(0xFFF1F5F9);
}

/// Classe que contém todas as constantes da aplicação ParkingZero.
///
/// Esta classe centraliza valores como cores, dimensões, textos e endpoints
/// da API para facilitar manutenção e consistência no app.
class AppConstants {
  AppConstants._(); // Construtor privado para evitar instanciação

  //=================================
  // INFORMAÇÕES DO APLICATIVO
  //=================================

  /// Nome do aplicativo
  static const String appName = 'ParkingZero';

  /// Versão do aplicativo
  static const String appVersion = '1.0.0';
}
