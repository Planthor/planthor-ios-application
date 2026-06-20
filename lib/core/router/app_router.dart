import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:planthor_ios_application/features/auth/presentation/providers/auth_provider.dart';
import 'package:planthor_ios_application/features/auth/presentation/sign_in_screen.dart';
import 'package:planthor_ios_application/features/auth/presentation/profile_screen.dart';
import 'package:planthor_ios_application/features/navigation/presentation/main_scaffold.dart';
import 'package:planthor_ios_application/features/plans/presentation/plans_screen.dart';
import 'package:planthor_ios_application/features/plant_discovery/presentation/discovery_screen.dart';

class _AuthRefreshNotifier extends ChangeNotifier {
  _AuthRefreshNotifier(Ref ref) {
    ref.listen(authProvider, (_, _) => notifyListeners());
  }
}

final appRouterProvider = Provider<GoRouter>((ref) {
  final notifier = _AuthRefreshNotifier(ref);

  return GoRouter(
    initialLocation: '/',
    refreshListenable: notifier,
    redirect: (context, state) {
      final authState = ref.read(authProvider);
      final location = state.matchedLocation;

      if (authState.isLoading) {
        return location == '/' ? null : '/';
      }

      final isAuth = authState.valueOrNull != null;
      final onAuthStack = location.startsWith('/sign-in');

      if (!isAuth && !onAuthStack) return '/sign-in';
      if (isAuth && (onAuthStack || location == '/')) return '/home';
      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (_, _) => const _SplashScreen(),
      ),
      GoRoute(
        path: '/sign-in',
        builder: (_, _) => const SignInScreen(),
      ),
      ShellRoute(
        builder: (context, _, child) => MainScaffold(child: child),
        routes: [
          GoRoute(
            path: '/home',
            builder: (_, _) => const DiscoveryScreen(),
          ),
          GoRoute(
            path: '/plans',
            builder: (_, _) => const PlansScreen(),
          ),
          GoRoute(
            path: '/settings',
            builder: (_, _) => const ProfileScreen(),
          ),
        ],
      ),
    ],
  );
});

class _SplashScreen extends StatelessWidget {
  const _SplashScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
