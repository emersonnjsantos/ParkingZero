import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:parkingzero/core/constants/app_constants.dart';
import 'package:parkingzero/features/home/presentation/screens/home_screen.dart';

class OnboardingLocationScreen extends StatelessWidget {
  const OnboardingLocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarDividerColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.dark,
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarContrastEnforced:
            false, // Importante para transparência total
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        body: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: MediaQuery.of(context).padding.top + 20),
                    const Spacer(flex: 2),

                    // Ilustração do Mapa
                    SizedBox(
                      height: screenHeight * 0.5, // 50% da altura da tela
                      child: Center(
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Círculo Dashed Externo
                            CustomPaint(
                              size: const Size(280, 280),
                              painter: DashedCirclePainter(
                                color: const Color(0x4D269E3A),
                              ),
                            ),
                            // Círculo Verde Opaco Interno
                            Container(
                              width: 180,
                              height: 180,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0x80EBF5EC),
                              ),
                            ),
                            // Ponto Central
                            Container(
                              width: 14,
                              height: 14,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.primary,
                              ),
                            ),
                            // Callout: Melhor oferta
                            Positioned(
                              top: 20,
                              right: 10,
                              child: _buildCallout(
                                text: 'Melhor oferta',
                                icon: Icons.star,
                              ),
                            ),
                            // Callout: Menor caminhada
                            Positioned(
                              top: 100,
                              left: -10,
                              child: _buildCallout(text: 'Menor caminhada'),
                            ),
                            // Callout: Mais barato
                            Positioned(
                              bottom: 60,
                              right: 30,
                              child: _buildCallout(text: 'Mais barato'),
                            ),
                            // Ícone de Pessoa/Tempo no Topo
                            const Positioned(
                              top: 0,
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.person_outline,
                                    size: 16,
                                    color: AppColors.primary,
                                  ),
                                  Text(
                                    '10 min',
                                    style: TextStyle(
                                      color: AppColors.primary,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const Spacer(),

                    Text(
                      'Encontre estacionamento,\nem todo lugar',
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        fontSize: 28,
                        height: 1.2,
                      ),
                    ),

                    const SizedBox(height: 16),

                    Text(
                      'Compartilhar sua localização nos permite direcioná-lo para qualquer uma de nossas mais de 100.000 vagas.',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontSize: 18,
                        height: 1.4,
                      ),
                    ),

                    const Spacer(flex: 2),

                    // Botão: Talvez depois
                    OutlinedButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (_) => const HomeScreen()),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.primary),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: const StadiumBorder(),
                      ),
                      child: const Text(
                        'Talvez depois',
                        style: TextStyle(
                          color: AppColors.textBody,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Botão: Mostre-me vagas próximas
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (_) => const HomeScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: const StadiumBorder(),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Mostre-me vagas próximas',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    SizedBox(
                      height: MediaQuery.of(context).padding.bottom + 20,
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

  Widget _buildCallout({required String text, IconData? icon}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(20)),
        border: Border.fromBorderSide(BorderSide(color: Colors.black12)),
        boxShadow: [
          BoxShadow(
            color: Color(0x0D000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 16, color: AppColors.primary),
            const SizedBox(width: 4),
          ],
          Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textBody,
            ),
          ),
        ],
      ),
    );
  }
}

class DashedCirclePainter extends CustomPainter {
  final Color color;
  DashedCirclePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    const dashWidth = 5.0;
    const dashSpace = 5.0;
    double currentAngle = 0.0;

    final circumference = 2 * 3.141592653589793 * radius;
    final totalSteps = circumference / (dashWidth + dashSpace);
    final angleStep = (2 * 3.141592653589793) / totalSteps;

    for (int i = 0; i < totalSteps; i++) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        currentAngle,
        angleStep * (dashWidth / (dashWidth + dashSpace)),
        false,
        paint,
      );
      currentAngle += angleStep;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
