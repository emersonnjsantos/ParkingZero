import 'package:flutter/material.dart';
import 'package:parking_app/core/theme/app_theme.dart';
import 'package:parking_app/core/routes/app_routes.dart';
import 'package:parking_app/core/auth/auth_service.dart';
import 'package:parking_app/core/di/injection.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      _showError('Preencha todos os campos');
      return;
    }

    setState(() => _isLoading = true);

    try {
      await sl<AuthService>().signInWithEmail(email, password);
      if (mounted) {
        AppRoutes.navigateAndClear(context, AppRoutes.home);
      }
    } catch (e) {
      if (mounted) {
        _showError(_getErrorMessage(e));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _handleForgotPassword() {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      _showError('Digite seu e-mail primeiro');
      return;
    }
    sl<AuthService>()
        .resetPassword(email)
        .then((_) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Link de redefinição enviado para $email'),
                backgroundColor: ParkingTheme.success,
              ),
            );
          }
        })
        .catchError((e) {
          if (mounted) _showError(_getErrorMessage(e));
        });
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: ParkingTheme.error),
    );
  }

  String _getErrorMessage(dynamic error) {
    final msg = error.toString();
    if (msg.contains('user-not-found')) return 'Usuário não encontrado';
    if (msg.contains('wrong-password')) return 'Senha incorreta';
    if (msg.contains('invalid-email')) return 'E-mail inválido';
    if (msg.contains('too-many-requests')) {
      return 'Muitas tentativas. Tente mais tarde';
    }
    if (msg.contains('network-request-failed')) {
      return 'Sem conexão com a internet';
    }
    return 'Erro ao fazer login. Tente novamente';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: ParkingTheme.headerGradient),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: ParkingTheme.accent.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: ParkingTheme.accent.withValues(alpha: 0.3),
                      ),
                    ),
                    child: const Icon(
                      Icons.local_parking_rounded,
                      size: 44,
                      color: ParkingTheme.accent,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'ParkingZero',
                    style: Theme.of(
                      context,
                    ).textTheme.headlineLarge?.copyWith(color: Colors.white),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: ParkingTheme.accent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'BUSINESS',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: ParkingTheme.primaryDeep,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                  const SizedBox(height: 48),

                  // Form card
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: ParkingTheme.surfaceCard,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: ParkingTheme.border,
                        width: 0.5,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Acesse sua conta',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Gerencie seu estacionamento',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const SizedBox(height: 24),

                        // Email
                        TextField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          style: Theme.of(context).textTheme.bodyLarge,
                          decoration: const InputDecoration(
                            labelText: 'E-mail',
                            prefixIcon: Icon(
                              Icons.email_outlined,
                              color: ParkingTheme.textMuted,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Password
                        TextField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          style: Theme.of(context).textTheme.bodyLarge,
                          decoration: InputDecoration(
                            labelText: 'Senha',
                            prefixIcon: const Icon(
                              Icons.lock_outlined,
                              color: ParkingTheme.textMuted,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: ParkingTheme.textMuted,
                              ),
                              onPressed: () => setState(
                                () => _obscurePassword = !_obscurePassword,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),

                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: _handleForgotPassword,
                            child: Text(
                              'Esqueceu a senha?',
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(color: ParkingTheme.accent),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Login button
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _handleLogin,
                            child: _isLoading
                                ? const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.5,
                                      color: ParkingTheme.primaryDeep,
                                    ),
                                  )
                                : const Text('Entrar'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Não tem conta? Fale com nosso comercial',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: ParkingTheme.textMuted,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
