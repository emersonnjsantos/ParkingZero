import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:parking_app/core/theme/app_theme.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Dashboard',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Estacionamento Central',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: ParkingTheme.accent,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: ParkingTheme.surfaceCard,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: ParkingTheme.border,
                        width: 0.5,
                      ),
                    ),
                    child: const Icon(
                      Icons.notifications_outlined,
                      color: ParkingTheme.textSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Occupancy Card
              _OccupancyCard(),
              const SizedBox(height: 16),

              // Stats Row
              Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      icon: Icons.login_rounded,
                      label: 'Entradas hoje',
                      value: '47',
                      color: ParkingTheme.info,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _StatCard(
                      icon: Icons.logout_rounded,
                      label: 'Saídas hoje',
                      value: '38',
                      color: ParkingTheme.success,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      icon: Icons.attach_money_rounded,
                      label: 'Receita hoje',
                      value: 'R\$ 1.240',
                      color: ParkingTheme.accent,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _StatCard(
                      icon: Icons.card_giftcard_rounded,
                      label: 'Patrocinados',
                      value: '12',
                      color: ParkingTheme.warning,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Revenue Chart
              Text(
                'Receita semanal',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 16),
              _RevenueChart(),
              const SizedBox(height: 24),

              // Recent Activity
              Text(
                'Atividade recente',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              _ActivityItem(
                plate: 'ABC-1234',
                type: 'Entrada',
                time: '14:32',
                icon: Icons.login_rounded,
                color: ParkingTheme.info,
              ),
              _ActivityItem(
                plate: 'XYZ-5678',
                type: 'Saída — Patrocinado',
                time: '14:28',
                icon: Icons.card_giftcard_rounded,
                color: ParkingTheme.accent,
              ),
              _ActivityItem(
                plate: 'DEF-9012',
                type: 'Saída — R\$ 25,00',
                time: '14:15',
                icon: Icons.logout_rounded,
                color: ParkingTheme.success,
              ),
              _ActivityItem(
                plate: 'GHI-3456',
                type: 'Entrada',
                time: '14:02',
                icon: Icons.login_rounded,
                color: ParkingTheme.info,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OccupancyCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const occupied = 32;
    const total = 50;
    const rate = occupied / total;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: ParkingTheme.headerGradient,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: ParkingTheme.border, width: 0.5),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ocupação atual',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: ParkingTheme.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '$occupied',
                        style: Theme.of(context).textTheme.displayMedium
                            ?.copyWith(
                              color: ParkingTheme.accent,
                              fontWeight: FontWeight.w800,
                            ),
                      ),
                      TextSpan(
                        text: ' / $total',
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(color: ParkingTheme.textSecondary),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${(rate * 100).toInt()}% ocupado • ${total - occupied} vagas livres',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: ParkingTheme.textMuted,
                  ),
                ),
              ],
            ),
          ),
          // Circular indicator
          SizedBox(
            width: 80,
            height: 80,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  value: rate,
                  strokeWidth: 8,
                  backgroundColor: ParkingTheme.border,
                  color: rate > 0.8
                      ? ParkingTheme.warning
                      : ParkingTheme.accent,
                  strokeCap: StrokeCap.round,
                ),
                Text(
                  '${(rate * 100).toInt()}%',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: ParkingTheme.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ParkingTheme.surfaceCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ParkingTheme.border, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 2),
          Text(label, style: Theme.of(context).textTheme.labelMedium),
        ],
      ),
    );
  }
}

class _RevenueChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ParkingTheme.surfaceCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ParkingTheme.border, width: 0.5),
      ),
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: 2000,
          barTouchData: BarTouchData(
            enabled: true,
            touchTooltipData: BarTouchTooltipData(
              getTooltipColor: (_) => ParkingTheme.surfaceElevated,
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                final days = ['Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb', 'Dom'];
                return BarTooltipItem(
                  '${days[group.x.toInt()]}\nR\$ ${rod.toY.toInt()}',
                  Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: ParkingTheme.accent,
                    fontWeight: FontWeight.w600,
                  ),
                );
              },
            ),
          ),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  final days = ['S', 'T', 'Q', 'Q', 'S', 'S', 'D'];
                  return Text(
                    days[value.toInt()],
                    style: Theme.of(context).textTheme.labelSmall,
                  );
                },
              ),
            ),
            leftTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          borderData: FlBorderData(show: false),
          gridData: const FlGridData(show: false),
          barGroups: [
            _makeBar(0, 1240),
            _makeBar(1, 980),
            _makeBar(2, 1450),
            _makeBar(3, 1120),
            _makeBar(4, 1680),
            _makeBar(5, 890),
            _makeBar(6, 560),
          ],
        ),
      ),
    );
  }

  BarChartGroupData _makeBar(int x, double y) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          width: 16,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
          gradient: ParkingTheme.accentGradient,
        ),
      ],
    );
  }
}

class _ActivityItem extends StatelessWidget {
  final String plate;
  final String type;
  final String time;
  final IconData icon;
  final Color color;

  const _ActivityItem({
    required this.plate,
    required this.type,
    required this.time,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: ParkingTheme.surfaceCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ParkingTheme.border, width: 0.5),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  plate,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: ParkingTheme.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(type, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
          Text(time, style: Theme.of(context).textTheme.labelMedium),
        ],
      ),
    );
  }
}
