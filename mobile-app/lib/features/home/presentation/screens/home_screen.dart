import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:parkingzero/core/constants/app_constants.dart';
import 'package:parkingzero/features/map_search/presentation/screens/map_screen.dart';

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

  final List<Map<String, String>> _carouselItems = [
    {
      'image': 'assets/images/garage_car_1.png',
      'title': 'Encontre Garagens ',
      'subtitle': 'Garagens apartir de R\$ 45+',
    },
    {
      'image': 'assets/images/garage_space_2.png',
      'title': 'Alugue sua vaga ociosa',
      'subtitle': 'Ganhe dinheiro com espaços não utilizados',
    },
    {
      'image': 'assets/images/garage_facility_3.png',
      'title': 'Estacionamento seguro e confiável',
      'subtitle': 'Garagens verificadas e monitoradas',
    },
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    _startAutoPlay();
  }

  void _startAutoPlay() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
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
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness:
            Brightness.light, // Ícones brancos no fundo verde
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarDividerColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.dark,
        systemNavigationBarContrastEnforced:
            false, // Importante para transparência total
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            // Fundo Verde Superior
            Container(
              height: 280,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
              ),
            ),

            // Conteúdo Scrollável
            SafeArea(
              bottom: false,
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  // App Bar Customizada (Menu e Perfil)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildCircleButton(Icons.menu),
                          const Text(
                            'ParkingZero',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          _buildCircleButton(Icons.person_outline),
                        ],
                      ),
                    ),
                  ),

                  // Cards de Ação Rápida (Grid)
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    sliver: SliverGrid.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      // DIMINUÍDO para 1.0 para tornar os cards MAIS ALTOS e dar espaço ao conteúdo
                      childAspectRatio: 1.0,
                      children: [
                        _buildActionCard(
                          context,
                          title: 'Já estacionou?',
                          subtitle: 'Insira o ID do Location ID',
                          icon: Icons.tag,
                        ),
                        _buildActionCard(
                          context,
                          title: 'Reservar para depois',
                          subtitle: 'Reservar Varking',
                          icon: Icons.calendar_today_outlined,
                        ),
                      ],
                    ),
                  ),

                  const SliverToBoxAdapter(child: SizedBox(height: 24)),

                  // Seção Descubra Mais
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text(
                            'Descubra mais',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textBody,
                            ),
                          ),
                          const SizedBox(height: 12),
                          _buildAirportCard(),
                        ],
                      ),
                    ),
                  ),

                  const SliverToBoxAdapter(child: SizedBox(height: 24)),

                  // Seção Explore Mais
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text(
                            'Explore mais',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textBody,
                            ),
                          ),
                          const SizedBox(height: 12),
                          _buildExploreCard(),
                          SizedBox(
                            height: MediaQuery.of(context).padding.bottom + 40,
                          ), // Espaço extra bottom + padding da barra
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Loading Overlay
            if (_isNavigating)
              Container(
                color: Colors.black.withAlpha(128),
                child: const Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.primary,
                        ),
                        strokeWidth: 4,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Carregando mapa...',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCircleButton(IconData icon) {
    return Container(
      width: 48,
      height: 48,
      decoration: const BoxDecoration(
        color: Color(0x1A000000),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: Colors.white),
    );
  }

  Widget _buildActionCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(
        12,
      ), // Reduzido de 16 para 12 para ganhar espaço
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: AppColors.primary,
            size: 26, // Levemente reduzido de 28
          ),
          const SizedBox(height: 8), // Reduzido de 12 para 8
          Text(
            title,
            maxLines: 2, // Permite 2 linhas
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 11, // Reduzido de 12 para 11
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 4),
          Expanded(
            child: Text(
              subtitle,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 13, // Reduzido de 15 para 13 para caber melhor
                fontWeight: FontWeight.bold,
                color: AppColors.textBody,
                height: 1.1, // Altura da linha mais compacta
              ),
            ),
          ),
          const Align(
            alignment: Alignment.bottomRight,
            child: Icon(
              Icons.chevron_right,
              color: AppColors.primary,
              size: 18,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAirportCard() {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(16)),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x0D000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                const Icon(
                  Icons.airplanemode_active,
                  size: 40,
                  color: AppColors.primary,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Aeroporto',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textBody,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: const BoxDecoration(
              color: AppColors.primaryDark,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),
            child: const Center(
              child: Text(
                'Até 70% mais barato',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExploreCard() {
    return Column(
      children: [
        // Carousel
        SizedBox(
          height: 360, // Aumentado para 360 para garantir espaço de sobra
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
              return GestureDetector(
                onTap: () async {
                  setState(() => _isNavigating = true);
                  await Future.delayed(const Duration(milliseconds: 800));
                  if (mounted) {
                    setState(() => _isNavigating = false);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MapScreen(),
                      ),
                    );
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                      color: Colors.white,
                      border: Border.fromBorderSide(
                        BorderSide(color: Color(0x339E9E9E)),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Imagem do carousel (Tamanho fixo)
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16),
                          ),
                          child: Image.asset(
                            _carouselItems[index]['image']!,
                            height:
                                180, // Imagem um pouco maior para ficar bonito
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                height: 180,
                                color: Colors.grey,
                                child: const Center(
                                  child: Icon(
                                    Icons.image,
                                    size: 50,
                                    color: Colors.white54,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),

                        // Área de texto flexível (Ocupa todo o espaço restante)
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(
                              16.0,
                            ), // Padding generoso
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment
                                  .center, // Centraliza verticalmente
                              children: [
                                Text(
                                  _carouselItems[index]['title']!,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textBody,
                                    height: 1.2,
                                  ),
                                ),
                                const SizedBox(
                                  height: 8,
                                ), // Espaçamento que você pediu
                                Flexible(
                                  // Permite que o texto se ajuste sem overflow
                                  child: Text(
                                    _carouselItems[index]['subtitle']!,
                                    maxLines: 2, // Restaurado para 2 linhas
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                      height: 1.3,
                                    ),
                                  ),
                                ),
                              ],
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
        const SizedBox(height: 12),
        // Indicadores de página (dots)
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            _carouselItems.length,
            (index) => Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: _currentPage == index ? 24 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: _currentPage == index
                    ? AppColors.primary
                    : Colors.grey[300],
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
