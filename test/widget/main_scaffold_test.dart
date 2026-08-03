import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:planthor_ios_application/features/navigation/presentation/main_scaffold.dart';

import '../helpers/fakes.dart';

GoRouter _makeRouter(Widget child, {String initialLocation = '/home'}) =>
    GoRouter(
      initialLocation: initialLocation,
      routes: [
        ShellRoute(
          builder: (_, _, shell) => MainScaffold(child: shell),
          routes: [
            GoRoute(path: '/home', builder: (_, _) => child),
            GoRoute(path: '/plans', builder: (_, _) => const Text('Plans')),
            GoRoute(
              path: '/settings',
              builder: (_, _) => const Text('Settings'),
            ),
          ],
        ),
      ],
    );

Widget _wrap({
  Widget body = const Text('Home'),
  String initialLocation = '/home',
}) => ProviderScope(
  overrides: authOverrides(),
  child: MaterialApp.router(
    routerConfig: _makeRouter(body, initialLocation: initialLocation),
  ),
);

void main() {
  group('MainScaffold', () {
    testWidgets('renders body child', (tester) async {
      await tester.pumpWidget(_wrap(body: const Text('Hello')));
      await tester.pumpAndSettle();
      expect(find.text('Hello'), findsOneWidget);
    });

    testWidgets('shows Planthor app bar', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pumpAndSettle();
      expect(find.text('Planthor'), findsOneWidget);
    });

    testWidgets('shows bottom navigation bar', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pumpAndSettle();
      // Home appears in both body + nav; use findsWidgets
      expect(find.text('Home'), findsWidgets);
      expect(find.text('Plans'), findsWidgets);
      expect(find.text('Settings'), findsOneWidget);
    });

    testWidgets('tapping Plans tab navigates', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pumpAndSettle();
      await tester.tap(find.text('Plans'));
      await tester.pumpAndSettle();
      expect(find.text('Plans'), findsWidgets);
    });
  });

  group('MainScaffold — URL-derived tab highlight', () {
    testWidgets('Home tab active when location is /home', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pumpAndSettle();
      // Filled icon = active; outlined = inactive
      expect(find.byIcon(Icons.home), findsOneWidget);
      expect(find.byIcon(Icons.home_outlined), findsNothing);
    });

    testWidgets('Plans tab active when location is /plans', (tester) async {
      await tester.pumpWidget(_wrap(initialLocation: '/plans'));
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.event_note), findsOneWidget);
      expect(find.byIcon(Icons.event_note_outlined), findsNothing);
    });

    testWidgets('Settings tab active when location is /settings', (
      tester,
    ) async {
      await tester.pumpWidget(_wrap(initialLocation: '/settings'));
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.settings), findsOneWidget);
      expect(find.byIcon(Icons.settings_outlined), findsNothing);
    });

    testWidgets('highlight follows navigation without imperative state', (
      tester,
    ) async {
      await tester.pumpWidget(_wrap());
      await tester.pumpAndSettle();

      // Start at Home
      expect(find.byIcon(Icons.home), findsOneWidget);

      // Tap Plans
      await tester.tap(find.text('Plans'));
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.event_note), findsOneWidget);
      expect(find.byIcon(Icons.home_outlined), findsOneWidget);

      // Tap Settings
      await tester.tap(find.text('Settings'));
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.settings), findsOneWidget);
      expect(find.byIcon(Icons.event_note_outlined), findsOneWidget);
    });
  });
}
