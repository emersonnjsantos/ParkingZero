import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:parkingzero/core/routes/app_routes.dart';

class PostAuthScreen extends StatelessWidget {
  const PostAuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const Color brandBlue = Color(0xFF1A73E8); // Azul vibrante da imagem

    // Garante que o fundo cubra a tela toda inclusive atrás das barras de sistema
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarDividerColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.dark,
        systemNavigationBarContrastEnforced: false,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: CustomScrollView(
            physics: const ClampingScrollPhysics(),
            slivers: [
              // ── SEÇÃO SUPERIOR: MAPA E ÍCONES ──
              SliverToBoxAdapter(
                child: ClipRect(
                  // Reduzido para 40% da tela para deixar mais espaço para os botões embaixo
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.40,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Grade de Fundo Inclinada
                        Positioned.fill(
                          child: CustomPaint(
                            painter: _GridPainter(),
                          ),
                        ),
                        // Ícone Central (Pino e Sombra reduzidos)
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Stack(
                              alignment: Alignment.topCenter,
                              children: [
                                Positioned(
                                  top: 14,
                                  child: Container(
                                    width: 24,
                                    height: 24,
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                                const Icon(Icons.location_on, size: 90, color: Colors.black),
                              ],
                            ),
                            Container(
                              width: 40,
                              height: 8,
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(100),
                              ),
                            ),
                          ],
                        ),
                        // Bolhas de Custo ($) trazidas mais para o centro para caber na nova altura
                        Positioned(
                          top: 20,
                          left: 60,
                          child: _buildChatBubble(brandBlue, Colors.white, isOutlined: false),
                        ),
                        Positioned(
                          top: 50,
                          right: 70,
                          child: _buildChatBubble(Colors.white, brandBlue, isOutlined: true),
                        ),
                        Positioned(
                          bottom: 30,
                          left: 50,
                          child: _buildChatBubble(Colors.white, brandBlue, isOutlined: true),
                        ),
                        Positioned(
                          bottom: 50,
                          right: 60,
                          child: _buildChatBubble(Colors.white, Colors.black87, isOutlined: true),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // ── SEÇÃO INFERIOR: TEXTOS E BOTÕES ──
              SliverFillRemaining(
                hasScrollBody: false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Ative a localização para\npesquisar mais rápido',
                        style: TextStyle(
                          fontSize: 24, // Fonte reduzida para caber sem rolar
                          fontWeight: FontWeight.w900,
                          color: Colors.black,
                          height: 1.15,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Para uma experiência mais rápida,\nselecione \'Permitir durante o uso do app\'\npara visualizar vagas de estacionamento\npróximas.',
                        style: TextStyle(
                          fontSize: 14, // Fonte reduzida
                          color: Colors.grey.shade800,
                          height: 1.4,
                        ),
                      ),
                      const Spacer(), // Com a redução de tudo, o Spacer agora é seguro e empurra para baixo sem quebrar a tela
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: brandBlue,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 14), // Botão mais fino
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onPressed: () {
                          AppRoutes.navigateAndRemoveUntil(context, AppRoutes.home);
                        },
                        child: const Text(
                          'Ativar Localização',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextButton(
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12), // TextButton mais compacto
                        ),
                        onPressed: () {
                          AppRoutes.navigateAndRemoveUntil(context, AppRoutes.home);
                        },
                        child: const Text(
                          'Agora não',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: brandBlue,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChatBubble(Color bgColor, Color textColor, {bool isOutlined = false}) {
    return Stack(
      alignment: Alignment.bottomCenter,
      clipBehavior: Clip.none,
      children: [
        if (!isOutlined)
          Positioned(
            bottom: 2,
            child: Container(
              width: 24,
              height: 10,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
            ),
          ),
        Positioned(
          bottom: 1,
          child: Transform.rotate(
            angle: 3.14159 / 4,
            child: Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                color: bgColor,
                border: isOutlined
                    ? Border(
                        bottom: BorderSide(color: Colors.grey.shade300, width: 1.5),
                        right: BorderSide(color: Colors.grey.shade300, width: 1.5),
                      )
                    : null,
              ),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10), // Balões levemente menores
          margin: const EdgeInsets.only(bottom: 6),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(24),
            border: isOutlined ? Border.all(color: Colors.grey.shade300, width: 1.5) : null,
          ),
          child: Text(
            '\$',
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.w800,
              fontSize: 14, // Fonte do balão reduzida
            ),
          ),
        ),
      ],
    );
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.shade200
      ..strokeWidth = 3;

    canvas.save();
    canvas.translate(size.width / 2, size.height / 2);
    canvas.rotate(-0.15);

    const double spacing = 70.0;
    for (double i = -size.width * 1.5; i < size.width * 1.5; i += spacing) {
      canvas.drawLine(Offset(i, -size.height * 1.5), Offset(i, size.height * 1.5), paint);
    }
    for (double i = -size.height * 1.5; i < size.height * 1.5; i += spacing) {
      canvas.drawLine(Offset(-size.width * 1.5, i), Offset(size.width * 1.5, i), paint);
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
