import 'package:flutter/material.dart';
import 'package:parking_app/core/theme/app_theme.dart';

class VoucherVerifyScreen extends StatefulWidget {
  const VoucherVerifyScreen({super.key});

  @override
  State<VoucherVerifyScreen> createState() => _VoucherVerifyScreenState();
}

class _VoucherVerifyScreenState extends State<VoucherVerifyScreen> {
  final _codeController = TextEditingController();
  bool _isVerifying = false;
  _VoucherResult? _result;

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  void _verifyVoucher() {
    if (_codeController.text.isEmpty) return;

    setState(() {
      _isVerifying = true;
      _result = null;
    });

    // Simular verificação gRPC
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _isVerifying = false;
          // Mock: voucher válido
          _result = _VoucherResult(
            isValid: true,
            plate: 'ABC-1234',
            storeName: 'Loja Fashion Center',
            discount: 'Gratuito',
            expiresAt: '15/02/2026 23:59',
            sponsorType: 'Patrocínio integral',
          );
        });
      }
    });
  }

  void _confirmExit() {
    setState(() => _isVerifying = true);

    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        setState(() {
          _isVerifying = false;
          _result = null;
        });
        _codeController.clear();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('✅ Saída liberada com sucesso!'),
            backgroundColor: ParkingTheme.success,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Verificar Voucher',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 4),
              Text(
                'Escaneie ou digite o código do voucher',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 24),

              // Scan area
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  gradient: ParkingTheme.headerGradient,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: ParkingTheme.accent.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: ParkingTheme.accent.withValues(alpha: 0.3),
                          width: 2,
                        ),
                      ),
                      child: const Icon(
                        Icons.qr_code_scanner_rounded,
                        size: 40,
                        color: ParkingTheme.accent,
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          // TODO: integrar com câmera QR
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text(
                                '📷 Scanner QR será integrado com a câmera',
                              ),
                              backgroundColor: ParkingTheme.info,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.camera_alt_rounded),
                        label: const Text('Escanear QR Code'),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: Divider(
                            color: ParkingTheme.border.withValues(alpha: 0.5),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Text(
                            'ou digite o código',
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            color: ParkingTheme.border.withValues(alpha: 0.5),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _codeController,
                      textCapitalization: TextCapitalization.characters,
                      style: Theme.of(
                        context,
                      ).textTheme.titleMedium?.copyWith(letterSpacing: 2),
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        hintText: 'VOUCHER-CODE',
                        filled: true,
                        fillColor: ParkingTheme.primaryDeep.withValues(
                          alpha: 0.5,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(
                            color: ParkingTheme.border,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(
                            color: ParkingTheme.border,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(
                            color: ParkingTheme.accent,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _isVerifying ? null : _verifyVoucher,
                        child: _isVerifying
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: ParkingTheme.primaryDeep,
                                ),
                              )
                            : const Text('Verificar'),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Result
              if (_result != null)
                _VoucherResultCard(
                  result: _result!,
                  onConfirm: _confirmExit,
                  isLoading: _isVerifying,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _VoucherResultCard extends StatelessWidget {
  final _VoucherResult result;
  final VoidCallback onConfirm;
  final bool isLoading;

  const _VoucherResultCard({
    required this.result,
    required this.onConfirm,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    final isValid = result.isValid;
    final statusColor = isValid ? ParkingTheme.success : ParkingTheme.error;
    final statusIcon = isValid
        ? Icons.check_circle_rounded
        : Icons.cancel_rounded;
    final statusText = isValid ? 'Voucher Válido' : 'Voucher Inválido';

    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutCubic,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: ParkingTheme.surfaceCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: statusColor.withValues(alpha: 0.4),
          width: 1.5,
        ),
      ),
      child: Column(
        children: [
          // Status
          Row(
            children: [
              Icon(statusIcon, color: statusColor, size: 28),
              const SizedBox(width: 10),
              Text(
                statusText,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: statusColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Details
          _DetailRow(label: 'Placa', value: result.plate),
          _DetailRow(label: 'Loja', value: result.storeName),
          _DetailRow(label: 'Desconto', value: result.discount),
          _DetailRow(label: 'Tipo', value: result.sponsorType),
          _DetailRow(label: 'Válido até', value: result.expiresAt),
          const SizedBox(height: 20),

          if (isValid)
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: isLoading ? null : onConfirm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: ParkingTheme.success,
                ),
                icon: const Icon(Icons.check_rounded),
                label: const Text('Liberar Saída'),
              ),
            ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodySmall),
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class _VoucherResult {
  final bool isValid;
  final String plate;
  final String storeName;
  final String discount;
  final String expiresAt;
  final String sponsorType;

  _VoucherResult({
    required this.isValid,
    required this.plate,
    required this.storeName,
    required this.discount,
    required this.expiresAt,
    required this.sponsorType,
  });
}
