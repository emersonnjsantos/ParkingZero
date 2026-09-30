import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:parkingzero/features/saldo/presentation/screens/novo_cartao_screen.dart';
import 'package:parkingzero/features/saldo/presentation/screens/payment_processing_screen.dart';

class SaldoScreen extends StatefulWidget {
  const SaldoScreen({Key? key}) : super(key: key);

  @override
  State<SaldoScreen> createState() => _SaldoScreenState();
}

class _SaldoScreenState extends State<SaldoScreen> {
  int _selectedPaymentMethod = 0; // 0 = Card, 1 = Apple Pay
  int _currentCardIndex = 0;
  late final PageController _cardPageController;

  final List<Map<String, String>> _cards = [
    {'last4': '4458', 'name': 'John Doe', 'expiry': '22/11', 'brand': 'VISA'},
    {
      'last4': '7821',
      'name': 'John Doe',
      'expiry': '25/03',
      'brand': 'MASTERCARD',
    },
  ];

  @override
  void initState() {
    super.initState();
    _cardPageController = PageController(viewportFraction: 0.85);
  }

  @override
  void dispose() {
    _cardPageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'CHECKOUT',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),

                  // --- Selecione o método de pagamento ---
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.0),
                    child: Text(
                      'Selecione o método de pagamento:',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.black87,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // --- Payment Method Tabs ---
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Row(
                      children: [
                        Expanded(child: _buildPaymentTab(index: 0)),
                        const SizedBox(width: 6),
                        Expanded(child: _buildPaymentTab(index: 1)),
                        const SizedBox(width: 6),
                        Expanded(child: _buildPaymentTab(index: 2)),
                        const SizedBox(width: 6),
                        Expanded(child: _buildPaymentTab(index: 3)),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // --- Selecione o cartão + botão adicionar ---
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Selecione o cartão',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.black87,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const NovoCartaoScreen(),
                              ),
                            );
                          },
                          child: const Icon(
                            Icons.add,
                            size: 28,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // --- Credit Card Carousel ---
                  SizedBox(
                    height: 210,
                    child: PageView.builder(
                      controller: _cardPageController,
                      onPageChanged: (index) {
                        setState(() => _currentCardIndex = index);
                      },
                      itemCount: _cards.length,
                      itemBuilder: (context, index) {
                        return _buildCreditCard(_cards[index]);
                      },
                    ),
                  ),

                  const SizedBox(height: 16),

                  // --- Dot indicators ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(_cards.length, (index) {
                      return Container(
                        width: 8,
                        height: 8,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _currentCardIndex == index
                              ? Colors.black87
                              : Colors.grey.shade400,
                        ),
                      );
                    }),
                  ),

                  const SizedBox(height: 32),

                  // --- Divider ---
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Divider(color: Colors.grey.shade300, thickness: 1),
                  ),

                  const SizedBox(height: 20),

                  // --- Valor Total ---
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Valor Total',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black54,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Text(
                          '\$11.1',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black87,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),

          // --- Botão Pagar ---
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 12),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    String brand = 'Google Pay';
                    if (_selectedPaymentMethod == 0) {
                      brand = _cards[_currentCardIndex]['brand'] ?? 'VISA';
                    } else if (_selectedPaymentMethod == 1) {
                      brand = 'Apple Pay';
                    } else if (_selectedPaymentMethod == 2) {
                      brand = 'Google Pay';
                    }

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            PaymentProcessingScreen(brand: brand),
                      ),
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
                    'Pagar',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- Payment method tab widget ---
  Widget _buildPaymentTab({required int index}) {
    final isSelected = _selectedPaymentMethod == index;

    Widget content;
    switch (index) {
      case 0:
        // Mastercard (Card) - Render only the icon, enlarged
        content = SvgPicture.asset(
          'assets/images/checkout_icons/mastercard-old-svgrepo-com.svg',
          width: 38,
          height: 28,
          fit: BoxFit.contain,
        );
        break;
      case 1:
        // Apple Pay
        content = SvgPicture.asset(
          'assets/images/checkout_icons/apple-pay-svgrepo-com.svg',
          width: 58,
          height: 22,
          fit: BoxFit.contain,
        );
        break;
      case 2:
        // Google Pay
        content = SvgPicture.asset(
          'assets/images/checkout_icons/google-pay-primary-logo-logo-svgrepo-com.svg',
          width: 54,
          height: 20,
          fit: BoxFit.contain,
        );
        break;
      case 3:
      default:
        // PayPal
        content = SvgPicture.asset(
          'assets/images/checkout_icons/paypal.svg',
          width: 64,
          height: 18,
          fit: BoxFit.contain,
        );
        break;
    }

    // Align all payment methods to a standard height for visual excellence
    final alignedContent = SizedBox(height: 28, child: Center(child: content));

    return GestureDetector(
      onTap: () {
        setState(() => _selectedPaymentMethod = index);

        String brand = 'MASTERCARD';
        if (index == 0) {
          brand = _cards[_currentCardIndex]['brand'] ?? 'MASTERCARD';
        } else if (index == 1) {
          brand = 'Apple Pay';
        } else if (index == 2) {
          brand = 'Google Pay';
        } else if (index == 3) {
          brand = 'PayPal';
        }

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PaymentProcessingScreen(brand: brand),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.black : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: alignedContent,
      ),
    );
  }

  // --- Credit Card visual widget ---
  Widget _buildCreditCard(Map<String, String> card) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          colors: [Color(0xFF1565C0), Color(0xFF42A5F5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1565C0).withOpacity(0.35),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Brand (VISA / MASTERCARD)
            Align(
              alignment: Alignment.topRight,
              child: Text(
                card['brand'] ?? '',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  fontStyle: FontStyle.italic,
                  letterSpacing: 2,
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Card number with dots
            Row(
              children: [
                _buildDotGroup(),
                const SizedBox(width: 16),
                _buildDotGroup(),
                const SizedBox(width: 16),
                _buildDotGroup(),
                const SizedBox(width: 16),
                Text(
                  card['last4'] ?? '',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 3,
                  ),
                ),
              ],
            ),

            const Spacer(),

            // Name & Expiry
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  card['name'] ?? '',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  card['expiry'] ?? '',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // --- Dot group for hidden card digits ---
  Widget _buildDotGroup() {
    return Row(
      children: List.generate(4, (index) {
        return Container(
          width: 6,
          height: 6,
          margin: const EdgeInsets.only(right: 3),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white70,
          ),
        );
      }),
    );
  }
}
