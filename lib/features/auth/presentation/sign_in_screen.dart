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
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF8FAFC), Color(0xFFF1F5F9)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 48.0,
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 384),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildCard(isLoading, ref),
                    const SizedBox(height: 40),
                    _buildFooter(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCard(bool isLoading, WidgetRef ref) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 48.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(48.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 25,
            offset: const Offset(0, 20),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildLogo(),
          const SizedBox(height: 24),
          _buildBrandHeader(),
          const SizedBox(height: 40),
          _buildWelcomeHeading(),
          const SizedBox(height: 40),
          _buildFacebookButton(isLoading, ref),
        ],
      ),
    );
  }

  Widget _buildLogo() {
    return SizedBox(
      width: 64,
      height: 46,
      child: Image.asset('assets/images/logo.png', fit: BoxFit.contain),
    );
  }

  Widget _buildBrandHeader() {
    return const Column(
      children: [
        Text(
          'PLANTHOR',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.6,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 4),
        Text(
          'FROM PLAN TO PERFORMANCE',
          style: TextStyle(
            fontSize: 10.4,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.04,
            color: Color(0xFF4A72B2),
          ),
        ),
      ],
    );
  }

  Widget _buildWelcomeHeading() {
    return const Text(
      'Sign in to Planthor',
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Color(0xFF111827),
      ),
    );
  }

  Widget _buildFacebookButton(bool isLoading, WidgetRef ref) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed:
            isLoading ? null : () => ref.read(authProvider.notifier).signIn(),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.facebookBlue,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.all(16.0),
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
    );
  }

  Widget _buildFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildFooterLink('PRIVACY'),
        const SizedBox(width: 24),
        _buildFooterLink('TERMS'),
        const SizedBox(width: 24),
        _buildFooterLink('SUPPORT'),
      ],
    );
  }

  Widget _buildFooterLink(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 11.2,
        fontWeight: FontWeight.w700,
        color: Color(0xFF9CA3AF),
        letterSpacing: 0.56,
      ),
    );
  }
}
