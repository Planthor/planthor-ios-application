import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:planthor_ios_application/core/network/api_client.dart';
import 'package:planthor_ios_application/features/auth/domain/entities/auth_token.dart';
import 'package:planthor_ios_application/features/auth/presentation/profile_screen.dart';
import 'package:planthor_ios_application/features/auth/presentation/providers/auth_provider.dart';
import 'package:planthor_ios_application/features/auth/presentation/providers/member_profile_provider.dart';
import 'package:planthor_ios_application/features/connect_apps/providers/strava_connection_provider.dart';

import '../../helpers/fakes.dart';

const _keycloakId = 'b0eddb80-ec7b-4216-9c1e-8f81ea851cef';
const _memberId = '53d4a8e0-732c-4e42-87e3-51cd4771204f';
const _autoLinkTitle = 'Auto Link Plans and Activity Applications';

final _token = AuthToken(
  accessToken:
      'eyJhbGciOiJSUzI1NiJ9.${base64Url.encode(utf8.encode(jsonEncode({'sub': _keycloakId, 'name': 'Identity User'})))}.fakesig',
  expiresAt: DateTime.utc(2100),
);

class _MembersApi implements HttpClientAdapter {
  final requests = <RequestOptions>[];
  final patchBodies = <Map<String, dynamic>>[];
  bool autoLink = false;
  int getStatus = 200;
  int patchStatus = 204;
  Completer<void>? patchGate;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
    if (options.path != '/v1/members/me') {
      return ResponseBody.fromString('', 404);
    }

    if (options.method == 'GET') {
      return ResponseBody.fromString(
        jsonEncode({
          'id': _memberId,
          'firstName': 'Planthor',
          'middleName': null,
          'lastName': 'Member',
          'description': null,
          'pathAvatar': '',
          'autoLinkUserAdapterToPlan': autoLink,
        }),
        getStatus,
        headers: {
          Headers.contentTypeHeader: [Headers.jsonContentType],
        },
      );
    }

    if (options.method == 'PATCH') {
      final body =
          jsonDecode(await utf8.decoder.bind(requestStream!).join())
              as Map<String, dynamic>;
      patchBodies.add(body);
      await patchGate?.future;
      if (patchStatus == 204) {
        if (body['autoLinkUserAdapterToPlan'] is! bool) {
          return ResponseBody.fromString('', 400);
        }
        autoLink = body['autoLinkUserAdapterToPlan'] as bool;
      }
      return ResponseBody.fromString('', patchStatus);
    }

    return ResponseBody.fromString('', 405);
  }

  @override
  void close({bool force = false}) {}
}

class _DisconnectedStrava extends StravaConnection {
  @override
  StravaConnectionStatus build() => StravaConnectionStatus.disconnected;
}

Finder get _autoLinkSwitch => find.descendant(
  of: find.ancestor(of: find.text(_autoLinkTitle), matching: find.byType(Row)),
  matching: find.byType(Switch),
);

Future<void> _waitForProfileReload(WidgetTester tester, _MembersApi api) async {
  for (var frame = 0; frame < 50 && api.requests.length < 3; frame++) {
    await tester.pump(const Duration(milliseconds: 20));
  }
  expect(api.requests.map((request) => request.method), [
    'GET',
    'PATCH',
    'GET',
  ]);
  await tester.pumpAndSettle();
}

