import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:store_app/core/theme/app_theme.dart';
import 'package:store_app/core/di/injection.dart';
import 'package:store_app/core/data/store_repository.dart';
import 'package:store_app/generated/dashboard/dashboard_service.pb.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final _repo = sl<StoreRepository>();
  final _currencyFormat = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

  StoreSponsorshipSummary? _summary;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadDashboard();
  }

  Future<void> _loadDashboard() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      // TODO: replace with actual storeId from auth profile
      final summary = await _repo.getStoreSummary('current_store');
      if (mounted) {
        setState(() {
          _summary = summary;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Não foi possível carregar o dashboard';
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: StoreTheme.primaryDeep,
      body: SafeArea(
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(color: StoreTheme.accent),
              )
            : _error != null
            ? _buildError()
            : RefreshIndicator(
                onRefresh: _loadDashboard,
                color: StoreTheme.accent,
                child: _buildContent(),
              ),
      ),
    );
  }

  Widget _buildError() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.cloud_off_rounded, size: 64, color: StoreTheme.textMuted),
          const SizedBox(height: 16),
          Text(_error!, style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _loadDashboard,
            icon: const Icon(Icons.refresh),
            label: const Text('Tentar novamente'),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    final s = _summary!;
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        // Header
        Text(
          'Dashboard',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          s.storeName.isNotEmpty ? s.storeName : 'Seus patrocínios',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: StoreTheme.textMuted),
        ),
        const SizedBox(height: 24),

        // Investment card
        _buildInvestmentCard(s),
        const SizedBox(height: 20),

        // Stats row
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'Patrocínios',
                s.totalSponsorships.toString(),
                Icons.handshake_rounded,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                'Clientes',
                s.uniqueCustomers.toString(),
                Icons.people_rounded,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'Ticket Médio',
                _currencyFormat.format(s.averageInvoice),
                Icons.receipt_long_rounded,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                'Total Investido',
                _currencyFormat.format(s.totalSpent),
                Icons.trending_up_rounded,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Monthly chart
        if (s.monthly.isNotEmpty) ...[
          Text(
            'Patrocínios por Mês',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(color: Colors.white),
          ),
          const SizedBox(height: 16),
          _buildMonthlyChart(s.monthly),
        ],
      ],
    );
  }

  Widget _buildInvestmentCard(StoreSponsorshipSummary s) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: StoreTheme.headerGradient,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: StoreTheme.accent.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.account_balance_wallet_rounded,
                color: StoreTheme.accent,
                size: 28,
              ),
              const SizedBox(width: 12),
              Text(
                'Investimento Total',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(color: StoreTheme.textMuted),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            _currencyFormat.format(s.totalSpent),
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${s.totalSponsorships} patrocínios • ${s.uniqueCustomers} clientes atendidos',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: StoreTheme.textMuted),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: StoreTheme.surfaceCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: StoreTheme.border, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: StoreTheme.accent, size: 22),
          const SizedBox(height: 12),
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: StoreTheme.textMuted),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthlyChart(List<MonthlySponsorshipStats> monthly) {
    return Container(
      height: 220,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: StoreTheme.surfaceCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: StoreTheme.border, width: 0.5),
      ),
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY:
              monthly
                  .map((m) => m.amountSpent)
                  .reduce((a, b) => a > b ? a : b) *
              1.2,
          barTouchData: BarTouchData(
            touchTooltipData: BarTouchTooltipData(
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                return BarTooltipItem(
                  _currencyFormat.format(rod.toY),
                  const TextStyle(color: Colors.white, fontSize: 12),
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
                  final idx = value.toInt();
                  if (idx < 0 || idx >= monthly.length) {
                    return const SizedBox.shrink();
                  }
                  return Text(
                    monthly[idx].month.length > 3
                        ? monthly[idx].month.substring(0, 3)
                        : monthly[idx].month,
                    style: const TextStyle(
                      color: StoreTheme.textMuted,
                      fontSize: 11,
                    ),
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
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          barGroups: monthly.asMap().entries.map((entry) {
            return BarChartGroupData(
              x: entry.key,
              barRods: [
                BarChartRodData(
                  toY: entry.value.amountSpent,
                  color: StoreTheme.accent,
                  width: 18,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(6),
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
