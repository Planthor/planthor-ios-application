import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:planthor_ios_application/features/auth/presentation/sign_in_screen.dart';
import 'core/theme/app_theme.dart';

void main() {
  // ProviderScope is required for Riverpod to work
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch our custom theme provider
    final theme = ref.watch(appThemeProvider);

    return MaterialApp(
      title: 'Planthor',
      theme: theme,
      home: const SignInScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
