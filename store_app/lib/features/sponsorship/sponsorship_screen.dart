import 'package:flutter/material.dart';
import 'package:grpc/grpc.dart';
import 'package:intl/intl.dart';
import 'package:store_app/core/theme/app_theme.dart';
import 'package:store_app/core/di/injection.dart';
import 'package:store_app/core/data/store_repository.dart';

class SponsorshipScreen extends StatefulWidget {
  const SponsorshipScreen({super.key});

  @override
  State<SponsorshipScreen> createState() => _SponsorshipScreenState();
}

class _SponsorshipScreenState extends State<SponsorshipScreen> {
  final _repo = sl<StoreRepository>();
  final _invoiceController = TextEditingController();
  final _plateController = TextEditingController();
  final _invoiceIdController = TextEditingController();
  final _currencyFormat = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
  bool _isProcessing = false;
  double _invoiceAmount = 0;

  @override
  void dispose() {
    _invoiceController.dispose();
    _plateController.dispose();
    _invoiceIdController.dispose();
    super.dispose();
  }

  Future<void> _handleSponsor() async {
    if (_plateController.text.isEmpty || _invoiceAmount < 200) return;

    setState(() => _isProcessing = true);
    try {
      // TODO: replace storeId and storeName with actual auth profile values
      final response = await _repo.requestSponsorship(
        storeId: 'current_store',
        reservationId: _plateController.text.trim().toUpperCase(),
        invoiceAmount: _invoiceAmount,
        invoiceId: _invoiceIdController.text.trim(),
        storeName: 'Minha Loja',
      );

      if (mounted) {
        setState(() => _isProcessing = false);
        if (response.success) {
          _showSuccess(
            amountSponsored: response.amountSponsored,
            ledgerEntryId: response.ledgerEntryId,
          );
          _invoiceController.clear();
          _plateController.clear();
          _invoiceIdController.clear();
          setState(() => _invoiceAmount = 0);
        } else {
          _showError(
            response.message.isNotEmpty
                ? response.message
                : 'Erro ao processar patrocínio',
          );
        }
      }
    } on GrpcError catch (e) {
      if (mounted) {
        setState(() => _isProcessing = false);
        _showError('Erro de conexão: ${e.message ?? "Tente novamente"}');
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isProcessing = false);
        _showError('Erro inesperado. Tente novamente.');
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showSuccess({double amountSponsored = 0, String ledgerEntryId = ''}) {
    showModalBottomSheet(
      context: context,
      backgroundColor: StoreTheme.surfaceCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: StoreTheme.success.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle_rounded,
                size: 36,
                color: StoreTheme.success,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Patrocínio registrado!',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Valor: ${_currencyFormat.format(amountSponsored)}\n'
              'Voucher gerado e enviado ao cliente',
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: StoreTheme.textSecondary),
            ),
            if (ledgerEntryId.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                'Ref: $ledgerEntryId',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: StoreTheme.textMuted,
                  fontSize: 11,
                ),
              ),
            ],
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final eligible = _invoiceAmount >= 200;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Patrocinar Estacionamento',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 4),
              Text(
                'Ofereça estacionamento grátis para clientes com NF ≥ R\$ 200',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 24),

              // Sponsorship Form
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: StoreTheme.headerGradient,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    const Icon(
                      Icons.receipt_long_rounded,
                      size: 48,
                      color: StoreTheme.accent,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Nova nota fiscal',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 20),

                    // Invoice amount
                    TextField(
                      controller: _invoiceController,
                      keyboardType: TextInputType.number,
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1,
                          ),
                      textAlign: TextAlign.center,
                      onChanged: (v) {
                        setState(() {
                          _invoiceAmount =
                              double.tryParse(v.replaceAll(',', '.')) ?? 0;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: '0,00',
                        prefixText: 'R\$ ',
                        hintStyle: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(
                              color: StoreTheme.textMuted,
                              letterSpacing: 1,
                            ),
                        filled: true,
                        fillColor: StoreTheme.primaryDeep.withValues(
                          alpha: 0.5,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(
                            color: StoreTheme.border,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(
                            color: StoreTheme.border,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(
                            color: StoreTheme.accent,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Eligibility indicator
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: eligible
                            ? StoreTheme.success.withValues(alpha: 0.12)
                            : StoreTheme.warning.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            eligible ? Icons.check_circle : Icons.info_outline,
                            size: 16,
                            color: eligible
                                ? StoreTheme.success
                                : StoreTheme.warning,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            eligible
                                ? 'Elegível para patrocínio!'
                                : 'Mínimo R\$ 200,00',
                            style: Theme.of(context).textTheme.labelMedium
                                ?.copyWith(
                                  color: eligible
                                      ? StoreTheme.success
                                      : StoreTheme.warning,
                                ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Plate
                    TextField(
                      controller: _plateController,
                      textCapitalization: TextCapitalization.characters,
                      style: Theme.of(
                        context,
                      ).textTheme.titleMedium?.copyWith(letterSpacing: 2),
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        hintText: 'Placa do veículo',
                        hintStyle: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(color: StoreTheme.textMuted),
                        filled: true,
                        fillColor: StoreTheme.primaryDeep.withValues(
                          alpha: 0.5,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(
                            color: StoreTheme.border,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(
                            color: StoreTheme.border,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(
                            color: StoreTheme.accent,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Sponsor button
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton.icon(
                        onPressed: (!eligible || _isProcessing)
                            ? null
                            : _handleSponsor,
                        icon: _isProcessing
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(Icons.card_giftcard_rounded),
                        label: Text(
                          _isProcessing
                              ? 'Processando...'
                              : 'Patrocinar Estacionamento',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // How it works
              Text(
                'Como funciona',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              _StepCard(
                number: '1',
                title: 'Cliente compra',
                desc: 'Compra ≥ R\$ 200 na sua loja',
              ),
              _StepCard(
                number: '2',
                title: 'Registre a NF',
                desc: 'Insira o valor e a placa do veículo',
              ),
              _StepCard(
                number: '3',
                title: 'Voucher gerado',
                desc: 'Cliente recebe voucher no app',
              ),
              _StepCard(
                number: '4',
                title: 'Saída gratuita',
                desc: 'Estacionamento valida automaticamente',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StepCard extends StatelessWidget {
  final String number, title, desc;
  const _StepCard({
    required this.number,
    required this.title,
    required this.desc,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: StoreTheme.surfaceCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: StoreTheme.border, width: 0.5),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: StoreTheme.accent.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                number,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: StoreTheme.accent,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: StoreTheme.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(desc, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
