import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:parkingzero/core/routes/app_routes.dart';
import 'package:parkingzero/features/auth/presentation/bloc/auth_bloc.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          // Debug output to verify listener execution
          debugPrint('AuthSuccess state received, navigating to PostAuthScreen');
          AppRoutes.navigateAndRemoveUntil(context, AppRoutes.postAuth);
        } else if (state is AuthFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erro: ${state.message}')),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is AuthLoading;
        return Scaffold(
          body: Stack(
            children: [
              const _BackgroundCircles(),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      const Text(
                        'PARKING',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                          height: 1.0,
                          color: Color(0xFF1E6038),
                          letterSpacing: 1.2,
                        ),
                      ),
                      const Text(
                        'ZERO',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.w900,
                          height: 1.0,
                          color: Color(0xFF154728),
                          letterSpacing: 1.5,
                        ),
                      ),
                      const SizedBox(height: 48),
                      const Text(
                        'Crie uma conta para\nreservar sua vaga de\nestacionamento.',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          height: 1.25,
                        ),
                      ),
                      const Spacer(),
                      _CustomButton(
                        iconWidget: const FaIcon(FontAwesomeIcons.google, color: Colors.white, size: 20),
                        label: 'Continuar com o Google',
                        onPressed: isLoading ? null : () => context.read<AuthBloc>().add(GoogleLoginRequested()),
                        backgroundColor: const Color(0xFF3B8E53),
                      ),
                      const SizedBox(height: 16),
                      _CustomButton(
                        iconData: Icons.email_outlined,
                        label: 'Continuar com Email',
                        onPressed: isLoading ? null : () => AppRoutes.navigateTo(context, AppRoutes.login),
                        backgroundColor: const Color(0xFF3B8E53),
                      ),
                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: isLoading ? null : () => AppRoutes.navigateTo(context, AppRoutes.home),
                        style: TextButton.styleFrom(
                          minimumSize: const Size(double.infinity, 56),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28),
                          ),
                        ),
                        child: const Text(
                          'Continuar como Convidado',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                      Center(
                        child: GestureDetector(
                          onTap: () => AppRoutes.navigateTo(context, AppRoutes.login),
                          child: RichText(
                            text: const TextSpan(
                              text: 'Já tem uma conta? ',
                              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
                              children: [
                                TextSpan(
                                  text: 'Entrar',
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
              if (isLoading)
                const Center(child: CircularProgressIndicator()),
            ],
          ),
        );
      },
    );
  }
}


class _BackgroundCircles extends StatelessWidget {
  const _BackgroundCircles();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF5AB47B), // Base light green
      ),
      child: CustomPaint(
        size: Size.infinite,
        painter: _CirclesPainter(),
      ),
    );
  }
}

class _CirclesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // We want concentric circles resembling the model
    // Center is slightly lower than the middle
    final center = Offset(size.width / 2, size.height * 0.55);
    
    // Gradients for circles to give that radial fade effect
    final Rect rect = Rect.fromCenter(center: center, width: 1000, height: 1000);
    final Gradient radialGradient = RadialGradient(
      colors: [
        const Color(0xFF5AB47B), // Light green center
        const Color(0xFF1E6038), // Dark green edges
      ],
      stops: const [0.0, 1.0],
    );

    final paintOverlay = Paint()
      ..shader = radialGradient.createShader(rect)
      ..style = PaintingStyle.fill;
      
    // Draw the main gradient background
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paintOverlay);

    // Draw rings to replicate banding
    final ringPaint = Paint()
      ..color = Colors.white.withOpacity(0.08)
      ..style = PaintingStyle.fill;

    final ringStroke = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2; // subtle stroke

    // Drawing from largest to smallest
    final double baseRadius = 550.0;
    for (int i = 0; i < 6; i++) {
      double radius = baseRadius - (i * 90);
      if (radius > 0) {
        ringPaint.color = Colors.white.withOpacity(0.03 + (i * 0.015));
        canvas.drawCircle(center, radius, ringPaint);
        canvas.drawCircle(center, radius, ringStroke);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _CustomButton extends StatelessWidget {
  final IconData? iconData;
  final Widget? iconWidget;
  final String label;
  final VoidCallback? onPressed;
  final Color backgroundColor;
  const _CustomButton({
    this.iconData,
    this.iconWidget,
    required this.label,
    required this.onPressed,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 56),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
        ),
        elevation: 0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (iconWidget != null) iconWidget!,
          if (iconData != null) Icon(iconData, color: Colors.white, size: 20),
          if (iconWidget != null || iconData != null) const SizedBox(width: 12),
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
