import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:parkingzero/features/map_search/presentation/screens/map_screen.dart';
import 'package:parkingzero/core/routes/app_routes.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late PageController _pageController;
  late Timer _timer;
  int _currentPage = 0;
  bool _isNavigating = false;

  final List<Map<String, dynamic>> _carouselItems = [
    {
      'title': 'Estacionamento para Eventos',
      'subtitle':
          'O ParkingZero facilita sua viagem para um jogo, show ou concerto, ajudando você a t...',
      'image': 'assets/images/carousel/banner.png',
    },
    {
      'title': 'Estacionamento Mensal',
      'subtitle':
          'Obtenha acesso mensal à vaga perfeita perto do trabalho ou de casa.',
      'image': 'assets/images/carousel/city.png',
    },
    {
      'title': 'Estacionamento de Aeroporto',
      'subtitle':
          'Assuma o controle de seu cronograma de viagem e de seu orçamento reservando estacionamento de aeroporto.',
      'image': 'assets/images/carousel/luggage.png',
    },
  ];

  @override
  void initState() {
    super.initState();
    // viewportFraction 0.9 allows the edge of the next card to peek in
    _pageController = PageController(initialPage: 0, viewportFraction: 0.9);
    _startAutoPlay();

    // Forçar status bar transparente nesta tela
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Color(0xFFF7F8FA),
        systemNavigationBarDividerColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.dark,
        systemNavigationBarContrastEnforced: false,
      ),
    );
  }

  void _startAutoPlay() {
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_currentPage < _carouselItems.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color brandBlue = Color(0xFF1976D2); // Azul estilo SpotHero
    const Color bgColor = Color(0xFFF7F8FA); // Fundo cinza claro

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: bgColor,
        systemNavigationBarDividerColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.dark,
        systemNavigationBarContrastEnforced: false,
      ),
      child: Scaffold(
        backgroundColor: bgColor,
        body: Stack(
          children: [
            Builder(
              builder: (context) {
                final topPadding = MediaQuery.of(context).padding.top;
                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: 200 + topPadding,
                    ), // Compensar o Header e a Search Bar fixos
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // --- QUICK ACTIONS ---
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: _buildQuickActionCard(
                                  icon: Icons.business,
                                  title: 'Trabalho',
                                  subtitle: 'Adicionar Trabalho',
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _buildQuickActionCard(
                                  icon: Icons.location_on_outlined,
                                  title: 'guu',
                                  subtitle: 'Miami, FL, USA',
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 32),

                        // --- VOCÊ PODE GOSTAR SECTION ---
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            'Você Pode Gostar',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // --- ORIGINAL CAROUSEL ---
                        SizedBox(
                          height: 160,
                          child: PageView.builder(
                            controller: _pageController,
                            onPageChanged: (index) {
                              setState(() {
                                _currentPage = index;
                              });
                              _timer.cancel();
                              _startAutoPlay();
                            },
                            itemCount: _carouselItems.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 12.0),
                                child: GestureDetector(
                                  onTap: () async {
                                    final navigator = Navigator.of(context);
                                    setState(() => _isNavigating = true);
                                    await Future.delayed(
                                      const Duration(milliseconds: 500),
                                    );
                                    if (!mounted) return;
                                    setState(() => _isNavigating = false);
                                    navigator.push(
                                      MaterialPageRoute(
                                        builder: (context) => const MapScreen(),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.03),
                                          blurRadius: 10,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      children: [
                                        // Ícone/Imagem estilo carro
                                        Container(
                                          width: 50,
                                          height: 50,
                                          decoration: BoxDecoration(
                                            color: Colors.blue.shade50,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Image.asset(
                                              _carouselItems[index]['image']
                                                  as String,
                                              fit: BoxFit.contain,
                                              width: 50,
                                              height: 50,
                                              errorBuilder:
                                                  (context, error, stackTrace) {
                                                    return const Center(
                                                      child: Icon(
                                                        Icons.image,
                                                        color: brandBlue,
                                                        size: 28,
                                                      ),
                                                    );
                                                  },
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        // Text details
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                _carouselItems[index]['title']!,
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black87,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                _carouselItems[index]['subtitle']!,
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.grey.shade600,
                                                  height: 1.2,
                                                ),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        // Arrow Right
                                        const Icon(
                                          Icons.chevron_right,
                                          color: brandBlue,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),

                        const SizedBox(height: 32),

                        // --- ENCONTRAR ESTACIONAMENTO PARA EVENTOS ---
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            'Encontrar Estacionamento para Eventos',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              height: 1.2,
                              letterSpacing: -0.5,
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Carousel Eventos
                        SizedBox(
                          height: 180,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                            ),
                            itemCount: 2,
                            itemBuilder: (context, index) {
                              final items = [
                                {'title': 'Estádio Hard Rock'},
                                {'title': 'Tropicana Field'},
                              ];
                              return Padding(
                                padding: const EdgeInsets.only(right: 12.0),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const MapScreen(),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    width: 200,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: Colors.grey.shade200,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.03),
                                          blurRadius: 8,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        Expanded(
                                          flex: 3,
                                          child: ClipRRect(
                                            borderRadius:
                                                const BorderRadius.vertical(
                                                  top: Radius.circular(12),
                                                ),
                                            child: Container(
                                              color: Colors.grey.shade300,
                                              // Placeholder for the event image
                                              // Image.asset('assets/images/eventos/event_${index+1}.png', fit: BoxFit.cover),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 12.0,
                                            ),
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                items[index]['title']!,
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.black87,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),

                        const SizedBox(height: 32),

                        // --- ENCONTRAR ESTACIONAMENTO DE AEROPORTO ---
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            'Encontrar Estacionamento de Aeroporto',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              height: 1.2,
                              letterSpacing: -0.5,
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Carousel Aeroportos
                        SizedBox(
                          height: 180,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                            ),
                            itemCount: 2,
                            itemBuilder: (context, index) {
                              final items = [
                                {'title': 'Aeroporto de Miami'},
                                {'title': 'Fort Lauderdale'},
                              ];
                              return Padding(
                                padding: const EdgeInsets.only(right: 12.0),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const MapScreen(),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    width: 200,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: Colors.grey.shade200,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.03),
                                          blurRadius: 8,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        Expanded(
                                          flex: 3,
                                          child: ClipRRect(
                                            borderRadius:
                                                const BorderRadius.vertical(
                                                  top: Radius.circular(12),
                                                ),
                                            child: Container(
                                              color: Colors.grey.shade300,
                                              // Placeholder for the airport image
                                              // Image.asset('assets/images/aeroportos/airport_${index+1}.png', fit: BoxFit.cover),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 12.0,
                                            ),
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                items[index]['title']!,
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.black87,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),

                        // Bottom padding
                        const SizedBox(height: 60),
                      ],
                    ),
                  ),
                );
              },
            ),

            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Builder(
                builder: (context) {
                  final topPadding = MediaQuery.of(context).padding.top;
                  return Stack(
                    clipBehavior: Clip.none,
                    children: [
                      // Blue Header Background
                      Container(
                        height: 150 + topPadding,
                        width: double.infinity,
                        decoration: const BoxDecoration(color: brandBlue),
                        child: Padding(
                          padding: EdgeInsets.only(top: topPadding),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                            ),
                            child: Column(
                              children: [
                                const SizedBox(height: 10),
                                // Logo and Badge Row
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(width: 80),
                                    // Logo PARK ZERO
                                    const Column(
                                      children: [
                                        Text(
                                          'PARK',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 3.0,
                                          ),
                                        ),
                                        Text(
                                          'ZERO',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 32,
                                            fontWeight: FontWeight.w900,
                                            height: 1.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                    // $0.00 Badge - navega para Saldo
                                    Material(
                                      color: Colors.transparent,
                                      borderRadius: BorderRadius.circular(20),
                                      clipBehavior: Clip.antiAlias,
                                      child: InkWell(
                                        onTap: () => AppRoutes.navigateTo(context, AppRoutes.saldo),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 8,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.black.withOpacity(0.15),
                                          ),
                                          child: const Text(
                                            '\$0.00',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      // Overlapping Search Bar
                      Positioned(
                        top: 120 + topPadding,
                        left: 16,
                        right: 16,
                        child: Container(
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(25),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: const Row(
                            children: [
                              SizedBox(width: 16),
                              Icon(Icons.search, color: brandBlue, size: 28),
                              SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'Endereço, Local ou Aeroporto',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 16,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),

            // Loading Overlay
            if (_isNavigating)
              Container(
                color: Colors.black.withOpacity(0.5),
                child: const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(brandBlue),
                  ),
                ),
              ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: brandBlue,
          unselectedItemColor: Colors.black87,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          currentIndex: 0,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Início',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.event_note_outlined),
              label: 'Reservas',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Encontrar\nEstacionamento',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              label: 'Conta',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'Mais'),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.black87, size: 22),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
