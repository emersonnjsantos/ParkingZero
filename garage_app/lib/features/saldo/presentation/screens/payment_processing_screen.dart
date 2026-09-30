import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:parkingzero/features/home/presentation/screens/home_screen.dart';
import 'package:parkingzero/features/saldo/data/mercado_pago_service.dart';

class PaymentProcessingScreen extends StatefulWidget {
  final String brand; // 'VISA', 'MASTERCARD', 'Apple Pay', 'Google Pay', 'PayPal'

  const PaymentProcessingScreen({
    Key? key,
    required this.brand,
  }) : super(key: key);

  @override
  State<PaymentProcessingScreen> createState() => _PaymentProcessingScreenState();
}

class _PaymentProcessingScreenState extends State<PaymentProcessingScreen> with SingleTickerProviderStateMixin {
  bool _isSuccess = false;
  late final AnimationController _animationController;
  late final Animation<double> _fadeAnimation;
  late final Animation<double> _scaleAnimation;
  
  final MercadoPagoService _mpService = MercadoPagoService();
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.elasticOut,
      ),
    );

    _processPayment();
  }

  Future<void> _processPayment() async {
    try {
      final brandUpper = widget.brand.toUpperCase();
      if (brandUpper == 'VISA' || brandUpper == 'MASTERCARD') {
        // --- 1. Fluxo de Cartão Real Integrado ao Mercado Pago ---
        // Obtemos um token seguro para o cartão de teste do Mercado Pago
        final String token = await _mpService.generateCardToken(
          cardNumber: brandUpper == 'VISA' 
              ? "4111111111111111" // Visa de Teste
              : "5432123456789012", // Mastercard de Teste
          cardholderName: "APROVADO",
          expirationMonth: "12",
          expirationYear: "2028",
          securityCode: "123",
        );

        // Enviamos o token para processar a cobrança real no Backend de Pagamentos
        final result = await _mpService.processCardPayment(
          token: token,
          amount: 11.10,
          payerEmail: "comprador_teste@email.com",
        );

        if (result["status"] == "approved") {
          _handleSuccess();
        } else {
          throw Exception("Transação recusada: ${result["status_detail"] ?? 'Desconhecido'}");
        }

      } else if (widget.brand == 'PayPal') {
        // --- 2. Fluxo de PIX Dinâmico via Mercado Pago ---
        final result = await _mpService.processPixPayment(
          amount: 11.10,
          description: "Recarga Saldo ParkingZero",
          payerEmail: "comprador_teste@email.com",
          payerFirstName: "John",
          payerLastName: "Doe",
          payerCpf: "12345678909",
        );

        if (result["payment_id"] != null) {
          _handleSuccess();
        } else {
          throw Exception("Falha na geração do Pix");
        }

      } else {
        // --- 3. Fluxo Simulado (Apple Pay, Google Pay) ---
        // Mantemos o timer clássico para demonstração visual das outras Splashes
        await Future.delayed(const Duration(milliseconds: 2000));
        _handleSuccess();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString().replaceAll("Exception: ", "");
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Falha na transação: $_errorMessage'),
            backgroundColor: Colors.red.shade800,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 4),
          ),
        );

        // Retorna o usuário à tela de checkout para refazer a tentativa
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            Navigator.pop(context);
          }
        });
      }
    }
  }

  void _handleSuccess() {
    if (mounted) {
      setState(() {
        _isSuccess = true;
      });
      _animationController.forward();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _isSuccess
          ? AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              scrolledUnderElevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.pop(context),
              ),
            )
          : null,
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          child: _isSuccess ? _buildSuccessScreen() : _buildSplashScreen(),
        ),
      ),
    );
  }

  // --- 1. STATE: Splash Screen ---
  Widget _buildSplashScreen() {
    return Container(
      key: const ValueKey('splash'),
      width: double.infinity,
      height: double.infinity,
      color: Colors.white,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Logo in center
          _buildBrandLogo(widget.brand, isLarge: true),

          // Loading indicator at the bottom
          Positioned(
            bottom: 60,
            child: SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                valueColor: AlwaysStoppedAnimation<Color>(_getBrandPrimaryColor(widget.brand)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- 2. STATE: Success Screen ---
  Widget _buildSuccessScreen() {
    final primaryColor = _getBrandPrimaryColor(widget.brand);

    return Container(
      key: const ValueKey('success'),
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),

          // Animated success icon
          ScaleTransition(
            scale: _scaleAnimation,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    Icons.check_circle,
                    size: 72,
                    color: primaryColor,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 32),

          // Title
          FadeTransition(
            opacity: _fadeAnimation,
            child: Text(
              'Pagamento Aprovado!',
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w800,
                color: Colors.black,
              ),
            ),
          ),

          const SizedBox(height: 8),

          // Subtitle
          FadeTransition(
            opacity: _fadeAnimation,
            child: Text(
              'Processado via ${widget.brand}',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          const SizedBox(height: 48),

          // Receipt details card
          FadeTransition(
            opacity: _fadeAnimation,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                children: [
                  _buildReceiptRow('Valor', 'R\$ 12,00'),
                  const Divider(height: 24),
                  _buildReceiptRow('Método', widget.brand),
                  const Divider(height: 24),
                  _buildReceiptRow('Transação ID', 'PZ-${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}'),
                  const Divider(height: 24),
                  _buildReceiptRow('Status', 'Confirmado', isStatus: true),
                ],
              ),
            ),
          ),

          const Spacer(),

          // Action Button
          FadeTransition(
            opacity: _fadeAnimation,
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  // Return to Home Screen clearing the stack
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                    (route) => false,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Voltar ao Início',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildReceiptRow(String label, String value, {bool isStatus = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 15,
            color: Colors.grey.shade500,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 15,
            color: isStatus ? const Color(0xFF34A853) : Colors.black,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  // --- LOGO BUILDERS ---
  Widget _buildBrandLogo(String brand, {bool isLarge = false}) {
    if (brand == 'PayPal') {
      const String assetPath = 'assets/images/checkout_icons/paypal.svg';
      final double width = isLarge ? 240 : 58;
      final double height = isLarge ? 68 : 18;

      return SvgPicture.asset(
        assetPath,
        width: width,
        height: height,
        fit: BoxFit.contain,
      );
    }

    final String assetPath;
    final double? width;
    final double? height;

    if (brand.toUpperCase() == 'VISA') {
      assetPath = 'assets/images/checkout_icons/mastercard-old-svgrepo-com.svg';
      width = isLarge ? 240 : 45;
      height = isLarge ? 180 : 35;
    } else if (brand.toUpperCase() == 'MASTERCARD') {
      assetPath = 'assets/images/checkout_icons/mastercard-old-svgrepo-com.svg';
      width = isLarge ? 240 : 45;
      height = isLarge ? 180 : 35;
    } else if (brand == 'Apple Pay') {
      assetPath = 'assets/images/checkout_icons/apple-pay-svgrepo-com.svg';
      width = isLarge ? 220 : 50;
      height = isLarge ? 88 : 20;
    } else {
      // Google Pay
      assetPath = 'assets/images/checkout_icons/google-pay-primary-logo-logo-svgrepo-com.svg';
      width = isLarge ? 260 : 60;
      height = isLarge ? 100 : 24;
    }

    return SvgPicture.asset(
      assetPath,
      width: width,
      height: height,
      fit: BoxFit.contain,
    );
  }

  // Brand Accent/Primary Color
  Color _getBrandPrimaryColor(String brand) {
    if (brand.toUpperCase() == 'VISA') {
      return const Color(0xFFFF5F00);
    } else if (brand.toUpperCase() == 'MASTERCARD') {
      return const Color(0xFFFF5F00);
    } else if (brand == 'Apple Pay') {
      return Colors.black;
    } else if (brand == 'PayPal') {
      return const Color(0xFF003087);
    } else {
      // Google Pay blue
      return const Color(0xFF4285F4);
    }
  }
}
