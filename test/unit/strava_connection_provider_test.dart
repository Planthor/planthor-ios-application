import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:planthor_ios_application/features/connect_apps/providers/strava_connection_provider.dart';

void main() {
  group('StravaConnectionProvider', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() => container.dispose());

    test('initial state is disconnected', () {
      // listen keeps AutoDispose provider alive
      container.listen(stravaConnectionProvider, (_, _) {});
      expect(
        container.read(stravaConnectionProvider),
        StravaConnectionStatus.disconnected,
      );
    });

    test(
      'connect transitions to connected after delay',
      () async {
        container.listen(stravaConnectionProvider, (_, _) {});
        await container.read(stravaConnectionProvider.notifier).connect();
        expect(
          container.read(stravaConnectionProvider),
          StravaConnectionStatus.connected,
        );
      },
      timeout: const Timeout(Duration(seconds: 10)),
    );

    test(
      'disconnect resets to disconnected',
      () async {
        container.listen(stravaConnectionProvider, (_, _) {});
        await container.read(stravaConnectionProvider.notifier).connect();
        await container.read(stravaConnectionProvider.notifier).disconnect();
        expect(
          container.read(stravaConnectionProvider),
          StravaConnectionStatus.disconnected,
        );
      },
      timeout: const Timeout(Duration(seconds: 10)),
    );
  });

  group('StravaConnectionStatus enum', () {
    test('has three values', () {
      expect(StravaConnectionStatus.values.length, 3);
    });
  });
}
