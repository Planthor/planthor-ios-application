import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:planthor_ios_application/features/plant_discovery/presentation/discovery_screen.dart';

void main() {
  group('DiscoveryScreen', () {
    testWidgets('renders without error', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: DiscoveryScreen())),
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets('shows explore icon', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: DiscoveryScreen())),
      );
      expect(find.byIcon(Icons.explore_outlined), findsOneWidget);
    });

    testWidgets('shows Coming Soon chip', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: DiscoveryScreen())),
      );
      expect(find.text('Coming Soon'), findsOneWidget);
    });
  });
}
