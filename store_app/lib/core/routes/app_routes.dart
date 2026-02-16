import 'package:flutter/material.dart';
import 'package:store_app/features/splash/splash_screen.dart';
import 'package:store_app/features/login/login_screen.dart';
import 'package:store_app/features/home/home_shell.dart';
import 'package:store_app/features/dashboard/dashboard_screen.dart';
import 'package:store_app/features/sponsorship/sponsorship_screen.dart';
import 'package:store_app/features/vouchers/voucher_history_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String home = '/home';
  static const String dashboard = '/dashboard';
  static const String sponsorship = '/sponsorship';
  static const String voucherHistory = '/voucher-history';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      splash: (context) => const SplashScreen(),
      login: (context) => const LoginScreen(),
      home: (context) => const HomeShell(),
      dashboard: (context) => const DashboardScreen(),
      sponsorship: (context) => const SponsorshipScreen(),
      voucherHistory: (context) => const VoucherHistoryScreen(),
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
