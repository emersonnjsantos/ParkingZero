import 'package:flutter/material.dart';
import 'package:parkingzero/features/splash/presentation/screens/splash_screen.dart';
import 'package:parkingzero/features/map_search/presentation/screens/onboarding_location_screen.dart';
import 'package:parkingzero/features/home/presentation/screens/home_screen.dart';

/// Centralized route management for ParkingZero application
class AppRoutes {
  // Route names
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String home = '/home';
  static const String login = '/login';
  static const String register = '/register';
  static const String profile = '/profile';
  static const String wallet = '/wallet';
  static const String booking = '/booking';
  static const String parkingDetails = '/parking-details';
  static const String paymentMethod = '/payment-method';
  static const String bookingHistory = '/booking-history';
  static const String settings = '/settings';

  /// Map of all routes
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      splash: (context) => const SplashScreen(),
      onboarding: (context) => const OnboardingLocationScreen(),
      home: (context) => const HomeScreen(),
      // Add other routes here as screens are implemented
    };
  }

  /// Navigate to a route
  static Future<dynamic> navigateTo(BuildContext context, String routeName, {Object? arguments}) {
    return Navigator.pushNamed(context, routeName, arguments: arguments);
  }

  /// Navigate and replace current route
  static Future<dynamic> navigateAndReplace(BuildContext context, String routeName, {Object? arguments}) {
    return Navigator.pushReplacementNamed(context, routeName, arguments: arguments);
  }

  /// Navigate and clear all previous routes
  static Future<dynamic> navigateAndRemoveUntil(BuildContext context, String routeName, {Object? arguments}) {
    return Navigator.pushNamedAndRemoveUntil(
      context,
      routeName,
      (route) => false,
      arguments: arguments,
    );
  }

  /// Go back
  static void goBack(BuildContext context, {dynamic result}) {
    Navigator.pop(context, result);
  }
}
