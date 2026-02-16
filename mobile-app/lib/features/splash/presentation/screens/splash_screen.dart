import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:parkingzero/core/theme/app_theme.dart';
import 'package:parkingzero/core/routes/app_routes.dart';

/// Splash Screen for ParkingZero application
/// Displays branded gradient background with logo and loading indicator
/// Handles app initialization and navigation flow
class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  String _initializationStatus = 'Inicializando...';

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _initializeApp();
  }

  /// Setup fade-in animation for logo
  void _setupAnimations() {
    _animationController = AnimationController(
      vsync: this,
      duration: AppTheme.logoFadeInDuration,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: AppTheme.defaultAnimationCurve,
      ),
    );

    _animationController.forward();
  }

  /// Initialize app services and determine navigation path
  Future<void> _initializeApp() async {
    try {
      // Simulate checking authentication status
      await Future.delayed(const Duration(milliseconds: 1500));
      if (mounted) {
        setState(() => _initializationStatus = 'Carregando preferências...');
      }

      // Simulate loading user preferences
      await Future.delayed(const Duration(milliseconds: 1500));
      if (mounted) {
        setState(() => _initializationStatus = 'Buscando configurações...');
      }

      // Simulate fetching configuration
      await Future.delayed(const Duration(milliseconds: 1500));
      if (mounted) {
        setState(() => _initializationStatus = 'Preparando dados...');
      }

      // Simulate preparing cached data
      await Future.delayed(const Duration(milliseconds: 1500));

      // Navigate after initialization complete
      await Future.delayed(const Duration(milliseconds: 1000));
      if (mounted) {
        _navigateToNextScreen();
      }
    } catch (e) {
      // Handle initialization errors gracefully
      if (mounted) {
        setState(() => _initializationStatus = 'Erro na inicialização');
      }
      await Future.delayed(const Duration(seconds: 2));
      if (mounted) {
        _showRetryOption();
      }
    }
  }

  /// Determine navigation path based on user state
  void _navigateToNextScreen() {
    // For now, navigate to home screen
    // In production: check auth status and navigate accordingly
    // - Authenticated users → main dashboard
    // - New users → onboarding flow
    // - Returning non-authenticated → login screen
    AppRoutes.navigateAndRemoveUntil(context, AppRoutes.home);
  }

  /// Show retry option on initialization failure
  void _showRetryOption() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(
          'Erro de Conexão',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        content: Text(
          'Não foi possível inicializar o aplicativo. Verifique sua conexão e tente novamente.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                _initializationStatus = 'Inicializando...';
              });
              _initializeApp();
            },
            child: const Text('Tentar Novamente'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Hide status bar for immersive experience
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);

    return Scaffold(
      body: Container(
        decoration: AppTheme.createGradientDecoration(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(flex: 2),

                // Logo with fade-in animation
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: _buildLogo(theme),
                ),

                const Spacer(flex: 1),

                // Loading indicator and status
                _buildLoadingSection(theme),

                const Spacer(flex: 2),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Build ParkingZero logo
  Widget _buildLogo(ThemeData theme) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Logo text with two-tone styling - vertically stacked
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Parking',
              textAlign: TextAlign.center,
              style: GoogleFonts.quicksand(
                color: const Color.fromARGB(255, 42, 43, 44),
                fontSize: 30.sp,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
            Transform.translate(
              offset: Offset(0, -5.h), // Move "Zero" para cima para aproximar
              child: Text(
                'Zero',
                textAlign: TextAlign.center,
                style: GoogleFonts.quicksand(
                  color: const Color(0xFF2FAC42),
                  fontSize: 30.sp,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ],
        ),

        SizedBox(height: 3.h),

        // Tagline
        Text(
          'Estacionamento Inteligente',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.logoWhite.withValues(alpha: 0.9),
            letterSpacing: 0.3,
          ),
        ),
      ],
    );
  }

  /// Build loading indicator section
  Widget _buildLoadingSection(ThemeData theme) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Loading indicator
        SizedBox(
          width: 8.w,
          height: 8.w,
          child: CircularProgressIndicator(
            strokeWidth: 0.6.w,
            valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.logoWhite),
          ),
        ),

        SizedBox(height: 2.h),

        // Initialization status
        AnimatedSwitcher(
          duration: AppTheme.shortAnimationDuration,
          child: Text(
            _initializationStatus,
            key: ValueKey<String>(_initializationStatus),
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppTheme.logoWhite.withValues(alpha: 0.8),
              letterSpacing: 0.2,
            ),
          ),
        ),
      ],
    );
  }
}
