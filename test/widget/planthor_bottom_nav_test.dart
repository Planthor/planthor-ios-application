import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:planthor_ios_application/core/widgets/planthor_bottom_nav.dart';

Widget _wrap({required int index, ValueChanged<int>? onTap}) => MaterialApp(
  home: Scaffold(
    bottomNavigationBar: PlanthorBottomNav(
      currentIndex: index,
      onTap: onTap ?? (_) {},
    ),
  ),
);

void main() {
  group('PlanthorBottomNav', () {
    testWidgets('renders without error', (tester) async {
      await tester.pumpWidget(_wrap(index: 0));
      expect(tester.takeException(), isNull);
    });

    testWidgets('shows Home, Plans, Settings labels', (tester) async {
      await tester.pumpWidget(_wrap(index: 0));
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Plans'), findsOneWidget);
      expect(find.text('Settings'), findsOneWidget);
    });

    testWidgets('calls onTap with correct index when Plans tapped', (
      tester,
    ) async {
      int? tappedIndex;
      await tester.pumpWidget(_wrap(index: 0, onTap: (i) => tappedIndex = i));
      await tester.tap(find.text('Plans'));
      expect(tappedIndex, 1);
    });

    testWidgets('calls onTap with 2 when Settings tapped', (tester) async {
      int? tappedIndex;
      await tester.pumpWidget(_wrap(index: 0, onTap: (i) => tappedIndex = i));
      await tester.tap(find.text('Settings'));
      expect(tappedIndex, 2);
    });

    testWidgets('active tab 1 renders correctly', (tester) async {
      await tester.pumpWidget(_wrap(index: 1));
      expect(tester.takeException(), isNull);
    });

    testWidgets('active tab 2 renders correctly', (tester) async {
      await tester.pumpWidget(_wrap(index: 2));
      expect(tester.takeException(), isNull);
    });

    testWidgets('uses fixed 90px Figma height', (tester) async {
      await tester.pumpWidget(_wrap(index: 0));

      expect(tester.getSize(find.byType(PlanthorBottomNav)).height, 90);
    });

    testWidgets('exposes selected destination semantics', (tester) async {
      final handle = tester.ensureSemantics();

      await tester.pumpWidget(_wrap(index: 1));

      expect(
        tester.getSemantics(find.bySemanticsLabel('Plans')),
        matchesSemantics(
          label: 'Plans',
          isButton: true,
          hasSelectedState: true,
          isSelected: true,
          hasTapAction: true,
        ),
      );
      handle.dispose();
    });
  });
}
