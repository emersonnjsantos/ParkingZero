import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:store_app/core/theme/app_theme.dart';
import 'package:store_app/core/di/injection.dart';
import 'package:store_app/core/data/store_repository.dart';
import 'package:store_app/generated/payment/payment_service.pb.dart';

class VoucherHistoryScreen extends StatefulWidget {
  const VoucherHistoryScreen({super.key});

  @override
  State<VoucherHistoryScreen> createState() => _VoucherHistoryScreenState();
}

class _VoucherHistoryScreenState extends State<VoucherHistoryScreen> {
  final _repo = sl<StoreRepository>();
  final _currencyFormat = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
  final _dateFormat = DateFormat('dd/MM');

  List<SponsorshipLedgerEntry> _entries = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadLedger();
  }

  Future<void> _loadLedger() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      // TODO: replace with actual reservationId from context or query
      final response = await _repo.getSponsorshipLedger('current_reservation');
      if (mounted) {
        setState(() {
          _entries = response.entries.toList();
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Não foi possível carregar o histórico';
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(color: StoreTheme.accent),
              )
            : _error != null
            ? _buildError()
            : RefreshIndicator(
                onRefresh: _loadLedger,
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
            onPressed: _loadLedger,
            icon: const Icon(Icons.refresh),
            label: const Text('Tentar novamente'),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    final totalAmount = _entries.fold<double>(0, (sum, e) => sum + e.amount);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Histórico de Vouchers',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 4),
              Text(
                'Todos os patrocínios realizados',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Summary row
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              _MiniStat(
                label: 'Total',
                value: '${_entries.length}',
                color: StoreTheme.accent,
              ),
              const SizedBox(width: 10),
              _MiniStat(
                label: 'Investido',
                value: _currencyFormat.format(totalAmount),
                color: StoreTheme.success,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Ledger entry list
        Expanded(
          child: _entries.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.receipt_long_outlined,
                        size: 64,
                        color: StoreTheme.textMuted,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Nenhum patrocínio ainda',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: StoreTheme.textMuted,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: _entries.length,
                  itemBuilder: (context, index) {
                    return _LedgerEntryCard(
                      entry: _entries[index],
                      currencyFormat: _currencyFormat,
                      dateFormat: _dateFormat,
                    );
                  },
                ),
        ),
      ],
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String label, value;
  final Color color;
  const _MiniStat({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              label,
              style: Theme.of(
                context,
              ).textTheme.labelSmall?.copyWith(color: color),
            ),
          ],
        ),
      ),
    );
  }
}

class _LedgerEntryCard extends StatelessWidget {
  final SponsorshipLedgerEntry entry;
  final NumberFormat currencyFormat;
  final DateFormat dateFormat;

  const _LedgerEntryCard({
    required this.entry,
    required this.currencyFormat,
    required this.dateFormat,
  });

  @override
  Widget build(BuildContext context) {
    final date = DateTime.fromMillisecondsSinceEpoch(entry.timestamp.toInt());
    final formattedDate = dateFormat.format(date);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: StoreTheme.surfaceCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: StoreTheme.border, width: 0.5),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: StoreTheme.accent.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.card_giftcard_rounded,
              color: StoreTheme.accent,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  currencyFormat.format(entry.amount),
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: StoreTheme.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'NF ${entry.invoiceId.isNotEmpty ? entry.invoiceId : "—"}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                formattedDate,
                style: Theme.of(context).textTheme.labelSmall,
              ),
              const SizedBox(height: 4),
              Text(
                entry.entryId.length > 8
                    ? entry.entryId.substring(0, 8)
                    : entry.entryId,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: StoreTheme.textMuted,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
