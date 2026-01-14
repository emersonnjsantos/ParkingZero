import 'package:flutter/material.dart';

/// Custom icon widget that supports Material icons and custom icons
class CustomIconWidget extends StatelessWidget {
  final String iconName;
  final Color? color;
  final double? size;

  const CustomIconWidget({
    Key? key,
    required this.iconName,
    this.color,
    this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Map string icon names to Material icons
    final iconMap = {
      'local_parking': Icons.local_parking,
      'home': Icons.home,
      'search': Icons.search,
      'person': Icons.person,
      'wallet': Icons.wallet,
      'location_on': Icons.location_on,
      'directions_car': Icons.directions_car,
      'access_time': Icons.access_time,
      'credit_card': Icons.credit_card,
      'qr_code': Icons.qr_code,
      'notifications': Icons.notifications,
      'settings': Icons.settings,
      'logout': Icons.logout,
    };

    final iconData = iconMap[iconName] ?? Icons.help_outline;

    return Icon(
      iconData,
      color: color,
      size: size,
    );
  }
}
