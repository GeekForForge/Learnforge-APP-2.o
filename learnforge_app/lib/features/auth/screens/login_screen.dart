import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/gradient_button.dart';
import '../../../core/widgets/glass_morphic_card.dart';
import '../providers/auth_provider.dart';
import '../providers/auth_state.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      backgroundColor: AppColors.dark900, // Changed from darkBg
      body: authState is Authenticated
          ? (() {
              Future.microtask(() => context.go('/dashboard'));
              return const SizedBox.shrink();
            })()
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 60),
                  Text(
                    'Welcome Back',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: AppColors.white, // Changed from textLight
                    ),
                  ).animate().slideY(duration: 400.ms, curve: Curves.easeOut),
                  const SizedBox(height: 8),
                  Text(
                    'Sign in to continue learning',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.grey400,
                    ), // Changed from textMuted
                  ).animate().slideY(duration: 500.ms, curve: Curves.easeOut),
                  const SizedBox(height: 40),
                  GlassMorphicCard(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        TextField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            hintText: 'Email',
                            prefixIcon: Icon(
                              Icons.email,
                              color:
                                  AppColors.neonPurple, // Changed from accent
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            hintStyle: TextStyle(
                              color:
                                  AppColors.grey400, // Changed from textMuted
                            ),
                          ),
                          style: TextStyle(
                            color: AppColors.white,
                          ), // Changed from textLight
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: 'Password',
                            prefixIcon: Icon(
                              Icons.lock,
                              color:
                                  AppColors.neonPurple, // Changed from accent
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            hintStyle: TextStyle(
                              color:
                                  AppColors.grey400, // Changed from textMuted
                            ),
                          ),
                          style: TextStyle(
                            color: AppColors.white,
                          ), // Changed from textLight
                        ),
                        const SizedBox(height: 20),
                        GradientButton(
                          text:
                              authState
                                  is Loading // Changed from label to text
                              ? 'Signing In...'
                              : 'Sign In',
                          isLoading: authState is Loading,
                          onPressed: () {
                            ref
                                .read(authProvider.notifier)
                                .login(
                                  _emailController.text,
                                  _passwordController.text,
                                );
                          },
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                        ),
                        if (authState is Error) ...[
                          const SizedBox(height: 12),
                          Text(
                            authState.message,
                            style: TextStyle(color: Colors.redAccent),
                          ),
                        ],
                      ],
                    ),
                  ).animate().slideY(duration: 600.ms, curve: Curves.easeOut),
                ],
              ),
            ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
