import 'dart:async';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:planthor_ios_application/core/network/api_client.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:planthor_ios_application/features/plans/bloc/personal_plans_provider.dart';
import 'package:planthor_ios_application/features/plans/domain/entities/personal_plan.dart';
import 'package:planthor_ios_application/features/plans/presentation/plans_screen.dart';

class _MockAdapter implements HttpClientAdapter {
  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    throw DioException(
      requestOptions: options,
      type: DioExceptionType.connectionError,
    );
  }

  @override
  void close({bool force = false}) {}
}

Widget _wrap(Future<List<PersonalPlan>> Function() loadPlans) => ProviderScope(
  overrides: [
    personalPlansProvider.overrideWith((ref) => loadPlans()),
    apiClientProvider.overrideWithValue(
      Dio()..httpClientAdapter = _MockAdapter(),
    ),
  ],
  child: const MaterialApp(home: Scaffold(body: PlansScreen())),
);

const _plans = [
  PersonalPlan(
    id: '1',
    name: 'Run 100km',
    dateRange: 'Jan – Dec 2026',
    current: 40,
    target: 100,
    unit: 'km',
    icon: Icons.directions_run,
  ),
];

void main() {
  group('PlansScreen', () {
    testWidgets('shows loading state', (tester) async {
      final pending = Completer<List<PersonalPlan>>();
      await tester.pumpWidget(_wrap(() => pending.future));

      expect(find.byKey(const Key('plans-loading')), findsOneWidget);

      pending.complete([]);
      await tester.pumpAndSettle();
    });

    testWidgets('shows empty state', (tester) async {
      await tester.pumpWidget(_wrap(() async => []));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('plans-empty')), findsOneWidget);
      expect(find.text('No Active Plans Yet'), findsOneWidget);
    });

    testWidgets('shows API plan cards', (tester) async {
      await tester.pumpWidget(_wrap(() async => _plans));
      await tester.pumpAndSettle();

      expect(find.text('Run 100km'), findsOneWidget);
      expect(find.text('40% ACHIEVED'), findsOneWidget);
    });

    testWidgets('shows error state and retry action', (tester) async {
      await tester.pumpWidget(_wrap(() async => throw Exception('offline')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('plans-error')), findsOneWidget);
      expect(find.text('Try again'), findsOneWidget);
    });

    testWidgets('matches active-plan structure', (tester) async {
      await tester.pumpWidget(_wrap(() async => _plans));
      await tester.pumpAndSettle();

      expect(find.text('Active Plans'), findsOneWidget);
      expect(find.text('NOT CONNECTED'), findsOneWidget);
      expect(find.byType(CustomScrollView), findsOneWidget);
      expect(find.byTooltip('Create plan'), findsOneWidget);
    });

    testWidgets('fits the 390px Figma canvas without overflow', (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(_wrap(() async => _plans));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
    });
  });
}
