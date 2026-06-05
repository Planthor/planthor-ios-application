import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:planthor_ios_application/core/theme/app_colors.dart';
import 'package:planthor_ios_application/features/auth/presentation/providers/auth_provider.dart';
import 'package:planthor_ios_application/features/navigation/presentation/main_scaffold.dart';

class SignInScreen extends ConsumerWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(authProvider, (previous, next) {
      next.whenOrNull(
        data: (token) {
          if (token != null) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (_) => const MainScaffold(showWelcome: true),
              ),
            );
          }
        },
        error: (error, _) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Sign in failed: $error')),
          );
        },
      );
    });

    final isLoading = ref.watch(
      authProvider.select((s) => s.isLoading),
    );

    return Scaffold(
      backgroundColor: AppColors.backgroundGrey,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 32.0, bottom: 24.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Sign-in',
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Sign-in',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.textGrey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 32.0),
                  padding: const EdgeInsets.only(
                    top: 64.0,
                    bottom: 48.0,
                    left: 24.0,
                    right: 24.0,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(40.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.03),
                        blurRadius: 30,
                        offset: const Offset(0, 15),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildLogo(),
                      const SizedBox(height: 24),
                      const Text(
                        'PLANTHOR',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.2,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'FROM PLAN TO PERFORMANCE',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.5,
                          color: AppColors.subtitleBlue,
                        ),
                      ),
                      const SizedBox(height: 48),
                      const Text(
                        'Sign in to Planthor',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton.icon(
                          onPressed: isLoading
                              ? null
                              : () => ref
                                  .read(authProvider.notifier)
                                  .signIn(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.facebookBlue,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          icon: isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Icon(Icons.facebook, size: 24),
                          label: Text(
                            isLoading ? 'Signing in…' : 'Sign in with Facebook',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildFooterLink('PRIVACY'),
                    const SizedBox(width: 24),
                    _buildFooterLink('TERMS'),
                    const SizedBox(width: 24),
                    _buildFooterLink('SUPPORT'),
                  ],
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return SizedBox(
      width: 48,
      height: 48,
      child: Transform.scale(
        scale: 2,
        child: Image.asset('assets/images/logo.png', fit: BoxFit.contain),
      ),
    );
  }

  Widget _buildFooterLink(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w800,
        color: AppColors.textGrey,
        letterSpacing: 0.5,
      ),
    );
  }
}
