import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:planthor_ios_application/core/widgets/planthor_app_bar.dart';

Widget _wrap(Widget child) =>
    MaterialApp(home: Scaffold(appBar: child as PreferredSizeWidget));

void main() {
  group('PlanthorAppBar', () {
    testWidgets('renders brand name', (tester) async {
      await tester.pumpWidget(_wrap(const PlanthorAppBar()));
      expect(find.text('Planthor'), findsOneWidget);
    });

    testWidgets('shows profile avatar by default', (tester) async {
      await tester.pumpWidget(_wrap(const PlanthorAppBar()));
      expect(find.byKey(const Key('profile-avatar')), findsOneWidget);
    });

    testWidgets('no back button when showBack is false', (tester) async {
      await tester.pumpWidget(_wrap(const PlanthorAppBar()));
      expect(find.byIcon(Icons.arrow_back), findsNothing);
    });

    testWidgets('shows back button when showBack is true', (tester) async {
      await tester.pumpWidget(_wrap(const PlanthorAppBar(showBack: true)));
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    });

    testWidgets('preferredSize height is 75', (tester) async {
      const bar = PlanthorAppBar();
      expect(bar.preferredSize.height, 75);
    });

    testWidgets('onProfileTap callback fires on avatar tap', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        _wrap(PlanthorAppBar(onProfileTap: () => tapped = true)),
      );
      await tester.tap(find.byKey(const Key('profile-avatar')));
      expect(tapped, isTrue);
    });
  });
}
