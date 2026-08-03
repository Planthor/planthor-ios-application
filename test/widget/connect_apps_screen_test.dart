import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:planthor_ios_application/features/connect_apps/presentation/connect_apps_screen.dart';
import 'package:planthor_ios_application/features/connect_apps/providers/strava_connection_provider.dart';

import '../helpers/fakes.dart';

Widget _wrap(StravaConnectionStatus status) => ProviderScope(
  overrides: [
    ...authOverrides(),
    stravaConnectionProvider.overrideWith(() => _FakeStrava(status)),
  ],
  child: const MaterialApp(home: ConnectAppsScreen()),
);

class _FakeStrava extends StravaConnection {
  _FakeStrava(this._status);
  final StravaConnectionStatus _status;

  @override
  StravaConnectionStatus build() => _status;
}

void main() {
  group('ConnectAppsScreen — disconnected', () {
    testWidgets('renders without error', (tester) async {
      await tester.pumpWidget(_wrap(StravaConnectionStatus.disconnected));
      expect(tester.takeException(), isNull);
    });

    testWidgets('shows Connect to apps heading', (tester) async {
      await tester.pumpWidget(_wrap(StravaConnectionStatus.disconnected));
      expect(find.text('Connect to apps'), findsOneWidget);
    });

    testWidgets('shows Strava label', (tester) async {
      await tester.pumpWidget(_wrap(StravaConnectionStatus.disconnected));
      expect(find.textContaining('Strava'), findsWidgets);
    });

    testWidgets('shows Connect button when disconnected', (tester) async {
      await tester.pumpWidget(_wrap(StravaConnectionStatus.disconnected));
      expect(find.textContaining('Connect'), findsWidgets);
    });
  });

  group('ConnectAppsScreen — connected', () {
    testWidgets('shows CONNECTED badge', (tester) async {
      await tester.pumpWidget(_wrap(StravaConnectionStatus.connected));
      expect(find.text('CONNECTED'), findsOneWidget);
    });

    testWidgets('renders without error', (tester) async {
      await tester.pumpWidget(_wrap(StravaConnectionStatus.connected));
      expect(tester.takeException(), isNull);
    });
  });

  group('ConnectAppsScreen — connecting', () {
    testWidgets('renders connecting state without error', (tester) async {
      await tester.pumpWidget(_wrap(StravaConnectionStatus.connecting));
      expect(tester.takeException(), isNull);
    });
  });
}
