import 'package:flutter/material.dart';
import 'package:parking_app/features/splash/splash_screen.dart';
import 'package:parking_app/features/login/login_screen.dart';
import 'package:parking_app/features/dashboard/dashboard_screen.dart';
import 'package:parking_app/features/vehicles/vehicle_control_screen.dart';
import 'package:parking_app/features/voucher/voucher_verify_screen.dart';
import 'package:parking_app/features/home/home_shell.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String home = '/home';
  static const String dashboard = '/dashboard';
  static const String vehicleControl = '/vehicle-control';
  static const String voucherVerify = '/voucher-verify';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      splash: (context) => const SplashScreen(),
      login: (context) => const LoginScreen(),
      home: (context) => const HomeShell(),
      dashboard: (context) => const DashboardScreen(),
      vehicleControl: (context) => const VehicleControlScreen(),
      voucherVerify: (context) => const VoucherVerifyScreen(),
    };
  }

  static Future<dynamic> navigateTo(BuildContext context, String route) {
    return Navigator.pushNamed(context, route);
  }

  static Future<dynamic> navigateAndReplace(
    BuildContext context,
    String route,
  ) {
    return Navigator.pushReplacementNamed(context, route);
  }

  static Future<dynamic> navigateAndClear(BuildContext context, String route) {
    return Navigator.pushNamedAndRemoveUntil(context, route, (_) => false);
  }
}
