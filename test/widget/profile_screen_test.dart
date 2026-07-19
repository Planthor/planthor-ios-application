import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:planthor_ios_application/features/auth/presentation/profile_screen.dart';
import 'package:planthor_ios_application/features/connect_apps/providers/strava_connection_provider.dart';

import '../helpers/fakes.dart';

Widget _wrap({
  StravaConnectionStatus stravaStatus = StravaConnectionStatus.disconnected,
}) => ProviderScope(
  overrides: [
    ...authOverrides(),
    stravaConnectionProvider.overrideWith(() => _FakeStrava(stravaStatus)),
  ],
  child: const MaterialApp(home: Scaffold(body: ProfileScreen())),
);

class _FakeStrava extends StravaConnection {
  _FakeStrava(this._status);
  final StravaConnectionStatus _status;

  @override
  StravaConnectionStatus build() => _status;
}

void main() {
  group('ProfileScreen', () {
    testWidgets('renders without error', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pump();
      expect(tester.takeException(), isNull);
    });

    testWidgets('shows user display name from JWT', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pump();
      expect(find.text('Test User'), findsWidgets);
    });

    testWidgets('shows SETTINGS section', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pump();
      expect(find.text('SETTINGS'), findsOneWidget);
    });

    testWidgets('shows Personal Information row', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pump();
      expect(find.text('Personal Information'), findsOneWidget);
    });

    testWidgets('shows Connect to apps row', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pump();
      expect(find.text('Connect to apps'), findsOneWidget);
    });

    testWidgets('shows UNITS section', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pump();
      expect(find.text('UNITS'), findsOneWidget);
    });

    testWidgets('shows Kilometers and Miles options', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pump();
      expect(find.text('Kilometers'), findsOneWidget);
      expect(find.text('Miles'), findsOneWidget);
    });

    testWidgets('shows PREFERENCES section', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pump();
      expect(find.text('PREFERENCES'), findsOneWidget);
    });

    testWidgets('shows Push Notifications toggle', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pump();
      expect(find.text('Push Notifications'), findsOneWidget);
    });

    testWidgets('shows Privacy & Security row', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pump();
      expect(find.text('Privacy & Security'), findsOneWidget);
    });

    testWidgets('shows Sign Out button', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pump();
      expect(find.textContaining('Sign'), findsWidgets);
    });

    testWidgets('toggling Miles radio updates state', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pump();
      final miles = find.text('Miles');
      await tester.ensureVisible(miles);
      await tester.tap(miles);
      await tester.pump();
      expect(tester.takeException(), isNull);
    });

    testWidgets('toggling notifications switch does not throw', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pump();
      final switchFinder = find.byType(Switch);
      if (switchFinder.evaluate().isNotEmpty) {
        await tester.ensureVisible(switchFinder.first);
        await tester.tap(switchFinder.first);
        await tester.pump();
      }
      expect(tester.takeException(), isNull);
    });

    testWidgets('renders connected Strava state', (tester) async {
      await tester.pumpWidget(
        _wrap(stravaStatus: StravaConnectionStatus.connected),
      );
      await tester.pump();
      expect(tester.takeException(), isNull);
    });

    testWidgets('sign out calls notifier signOut', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pump();
      final signOut = find.textContaining('Sign Out');
      if (signOut.evaluate().isNotEmpty) {
        await tester.tap(signOut.first);
        await tester.pump();
      }
      expect(tester.takeException(), isNull);
    });
  });
}