void main() {
  late ProviderContainer container;
  late _MembersApi api;

  setUp(() {
    FlutterSecureStorage.setMockInitialValues({});
    api = _MembersApi();
  });

  Future<void> showProfile(WidgetTester tester) async {
    container = ProviderContainer(
      overrides: [
        authProvider.overrideWith(() => FakeAuth(_token)),
        stravaConnectionProvider.overrideWith(_DisconnectedStrava.new),
      ],
    );
    // Keep the real API client, including bearer-token injection.
    final dio = container.read(apiClientProvider);
    dio.httpClientAdapter = api;
    addTearDown(() => dio.close(force: true));
    addTearDown(container.dispose);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(home: Scaffold(body: ProfileScreen())),
      ),
    );
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text(_autoLinkTitle));
    await tester.pumpAndSettle();
    expect(_autoLinkSwitch, findsOneWidget);
  }

  for (final initiallyEnabled in [false, true]) {
    testWidgets(
      'saves auto-link as ${!initiallyEnabled} through me without a stored member ID',
      (tester) async {
        api.autoLink = initiallyEnabled;
        await showProfile(tester);

        expect(find.text('Planthor Member'), findsOneWidget);
        expect(tester.widget<Switch>(_autoLinkSwitch).value, initiallyEnabled);
        expect(
          container.read(memberProfileProvider).valueOrNull?.id,
          _memberId,
        );

        await tester.tap(_autoLinkSwitch);
        await tester.pumpAndSettle();

        expect(api.requests.map((request) => request.method), ['GET', 'PATCH']);
        expect(api.requests.map((request) => request.path), [
          '/v1/members/me',
          '/v1/members/me',
        ]);
        for (final request in api.requests) {
          expect(
            request.headers['Authorization'],
            'Bearer ${_token.accessToken}',
          );
        }
        expect(api.patchBodies, [
          {
            'autoLinkUserAdapterToPlan': !initiallyEnabled,
            'updateMask': ['autoLinkUserAdapterToPlan'],
          },
        ]);
        expect(tester.widget<Switch>(_autoLinkSwitch).value, !initiallyEnabled);

        // A fresh read must show the persisted value from the API.
        container.invalidate(memberProfileProvider);
        await _waitForProfileReload(tester, api);
        expect(tester.widget<Switch>(_autoLinkSwitch).value, !initiallyEnabled);
        expect(tester.takeException(), isNull);
      },
    );
  }

  testWidgets('ignores a stale Keycloak ID in member storage', (tester) async {
    FlutterSecureStorage.setMockInitialValues({'member_id': _keycloakId});
    await showProfile(tester);

    await tester.tap(_autoLinkSwitch);
    await tester.pumpAndSettle();

    expect(api.requests.map((request) => request.method), ['GET', 'PATCH']);
    expect(
      api.requests.map((request) => request.path),
      everyElement('/v1/members/me'),
    );
    expect(api.autoLink, isTrue);
    expect(tester.widget<Switch>(_autoLinkSwitch).value, isTrue);
  });

  testWidgets('updates the switch while the save is pending', (tester) async {
    api.patchGate = Completer<void>();
    await showProfile(tester);

    await tester.tap(_autoLinkSwitch);
    await tester.pumpAndSettle();

    expect(api.patchBodies, hasLength(1));
    expect(api.autoLink, isFalse);
    expect(tester.widget<Switch>(_autoLinkSwitch).value, isTrue);

    api.patchGate!.complete();
    await tester.pumpAndSettle();
    expect(api.autoLink, isTrue);
    expect(tester.widget<Switch>(_autoLinkSwitch).value, isTrue);
  });

  testWidgets('restores the saved switch value when PATCH fails', (
    tester,
  ) async {
    api.autoLink = true;
    api.patchStatus = 403;
    api.patchGate = Completer<void>();
    await showProfile(tester);

    await tester.tap(_autoLinkSwitch);
    await tester.pumpAndSettle();
    expect(tester.widget<Switch>(_autoLinkSwitch).value, isFalse);

    api.patchGate!.complete();
    await tester.pumpAndSettle();

    expect(api.patchBodies, hasLength(1));
    expect(api.autoLink, isTrue);
    expect(tester.widget<Switch>(_autoLinkSwitch).value, isTrue);
    expect(tester.takeException(), isNull);
  });

  testWidgets('reloads the profile after saving when the initial read failed', (
    tester,
  ) async {
    api.getStatus = 503;
    await showProfile(tester);
    expect(container.read(memberProfileProvider).valueOrNull, isNull);

    api.getStatus = 200;
    await tester.tap(_autoLinkSwitch);
    await _waitForProfileReload(tester, api);

    expect(api.requests.map((request) => request.method), [
      'GET',
      'PATCH',
      'GET',
    ]);
    expect(find.text('Planthor Member'), findsOneWidget);
    expect(tester.widget<Switch>(_autoLinkSwitch).value, isTrue);
  });

  testWidgets('does not load or patch a member after sign-out', (tester) async {
    await showProfile(tester);
    await container.read(authProvider.notifier).signOut();
    await tester.pumpAndSettle();
    api.requests.clear();

    await tester.tap(_autoLinkSwitch);
    await tester.pumpAndSettle();

    expect(api.requests, isEmpty);
    expect(container.read(memberProfileProvider).valueOrNull, isNull);
    expect(tester.widget<Switch>(_autoLinkSwitch).value, isFalse);
  });
}
