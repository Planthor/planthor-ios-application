import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:planthor_ios_application/core/theme/app_theme.dart';
import 'package:planthor_ios_application/features/auth/presentation/providers/auth_provider.dart';
import 'package:planthor_ios_application/features/auth/presentation/sign_in_screen.dart';
import 'package:planthor_ios_application/features/navigation/presentation/main_scaffold.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(appThemeProvider);
    final authState = ref.watch(authProvider);

    return MaterialApp(
      title: 'Planthor',
      theme: theme,
      debugShowCheckedModeBanner: false,
      home: authState.when(
        loading: () => const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
        error: (_, _) => const SignInScreen(),
        data: (token) =>
            token != null ? const MainScaffold() : const SignInScreen(),
      ),
    );
  }
}
