import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:planthor_ios_application/features/auth/presentation/providers/auth_provider.dart';
import 'package:planthor_ios_application/features/auth/presentation/account_deleted_screen.dart';
import 'package:planthor_ios_application/features/auth/presentation/sign_in_screen.dart';
import 'package:planthor_ios_application/features/auth/presentation/profile_screen.dart';
import 'package:planthor_ios_application/features/navigation/presentation/main_scaffold.dart';
import 'package:planthor_ios_application/features/plans/domain/entities/personal_plan.dart';
import 'package:planthor_ios_application/features/plans/presentation/plan_details_screen.dart';
import 'package:planthor_ios_application/features/plans/presentation/plan_form_screen.dart';
import 'package:planthor_ios_application/features/plans/presentation/plans_screen.dart';
import 'package:planthor_ios_application/features/plant_discovery/presentation/discovery_screen.dart';

class _AuthRefreshNotifier extends ChangeNotifier {
  _AuthRefreshNotifier(Ref ref) {
    final sub = ref.listen(authProvider, (_, _) => notifyListeners());
    ref.onDispose(sub.close);
    ref.onDispose(dispose);
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
      GoRoute(path: '/', builder: (_, _) => const _SplashScreen()),
      GoRoute(path: '/sign-in', builder: (_, _) => const SignInScreen()),
      GoRoute(
        path: '/account-deleted',
        builder: (_, _) => const AccountDeletedScreen(),
      ),
      ShellRoute(
        builder: (context, _, child) => MainScaffold(child: child),
        routes: [
          GoRoute(path: '/home', builder: (_, _) => const DiscoveryScreen()),
          GoRoute(path: '/plans', builder: (_, _) => const PlansScreen()),
          GoRoute(
            path: '/plans/new',
            builder: (_, _) => const PlanFormScreen(),
          ),
          GoRoute(
            path: '/plans/:planId/edit',
            builder: (_, state) => PlanFormScreen(
              plan: state.extra is PersonalPlan
                  ? state.extra! as PersonalPlan
                  : null,
            ),
          ),
          GoRoute(
            path: '/plans/:planId',
            builder: (_, state) => PlanDetailsScreen(
              plan: state.extra is PersonalPlan
                  ? state.extra! as PersonalPlan
                  : null,
            ),
          ),
          GoRoute(path: '/settings', builder: (_, _) => const ProfileScreen()),
        ],
      ),
    ],
  );
});

class _SplashScreen extends StatelessWidget {
  const _SplashScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
