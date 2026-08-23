import 'package:flutter/services.dart';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:planthor_ios_application/core/network/api_client.dart';
import 'package:planthor_ios_application/features/connect_apps/providers/strava_connection_provider.dart';

class _MockAdapter implements HttpClientAdapter {
  bool isConnected = false;

  @override
  Future<ResponseBody> fetch(RequestOptions options, Stream<Uint8List>? requestStream, Future<void>? cancelFuture) async {
    if (options.path.contains('authorize')) {
      return ResponseBody.fromString('', 302, headers: {
        'location': ['https://strava.com/oauth']
      });
    }
    
    if (options.path.contains('disconnect')) {
      isConnected = false;
      return ResponseBody.fromString('', 200);
    }

    if (options.path.contains('external-connections')) {
      if (isConnected) {
        const jsonStr = '[{"providerId": "strava", "statusId": "A"}]';
        return ResponseBody.fromString(jsonStr, 200, headers: {
          Headers.contentTypeHeader: [Headers.jsonContentType],
        });
      } else {
        return ResponseBody.fromString('[]', 200, headers: {
          Headers.contentTypeHeader: [Headers.jsonContentType],
        });
      }
    }
    
    return ResponseBody.fromString('', 200);
  }
  @override
  void close({bool force = false}) {}
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('StravaConnectionProvider', () {
    late ProviderContainer container;
    late _MockAdapter mockAdapter;

    setUp(() {
      mockAdapter = _MockAdapter();
      container = ProviderContainer(
        overrides: [
          apiClientProvider.overrideWithValue(Dio()..httpClientAdapter = mockAdapter),
        ],
      );

      // Mock FlutterWebAuth2 MethodChannel
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
        const MethodChannel('flutter_web_auth_2'),
        (MethodCall methodCall) async {
          if (methodCall.method == 'authenticate') {
            // Simulate successful auth which should then set isConnected to true on the backend mock
            mockAdapter.isConnected = true;
            return 'planthor://callback?code=123';
          }
          return null;
        },
      );
    });

    tearDown(() => container.dispose());

    test('initial state is disconnected', () async {
      // listen keeps AutoDispose provider alive
      container.listen(stravaConnectionProvider, (_, _) {});
      
      final state = await container.read(stravaConnectionProvider.future);
      expect(
        state,
        StravaConnectionStatus.disconnected,
      );
    });

    test(
      'connect transitions to connected after delay',
      () async {
        container.listen(stravaConnectionProvider, (_, _) {});
        
        await container.read(stravaConnectionProvider.notifier).connect();
        
        final state = container.read(stravaConnectionProvider).value;
        expect(
          state,
          StravaConnectionStatus.connected,
        );
      },
    );

    test(
      'disconnect resets to disconnected',
      () async {
        container.listen(stravaConnectionProvider, (_, _) {});
        
        mockAdapter.isConnected = true;
        
        await container.read(stravaConnectionProvider.notifier).disconnect();
        
        final state = container.read(stravaConnectionProvider).value;
        expect(
          state,
          StravaConnectionStatus.disconnected,
        );
      },
    );
  });

  group('StravaConnectionStatus enum', () {
    test('has three values', () {
      expect(StravaConnectionStatus.values.length, 3);
    });
  });
}
